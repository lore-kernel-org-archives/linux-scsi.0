Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD723C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 10:32:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4172206B6
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 10:32:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="MS50bBlw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbgEOKcX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 06:32:23 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:40658 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728144AbgEOKcW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 06:32:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589538741; x=1621074741;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Os9z6PsOnxDH0LexRBHN5OTMieAJh3/9X7MkFdNnT18=;
  b=MS50bBlwQX/f4xyRfj9HYWTub+dMwzk4O5n8OKKoUApJHQwp+C1R+sz8
   I/DbLrNMqO6GO83rKOwo00aAIye4Kq7HlVUj3q37rgXar35XqW7npkGqY
   zMOCiDwqn0epKGQIa98XM0H0Y+ZfUDHB4NfHF0uHhZeq2DQ7IPlpZz/nD
   5JZPj4Y0SqqSM517UwCQKZh/T9Or7HFzIFkEbsUdno4rvitDcwSGOEEtL
   iX94CC9b9LjcU7hmEcrxSGSXcAHjmsSIj1qHpjZXAANcznSqHVlhfbUSA
   LQrDMK22TMa/xe5y4sI6frEHtOldSIwQiO8CkXABxEGsNLr/Hy06H3a8p
   w==;
IronPort-SDR: ldwdtfgKYWlgHAWdsJ6ykGitA9EBZNJYbwPsQ0mRoC0qEgDV47Zt/NTJK9SFeEOZl7FGqtmXl0
 e0DgfmrLRNG+a18xqSt+6PYjLVB2dXhezhPt5zEkpTPYnLflkXD/9/ZnbZ9iopWdXw5rdTlaMv
 7p4X2QOsVJg+4RpuKEmwHqDSY5HdBGFpWjAM+u2tm68F/DdbEuDWkDUKWgqo2C/Vi/P5kgbB4o
 jxph07A4wtdmXe9sX2j1y3u2O1N3GoZ3qcux+vJv6a6h8kWR0MNUf4O776kmU9Qi5oiylYyX/3
 Q3k=
X-IronPort-AV: E=Sophos;i="5.73,394,1583164800"; 
   d="scan'208";a="246735836"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 15 May 2020 18:32:21 +0800
IronPort-SDR: zijmhpqSkfW8+lb9P9T/+EsO/wZ1k/TRtUzD25WOal5Gq8CL5lhUp3JZy9PqU8SmGqaZgkiaQX
 pCeWIgwpvK1UWb0XvyHy8fJcGGxeL2R04=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 03:21:59 -0700
IronPort-SDR: jskCiCNwfSHdDnrQoWHI+/1W6bvIEwdLf5eG/0SWoi4v/TKIOtdX9jjUk6ajLCQz2d6ti9Lm8Q
 GVpYX8iEhVTg==
WDCIronportException: Internal
Received: from ile422988.sdcorp.global.sandisk.com ([10.0.231.246])
  by uls-op-cesaip01.wdc.com with ESMTP; 15 May 2020 03:32:17 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>, alim.akhtar@samsung.com,
        asutoshd@codeaurora.org, Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com,
        MOHAMMED RAFIQ KAMAL BASHA <md.rafiq@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [RFC PATCH 08/13] scsi: dh: ufshpb: Activate pinned regions
Date:   Fri, 15 May 2020 13:30:09 +0300
Message-Id: <1589538614-24048-9-git-send-email-avri.altman@wdc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
References: <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Pinned regions are regions that needs to be always active. They are
adjacent starting from a pre-defined starting index. On Init and post
lun reset, those regions are moved promptly to active state.

On init, during the lun activation sequence, we run through the full
sequence of activating all the subregions of the pinned regions. Upon
failure HPB is disabled for that lun.

On lun reset, as it is the middle of the platform life and memory might
not be available, it is ok if a subregion activation has failed.  The
region however is counted as one of the lun active regions anyway.

We will also maintain a bitmap per lun indicating its pinned regions, so
that we will not accidently inactivate any of its subregions.

As a general statement, it is undesirable to configure any pinned
regions at all.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/device_handler/scsi_dh_ufshpb.c | 53 ++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/scsi/device_handler/scsi_dh_ufshpb.c b/drivers/scsi/device_handler/scsi_dh_ufshpb.c
index c94a616..8f85933 100644
--- a/drivers/scsi/device_handler/scsi_dh_ufshpb.c
+++ b/drivers/scsi/device_handler/scsi_dh_ufshpb.c
@@ -618,6 +618,55 @@ static void ufshpb_work_handler(struct work_struct *work)
 	mutex_unlock(&s->state_lock);
 }
 
+static int ufshpb_activate_pinned_regions(struct ufshpb_dh_data *h, bool init)
+{
+	const struct ufshpb_lun_config *lun_conf = h->ufshpb_lun_conf;
+	struct ufshpb_dh_lun *hpb = h->hpb;
+	u16 start_idx = lun_conf->pinned_starting_idx;
+	u16 pinned_count = lun_conf->pinned_count;
+	int i, j;
+	int ret;
+
+	if (!pinned_count)
+		return 0;
+
+	for (i = 0; i < pinned_count; i++) {
+		struct ufshpb_region *r = hpb->region_tbl + start_idx + i;
+		struct ufshpb_subregion *subregions = r->subregion_tbl;
+		unsigned int sub_count = subregions_per_region;
+
+		/*
+		 * lun might not be region/subregion aligned.  pinned region
+		 * activation is the only case in which we do care the exact
+		 * amount of the region’s subregions, to avoid sending
+		 * HPB_READ_BUFFER to a nonexistent subregion
+		 */
+		if (i == hpb->regions_per_lun - 1) {
+			/*
+			 * A small trick to avoid checking if the lun is
+			 * subregion aligned
+			 */
+			sub_count = ((hpb->subregions_per_lun - 1) %
+				     subregions_per_region) + 1;
+		}
+
+		for (j = 0; j < sub_count; j++) {
+			struct ufshpb_subregion *s = subregions + j;
+
+			mutex_lock(&s->state_lock);
+			ret = ufshpb_subregion_activate(hpb, r, s, true);
+			mutex_unlock(&s->state_lock);
+
+			if (ret && init)
+				return ret;
+		}
+
+		set_bit(start_idx + i, hpb->pinned_map);
+	}
+
+	return ret;
+}
+
 static int ufshpb_mempool_init(struct ufshpb_dh_lun *hpb)
 {
 	unsigned int max_active_subregions = hpb->max_active_regions *
@@ -791,6 +840,10 @@ static int ufshpb_activate(struct scsi_device *sdev, activate_complete fn,
 	if (ret)
 		return ret;
 
+	ret = ufshpb_activate_pinned_regions(h, true);
+	if (ret)
+		return ret;
+
 	if (fn)
 		fn(data, ret);
 
-- 
2.7.4

