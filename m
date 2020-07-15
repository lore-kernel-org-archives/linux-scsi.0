Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB09CC433E5
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 07:48:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F0922072E
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 07:48:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="HGRz47B3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729444AbgGOHsK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 03:48:10 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31404 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729430AbgGOHsJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 03:48:09 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200715074804epoutp03d98735fb370ca86424e67186721b3ac9~h3X--ju5e1592215922epoutp03r
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2020 07:48:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200715074804epoutp03d98735fb370ca86424e67186721b3ac9~h3X--ju5e1592215922epoutp03r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594799284;
        bh=8xOeQ3Mw86ciSgBzQ3w+8aDLYwqSJxwEJ6HIro0l/s4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=HGRz47B3XhCiz3WPBHoC53al/kgKgJyDL1WN6kOcz9YIzm8bBQKE4Gob8mztZCewV
         ebIwC53+aiE+c+USJ+OelFNQfCyy/dTht8IFgZQmgkGjOpWfAizb+EEtUoswzSzJpB
         Lt9J3+TVdHws0fqaFalbTPiVV36FrpH1f5gC1Occ=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200715074804epcas2p16edd3d57232ae6e05f1f5a63e558dedf~h3X-c0pSx2828228282epcas2p1M;
        Wed, 15 Jul 2020 07:48:04 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.182]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4B68cx0RrRzMqYmK; Wed, 15 Jul
        2020 07:48:01 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        43.0A.27013.FA4BE0F5; Wed, 15 Jul 2020 16:48:00 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20200715074759epcas2p2a2046f8fc8548601d644089c141ab7cd~h3X6y50Bf2918829188epcas2p2i;
        Wed, 15 Jul 2020 07:47:59 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200715074759epsmtrp2c7bd5c868f2643c20e0bfb223d101058~h3X6yLmDl3059630596epsmtrp2b;
        Wed, 15 Jul 2020 07:47:59 +0000 (GMT)
X-AuditID: b6c32a48-d35ff70000006985-04-5f0eb4af2a17
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        A2.97.08303.FA4BE0F5; Wed, 15 Jul 2020 16:47:59 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200715074759epsmtip24060bb84902a7442bc85ca7947d3e216~h3X6iAncN2906829068epsmtip2r;
        Wed, 15 Jul 2020 07:47:59 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v6 3/3] ufs: exynos: implement dbg_register_dump
