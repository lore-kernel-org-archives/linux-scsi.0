From: Andrew Morton <akpm@digeo.com>
Subject: qlogic fix
Date: Tue, 4 Feb 2003 01:43:37 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030204014337.0afd3d9a.akpm@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from digeo-nav01.digeo.com (digeo-nav01.digeo.com [192.168.1.233])
	by packet.digeo.com (8.9.3+Sun/8.9.3) with SMTP id BAA08229
	for <linux-scsi@vger.kernel.org>; Tue, 4 Feb 2003 01:43:25 -0800 (PST)
Received: from digeo-e2k04.digeo.com ([192.168.2.24])
 by digeo-nav01.digeo.com (NAVGW 2.5.2.12) with SMTP id M2003020401465616423
 for <linux-scsi@vger.kernel.org>; Tue, 04 Feb 2003 01:46:56 -0800
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Linus's current BK tree needs the following build fix:

diff -puN drivers/scsi/qlogicfas.c~qlogic drivers/scsi/qlogicfas.c
--- 25/drivers/scsi/qlogicfas.c~qlogic	2003-02-04 01:40:52.000000000 -0800
+++ 25-akpm/drivers/scsi/qlogicfas.c	2003-02-04 01:41:00.000000000 -0800
@@ -348,7 +348,7 @@ static void ql_icmd(Scsi_Cmnd * cmd)
 	 /**/ outb(qlcfg5, qbase + 5);	/* select timer */
 	outb(qlcfg9 & 7, qbase + 9);	/* prescaler */
 /*	outb(0x99, qbase + 5);	*/
-	outb(cmd->target, qbase + 4);
+	outb(cmd->device->id, qbase + 4);
 
 	for (i = 0; i < cmd->cmd_len; i++)
 		outb(cmd->cmnd[i], qbase + 2);
@@ -573,7 +573,7 @@ static int qlogicfas_command(Scsi_Cmnd *
 	 *	Non-irq version
 	 */
 	 
-	if (cmd->target == qinitid)
+	if (cmd->device->id == qinitid)
 		return (DID_BAD_TARGET << 16);
 	ql_icmd(cmd);
 	if ((k = ql_wai()))
@@ -590,7 +590,7 @@ static int qlogicfas_command(Scsi_Cmnd *
 
 int qlogicfas_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 {
-	if (cmd->target == qinitid) {
+	if (cmd->device->id == qinitid) {
 		cmd->result = DID_BAD_TARGET << 16;
 		done(cmd);
 		return 0;

_

And my "SCSI storage controller: QLogic Corp.  ISP12160 Dual Channel Ultra3
SCSI Processor (rev 06)" works OK with the above change.




And there are some scruffies during scsi build:

drivers/scsi/scsi.c: In function `scsi_unregister_device':
drivers/scsi/scsi.c:1955: warning: unused variable `prev_spnt'
drivers/scsi/scsi.c:1955: warning: unused variable `spnt'
drivers/scsi/qla1280.c:5932: warning: initialization from incompatible pointer type
drivers/scsi/qla1280.c:5932: warning: initialization from incompatible pointer type



Also, I always see this:

qla1x160: Supported Device Found VID=1077 DID=1216 SSVID=1077 SSDID=7
qla1x160: Initializing ISP12160 on PCI bus 3, dev 7, irq 20
ERROR: SCSI host `qla1280' has no error handling
ERROR: This is not a safe way to run your SCSI host
ERROR: The error handling must be added to this driver
Call Trace:
 [<c0212e09>] scsi_register+0x69/0x300
 [<c021da2d>] qla1280_do_device_init+0x3d/0x220
 [<c021dd81>] qla1280_detect+0x171/0x1f4
 [<c02130da>] scsi_register_host+0x3a/0x94
 [<c01050a7>] init+0x47/0x1a0
 [<c0105060>] init+0x0/0x1a0
 [<c01070a5>] kernel_thread_helper+0x5/0xc

and can test patches when someone turns them out.

Thanks.


