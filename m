From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: In-kernel QLE2462 driver LU enumeration bug?
Date: Tue, 7 Feb 2006 08:19:13 -0800
Message-ID: <20060207161913.GB1405@andrew-vasquezs-powerbook-g4-15.local>
References: <1138279741.1318.76.camel@echo.e.linpro.no> <20060206231150.GG9044@andrew-vasquezs-powerbook-g4-15.local> <20060207091716.GB11691@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:35895 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S965148AbWBGQTT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2006 11:19:19 -0500
Content-Disposition: inline
In-Reply-To: <20060207091716.GB11691@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Tore Anderson <tore@linpro.no>, linux-scsi@vger.kernel.org

On Tue, 07 Feb 2006, Christoph Hellwig wrote:

> >  	int_to_scsilun(sp->cmd->device->lun, &cmd_pkt->lun);
> > +	host_to_fcp_swap((uint8_t *)&cmd_pkt->lun, sizeof(cmd_pkt->lun));
> 
> this looks rather odd to me.  first and minor cmd_pkt->lun now gets
> values in different endianesses asigned, which doesn't help static
> typechecking, aka getting the qla2xxx driver sparse clean.

Granted, to take advantage of the larger addressing space, the driver
went from:

  qla_fw.h:

	#define COMMAND_TYPE_7  0x18            /* Command Type 7 entry */
	struct cmd_type_7 {
		uint8_t entry_type;             /* Entry type. */
		...
		uint8_t lun[8];                 /* FCP LUN (BE). */
		...
	}

  qla_iocb.c::qla24xx_start_scsi():

	...
	/* Set LUN number*/
	cmd_pkt->lun[1] = LSB(fclun->lun);
	cmd_pkt->lun[2] = MSB(fclun->lun);
	host_to_fcp_swap(cmd_pkt->lun, sizeof(cmd_pkt->lun));

to:

	#define COMMAND_TYPE_7  0x18            /* Command Type 7 entry */
	struct cmd_type_7 {
		uint8_t entry_type;             /* Entry type. */
		...
		struct scsi_lun lun;            /* FCP LUN (BE). */
		...
	}

  qla_iocb.c::qla24xx_start_scsi():

	...
	int_to_scsilun(sp->cmd->device->lun, &cmd_pkt->lun);
	host_to_fcp_swap((uint8_t *)&cmd_pkt->lun, sizeof(cmd_pkt->lun));

(note: the host_to_fcp_swap() was originally missing).

> Second the
> host_to_fcp_swap function looks more than fishy to me.  It's doing a loop
> of unconditional byteswaps.  that can't be right on BE hardware, can it?

Unlike our 2gb (and earlier products), specific data passed through an
IOCB (LU, CDB), are converted to wire-format before the submission to
the firmware.  Note these values are not scalars, but instead arrays
of opaque 8bit data.

You'll also notice the that much of the FCP_DATA returned in a 4gb
status-IOCB is also converted from wire-format (via
host_to_fcp_swap()).

--
AV
