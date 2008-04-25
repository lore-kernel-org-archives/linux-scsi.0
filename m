From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Recurring qla2xxx crashes (maybe APIC related)
Date: Fri, 25 Apr 2008 08:50:18 -0700
Message-ID: <20080425155018.GG8849@plap4>
References: <4811ACAC.7060808@linpro.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:9584 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731AbYDYPuV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Apr 2008 11:50:21 -0400
Content-Disposition: inline
In-Reply-To: <4811ACAC.7060808@linpro.no>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tore Anderson <tore@linpro.no>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 25 Apr 2008, Tore Anderson wrote:

> Hi.  I've been having recurring problems with the qla2xxx driver or
> firmware lockups.  Seems to happen out of the blue, with nothing special 
> going on on the SAN.
> 
> The servers are IBM BladeCenter HS21 8853A2Gs, with dual-port QLA2422
> cards connected to a dual-fabric topology.  They are running Ubuntu
> 6.06, kernel 2.6.22.19 with some OCFS2 patches applied.  qla2xxx driver
> version is 8.01.07-k7, loaded with params qlport_down_retry=35 and
> ql2xextended_error_logging=1.  Firmware is the latest from QLogic's FTP.
> 
> When they crash, the following is logged:
> 
> Apr 21 09:50:33 xander kernel: APIC error on CPU3: 00(40)

There's a slew of problem reports noted on the web with this 'APIC
error' signature...  From the qla2xxx driver perspective the following
logs show the classic 'no interrupts being routed' failures:

I/O needs to be aborted, request issued:

> Apr 21 09:51:18 xander kernel: qla2xxx_eh_abort(1): aborting sp ffff81010ae4c7c0 from RISC. pid=1024761.

Request times out, only recourse is for the driver to perform a full
RISC reset:

> Apr 21 09:51:48 xander kernel: qla2x00_mailbox_command(1): timeout calling abort_isp
> Apr 21 09:51:48 xander kernel: qla2x00_mailbox_command(1): timeout calling abort_isp
> Apr 21 09:51:48 xander kernel: qla2xxx 0000:08:01.0: Mailbox command timeout occured. Issuing ISP abort.
> Apr 21 09:51:48 xander kernel: qla2xxx 0000:08:01.0: Performing ISP error recovery - ha= ffff81021f5ec530.
> Apr 21 09:51:48 xander kernel: scsi(1): **** Load RISC code ****
> Apr 21 09:51:48 xander kernel: scsi(1): Verifying Checksum of loaded RISC code.
> Apr 21 09:51:48 xander kernel: scsi(1): Checksum OK, start firmware.
> Apr 21 09:51:48 xander kernel: scsi(1): Issue init firmware.
> Apr 21 09:51:49 xander kernel: scsi(1): fcport-0 - port retry count: 34 remaining
> Apr 21 09:51:49 xander kernel: scsi(1): fcport-1 - port retry count: 34 remaining
> Apr 21 09:51:49 xander kernel: scsi(1): Asynchronous P2P MODE received.
> Apr 21 09:51:49 xander kernel: scsi(1): Asynchronous LOOP UP (4 Gbps).
> Apr 21 09:51:49 xander kernel: qla2xxx 0000:08:01.0: LOOP UP detected (4 Gbps).
> Apr 21 09:51:49 xander kernel: scsi(1): F/W Ready - OK 
> Apr 21 09:51:49 xander kernel: scsi(1): Asynchronous PORT UPDATE.

Note, the driver is in 'polling' mode during error recovery...

