Return-Path: <SRS0=CpYn=AB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9CADC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 07:39:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94154239D2
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 07:39:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="MeGtUJXC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbgFTHjX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Jun 2020 03:39:23 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41712 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgFTHjW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Jun 2020 03:39:22 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200620073918epoutp030a9b1636d8271f4e2435b3f76e38da90~aMINLth4N3099230992epoutp03-
        for <linux-scsi@vger.kernel.org>; Sat, 20 Jun 2020 07:39:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200620073918epoutp030a9b1636d8271f4e2435b3f76e38da90~aMINLth4N3099230992epoutp03-
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592638758;
        bh=gbLzNkh7YdNcmin4lMx0Xai8fozVYmBfap1tGd47Y/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MeGtUJXCpjUWNWo5ctviNLw7QaZBxecQwUzvsK2DZuOJFY+s2nTzTLOFh+lnlRaHv
         QO7KN6FYXyerAesVcvNrYq6oeGV8CItcKOzLPyBHiixVTzS1LzDtb8hy74IbYF7VDB
         Bv349V8xv0zZKTNO/l6DO5DrgAN7VIIrMeCzmVUg=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20200620073917epcas2p2be28fea64ada4fdd42a2fa0b83a68aec~aMILtok8A0360603606epcas2p29;
        Sat, 20 Jun 2020 07:39:17 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.190]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 49pncM2pbNzMqYkZ; Sat, 20 Jun
        2020 07:39:15 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        C7.43.19322.32DBDEE5; Sat, 20 Jun 2020 16:39:15 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20200620073914epcas2p2c788e787f4fff602de61e5f8e5fb79ae~aMII9546c1035810358epcas2p2e;
        Sat, 20 Jun 2020 07:39:14 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200620073914epsmtrp16c32ec09203f928d088f50ade6800d26~aMII9H3Y10771907719epsmtrp1A;
        Sat, 20 Jun 2020 07:39:14 +0000 (GMT)
X-AuditID: b6c32a45-797ff70000004b7a-a3-5eedbd239ebc
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F7.D6.08303.22DBDEE5; Sat, 20 Jun 2020 16:39:14 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200620073913epsmtip289fdf586ea389470f6e1e766752ea950~aMIIzU8OE2468524685epsmtip2f;
        Sat, 20 Jun 2020 07:39:13 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v1 1/2] ufs: support various values per device
