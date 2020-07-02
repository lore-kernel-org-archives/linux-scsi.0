Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29BF1C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 02:19:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 042BF2070C
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 02:19:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="oPPhuM5P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgGBCTr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 22:19:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:14949 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbgGBCTq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 22:19:46 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200702021942epoutp04d89d1d93429d672f820d9445d10d16be~dzglTgX702403724037epoutp04J
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2020 02:19:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200702021942epoutp04d89d1d93429d672f820d9445d10d16be~dzglTgX702403724037epoutp04J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593656382;
        bh=gq8XNEz6DfOt51iMcSSB/6Jvegbfc40c/aYHfEzFe4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=oPPhuM5PQ621QEfdjksn7MxwFYHBUmMVMUY8bl7p9F58NdPPx6Nots8FylOi7/5Oz
         WTisukhMoD601RAMHDmI9wTJ3B2mMoEPVcsD/qXY9s+m8S2cFqHtsUExhlKWxcGt8F
         Scg8gSnrq5LoLxEwWx7geh1MuCVj7znvrdByON6U=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20200702021941epcas2p254c359ef50127b5ae3c31eb87e61531e~dzgkuvrSB1209212092epcas2p2r;
        Thu,  2 Jul 2020 02:19:41 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.186]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 49y1y34dfgzMqYlp; Thu,  2 Jul
        2020 02:19:39 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        12.25.18874.A344DFE5; Thu,  2 Jul 2020 11:19:38 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20200702021938epcas2p249e149341d6227a2c10ab25a8695f579~dzghBzkWo1209212092epcas2p2m;
        Thu,  2 Jul 2020 02:19:38 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200702021938epsmtrp2763b804baf71e26c9b8471fc868ba1bb~dzghBCp8Z1404614046epsmtrp20;
        Thu,  2 Jul 2020 02:19:38 +0000 (GMT)
X-AuditID: b6c32a46-519ff700000049ba-f9-5efd443a1661
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B1.AE.08382.9344DFE5; Thu,  2 Jul 2020 11:19:37 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200702021937epsmtip13c7625f64ca8015993088f2c9ea70208~dzggw7-Sh2260422604epsmtip1B;
        Thu,  2 Jul 2020 02:19:37 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v1 1/2] ufs: support various values per device