Date:   Wed, 15 Jul 2020 16:39:57 +0900
Message-Id: <a8ae2f2c4c9a2422ffb2318d7bb92e21154d6cf1.1594798514.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1594798514.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1594798514.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOJsWRmVeSWpSXmKPExsWy7bCmhe6GLXzxBnsnsVg8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7K4ueUoi0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58HpeveHtc7utl8piw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAEc
        UTk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUB3KymU
        JeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKDA0L9IoTc4tL89L1kvNzrQwNDIxMgSoT
        cjKmPOlnL+gzqvgweSp7A+MbzS5GTg4JAROJA6+/snQxcnEICexglDj46CCU84lR4vir0+wQ
        zmdGia5PjYwwLbvudrJBJHYxSuyd9J4ZwvnBKDF/w3F2kCo2AU2JpzenMoEkRAQ2M0m8WnCf
        GSTBLKAusWvCCaAEB4ewgIPEk8YAEJNFQFXica84iMkrEC2x/agVxC45iZvnOsEaOQUsJdZN
        Os+OzpYQmMohsW6KJ4TtIrFq5mUmCFtY4tXxLVA1UhKf3+1lg7DrJfZNbWAFuUxCoIdR4um+
        f1CPGUvMetbOCHIDM9D563fpg5gSAsoSR26xQNzOJ9Fx+C87RJhXoqNNCKJRWeLXpMlQQyQl
        Zt68A7XVQ+JZxwswWwhk06zLkhMY5WchzF/AyLiKUSy1oDg3PbXYqMAEOeo2MYJTqJbHDsbZ
        bz/oHWJk4mA8xCjBwawkwsvDxRsvxJuSWFmVWpQfX1Sak1p8iNEUGIgTmaVEk/OBSTyvJN7Q
        1MjMzMDS1MLUzMhCSZz3ndWFOCGB9MSS1OzU1ILUIpg+Jg5OqQam6KcXd/RvL+tPZnvQMLfz
        dKZlHYedl8XEduubV6ZuKAz9YiQ88/Hs+dePH+f9Iv3pzxzXu5xPz1i+7qqXWL9gwZ8vRh5H
        jnKvCLr7U6vPbs9SP9Fl7Wdv8fPyvLHv/HX5RrjftHkPt5WyzjghcqbP+anBvA0T6j4eN8k5
        9bZS+9IDoVOPJeccvTtzw+egeUI7GMIPHj7vc/2Z5+YLJb7qmW8Cgiw2/FdWuDX54OctYnEb
        QlP/CRxp/e45aXpQw+kqBoVZ/go3yuJbO6Kya5d8ZuPp1mvaftr0VsPt6ivOoXmskttjp14R
        9drauDUr0LpyztMlu4O0NUOutnEam73O8k6XOfHn0r9dJ6crmi+fNlGJpTgj0VCLuag4EQAK
        xIPZKgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsWy7bCSvO76LXzxBgf/c1g8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7K4ueUoi0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58HpeveHtc7utl8piw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAEc
        UVw2Kak5mWWpRfp2CVwZU570sxf0GVV8mDyVvYHxjWYXIyeHhICJxK67nWxdjFwcQgI7GCVO
        fZ/FCpGQlDix8zkjhC0scb/lCCtE0TdGiTf7tjKDJNgENCWe3pzKBJIQETjMJPF/63N2kASz
        gLrErgkngBIcHMICDhJPGgNATBYBVYnHveIgJq9AtMT2o1YQ4+Ukbp7rBJvIKWApsW7SebAh
        QgIWEpvevWfEJT6BUWABI8MqRsnUguLc9NxiwwKjvNRyveLE3OLSvHS95PzcTYzgKNDS2sG4
        Z9UHvUOMTByMhxglOJiVRHh5uHjjhXhTEiurUovy44tKc1KLDzFKc7AoifN+nbUwTkggPbEk
        NTs1tSC1CCbLxMEp1cBkYCH1RnbNx6k33vxn/Vbd0G3tFnT/3lf3knptpYRfbxfLPX6y9oe7
        6uQZXzccmSKyeb1hSq1jaPzbJBcbvzOMzoKSGpWHlfJsN6jkcoWsWtO580NXWfuvb1WC58Ne
        7TjpdmL9GpsAY4/KaLEpW+dFfVz+Paqsm5/lyqnrhQIyE7f9exiW/9BToGT/ttzGpQ9LHNd+
        eTajfR7/tNAlRs9ffxR8uCttzvx9dcpz/81eNe1RaPW/k6LxyfMuZCeGVF8qWD5tluSB8Hmi
        NzmZtticfG1+mL2u7e6Whmj760dmaSukt5/ffHzTLqYTa28fN7AJ6Zh4ZItLYw7nT6l5+S//
        /mZsczz+c35t7ZXvD2NjXJRYijMSDbWYi4oTAcYhL/vxAgAA
X-CMS-MailID: 20200715074759epcas2p2a2046f8fc8548601d644089c141ab7cd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200715074759epcas2p2a2046f8fc8548601d644089c141ab7cd
References: <cover.1594798514.git.kwmad.kim@samsung.com>
        <CGME20200715074759epcas2p2a2046f8fc8548601d644089c141ab7cd@epcas2p2.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

At present, I just add command history print and
you can add various vendor regions.

I tried this with force error injection to verify
this:

