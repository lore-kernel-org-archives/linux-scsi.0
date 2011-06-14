From: =?ISO-8859-1?Q?C=E9dric_Cano?= <ccano@interfaceconcept.com>
Subject: [PATCH 1/1] Big endian swap for Marvell 6440 SAS driver
Date: Tue, 14 Jun 2011 11:31:13 +0200
Message-ID: <4DF72A61.1000805@ic.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp06.msg.oleane.net ([62.161.4.6]:52366 "EHLO
	smtp06.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab1FNJbT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2011 05:31:19 -0400
Received: from ic.fr (iconcept-gw.rain.fr [194.2.96.216])
	by smtp06.msg.oleane.net (MTA) with ESMTP id p5E9VFAO018896
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jun 2011 11:31:17 +0200
Received: from [192.168.1.33] (unknown [192.168.1.33])
	by ic.fr (Postfix) with ESMTPA id 8A26722BF4
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jun 2011 11:31:38 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

Marvell SAS driver doesn't work on powerpc architecture due to big 
endian swap. I've tested it with the MV6440 chip.
Here you can find the patch for Linux 2.6.39.1.

Cedric Cano

Signed-off-by: Cedric Cano<ccano@interfaceconcept.com>
---
diff -Naur drivers/scsi/mvsas/mv_sas.c drivers/scsi/mvsas/mv_sas.c
--- drivers/scsi/mvsas/mv_sas.c    2011-06-03 02:34:20.000000000 +0200
+++ drivers/scsi/mvsas/mv_sas.c    2011-06-14 09:27:15.000000000 +0200
@@ -1143,6 +1143,12 @@
      MVS_CHIP_DISP->write_port_cfg_addr(mvi, i, PHYR_SATA_SIG0);
      s[0] = MVS_CHIP_DISP->read_port_cfg_data(mvi, i);

+    /* swap for big endian devices because of use of these data in 
bytes */
+    s[0] = le32_to_cpu(s[0]);
+    s[1] = le32_to_cpu(s[1]);
+    s[2] = le32_to_cpu(s[2]);
+    s[3] = le32_to_cpu(s[3]);
+
      /* Workaround: take some ATAPI devices for ATA */
      if (((s[1]&  0x00FFFFFF) == 0x00EB1401)&&  (*(u8 *)&s[3] == 0x01))
          s[1] = 0x00EB1401 | (*((u8 *)&s[1] + 3)&  0x10);


