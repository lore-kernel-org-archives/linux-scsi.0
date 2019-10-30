Return-Path: <SRS0=//Xo=YX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CA56CA9EC4
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 09:08:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18380208C0
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 09:08:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="W8fGzsJS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfJ3JIu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Oct 2019 05:08:50 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:41540 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfJ3JIu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Oct 2019 05:08:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1572426529; x=1603962529;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vMCqoRuh5R2oVeUmjkeZMYXWXrajdWHBuSSKi9ZdRdk=;
  b=W8fGzsJSprKsNCgBpADoTYxXQ96Nd9/fTDR30yUUQSlw/nm/qSZhQtc9
   Vw2KrSsBBaoMt15ZugyCC/sIiyAvZpF4TCv2Hx1/i5pC9BOJv3GP9T/y8
   kn9J4Rl1g8E//dvcnvAb0SePab7JB2V4qtjXDlrcJIm2FxT0h5p3Fmh5H
   5SNvDw4KcPcJA9SN/ZcAYe7LSCnwLit4PlyztbqP4KKP+dAVdigq5CqPX
   oKZ4RyuI52rapvzCF+mg0g2duSe7p2dfi/vkBTnqiycVkAkEJ4LMj9Uz1
   wLrBS/tI2jVPJgB8jMFx+ue0W2Amm8aoADNHEeDcf0xhGy/BLN2+sDc/h
   A==;
IronPort-SDR: fYvZXvVvlLJvToJ5FOERNH/tjO14JYGlILshBsJhZwmfZJXK4NTwbIXdDc+t9XEa0Cr930U4rF
 ZvAzWlgG0Wpu/UoD8DrBv8BfCtPqOTkHIMf/1KVuT37jczJ2vYjskZiJ8GJuoeIsT5VKHKSnXq
 j/CYJHVgdmshKhkLFF2wKBUJyIQsPqU/wld3MR89OPSx/EFNirHcfv8g6Ps/uDWOI4LGv8wXAc
 zYEx8kbFEM1GrZCbU7ZSZ2aQopSLEwJ9uT/xVJ6kdkR0Mou363SYi/x+lXqDaCARoImsUplvz2
 Uys=
X-IronPort-AV: E=Sophos;i="5.68,246,1569254400"; 
   d="scan'208";a="121676271"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 30 Oct 2019 17:08:49 +0800
IronPort-SDR: 4uU9LxjHRR1tAS2BDGS289ohA8A4DWL9iM3g4ylvROvJys+fmU3VvofUKNwbL6GKl1UBpJZc9A
 Sej0VvBSg8gfPL96piZ60fbYZkCVeHl2r5d0Fa6rj6eh7dZCOp9eokWTOHyWNNwreC+eV7GQV4
 FMYEoQDoHrNxIrfcoM0yg+gheSpPHkmbP8AukVkTSML6FUTQxrykxLb6+PPzsSqiIKDl+8N6Xf
 yI0Q79c7gVJ18HYT8BL2DlIHzD+Unu0DAUZ74+ABd0V1gU5JbR62zI9VdwWhCQYfS8RUQHM7QP
 W1p/488zgzbSlJUKG4vwIlP4
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2019 02:04:07 -0700
IronPort-SDR: Cou+fOihshBb2UI9JhKi7kP4O6lQHN2/lk6/vis2elXlhA7E8O56rrV4pMg+bwyn/hIRJSY18M
 G6VLIctIWULMJH4fbTaqX6g2dDBmeIsv8h82QW4jH7pE/7s1kmaIDCrCUg/10CE39I7okN3Nwg
 g7oFeanGAWTE7C1X3fZ0QsSWBn9UG2c7DcM3hOwOZvrucReqLDtQ4cIIybTHkSfiA4cbg07r9x
 pKl4CZ725hpGqR1fsQtx8Loo0CV8iLOHzFfo6whLSkps89ORJu9i/C8AIs/6RRMaqHfRK2MHnr
 JWU=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 30 Oct 2019 02:08:48 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: [PATCH v2] scsi: Fix scsi_get/set_resid() interface
