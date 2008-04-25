From: Tore Anderson <tore@linpro.no>
Subject: Recurring qla2xxx crashes (maybe APIC related)
Date: Fri, 25 Apr 2008 12:04:28 +0200
Message-ID: <4811ACAC.7060808@linpro.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.linpro.no ([213.236.139.167]:50006 "EHLO
	mailhub.linpro.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760818AbYDYK2v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Apr 2008 06:28:51 -0400
Received: from localhost (mailhub.linpro.no [213.236.139.167])
	by mailhub.linpro.no (Postfix) with ESMTP id 939B6200C22
	for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2008 12:04:29 +0200 (CEST)
Received: from mailhub.linpro.no ([213.236.139.167])
	by localhost (mailhub.linpro.no [213.236.139.167]) (amavisd-new, port 10024)
	with ESMTP id rKjFY4JDdTK5 for <linux-scsi@vger.kernel.org>;
	Fri, 25 Apr 2008 12:04:29 +0200 (CEST)
Received: from ox.linpro.no (ox.linpro.no [87.238.45.114])
	by mailhub.linpro.no (Postfix) with ESMTP
	for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2008 12:04:29 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi.  I've been having recurring problems with the qla2xxx driver or
firmware lockups.  Seems to happen out of the blue, with nothing special 
going on on the SAN.

The servers are IBM BladeCenter HS21 8853A2Gs, with dual-port QLA2422
cards connected to a dual-fabric topology.  They are running Ubuntu
6.06, kernel 2.6.22.19 with some OCFS2 patches applied.  qla2xxx driver
version is 8.01.07-k7, loaded with params qlport_down_retry=35 and
ql2xextended_error_logging=1.  Firmware is the latest from QLogic's FTP.

When they crash, the following is logged:

Apr 21 09:50:33 xander kernel: APIC error on CPU3: 00(40)
Apr 21 09:51:18 xander kernel: qla2xxx_eh_abort(1): aborting sp ffff81010ae4c7c0 from RISC. pid=1024761.
Apr 21 09:51:48 xander kernel: qla2x00_mailbox_command(1): timeout calling abort_isp
Apr 21 09:51:48 xander kernel: qla2x00_mailbox_command(1): timeout calling abort_isp
Apr 21 09:51:48 xander kernel: qla2xxx 0000:08:01.0: Mailbox command timeout occured. Issuing ISP abort.
Apr 21 09:51:48 xander kernel: qla2xxx 0000:08:01.0: Performing ISP error recovery - ha= ffff81021f5ec530.
Apr 21 09:51:48 xander kernel: scsi(1): **** Load RISC code ****
Apr 21 09:51:48 xander kernel: scsi(1): Verifying Checksum of loaded RISC code.
Apr 21 09:51:48 xander kernel: scsi(1): Checksum OK, start firmware.
Apr 21 09:51:48 xander kernel: scsi(1): Issue init firmware.
Apr 21 09:51:49 xander kernel: scsi(1): fcport-0 - port retry count: 34 remaining
Apr 21 09:51:49 xander kernel: scsi(1): fcport-1 - port retry count: 34 remaining
Apr 21 09:51:49 xander kernel: scsi(1): Asynchronous P2P MODE received.
Apr 21 09:51:49 xander kernel: scsi(1): Asynchronous LOOP UP (4 Gbps).
Apr 21 09:51:49 xander kernel: qla2xxx 0000:08:01.0: LOOP UP detected (4 Gbps).
Apr 21 09:51:49 xander kernel: scsi(1): F/W Ready - OK 
Apr 21 09:51:49 xander kernel: scsi(1): Asynchronous PORT UPDATE.
Apr 21 09:51:49 xander kernel: scsi(1): Port database changed ffff 0006 0000.
Apr 21 09:51:49 xander kernel: scsi(1): Asynchronous PORT UPDATE ignored 0000/0007/0b00.
Apr 21 09:51:49 xander kernel: scsi(1): Asynchronous PORT UPDATE ignored 0001/0007/0b00.
Apr 21 09:51:49 xander kernel: scsi(1): Asynchronous PORT UPDATE ignored 0002/0004/0600.
Apr 21 09:51:49 xander kernel: scsi(1): Asynchronous PORT UPDATE ignored 0002/0007/0b00.
Apr 21 09:51:49 xander kernel: scsi(1): fw_state=3 curr time=102a04c2d.
Apr 21 09:51:49 xander kernel: qla2x00_restart_isp(): Start configure loop, status = 0
Apr 21 09:51:49 xander kernel: scsi(1): Configure loop -- dpc flags =0x4080048
Apr 21 09:51:49 xander kernel: scsi(1): RSCN queue entry[0] = [00/000000].
Apr 21 09:51:49 xander kernel: scsi(1): device_resync: rscn overflow.
Apr 21 09:51:50 xander kernel: scsi(1): RFT_ID failed, completion status (280).
Apr 21 09:51:50 xander kernel: scsi(1): Register FC-4 TYPE failed.
Apr 21 09:51:50 xander kernel: scsi(1): RFF_ID failed, completion status (280).
Apr 21 09:51:50 xander kernel: scsi(1): fcport-0 - port retry count: 33 remaining
Apr 21 09:51:50 xander kernel: scsi(1): fcport-1 - port retry count: 33 remaining
Apr 21 09:51:50 xander kernel: scsi(1): Register FC-4 Features failed.
Apr 21 09:51:50 xander kernel: scsi(1): RNN_ID failed, completion status (280).
Apr 21 09:51:50 xander kernel: scsi(1): Register Node Name failed.
Apr 21 09:51:50 xander kernel: scsi(1): GID_PT failed, completion status (6380).
Apr 21 09:51:50 xander kernel: scsi(1): GA_NXT failed, rejected request:
Apr 21 09:51:50 xander kernel: 0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
Apr 21 09:51:50 xander kernel: --------------------------------------------------------------
Apr 21 09:51:50 xander kernel: 14  00  00  00  00  70  26  1f  02  00  00  00  10  08  00  00
Apr 21 09:51:50 xander kernel: qla2xxx 0000:08:01.0: SNS scan failed -- assuming zero-entry result...
Apr 21 09:51:50 xander kernel: qla24xx_fabric_logout(1): failed to complete IOCB -- completion status (2)  ioparam=0/810031.
Apr 21 09:51:50 xander kernel: scsi(1): LOOP READY
Apr 21 09:51:50 xander kernel: qla2x00_restart_isp(): Configure loop done, status = 0x0
Apr 21 09:51:50 xander kernel: APIC error on CPU4: 00(40)
Apr 21 09:51:50 xander kernel: qla2x00_abort_isp(1): exiting.
Apr 21 09:51:50 xander kernel: qla2x00_mailbox_command(1): finished abort_isp
Apr 21 09:51:50 xander kernel: qla2x00_mailbox_command(1): finished abort_isp
Apr 21 09:51:50 xander kernel: qla2x00_mailbox_command(1): **** FAILED. mbx0=54, mbx1=0, mbx2=1f58, cmd=54 ****
Apr 21 09:51:50 xander kernel: qla2x00_issue_iocb(1): failed rval 0x100
Apr 21 09:51:50 xander kernel: qla2x00_issue_iocb(1): failed rval 0x100
Apr 21 09:51:50 xander kernel: qla24xx_abort_command(1): failed to issue IOCB (100).
Apr 21 09:51:50 xander kernel: qla2xxx_eh_abort(1): abort_command mbx failed.
Apr 21 09:51:50 xander kernel: qla2xxx 0000:08:01.0: scsi(1:1:5): Abort command issued -- 0 fa2f9 2002.
Apr 21 09:51:51 xander kernel: scsi(1): fcport-0 - port retry count: 32 remaining
Apr 21 09:51:51 xander kernel: scsi(1): fcport-1 - port retry count: 32 remaining
Apr 21 09:51:52 xander kernel: scsi(1): fcport-0 - port retry count: 31 remaining
Apr 21 09:51:52 xander kernel: scsi(1): fcport-1 - port retry count: 31 remaining
Apr 21 09:51:53 xander kernel: scsi(1): fcport-0 - port retry count: 30 remaining
Apr 21 09:51:53 xander kernel: scsi(1): fcport-1 - port retry count: 30 remaining
Apr 21 09:51:54 xander kernel: scsi(1): fcport-0 - port retry count: 29 remaining
Apr 21 09:51:54 xander kernel: scsi(1): fcport-1 - port retry count: 29 remaining
Apr 21 09:51:55 xander kernel: scsi(1): fcport-0 - port retry count: 28 remaining
Apr 21 09:51:55 xander kernel: scsi(1): fcport-1 - port retry count: 28 remaining
Apr 21 09:51:56 xander kernel: scsi(1): fcport-0 - port retry count: 27 remaining
Apr 21 09:51:56 xander kernel: scsi(1): fcport-1 - port retry count: 27 remaining
Apr 21 09:51:57 xander kernel: scsi(1): fcport-0 - port retry count: 26 remaining
Apr 21 09:51:57 xander kernel: scsi(1): fcport-1 - port retry count: 26 remaining
Apr 21 09:51:58 xander kernel: scsi(1): fcport-0 - port retry count: 25 remaining
Apr 21 09:51:58 xander kernel: scsi(1): fcport-1 - port retry count: 25 remaining
Apr 21 09:51:59 xander kernel: scsi(1): fcport-0 - port retry count: 24 remaining
Apr 21 09:51:59 xander kernel: scsi(1): fcport-1 - port retry count: 24 remaining
Apr 21 09:52:00 xander kernel: scsi(1): fcport-0 - port retry count: 23 remaining
Apr 21 09:52:00 xander kernel: scsi(1): fcport-1 - port retry count: 23 remaining
Apr 21 09:52:01 xander kernel: scsi(1): fcport-0 - port retry count: 22 remaining
Apr 21 09:52:01 xander kernel: scsi(1): fcport-1 - port retry count: 22 remaining
Apr 21 09:52:02 xander kernel: scsi(1): fcport-0 - port retry count: 21 remaining
Apr 21 09:52:02 xander kernel: scsi(1): fcport-1 - port retry count: 21 remaining
Apr 21 09:52:03 xander kernel: scsi(1): fcport-0 - port retry count: 20 remaining
Apr 21 09:52:03 xander kernel: scsi(1): fcport-1 - port retry count: 20 remaining
Apr 21 09:52:04 xander kernel: scsi(1): fcport-0 - port retry count: 19 remaining
Apr 21 09:52:04 xander kernel: scsi(1): fcport-1 - port retry count: 19 remaining
Apr 21 09:52:05 xander kernel: scsi(1): fcport-0 - port retry count: 18 remaining
Apr 21 09:52:05 xander kernel: scsi(1): fcport-1 - port retry count: 18 remaining
Apr 21 09:52:06 xander kernel: scsi(1): fcport-0 - port retry count: 17 remaining
Apr 21 09:52:06 xander kernel: scsi(1): fcport-1 - port retry count: 17 remaining
Apr 21 09:52:07 xander kernel: scsi(1): fcport-0 - port retry count: 16 remaining
Apr 21 09:52:07 xander kernel: scsi(1): fcport-1 - port retry count: 16 remaining
Apr 21 09:52:09 xander kernel: scsi(1): fcport-0 - port retry count: 15 remaining
Apr 21 09:52:09 xander kernel: scsi(1): fcport-1 - port retry count: 15 remaining
Apr 21 09:52:10 xander kernel: scsi(1): fcport-0 - port retry count: 14 remaining
Apr 21 09:52:10 xander kernel: scsi(1): fcport-1 - port retry count: 14 remaining
Apr 21 09:52:11 xander kernel: scsi(1): fcport-0 - port retry count: 13 remaining
Apr 21 09:52:11 xander kernel: scsi(1): fcport-1 - port retry count: 13 remaining
Apr 21 09:52:12 xander kernel: scsi(1): fcport-0 - port retry count: 12 remaining
Apr 21 09:52:12 xander kernel: scsi(1): fcport-1 - port retry count: 12 remaining
Apr 21 09:52:13 xander kernel: scsi(1): fcport-0 - port retry count: 11 remaining
Apr 21 09:52:13 xander kernel: scsi(1): fcport-1 - port retry count: 11 remaining
Apr 21 09:52:14 xander kernel: scsi(1): fcport-0 - port retry count: 10 remaining
Apr 21 09:52:14 xander kernel: scsi(1): fcport-1 - port retry count: 10 remaining
Apr 21 09:52:15 xander kernel: scsi(1): fcport-0 - port retry count: 9 remaining
Apr 21 09:52:15 xander kernel: scsi(1): fcport-1 - port retry count: 9 remaining
Apr 21 09:52:16 xander kernel: scsi(1): fcport-0 - port retry count: 8 remaining
Apr 21 09:52:16 xander kernel: scsi(1): fcport-1 - port retry count: 8 remaining
Apr 21 09:52:17 xander kernel: scsi(1): fcport-0 - port retry count: 7 remaining
Apr 21 09:52:17 xander kernel: scsi(1): fcport-1 - port retry count: 7 remaining
Apr 21 09:52:18 xander kernel: scsi(1): fcport-0 - port retry count: 6 remaining
Apr 21 09:52:18 xander kernel: scsi(1): fcport-1 - port retry count: 6 remaining
Apr 21 09:52:19 xander kernel: scsi(1): fcport-0 - port retry count: 5 remaining
Apr 21 09:52:19 xander kernel: scsi(1): fcport-1 - port retry count: 5 remaining
Apr 21 09:52:20 xander kernel: scsi(1): fcport-0 - port retry count: 4 remaining
Apr 21 09:52:20 xander kernel: scsi(1): fcport-1 - port retry count: 4 remaining
Apr 21 09:52:21 xander kernel: scsi(1): fcport-0 - port retry count: 3 remaining
Apr 21 09:52:21 xander kernel: scsi(1): fcport-1 - port retry count: 3 remaining
Apr 21 09:52:22 xander kernel: scsi(1): fcport-0 - port retry count: 2 remaining
Apr 21 09:52:22 xander kernel: scsi(1): fcport-1 - port retry count: 2 remaining
Apr 21 09:52:23 xander kernel: scsi(1): fcport-0 - port retry count: 1 remaining
Apr 21 09:52:23 xander kernel: scsi(1): fcport-1 - port retry count: 1 remaining
Apr 21 09:52:24 xander kernel: scsi(1): fcport-0 - port retry count: 0 remaining
Apr 21 09:52:24 xander kernel: scsi(1): fcport-1 - port retry count: 0 remaining

It varies on which CPU the APIC error happens, but after that it's
always the same:  qla2xxx complaining and attempting to restart the
firmware without any success, and I/O service never recovers.  Soon
thereafter other cluster members fences out the problematic machine by
rebooting it.

Any ideas on what could cause this, or how to track down the problem?

Regards,
-- 
Tore Anderson