> Apr 21 09:51:49 xander kernel: scsi(1): Port database changed ffff 0006 0000.
> Apr 21 09:51:49 xander kernel: scsi(1): Asynchronous PORT UPDATE ignored 0000/0007/0b00.
> Apr 21 09:51:49 xander kernel: scsi(1): Asynchronous PORT UPDATE ignored 0001/0007/0b00.
> Apr 21 09:51:49 xander kernel: scsi(1): Asynchronous PORT UPDATE ignored 0002/0004/0600.
> Apr 21 09:51:49 xander kernel: scsi(1): Asynchronous PORT UPDATE ignored 0002/0007/0b00.
> Apr 21 09:51:49 xander kernel: scsi(1): fw_state=3 curr time=102a04c2d.
> Apr 21 09:51:49 xander kernel: qla2x00_restart_isp(): Start configure loop, status = 0
> Apr 21 09:51:49 xander kernel: scsi(1): Configure loop -- dpc flags =0x4080048
> Apr 21 09:51:49 xander kernel: scsi(1): RSCN queue entry[0] = [00/000000].
> Apr 21 09:51:49 xander kernel: scsi(1): device_resync: rscn overflow.
> Apr 21 09:51:50 xander kernel: scsi(1): RFT_ID failed, completion status (280).
> Apr 21 09:51:50 xander kernel: scsi(1): Register FC-4 TYPE failed.
> Apr 21 09:51:50 xander kernel: scsi(1): RFF_ID failed, completion status (280).
> Apr 21 09:51:50 xander kernel: scsi(1): fcport-0 - port retry count: 33 remaining
> Apr 21 09:51:50 xander kernel: scsi(1): fcport-1 - port retry count: 33 remaining
> Apr 21 09:51:50 xander kernel: scsi(1): Register FC-4 Features failed.
> Apr 21 09:51:50 xander kernel: scsi(1): RNN_ID failed, completion status (280).
> Apr 21 09:51:50 xander kernel: scsi(1): Register Node Name failed.
> Apr 21 09:51:50 xander kernel: scsi(1): GID_PT failed, completion status (6380).
> Apr 21 09:51:50 xander kernel: scsi(1): GA_NXT failed, rejected request:
> Apr 21 09:51:50 xander kernel: 0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
> Apr 21 09:51:50 xander kernel: --------------------------------------------------------------
> Apr 21 09:51:50 xander kernel: 14  00  00  00  00  70  26  1f  02  00  00  00  10  08  00  00
> Apr 21 09:51:50 xander kernel: qla2xxx 0000:08:01.0: SNS scan failed -- assuming zero-entry result...
> Apr 21 09:51:50 xander kernel: qla24xx_fabric_logout(1): failed to complete IOCB -- completion status (2)  ioparam=0/810031.
> Apr 21 09:51:50 xander kernel: scsi(1): LOOP READY
> Apr 21 09:51:50 xander kernel: qla2x00_restart_isp(): Configure loop done, status = 0x0
> Apr 21 09:51:50 xander kernel: APIC error on CPU4: 00(40)
> Apr 21 09:51:50 xander kernel: qla2x00_abort_isp(1): exiting.
> Apr 21 09:51:50 xander kernel: qla2x00_mailbox_command(1): finished abort_isp
> Apr 21 09:51:50 xander kernel: qla2x00_mailbox_command(1): finished abort_isp
> Apr 21 09:51:50 xander kernel: qla2x00_mailbox_command(1): **** FAILED. mbx0=54, mbx1=0, mbx2=1f58, cmd=54 ****
> Apr 21 09:51:50 xander kernel: qla2x00_issue_iocb(1): failed rval 0x100
> Apr 21 09:51:50 xander kernel: qla2x00_issue_iocb(1): failed rval 0x100
> Apr 21 09:51:50 xander kernel: qla24xx_abort_command(1): failed to issue IOCB (100).
> Apr 21 09:51:50 xander kernel: qla2xxx_eh_abort(1): abort_command mbx failed.

Error recovery (RISC reset) completes, transition to normal INTx
processing and continue.  Next abort request comes down:

> Apr 21 09:51:50 xander kernel: qla2xxx 0000:08:01.0: scsi(1:1:5): Abort command issued -- 0 fa2f9 2002.
> Apr 21 09:51:51 xander kernel: scsi(1): fcport-0 - port retry count: 32 remaining
...
> Apr 21 09:52:24 xander kernel: scsi(1): fcport-0 - port retry count: 0 remaining
> Apr 21 09:52:24 xander kernel: scsi(1): fcport-1 - port retry count: 0 remaining

So do the abort requests fail with the similar signature (timeout)?

> It varies on which CPU the APIC error happens, but after that it's
> always the same:  qla2xxx complaining and attempting to restart the
> firmware without any success, and I/O service never recovers.  Soon
> thereafter other cluster members fences out the problematic machine by
> rebooting it.
> 
> Any ideas on what could cause this, or how to track down the problem?

There's a blanket suggestion that has helped others (perhaps by
ignoring the problem), disable the APIC:

	apm=force noapic acpi=off pci=noacpi

but that seems like a bandaid.  I'd suggest you work this through your
IBM support contract, if possible.

BTW: I'd like to take a look at several failure iterations, could you
send the messages file during the failures...
