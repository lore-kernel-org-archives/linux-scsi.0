Return-Path: <SRS0=uOdR=AW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BC4DC433E4
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jul 2020 07:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6629A207D4
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jul 2020 07:05:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ZN59jpZG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgGKHFw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Jul 2020 03:05:52 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:22371 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728012AbgGKHFv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jul 2020 03:05:51 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200711070547epoutp049224baa9b027b49f626d6ac6d706a364~goN78NVHt2541925419epoutp04L
        for <linux-scsi@vger.kernel.org>; Sat, 11 Jul 2020 07:05:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200711070547epoutp049224baa9b027b49f626d6ac6d706a364~goN78NVHt2541925419epoutp04L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594451147;
        bh=z0DyozeBUNupwNMnBRpmcus0h9qYbAMUrFqrwRE7uqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=ZN59jpZGAq4c2IcJZIA/7XhqX+rbcWjAkau68/0NVCaffNqGkhRtozPiubvfoL0fY
         XQgzk2bnHdL8GK9tpltVp3Bph5Q5OZ/sokdopSfYCPZmZN59JLNJae7TLaTYYRpBBe
         k7mXNYe3MFzbCkkUz651g66qTo5t+phiFfnL1EjM=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20200711070546epcas2p2a0f189e3d65ab513fec3f9361c2d6f36~goN7TRMe20916109161epcas2p2v;
        Sat, 11 Jul 2020 07:05:46 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.185]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4B3gt06cjXzMqYls; Sat, 11 Jul
        2020 07:05:44 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        E3.85.27441.8C4690F5; Sat, 11 Jul 2020 16:05:44 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200711070544epcas2p10291ef069c92d54a7cb8a6b7e0eb09a1~goN5FdyI72183221832epcas2p1j;
        Sat, 11 Jul 2020 07:05:44 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200711070544epsmtrp197b3cc2a8cbc22222f9a761361e48e24~goN5Es1DC0578505785epsmtrp1Z;
        Sat, 11 Jul 2020 07:05:44 +0000 (GMT)
X-AuditID: b6c32a47-fc5ff70000006b31-2b-5f0964c84a10
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        31.79.08382.8C4690F5; Sat, 11 Jul 2020 16:05:44 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200711070544epsmtip28446a4954643d9a020b5072526fda6eb~goN451HJ60072700727epsmtip2E;
        Sat, 11 Jul 2020 07:05:44 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v5 3/3] ufs: exynos: implement dbg_register_dump
Date:   Sat, 11 Jul 2020 15:57:45 +0900
Message-Id: <c8a2e31269685692b456b278afb5113f46afe3ed.1594450408.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1594450408.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1594450408.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJJsWRmVeSWpSXmKPExsWy7bCmme6JFM54g89dJhYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        VI5NRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDdSgpl
        iTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwCQ8MCveLE3OLSvHS95PxcK0MDAyNToMqE
        nIylNzayFmyXr2hbHtfAOEeqi5GDQ0LAROJQZ10XIxeHkMAORome5RcYIZxPjBKbv/9mhnC+
        MUos39LN1sXICdYx4+4fNojEXkaJOzfbmSCcH4wSTcf3soJUsQloSjy9ORUsISKwmUni1YL7
        zCAJZgF1iV0TTjCB2MICLhJNE/eD2SwCqhLtax8wghzFKxAt8aLdCmKbnMTNc51grZwClhJn
        n15gQWVzAdVM5JDoPn+TEaLBRWLPxtPsELawxKvjW6BsKYmX/W1Qdr3EvqkNrBDNPYwST/f9
        g2o2lpj1rB3sCGagD9bv0ocEkrLEkVssEOfzSXQc/ssOEeaV6GgTgmhUlvg1aTLUEEmJmTfv
        QG3ykNi55Qw0sIA2PVrezjiBUX4WwoIFjIyrGMVSC4pz01OLjQqMkSNvEyM4jWq572Cc8faD
        3iFGJg7GQ4wSHMxKIrzRopzxQrwpiZVVqUX58UWlOanFhxhNgeE4kVlKNDkfmMjzSuINTY3M
        zAwsTS1MzYwslMR5i60uxAkJpCeWpGanphakFsH0MXFwSjUwFT911XvO0lJTq6XFxTxZ+l//
        v8fxKfdtzL/zHGwoZom/HalhcMRfeOuZzlndps5sXDMW38+P7v325/911711ymyh7R8f/zyt
        45314VHDq/D7a6WtPD+6VjpNyD5iafJ/m98s0T/rD3z8IlpwJS70Y3wkW8g+pyDzlUz/hawX
        RD4x/SptIqgy+VhKeO7VoFcmkvKGB8tZ2vZp3GAv9LW5kfYxME3r7fstDFMND9f+M1z9d3P1
        fsHAroYHwSw3LOWV15wTCWN+N/emmGRRlem3iRWHlwk9OP26aMfzb6diBPZOTC4wnvVmysuG
        xuOSXXdUpEJv3G88sG8jV6j1u99HmDpWbV1cuPvUXfVPX4/VKbEUZyQaajEXFScCABmfmsos
        BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsWy7bCSvO6JFM54g8UL5C0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        KC6blNSczLLUIn27BK6MpTc2shZsl69oWx7XwDhHqouRk0NCwERixt0/bF2MXBxCArsZJWav
        b2WCSEhKnNj5nBHCFpa433KEFcQWEvjGKLFqYjiIzSagKfH05lQmkGYRgcNMEv+3PmcHSTAL
        qEvsmnACbJCwgItE08T9YDaLgKpE+9oHQEM5OHgFoiVetFtBzJeTuHmukxnE5hSwlDj79AIL
        SImQgIXE2vl1OIQnMAosYGRYxSiZWlCcm55bbFhgmJdarlecmFtcmpeul5yfu4kRHAFamjsY
        t6/6oHeIkYmD8RCjBAezkghvtChnvBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeG4UL44QE0hNL
        UrNTUwtSi2CyTBycUg1Mp3n2b3zCIhmaMmfiRq+zGs2bRPiZc7siK4+y8Bd8qi9ftaHtreOm
        qed/mB8LldtyesfyuJgjLB1m0ZplLh83SK92s4567aR3e+KG5LYj5r5HxTZNSoxnXjiJR3/v
        sm3/FsgKKXdqBW5ku/8lPPrrmVeXMtfPja2bdHDj5x1CcTkJ1ysTbzOqiLrxl7SaZSxT6u59
        rm2sfz30U9x/IftLVfePLJ4RMPWZ/jPrQm+TNa6mDKmaqYX8EwK5g5M06qfZafveeal3beNs
        EUUHkfai2n8mX7Q2bqra36MaqGlpGqPdztTVvco6t2VzsbaPzudob8NshkXbW+7ZmzIfymmX
        mlRSllbP63d0hVRdkhJLcUaioRZzUXEiAOYXMZrvAgAA
