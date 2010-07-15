From: Dan Carpenter <error27@gmail.com>
Subject: [patch] dpt_i2o: move range check forward
Date: Thu, 15 Jul 2010 10:20:19 +0200
Message-ID: <20100715082019.GD5164@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42788 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932653Ab0GOIWX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jul 2010 04:22:23 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, John Kacur <jkacur@redhat.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

The check to test that "bus_no" was valid came after we had already used
it as an array offset.  This patch moves it forward.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index b0c576f..2a46f25 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -2640,6 +2640,13 @@ static s32 adpt_i2o_reparse_lct(adpt_hba* pHba)
 				continue;
 			}
 			bus_no = buf[0]>>16;
+			if (bus_no >= MAX_CHANNEL) {	/* Something wrong skip it */
+				printk(KERN_WARNING
+					"%s: Channel number %d out of range\n",
+					pHba->name, bus_no);
+				continue;
+			}
+
 			scsi_id = buf[1];
 			scsi_lun = (buf[2]>>8 )&0xff;
 			pDev = pHba->channel[bus_no].device[scsi_id];
@@ -2667,10 +2674,6 @@ static s32 adpt_i2o_reparse_lct(adpt_hba* pHba)
 				adpt_i2o_report_hba_unit(pHba, d);
 				adpt_i2o_install_device(pHba, d);
 	
-				if(bus_no >= MAX_CHANNEL) {	// Something wrong skip it
-					printk(KERN_WARNING"%s: Channel number %d out of range \n", pHba->name, bus_no);
-					continue;
-				}
 				pDev = pHba->channel[bus_no].device[scsi_id];	
 				if( pDev == NULL){
 					pDev =  kzalloc(sizeof(struct adpt_device),GFP_KERNEL);
