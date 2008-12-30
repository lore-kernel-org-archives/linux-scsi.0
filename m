From: "Roland" <devzero@web.de>
Subject: PATCH: mvsas: increase port type detection delay to suit Seagate's 15k6 drive ST3450856SS 0003
Date: Tue, 30 Dec 2008 02:08:24 +0100
Message-ID: <00cd01c96a1b$240d6a50$6602a8c0@bui.materna.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:36111 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbYL3BIo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Dec 2008 20:08:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: kewei@marvell.com, rnissl@gmx.de

as this driver is relatively new, is it already stable enough for production 
use ?

i thought about buying a mobo with marvell sas controller.

is it planned to merge this patch, as it is fixing a problem or must this 
problems being workarounded in userspace ?

here`s some more with that problem:

https://bugzilla.redhat.com/show_bug.cgi?id=474482
http://forumubuntusoftware.info/viewtopic.php?f=46&t=2454

regards
roland


List:       linux-scsi
Subject:    PATCH: mvsas: increase port type detection delay to suit 
Seagate's 15k6 drive ST3450856SS 0003
From:       Reinhard Nissl <rnissl () gmx ! de>
Date:       2008-12-10 23:31:03
Message-ID: 49405137.9000902 () gmx ! de
[Download message RAW]

I increased the delay step by step until loading of mvsas
reliably detected the drive 200 times in sequence. A much better
approach would be to monitor the hardware for some flag which
indicates that port detection has finished, but I do not have any
hardware documentation.

BTW: patch is against
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git

Signed-off-by: Reinhard Nissl <rnissl@gmx.de>


["mvsas.diff" (text/x-patch)]

diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
index 1dd70d7..23e5a87 100644
--- a/drivers/scsi/mvsas.c
+++ b/drivers/scsi/mvsas.c
@@ -2959,7 +2959,7 @@ static int __devinit mvs_hw_init(struct mvs_info *mvi)

  /* enable auto port detection */
  mw32(GBL_PORT_TYPE, MODE_AUTO_DET_EN);
- msleep(100);
+ msleep(1100);
  /* init and reset phys */
  for (i = 0; i < mvi->chip->n_phy; i++) {
   u32 lo = be32_to_cpu(*(u32 *)&mvi->sas_addr[4]); 