Date:   Sat, 20 Jun 2020 16:31:36 +0900
Message-Id: <1592638297-36155-2-git-send-email-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1592638297-36155-1-git-send-email-kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJKsWRmVeSWpSXmKPExsWy7bCmma7y3rdxBmv2C1g8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWiy6sY3J4uaWoywW3dd3sFksP/6PyYHL4/IVb4/Lfb1M
        HhMWHWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYAjKscmIzUxJbVIITUvOT8lMy/dVsk7
        ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+hGJYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+
        cYmtUmpBSk6BoWGBXnFibnFpXrpecn6ulaGBgZEpUGVCTsbMP5/YCjbLVPw65dTA2CHexcjJ
        ISFgInGs4SBzFyMXh5DADkaJYxNvQjmfGCWuvj7LDlIlJPCZUaLnmCFMx9HrC1kginYxSpxY
        848dwvnBKPFp+QUmkCo2AU2JpzenMoEkRARuMErMaT7MCpJgFlCX2DXhBFiRsICTxIaG9WA2
        i4CqxL7m6UA2BwevgKvE7pMFENvkJG6e62QGsTkF3CT2bXsIdp6EwFd2iX9XLzBCFLlI7Hz7
        jA3CFpZ4dXwLO4QtJfGyvw3KrpfYN7WBFaK5h1Hi6b5/UM3GErOetTOCLGYGunr9Ln0QU0JA
        WeLILRaIk/kkOg7/ZYcI80p0tAlBNCpL/Jo0GWqIpMTMm3egNnlI9J5rgYbJTEaJ+avmsk1g
        lJuFsGABI+MqRrHUguLc9NRiowJD5AjbxAhOg1quOxgnv/2gd4iRiYPxEKMEB7OSCO/h92/i
        hHhTEiurUovy44tKc1KLDzGaAsNuIrOUaHI+MBHnlcQbmhqZmRlYmlqYmhlZKInz5ipeiBMS
        SE8sSc1OTS1ILYLpY+LglGpg2rZeKDytaC/fVR3Go/H7lq7KLzPiSjiyZYtOkfmL7HdRL+Vs
        Z596vzNpUiRXd8sMD8NSpUvhjRvjaqeuNvKbM99tuY7W7aTaCo9NC3KTSuTT3z7I9k7d+vJP
        0CrTXUoW/6SWGXHcXJi5ecXnW8+n71AT+7DLL/vqcZk7D/4yv90ao2DsG1YpvaZ59Uspx8z0
        7NlNMzLOmMzun5B5NPPb5ZZZXQE3HCY8kWn/OznWybNTWPzu5bdluRv+PGn/zW216dg9WQub
        h08fXJy9cvtXtoAEH7W4a0dnPud8lFbOpcn0dFvun4NC4rzPfMRjNztm7LjvV7mYp+d0+Iyb
        0ZrdFQt8jeoFPXZ03WQSr/jBpsRSnJFoqMVcVJwIADO3AFEMBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsWy7bCSvK7S3rdxBncPs1o8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWiy6sY3J4uaWoywW3dd3sFksP/6PyYHL4/IVb4/Lfb1M
        HhMWHWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYAjissmJTUnsyy1SN8ugStj5p9PbAWb
        ZSp+nXJqYOwQ72Lk5JAQMJE4en0hSxcjF4eQwA5Gia6389kgEpISJ3Y+Z4SwhSXutxxhhSj6
        xihxcdpVZpAEm4CmxNObU5lAEiICjxglfs/sZAdJMAuoS+yacIIJxBYWcJLY0LAezGYRUJXY
        1zwdyObg4BVwldh9sgBigZzEzXOdYDM5Bdwk9m17CGYLAZVc+LGUeQIj3wJGhlWMkqkFxbnp
        ucWGBUZ5qeV6xYm5xaV56XrJ+bmbGMHhqqW1g3HPqg96hxiZOBgPMUpwMCuJ8B5+/yZOiDcl
        sbIqtSg/vqg0J7X4EKM0B4uSOO/XWQvjhATSE0tSs1NTC1KLYLJMHJxSDUwX/yountjO3DjR
        r+vuyfI1pwsWO9hLN2zZ3uBxgOt5w5d1LbfPtLp3eSyVTdFNvDzNQDR1grbCRLNpgso5m8+I
        2J3cecpzrkey1+wJG7TiVkQe3jVl3rl35uf53wmc/TRT++SDGd38b3gmd3vu8lyw9GyTYzKH
        a/Uhg8j/b7N2X8pcsGhSuvurVFOhKPELp6xumaYvumV+8JTdxE35kerHrW49WHXA3Vy9bd8T
        j+cH+U4dZTxray9k8vXcT2mWq7ufdi+2TYn/nBXqNtO0xlWy6tvkfUcbee/nHjz4lCO2ytXi
        tIpibVLGT0H7v//KZ2nLPZ4XWD794v6lGlw7s97Ifo4+kNVgm323yk32qshyJZbijERDLeai
        4kQApHrCo8YCAAA=
X-CMS-MailID: 20200620073914epcas2p2c788e787f4fff602de61e5f8e5fb79ae
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200620073914epcas2p2c788e787f4fff602de61e5f8e5fb79ae
References: <1592638297-36155-1-git-send-email-kwmad.kim@samsung.com>
        <CGME20200620073914epcas2p2c788e787f4fff602de61e5f8e5fb79ae@epcas2p2.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Respective UFS devices have their own characteristics and
many of them could be a form of numbers, such as timeout
and a number of retires. This introduces the way to set
those things per specific device vendor or specific device.