Date:   Wed, 30 Oct 2019 18:08:47 +0900
Message-Id: <20191030090847.25650-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

struct scsi_cmnd cmd->req.resid_len which is returned and set
respectively by the helper functions scsi_get_resid() and
scsi_set_resid() is an unsigned int. Reflect this fact in the interface
of these helper functions.

Also fix compilation errors due to min() and max() type mismatch
introduced by this change in scsi debug code, usb transport code and in
the USB ENE card reader driver.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---

Changes from v1:
* Fix compilation error in the USB ENE card reader driver

 drivers/scsi/scsi_debug.c        | 4 ++--
 drivers/usb/storage/ene_ub6250.c | 2 +-
 drivers/usb/storage/transport.c  | 3 +--
 include/scsi/scsi_cmnd.h         | 4 ++--
 4 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index d323523f5f9d..4daf2637c011 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1025,7 +1025,7 @@ static int fill_from_dev_buffer(struct scsi_cmnd *scp, unsigned char *arr,
 static int p_fill_from_dev_buffer(struct scsi_cmnd *scp, const void *arr,
 				  int arr_len, unsigned int off_dst)
 {
-	int act_len, n;
+	unsigned int act_len, n;
 	struct scsi_data_buffer *sdb = &scp->sdb;
 	off_t skip = off_dst;
 
@@ -1039,7 +1039,7 @@ static int p_fill_from_dev_buffer(struct scsi_cmnd *scp, const void *arr,
 	pr_debug("%s: off_dst=%u, scsi_bufflen=%u, act_len=%u, resid=%d\n",
 		 __func__, off_dst, scsi_bufflen(scp), act_len,
 		 scsi_get_resid(scp));
-	n = (int)scsi_bufflen(scp) - ((int)off_dst + act_len);
+	n = scsi_bufflen(scp) - (off_dst + act_len);
 	scsi_set_resid(scp, min(scsi_get_resid(scp), n));
 	return 0;
 }
diff --git a/drivers/usb/storage/ene_ub6250.c b/drivers/usb/storage/ene_ub6250.c
index 8b1b73065421..98c1aa594e6c 100644
--- a/drivers/usb/storage/ene_ub6250.c
+++ b/drivers/usb/storage/ene_ub6250.c
@@ -561,7 +561,7 @@ static int ene_send_scsi_cmd(struct us_data *us, u8 fDir, void *buf, int use_sg)
 		residue = min(residue, transfer_length);
 		if (us->srb != NULL)
 			scsi_set_resid(us->srb, max(scsi_get_resid(us->srb),
-								(int)residue));
+								residue));
 	}
 
 	if (bcs->Status != US_BULK_STAT_OK)
diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
index 96cb0409dd89..238a8088e17f 100644
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -1284,8 +1284,7 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 
 		} else {
 			residue = min(residue, transfer_length);
-			scsi_set_resid(srb, max(scsi_get_resid(srb),
-			                                       (int) residue));
+			scsi_set_resid(srb, max(scsi_get_resid(srb), residue));
 		}
 	}
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 91bd749a02f7..3772ae5d40cd 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -190,12 +190,12 @@ static inline unsigned scsi_bufflen(struct scsi_cmnd *cmd)
 	return cmd->sdb.length;
 }
 
-static inline void scsi_set_resid(struct scsi_cmnd *cmd, int resid)
+static inline void scsi_set_resid(struct scsi_cmnd *cmd, unsigned int resid)
 {
 	cmd->req.resid_len = resid;
 }
 
-static inline int scsi_get_resid(struct scsi_cmnd *cmd)
+static inline unsigned int scsi_get_resid(struct scsi_cmnd *cmd)
 {
 	return cmd->req.resid_len;
 }
-- 
2.21.0