X-CMS-MailID: 20200711070544epcas2p10291ef069c92d54a7cb8a6b7e0eb09a1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200711070544epcas2p10291ef069c92d54a7cb8a6b7e0eb09a1
References: <cover.1594450408.git.kwmad.kim@samsung.com>
        <CGME20200711070544epcas2p10291ef069c92d54a7cb8a6b7e0eb09a1@epcas2p1.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

At present, I just add command history print and
you can add various vendor regions.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/Kconfig          |  2 +-
 drivers/scsi/ufs/ufs-exynos-dbg.c |  2 --
 drivers/scsi/ufs/ufs-exynos.c     | 14 +++++++++++++-
 drivers/scsi/ufs/ufs-exynos.h     | 10 ++++++++--
 4 files changed, 22 insertions(+), 6 deletions(-)

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
index a626b71..7fd7308 100644
--- a/drivers/scsi/ufs/ufs-exynos-dbg.c
+++ b/drivers/scsi/ufs/ufs-exynos-dbg.c
@@ -121,9 +121,7 @@ void exynos_ufs_dump_info(struct ufs_exynos_handle *handle, struct device *dev)
 
 	mgr->time = cpu_clock(raw_smp_processor_id());
 
-#ifdef CONFIG_SCSI_UFS_EXYNOS_CMD_LOG
 	ufs_s_print_cmd_log(mgr, dev);
-#endif
 
 	if (mgr->first_time == 0ULL)
 		mgr->first_time = mgr->time;
diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 53b9d6e..444aba1 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -1033,7 +1033,6 @@ static int exynos_ufs_init(struct ufs_hba *hba)
 	ret = exynos_ufs_init_dbg(&ufs->handle, dev);
 	if (ret)
 		return ret;
-	spin_lock_init(&ufs->dbg_lock);
 	return 0;
 
 phy_off:
@@ -1236,6 +1235,18 @@ static int exynos_ufs_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
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
+out:
+	return;
+}
+
 static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.name				= "exynos_ufs",
 	.init				= exynos_ufs_init,
@@ -1248,6 +1259,7 @@ static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.hibern8_notify			= exynos_ufs_hibern8_notify,
 	.suspend			= exynos_ufs_suspend,
 	.resume				= exynos_ufs_resume,
+	.dbg_register_dump		= exynos_ufs_dbg_register_dump,
 };
 
 static int exynos_ufs_probe(struct platform_device *pdev)
diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index b9cb517..3f242de 100644
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
+	return 0;
+}
 #endif
 #endif /* _UFS_EXYNOS_H_ */
-- 
2.7.4

