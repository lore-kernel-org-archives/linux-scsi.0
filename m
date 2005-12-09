From: Michael Joosten <michael.joosten@c-lab.de>
Subject: qla1280.c broken on SGI visws, PCI coherency problem
Date: Fri, 09 Dec 2005 20:11:39 +0100
Message-ID: <4399D6EB.4080603@c-lab.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000000010102060300080200"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailserver.c-lab.de ([131.234.80.230]:1681 "EHLO
	mailserver.c-lab.de") by vger.kernel.org with ESMTP id S932414AbVLITR1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Dec 2005 14:17:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------000000010102060300080200
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,
since last week I'm trying to bring the current version of 2.6.12+ in 
working order on that almost abandoned SGI 320 Visual Workstation. This
beastlet also used have a QLA1080 as SCSI controller, which is actually
the only supported one to boot from.
I'm not sure if this is just a SGI320 problem (there seems to be two bus
bridges in use: PCI: Lithium bridge A bus: 1, bridge B (PIIX4) bus: 0)
or now a general problem for all platforms not implementing a mmiowb()
write barrier operation, but since 2.6.11 the qla1280.c driver gets
severly stuck after a few minutes of heavy use:

zapp kernel: qla1280: ISP invalid handle

and then usually the kernel hangs hard or the SCSI subsystem is
inoperable.
Last year Jesse Barnes published a patch introducing I/O space write 
barrier instructions especially for IA64 and MIPS multiprocessors. In 
that patch some PCI posted write flushs were replaced by mmiowb() 
(platform specific write barrier instruction), and at least for
the SGI VisWS, this was one replacement too much.... I'm aware that the 
Visws PCI controller (at least the Lithium chip resp. for PCI 64 bus) 
reused
parts from the O2 and sufferes the same problem of lacking cache 
coherency, but
I wonder now if the qla1280.c is actually stable anymore in kernels 
after 2.6.10 (last version with the PCI write flushes in 
qla1280_64/32bit_start_scsi() ) and non-x86 platforms.

I've just tried qla1280.[ch] from a more recent version than 2.6.12.4,
namely 2.6.14.3, and have the same problem again (only worse, but there
has been some patches in qla1280.c regarding error recovery recently,
and now the kernel just hangs...), unless I add the one/two RD_REG_WORD()
lines again.
To repeat: Has there been any notion of problems with qla1280.c recently,
last known good version in 2.6.10 is from Xmas last year.

I can run tests also on a Intel dual PII server board with that QLA1080 
HBA, but not now.

Regards, Michael


--------------000000010102060300080200
Content-Type: text/plain;
 name="qla1280.c.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="qla1280.c.diff"

--- ../linux-2.6.14.3/drivers/scsi/qla1280.c-	2005-11-24 23:10:21.000000000 +0100
+++ ../linux-2.6.14.3/drivers/scsi/qla1280.c	2005-12-07 21:27:42.000000000 +0100
@@ -3236,6 +3236,7 @@
 	WRT_REG_WORD(&reg->mailbox4, ha->req_ring_index);
 	/* Enforce mmio write ordering; see comment in qla1280_isp_cmd(). */
 	mmiowb();
+	RD_REG_WORD(&reg->mailbox4);
 
  out:
 	if (status)
@@ -3504,6 +3505,7 @@
 	WRT_REG_WORD(&reg->mailbox4, ha->req_ring_index);
 	/* Enforce mmio write ordering; see comment in qla1280_isp_cmd(). */
 	mmiowb();
+	RD_REG_WORD(&reg->mailbox4);
 
 out:
 	if (status)

--------------000000010102060300080200--