Date:   Thu,  2 Jul 2020 11:11:48 +0900
Message-Id: <464c059503bf1262e01bb16ea9b0726bc179be8c.1593655834.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1593655834.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1593655834.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjk+LIzCtJLcpLzFFi42LZdljTVNfK5W+cwdz//BYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFotubGOyuLnlKItF9/UdbBbLj/9jcuDyuHzF2+NyXy+T
        x4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0H+hmCuCIyrHJSE1MSS1SSM1Lzk/JzEu3VfIO
        jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpRSaEsMacUKBSQWFyspG9nU5RfWpKqkJFf
        XGKrlFqQklNgaFigV5yYW1yal66XnJ9rZWhgYGQKVJmQk3F0URNLwWnJih9H+9gbGJtFuxg5
        OSQETCRmTjzO3sXIxSEksINRYuXKV0wQzidGiYULj7JCON8YJTq2bgFyOMBaVpy3gojvZZS4
        efo5C4Tzg1Fi+fl+VpC5bAKaEk9vTgUbJSJwg1FiTvNhsASzgLrErgknmEBsYQE7iQPXzoPZ
        LAKqEn3NTWA2r0C0xJ5FIFNBDpSTuHmukxnE5hSwlDi07yojKpsLqOYnu8SWpldsEA0uEkuu
        nWOEsIUlXh3fwg5hS0l8frcXqqZeYt/UBlaI5h5Giaf7/kE1GEvMetbOCPInM9AL63fpQ7ys
        LHHkFgvE/XwSHYf/skOEeSU62oQgGpUlfk2aDDVEUmLmzTtQWz0kTnR/B9sqBLLpx06eCYzy
        sxDmL2BkXMUollpQnJueWmxUYIQce5sYwQlSy20H45S3H/QOMTJxMB5ilOBgVhLhPW3wK06I
        NyWxsiq1KD++qDQntfgQoykwHCcyS4km5wNTdF5JvKGpkZmZgaWphamZkYWSOG+94oU4IYH0
        xJLU7NTUgtQimD4mDk6pBqbpm4urfrLGTJsh9t2GT/mLT3Siq+fsE5Hivvubu19G95caBa7a
        kaiZH2qtPn1J+eRZmqxuXPnWSl/4p5k9OP2t6e/O6vBAni+m3J6bbvZHrVFvmf2Z7/A1x5eG
        s5XXPny8VHVvPv8dBslpstPmFGZN2TF/SVWIX9kh2RUzptqHF57Z/OrkQyeWXd/6b7xe/OrV
        pw3zjzgaRa/5p5dr8avR1eohs/6uQ9ret9tZdmo+OD7dVCdUb/qjZb+v2q9/7H5QOty//+Pp
        Er2Nd33N61h0GWOOcbz0fGYzx9Cz36SN9zZHIzvfinkvQzKu7I4LlRHxWVhmW3Tygcftcr2f
        T+2vSi3Jnu6R+GzvWg794HlKLMUZiYZazEXFiQBDPd9eGQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsWy7bCSnK6ly984g9dXjS0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLRbd2MZkcXPLURaL7us72CyWH//H5MDlcfmKt8flvl4m
        jwmLDjB6fF/fwebx8ektFo++LasYPT5vkvNoP9DNFMARxWWTkpqTWZZapG+XwJVxdFETS8Fp
        yYofR/vYGxibRbsYOTgkBEwkVpy36mLk4hAS2M0oceLiA9YuRk6guKTEiZ3PGSFsYYn7LUdY
        IYq+MUpcOr2EHSTBJqAp8fTmVCaQhIjAI0aJ3zM7wRLMAuoSuyacYAKxhQXsJA5cOw9mswio
        SvQ1N4HZvALREnsWPWeB2CAncfNcJzOIzSlgKXFo31WwzUICFhJrnjxjxCU+gVFgASPDKkbJ
        1ILi3PTcYsMCw7zUcr3ixNzi0rx0veT83E2M4ADX0tzBuH3VB71DjEwcjIcYJTiYlUR4Txv8
        ihPiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6NwYZyQQHpiSWp2ampBahFMlomDU6qBKdGpkE3x
        2b0HTYombFsc1xVECd16nLU/lfHCkoQtlcxT1t1WPljV9kL1y7ulbT68t5jW3SrpN5nj8uWi
        c+K0N021P8Kmbi/7XpjEX/PNYsa9+jsn/NyPMKw941gcoOlb6/csf9qJvPkv41OihWKTU5Yd
        3lrRmTNJ+ddJBynXlx0VM1I/PfO/033ZtF6rYo9RwsKpDy93xBUbes+3UqxoVmcxWrfetZbh
        tzavwNQnq/+ukzSqPffm/nU9i8f/+RItxRdfKLp+lEcjf6XXXbtqA+NZOjIBp43Db0urMfXO
        urKq9v2ufN5nWR/STbZdvx1WZ7u6ZtHMyscS3JWtReuEVQuc1l3YEPxg7txDJnd5lViKMxIN
        tZiLihMBDE0xwN8CAAA=
X-CMS-MailID: 20200702021938epcas2p249e149341d6227a2c10ab25a8695f579
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200702021938epcas2p249e149341d6227a2c10ab25a8695f579
References: <cover.1593655834.git.kwmad.kim@samsung.com>
        <CGME20200702021938epcas2p249e149341d6227a2c10ab25a8695f579@epcas2p2.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>

Respective UFS devices have their own characteristics and
many of them could be a form of numbers, such as timeout
and a number of retires. This introduces the way to set
those things per specific device vendor or specific device.

I wrote this like the style of ufs_fixups stuffs.
---
 drivers/scsi/ufs/ufs_quirks.h | 13 +++++++++++++
 drivers/scsi/ufs/ufshcd.c     | 39 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.h     |  1 +
 3 files changed, 53 insertions(+)

diff --git a/drivers/scsi/ufs/ufs_quirks.h b/drivers/scsi/ufs/ufs_quirks.h
index 2a00414..f074093 100644
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
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 52abe82..7b6f13a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -207,6 +207,21 @@ static struct ufs_dev_fix ufs_fixups[] = {
 	END_FIX
 };
 
+static const struct ufs_dev_value ufs_dev_values[] = {
+	{0, 0, 0, 0, false},
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
@@ -6923,11 +6938,35 @@ void ufshcd_fixup_dev_quirks(struct ufs_hba *hba, struct ufs_dev_fix *fixups)
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
+					f->wmanufacturerid == UFS_ANY_VENDOR) &&
+				((dev_info->model &&
+				  STR_PRFX_EQUAL(f->model, dev_info->model)) ||
+				 !strcmp(f->model, UFS_ANY_MODEL))) {
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
 
+	/* set device specific values */
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