I wrote this like the style of ufs_fixups stuffs.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufs_quirks.h | 20 ++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c     | 38 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.h     |  1 +
 3 files changed, 59 insertions(+)

diff --git a/drivers/scsi/ufs/ufs_quirks.h b/drivers/scsi/ufs/ufs_quirks.h
index 2a00414..9896d98 100644
--- a/drivers/scsi/ufs/ufs_quirks.h
+++ b/drivers/scsi/ufs/ufs_quirks.h
@@ -29,6 +29,19 @@ struct ufs_dev_fix {
 	unsigned int quirk;
 };
 
+enum dev_val_type {
+	DEV_VAL_FDEVICEINIT	= 0x0,
+	DEV_VAL_NUM,
+};
+
+struct ufs_dev_value {
+	u16 wmanufacturerid;
+	u8 *model;
+	u32 key;
+	u32 val;
+	bool enable;
+};
+
 #define END_FIX { }
 
 /* add specific device quirk */
@@ -38,6 +51,13 @@ struct ufs_dev_fix {
 	.quirk = (_quirk),		   \
 }
 
+#define UFS_DEV_VAL(_vendor, _model, _key, _val) { \
+	.wmanufacturerid = (_vendor),\
+	.model = (_model),		\
+	.key = (_key),			\
+	.val = (_val),			\
+}
+
 /*
  * Some vendor's UFS device sends back to back NACs for the DL data frames
  * causing the host controller to raise the DFES error status. Sometimes
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 52abe82..b6bc333 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -207,6 +207,21 @@ static struct ufs_dev_fix ufs_fixups[] = {
 	END_FIX
 };
 
+static struct ufs_dev_value ufs_dev_values[] = {
+	END_FIX
+};
+
+static inline bool
+ufs_get_dev_specific_value(struct ufs_hba *hba,
+			   enum dev_val_type type, u32 *val)
+{
+	if (!ufs_dev_values[type].enable)
+		return false;
+
+	*val = hba->dev_value[type];
+	return true;
+}
+
 static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba);
 static void ufshcd_async_scan(void *data, async_cookie_t cookie);
 static int ufshcd_reset_and_restore(struct ufs_hba *hba);
@@ -6923,11 +6938,34 @@ void ufshcd_fixup_dev_quirks(struct ufs_hba *hba, struct ufs_dev_fix *fixups)
 }
 EXPORT_SYMBOL_GPL(ufshcd_fixup_dev_quirks);
 
+void ufshcd_set_dev_values(struct ufs_hba *hba, struct ufs_dev_value *value)
+{
+	struct ufs_dev_value *f;
+	struct ufs_dev_info *dev_info = &hba->dev_info;
+
+	if (!value)
+		return;
+
+	for (f = value; f->val; f++) {
+		if ((f->wmanufacturerid == dev_info->wmanufacturerid ||
+		     f->wmanufacturerid == UFS_ANY_VENDOR) &&
+		     ((dev_info->model &&
+		       STR_PRFX_EQUAL(f->model, dev_info->model)) ||
+		      !strcmp(f->model, UFS_ANY_MODEL))) {
+			f->enable = true;
+			hba->dev_value[f->key] = f->val;
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(ufshcd_set_dev_values);
+
 static void ufs_fixup_device_setup(struct ufs_hba *hba)
 {
 	/* fix by general quirk table */
 	ufshcd_fixup_dev_quirks(hba, ufs_fixups);
 
+	ufshcd_set_dev_values(hba, ufs_dev_values);
+
 	/* allow vendors to fix quirks */
 	ufshcd_vops_fixup_dev_quirks(hba);
 }
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index c774012..f221ca7 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -670,6 +670,7 @@ struct ufs_hba {
 
 	/* Device deviations from standard UFS device spec. */
 	unsigned int dev_quirks;
+	u32 dev_value[DEV_VAL_NUM];
 
 	struct blk_mq_tag_set tmf_tag_set;
 	struct request_queue *tmf_queue;
-- 
2.7.4

