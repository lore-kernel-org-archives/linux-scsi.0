Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74056C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 08:36:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30DB764EC3
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 08:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbhBZIgA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Feb 2021 03:36:00 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:52788 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbhBZIfo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2021 03:35:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614328543; x=1645864543;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o/fwaHoIdF5RuyvmSwRscwZHOHJtzyQhBfHY/UPlgcY=;
  b=Wr1AhlssT4l9z8chgjplmQFMHtKxPyxhQsxE9cdcL0n8pV9zgtTb+0K5
   wugzf6kHuPkSzJRRVw6jdSvaUZmqUCIWjG9l1fyf5FIdO+hOik9FUBh+s
   E5yIssgvUfOdEzAyFyaeBHMp4kWITv1oTw5PyyA8cty/l40c+oe7deMUE
   Un8LdjWZ8M98t4q/i7ou4BLNbqtsW8YuoVFculR54wg58uUHSywTypGaC
   jX1jhGtDuVYrKgX3abixQvmCa+jV2KtnGtyaHPFZgVvWFRU6DVHaS5Hj+
   HiRboI53dFtmIMZINkO9NKTFJmpA82WpbNQ4+mKLtOPSjVR0nfCSP4wLY
   g==;
IronPort-SDR: V2h4FP99P1WTZLuKNgIAdPYrhN3bT3a/g32uBGlMe05UMYtmQ8F4Xe5RCJ2W3kOr5CgRR/ekx9
 DuqtBzn0Tr2ySz163GC8XEbd2Gaq35Hsx8yYFUYZnR9/LysLmzbiYcssid+Z1iWCSfR4DmO6kh
 R+6eYrzvYgYeGe+ZdZcFd35rvsp9vm+MYqZGjEbFfE9PgbTg2at4hiLfnC+ofgqJuiQN0bqUZw
 z5gIdSxaLJE6kKgaWBJu9P8VbwcjeMDKQ9outmfcpjgd4pV4KM0c/PKtlKfSHMlQEzTNGW8arq
 JXo=
X-IronPort-AV: E=Sophos;i="5.81,208,1610380800"; 
   d="scan'208";a="160859671"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 26 Feb 2021 16:34:36 +0800
IronPort-SDR: QdOzhaGpNd6yZeREt9yMP7T1eTnQ4T5Z5BN9IqL6eD0MVGemTn7UxzvTy2AFsO/VJjcrn2efmg
 GeAxXLpaISEIRzn2qoy/ZrqFc3K3xb5AhHaYveFIrSS6Gco+hgD9RI27hqUv6d9dwQF94/ggHI
 RjAWE840u2OJEohGMLwDfKHPNl+PwGnFwdwGXDE8annx2Le13KjPKdZEZXW73Xf1GC2baldHOv
 l0F4qB9CdL4jeTiU7uu3146yw6uHkPi/1cbPgDHRcgkNsSq1nFEGQm/JCxgjrGB9QPXhmISHbb
 cgVYmfxcs+yIv8iqiPOgRGYR
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 00:17:49 -0800
IronPort-SDR: VZvWwkNlPWjU9W8G4SfPd9X8FFxYyWwl/pfpeqUWsxdkhIs/wVX0JJhy/zbDFXDqIC8TWiR6zs
 VZnVx+YCyA2JfyXsCz0AVdNoil6Uzcp88XmDp5WtAwEX6NIJILyhys5FhEmDv3CcivueamyQxF
 UPxbbmbnzgzkvwxPet3rNZzQ1khvCXi/ZGeOwGwa63Wb8rTC6ogVFSLJkzSsFdeTMj6Zdd8FiO
 E+Y6sG8CQ92FNA/IavjfxlpvpAOpsdL/DtijZoCNiRdhl+PdLBxZHy1Rr2crz0m7bDqnnPpTl8
 jt8=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 Feb 2021 00:34:32 -0800
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com, Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v4 5/9] scsi: ufshpb: Region inactivation in host mode
Date:   Fri, 26 Feb 2021 10:32:56 +0200
Message-Id: <20210226083300.30934-6-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210226083300.30934-1-avri.altman@wdc.com>
References: <20210226083300.30934-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I host mode, the host is expected to send HPB-WRITE-BUFFER with
buffer-id = 0x1 when it inactivates a region.

Use the map-requests pool as there is no point in assigning a
designated cache for umap-requests.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshpb.c | 14 ++++++++++++++
 drivers/scsi/ufs/ufshpb.h |  1 +
 2 files changed, 15 insertions(+)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 44e56a6d7102..cf704b82e72a 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -908,6 +908,7 @@ static int ufshpb_execute_umap_req(struct ufshpb_lu *hpb,
 
 	blk_execute_rq_nowait(q, NULL, req, 1, ufshpb_umap_req_compl_fn);
 
+	hpb->stats.umap_req_cnt++;
 	return 0;
 }
 
@@ -1104,6 +1105,12 @@ static int ufshpb_issue_umap_req(struct ufshpb_lu *hpb,
 	return -EAGAIN;
 }
 
+static int ufshpb_issue_umap_single_req(struct ufshpb_lu *hpb,
+					struct ufshpb_region *rgn)
+{
+	return ufshpb_issue_umap_req(hpb, rgn);
+}
+
 static int ufshpb_issue_umap_all_req(struct ufshpb_lu *hpb)
 {
 	return ufshpb_issue_umap_req(hpb, NULL);
@@ -1116,6 +1123,10 @@ static void __ufshpb_evict_region(struct ufshpb_lu *hpb,
 	struct ufshpb_subregion *srgn;
 	int srgn_idx;
 
+
+	if (hpb->is_hcm && ufshpb_issue_umap_single_req(hpb, rgn))
+		return;
+
 	lru_info = &hpb->lru_info;
 
 	dev_dbg(&hpb->sdev_ufs_lu->sdev_dev, "evict region %d\n", rgn->rgn_idx);
@@ -1861,6 +1872,7 @@ ufshpb_sysfs_attr_show_func(rb_noti_cnt);
 ufshpb_sysfs_attr_show_func(rb_active_cnt);
 ufshpb_sysfs_attr_show_func(rb_inactive_cnt);
 ufshpb_sysfs_attr_show_func(map_req_cnt);
+ufshpb_sysfs_attr_show_func(umap_req_cnt);
 
 static struct attribute *hpb_dev_stat_attrs[] = {
 	&dev_attr_hit_cnt.attr,
@@ -1869,6 +1881,7 @@ static struct attribute *hpb_dev_stat_attrs[] = {
 	&dev_attr_rb_active_cnt.attr,
 	&dev_attr_rb_inactive_cnt.attr,
 	&dev_attr_map_req_cnt.attr,
+	&dev_attr_umap_req_cnt.attr,
 	NULL,
 };
 
@@ -1984,6 +1997,7 @@ static void ufshpb_stat_init(struct ufshpb_lu *hpb)
 	hpb->stats.rb_active_cnt = 0;
 	hpb->stats.rb_inactive_cnt = 0;
 	hpb->stats.map_req_cnt = 0;
+	hpb->stats.umap_req_cnt = 0;
 }
 
 static void ufshpb_param_init(struct ufshpb_lu *hpb)
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 2fbe928ae7fd..b78ccb67b765 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -186,6 +186,7 @@ struct ufshpb_stats {
 	u64 rb_inactive_cnt;
 	u64 map_req_cnt;
 	u64 pre_req_cnt;
+	u64 umap_req_cnt;
 };
 
 struct ufshpb_lu {
-- 
2.25.1

