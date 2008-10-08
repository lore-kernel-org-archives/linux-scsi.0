From: thomas schorpp <thomas.schorpp@googlemail.com>
Subject: [Fwd: [PATCH]aic7xxx: Take the LED out of diagnostic mode on PM resume,
 too.]
Date: Wed, 08 Oct 2008 13:21:19 +0200
Message-ID: <48EC97AF.8080300@gmail.com>
Reply-To: thomas.schorpp@gmail.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030800030003080607070507"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:33633 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbYJHLV6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Oct 2008 07:21:58 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1532418nfc.21
        for <linux-scsi@vger.kernel.org>; Wed, 08 Oct 2008 04:21:56 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------030800030003080607070507
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

NACK? malformed patches? do You want it against scsi-git? or what?

y
tom

--------------030800030003080607070507
Content-Type: message/rfc822;
 name="[PATCH]aic7xxx: Take the LED out of diagnostic mode on PM resume, too..eml"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="[PATCH]aic7xxx: Take the LED out of diagnostic mode on PM re";
 filename*1="sume, too..eml"

X-Mozilla-Keys: 
Message-ID: <48E69279.2000507@gmail.com>
Date: Fri, 03 Oct 2008 23:45:29 +0200
From: thomas schorpp <thomas.schorpp@gmail.com>
Reply-To: thomas.schorpp@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de-AT; rv:1.8.1.16) Gecko/20080702 Iceape/1.1.11 (Debian-1.1.11-1)
MIME-Version: 1.0
To: SCSI development list <linux-scsi@vger.kernel.org>
Subject: [PATCH]aic7xxx: Take the LED out of diagnostic mode on PM resume,
 too.
Content-Type: multipart/mixed;
 boundary="------------020306090600020306080309"

This is a multi-part message in MIME format.
--------------020306090600020306080309
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Take the Diag/Activity-LED of the HBA out of diagnostic mode on PM resume after successful PM resume from standby and HBA restart, 
it remained always on before. If something fails before complete recovery, it should remain on, since it is a diagnostics LED, 
reason for the used higher layer for the clear. 

Signed-off-by: thomas.schorpp@gmail.com




--------------020306090600020306080309
Content-Type: text/x-diff;
 name="aic7xxx_PM_fixled.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="aic7xxx_PM_fixled.patch"

--- drivers/scsi/aic7xxx/aic7xxx_core.c	2008-10-03 13:53:39.000000000 +0200
+++ drivers/scsi/aic7xxx/aic7xxx_core.c	2008-10-03 14:26:04.000000000 +0200
@@ -814,6 +814,7 @@
 static void
 ahc_restart(struct ahc_softc *ahc)
 {
+	uint8_t	sblkctl;
 
 	ahc_pause(ahc);
 
@@ -868,6 +869,12 @@
 	ahc_outb(ahc, SEQADDR0, 0);
 	ahc_outb(ahc, SEQADDR1, 0);
 
+	/*
+	 * Take the LED out of diagnostic mode on PM resume, too
+	 */
+	sblkctl = ahc_inb(ahc, SBLKCTL);
+	ahc_outb(ahc, SBLKCTL, (sblkctl & ~(DIAGLEDEN|DIAGLEDON)));
+
 	ahc_unpause(ahc);
 }
 

--------------020306090600020306080309--


--------------030800030003080607070507
Content-Type: message/rfc822;
 name="Nachricht als Attachment"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Nachricht als Attachment"

X-Account-Key: account3
Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Flags: 1001
Delivered-To: GMX delivery to t.schorpp@gmx.de
Received: (qmail invoked by alias); 23 Mar 2007 16:45:57 -0000
Received: from vger.kernel.org (EHLO vger.kernel.org) [209.132.176.167]
  by mx0.gmx.net (mx087) with SMTP; 23 Mar 2007 17:45:57 +0100
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbXCWQpz (ORCPT <rfc822;t.schorpp@gmx.de> + 2 others);
	Fri, 23 Mar 2007 12:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbXCWQpz
	(ORCPT <rfc822;linux-scsi-outgoing>);
	Fri, 23 Mar 2007 12:45:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:56047 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752141AbXCWQpy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Mar 2007 12:45:54 -0400
Received: (qmail invoked by alias); 23 Mar 2007 16:45:53 -0000
Received: from HSI-KBW-091-089-003-211.hsi2.kabelbw.de (EHLO [192.168.1.100]) [91.89.3.211]
  by mail.gmx.net (mp038) with SMTP; 23 Mar 2007 17:45:53 +0100
X-Authenticated: #17142692
Message-ID: <46040440.1020704@gmx.de>
Date: Fri, 23 Mar 2007 17:45:52 +0100
From: thomas schorpp <t.schorpp@gmx.de>
Reply-To: t.schorpp@gmx.de
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070217 Iceape/1.0.8 (Debian-1.0.8-3)
MIME-Version: 1.0
To: SCSI development list <linux-scsi@vger.kernel.org>
Subject: [PATCH][DOC]aic7xxx: Correct wrong Kernel Documentation for Adaptec
 AHA19160(B) HBA
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
X-GMX-Antivirus: -1 (not scanned, may not use virus scanner)
X-GMX-Antispam: 0 (Mail was not recognized as spam)
X-GMX-UID: CXFlIvtFa0Ao/cX8cDAzJDc3Njh6dI65

--- Documentation/scsi/aic7xxx.txt 2007-03-23 16:44:05.000000000 +0100
+++ Documentation/scsi/aic7xxx.txt 2007-03-23 17:01:19.000000000 +0100
@@ -28,7 +28,7 @@
    aic7880  10    PCI/32    20MHz    16Bit      16
    aic7890  20    PCI/32    40MHz    16Bit      16      3 4 5 6 7 8
    aic7891  20    PCI/64    40MHz    16Bit      16      3 4 5 6 7 8
-   aic7892  20   PCI/64-66  80MHz    16Bit      16      3 4 5 6 7 8
+   aic7892  20 PCI/32/64-66 80MHz    16Bit      16      3 4 5 6 7 8
    aic7895  15    PCI/32    20MHz    16Bit      16    2 3 4 5
    aic7895C 15    PCI/32    20MHz    16Bit      16    2 3 4 5     8
    aic7896  20    PCI/32    40MHz    16Bit      16    2 3 4 5 6 7 8
@@ -114,7 +114,7 @@
    AHA-29160N     aic7892   PCI/32      LVD-HD68F       SE-HD50F
                                          SE-50M
    AHA-29160LP    aic7892   PCI/64-66
-   AHA-19160      aic7892   PCI/64-66
+   AHA-19160      aic7892   PCI/32
    AHA-29150LP    aic7892   PCI/64-66
    AHA-29130LP    aic7892   PCI/64-66
    AHA-3960D      aic7899   PCI/64-66  2 X LVD-HD68F  2 X LVD-VHD68F

Correct documentation according to the aic7892 chip, adaptec aha19160 hba specs.

Signed-off-by tom schorpp <t.schorpp@gmx.de>

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


--------------030800030003080607070507--
