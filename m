From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC] Asynchronous scanning for FC/SAS version 3
Date: Mon, 20 Nov 2006 13:11:44 -0700
Message-ID: <20061120201143.GN18567@parisc-linux.org>
References: <20061113152605.GZ16952@parisc-linux.org> <20061120192140.GE11420@andrew-vasquezs-computer.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:61577 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S965869AbWKTULp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Nov 2006 15:11:45 -0500
Content-Disposition: inline
In-Reply-To: <20061120192140.GE11420@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org, linux-driver@qlogic.com, james.smart@emulex.com

On Mon, Nov 20, 2006 at 11:21:41AM -0800, Andrew Vasquez wrote:
> The main reason the qla2xxx driver delayed initialization until a
> 'steady' link-state was acheived, was to insure that devices would be
> discovered during the first(/only)-pass scsi_scan_host().  This though
> is all legacy-style scanning as FC transport aware drivers initiate
> lun scannning indirectly via an fc_remote_port_add() call.
> 
> Perhaps as an alternative, I'd propose the following change to qla2xxx
> intialization semantics:
> 
> - perform basic hardware configuration only (as usual)
>   - allocate resources
>   - load and execute firmware
> 
> - defer link (transport) negotiations to the DPC thread
>   - again the code in qla2x00_initialize_adapter() to stall probe()
>     completion was needed for legacy-style scanning.
>   - DPC thread stalls until probe() complete.
> 
> - before probe() completes, set DPC flags to perform loop-resync logic
>   (similar to what's done during cable-insertion/removal).
> 
> Benefits: user does not have to wait 20+ seconds in case the FC cable
> is unplugged during driver load, code consolidation (removal of
> redundant link negotiation logic during initialize_adaoter()), and
> finilly, the driver no longer needs to defer the fc_remote_port_add()
> calls to hold off lun-scanning prior to returning from the probe()
> function.

This seems like a nice cleanup of some moderately complicated code.
We still need scan_start and scan_finished methods so that the midlayer
knows when the qla2xxx driver thinks it's found all the devices there
are to find.  But the patch to add those looks like it could be
significantly smaller and have less chance of being buggy.

I think it should probably look something like this:

void qla2xxx_scan_start(struct Scsi_Host *shost)
{
	set_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
	set_bit(LOCAL_LOOP_UPDATE, &ha->dpc_flags);
	set_bit(RSCN_UPDATE, &ha->dpc_flags);
	ha->flags.init_done = 1;
	ha->flags.online = 1;
}

int qla2xxx_scan_finished(struct Scsi_Host *shost, unsigned long time)
{
	scsi_qla_host_t *ha = (scsi_qla_host_t *)shost->hostdata;
	if (!ha->host)
		return 1;
	if (time > ha->loop_reset_delay * HZ)
		return 1;

	return atomic_read(&ha->loop_state) == LOOP_READY;
}


... and then add the call to scsi_scan_host() right after the call
to scsi_add_host().  Bear in mind that if async scanning is disabled,
scsi_scan_host will wait for ->scan_finished() to return true, so
everything (eg interrupts and the DPC thread) must be initialised
before calling scsi_scan_host().  But also remember that we must call
scsi_scan_host() before the driver calls scsi_scan_target() for the
first time, so anything that could trigger that happening has to be done
in ->scan_start().

Thanks for looking at this.
