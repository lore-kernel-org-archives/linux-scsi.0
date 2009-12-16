From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH] scsi_debug: scale virtual_gb with sector_size properly
Date: Tue, 15 Dec 2009 19:58:55 -0500
Message-ID: <4B2830CF.2020203@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58170 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754376AbZLPA75 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Dec 2009 19:59:57 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.221.2])
	by mx2.suse.de (Postfix) with ESMTP id 067F086391
	for <linux-scsi@vger.kernel.org>; Wed, 16 Dec 2009 01:59:56 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

 The scsi_debug virtual_gb feature currently assumes that the sector size
 is always 512 bytes and scales the capacity of virtual_gb based on that
 assumption.

 When passed a different sector size, the capacity of the disk is scaled
 incorrectly higher than it should be.

 For example, modprobe scsi_debug virtual_gb=1 sector_size=4096 results
 in an 8 GB device.

 This patch scales it appropriately. I chose to scale down the sectors-per-GB
 value and then multiply so that if virtual_gb is changed to allow devices that
 can max out sector_t, it will just work.

 References: https://bugzilla.novell.com/show_bug.cgi?id=535939

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
- ---
 drivers/scsi/scsi_debug.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

- --- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -154,6 +154,7 @@ static int scsi_debug_virtual_gb = DEF_V
 static int scsi_debug_fake_rw = DEF_FAKE_RW;
 static int scsi_debug_vpd_use_hostno = DEF_VPD_USE_HOSTNO;
 static int scsi_debug_sector_size = DEF_SECTOR_SIZE;
+static int scsi_debug_sector_size_bits = ilog2(DEF_SECTOR_SIZE);
 static int scsi_debug_dix = DEF_DIX;
 static int scsi_debug_dif = DEF_DIF;
 static int scsi_debug_guard = DEF_GUARD;
@@ -895,9 +896,11 @@ static int resp_start_stop(struct scsi_c
 
 static sector_t get_sdebug_capacity(void)
 {
- -	if (scsi_debug_virtual_gb > 0)
- -		return 2048 * 1024 * (sector_t)scsi_debug_virtual_gb;
- -	else
+	if (scsi_debug_virtual_gb > 0) {
+		sector_t sectors = 2 * 1024 * 1024;
+		sectors >>= (scsi_debug_sector_size_bits - 9);
+		return sectors * (sector_t)scsi_debug_virtual_gb;
+	} else
 		return sdebug_store_sectors;
 }
 
@@ -2861,6 +2864,7 @@ static int __init scsi_debug_init(void)
 	case 1024:
 	case 2048:
 	case 4096:
+		scsi_debug_sector_size_bits = ilog2(scsi_debug_sector_size);
 		break;
 	default:
 		printk(KERN_ERR "scsi_debug_init: invalid sector_size %d\n",
- -- 
Jeff Mahoney
SuSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAksoMM8ACgkQLPWxlyuTD7JX5wCePXEPr9nsTescewxkCVnMKZ5e
GQ8An3sSVP1UhWAQ4O6LlKznvEWMg+tH
=CEfl
-----END PGP SIGNATURE-----