[  421.876751] exynos-ufs 13100000.ufs: :---------------------------------------------------
[  421.876767] exynos-ufs 13100000.ufs: :\x09\x09SCSI CMD(19262)
[  421.876779] exynos-ufs 13100000.ufs: :---------------------------------------------------
[  421.876793] exynos-ufs 13100000.ufs: :OP, TAG, LBA, SCT, RETRIES, STIME, ETIME, REQS\x0a
...
[  421.876979] exynos-ufs 13100000.ufs: : 0x2a, 00, 0x0012f1ae, 0x10000, 5, 415979836143, 0, 0x0
[  421.876991] exynos-ufs 13100000.ufs: : 0x2a, 00, 0x00f7ddbc, 0x410000, 5, 416246257103, 0, 0x0
[  421.877004] exynos-ufs 13100000.ufs: : 0x2a, 01, 0x00130e62, 0x80000, 5, 416246296834, 0, 0x1
[  421.877017] exynos-ufs 13100000.ufs: : 0x2a, 02, 0x0085597f, 0x40000, 5, 416246309988, 0, 0x3
[  421.877030] exynos-ufs 13100000.ufs: : 0x2a, 03, 0x00855985, 0x240000, 5, 416246331373, 0, 0x7
...
[  421.877206] exynos-ufs 13100000.ufs: : 0x2a, 00, 0x0012f1b9, 0x10000, 5, 417676828598, 0, 0x0
[  421.877217] exynos-ufs 13100000.ufs: : 0x2a, 00, 0x0012f1ba, 0x10000, 5, 417677462136, 0, 0x0

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
Tested-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/Kconfig          |  2 +-
 drivers/scsi/ufs/ufs-exynos-dbg.c | 11 +++++------
 drivers/scsi/ufs/ufs-exynos.c     | 13 ++++++++++++-
 drivers/scsi/ufs/ufs-exynos.h     | 10 ++++++++--
 4 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index c946d8f..b906ff8 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -181,7 +181,7 @@ config SCSI_UFS_EXYNOS_DBG
 	  This selects EXYNOS specific functions to get and even print
 	  some information to see what's happening at both command
 	  issue time completion time.
-	  The information may contain gerernal things as well as
+	  The information may contain general things as well as
 	  EXYNOS specific, such as vendor specific hardware contexts.
 
 	  Select this if you want to get and print the information.
diff --git a/drivers/scsi/ufs/ufs-exynos-dbg.c b/drivers/scsi/ufs/ufs-exynos-dbg.c
index e1f1452..bd1f4be 100644
--- a/drivers/scsi/ufs/ufs-exynos-dbg.c
+++ b/drivers/scsi/ufs/ufs-exynos-dbg.c
@@ -74,6 +74,7 @@ static void ufs_s_print_cmd_log(struct ufs_s_dbg_mgr *mgr, struct device *dev)
 	dev_err(dev, ":OP, TAG, LBA, SCT, RETRIES, STIME, ETIME, REQS\n\n");
 
 	idx = (last == max - 1) ? 0 : last + 1;
+	data = &cmd_info->data[idx];
 	for (i = 0 ; i < max ; i++, data = &cmd_info->data[idx]) {
 		dev_err(dev, ": 0x%02x, %02d, 0x%08llx, 0x%04x, %d, %llu, %llu, 0x%llx",
 			data->op, data->tag, data->lba, data->sct, data->retries,
@@ -122,9 +123,7 @@ void exynos_ufs_dump_info(struct ufs_exynos_handle *handle, struct device *dev)
 
 	mgr->time = cpu_clock(raw_smp_processor_id());
 
-#ifdef CONFIG_SCSI_UFS_EXYNOS_CMD_LOG
 	ufs_s_print_cmd_log(mgr, dev);
-#endif
 
 	if (mgr->first_time == 0ULL)
 		mgr->first_time = mgr->time;
@@ -139,8 +138,8 @@ void exynos_ufs_cmd_log_start(struct ufs_exynos_handle *handle,
 	struct scsi_cmnd *cmd = hba->lrb[tag].cmd;
 	int cpu = raw_smp_processor_id();
 	struct cmd_data *cmd_log = &mgr->cmd_log;	/* temp buffer to put */
-	u64 lba = 0;
-	u32 sct = 0;
+	u64 lba;
+	u32 sct;
 
 	if (mgr->active == 0)
 		return;
@@ -153,8 +152,8 @@ void exynos_ufs_cmd_log_start(struct ufs_exynos_handle *handle,
 	cmd_log->outstanding_reqs = hba->outstanding_reqs;
 
 	/* Now assume using WRITE_10 and READ_10 */
-	put_unaligned(cpu_to_le32(*(u32 *)cmd->cmnd[2]), &lba);
-	put_unaligned(cpu_to_le16(*(u16 *)cmd->cmnd[7]), &sct);
+	lba = get_unaligned_be32(&cmd->cmnd[2]);
+	sct = get_unaligned_be32(&cmd->cmnd[7]);
 	if (cmd->cmnd[0] != UNMAP)
 		cmd_log->lba = lba;
 
diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 53b9d6e..be2e74f 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -1033,7 +1033,6 @@ static int exynos_ufs_init(struct ufs_hba *hba)
 	ret = exynos_ufs_init_dbg(&ufs->handle, dev);
 	if (ret)
 		return ret;
-	spin_lock_init(&ufs->dbg_lock);
 	return 0;
 
 phy_off:
@@ -1236,6 +1235,17 @@ static int exynos_ufs_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	return 0;
 }
 
+static void exynos_ufs_dbg_register_dump(struct ufs_hba *hba)
+{
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
+
+	if (!test_and_set_bit(EXYNOS_UFS_DBG_DUMP_CXT, &ufs->dbg_flag)) {
+		exynos_ufs_dump_info(&ufs->handle, hba->dev);
+		clear_bit(EXYNOS_UFS_DBG_DUMP_CXT, &ufs->dbg_flag);
+	}
+	return;
+}
+
 static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.name				= "exynos_ufs",
 	.init				= exynos_ufs_init,
@@ -1248,6 +1258,7 @@ static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.hibern8_notify			= exynos_ufs_hibern8_notify,
 	.suspend			= exynos_ufs_suspend,
 	.resume				= exynos_ufs_resume,
+	.dbg_register_dump		= exynos_ufs_dbg_register_dump,
 };
 
 static int exynos_ufs_probe(struct platform_device *pdev)
diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index b9cb517..cd752eb 100644
--- a/drivers/scsi/ufs/ufs-exynos.h
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -215,8 +215,8 @@ struct exynos_ufs {
 #define EXYNOS_UFS_OPT_USE_SW_HIBERN8_TIMER	BIT(4)
 
 	struct ufs_exynos_handle handle;
-	spinlock_t dbg_lock;
-	int under_dump;
+	unsigned long dbg_flag;
+#define EXYNOS_UFS_DBG_DUMP_CXT			BIT(0)
 };
 
 #define for_each_ufs_rx_lane(ufs, i) \
@@ -297,6 +297,7 @@ void exynos_ufs_cmd_log_start(struct ufs_exynos_handle *handle,
 void exynos_ufs_cmd_log_end(struct ufs_exynos_handle *handle,
 			    struct ufs_hba *hba, int tag);
 int exynos_ufs_init_dbg(struct ufs_exynos_handle *handle, struct device *dev);
+void exynos_ufs_dump_info(struct ufs_exynos_handle *handle, struct device *dev);
 #else
 void exynos_ufs_cmd_log_start(struct ufs_exynos_handle *handle,
 			      struct ufs_hba *hba, int tag)
@@ -312,5 +313,10 @@ int exynos_ufs_init_dbg(struct ufs_exynos_handle *handle, struct device *dev)
 {
 	return 0;
 }
+
+void exynos_ufs_dump_info(struct ufs_exynos_handle *handle, struct device *dev)
+{
+	return;
+}
 #endif
 #endif /* _UFS_EXYNOS_H_ */
-- 
2.7.4

