Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0282EC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 18:43:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6CFB2064B
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 18:43:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="G0wScVvd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgF2Snq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 14:43:46 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:63877 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726153AbgF2Snj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 14:43:39 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200629102354epoutp03132295923ecaf9322b18b44722c0a29a~c-LfmH79U0684206842epoutp03e
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 10:23:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200629102354epoutp03132295923ecaf9322b18b44722c0a29a~c-LfmH79U0684206842epoutp03e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593426234;
        bh=gq8XNEz6DfOt51iMcSSB/6Jvegbfc40c/aYHfEzFe4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=G0wScVvdJ9ZMsIysEo1QewrnxsPi+rS7exn3iRRUiImfoJAQqp1BpeMTn9CqhnTuw
         Kafr1vdTDZRti0d1rRYFMgn9F5EJiNzZWQHCCuEY7crI3J3uV01sOD7LGf+zsvtCdu
         jHdO0zGp9ZDemDk8pToV1mdhIZkj3OZsc8kBCRMA=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20200629102354epcas2p32620640889b12a08d23ef5ca933d9549~c-LfLV0yh2931829318epcas2p3_;
        Mon, 29 Jun 2020 10:23:54 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.189]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 49wNr82JNszMqYkc; Mon, 29 Jun
        2020 10:23:52 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        4F.E2.18874.631C9FE5; Mon, 29 Jun 2020 19:23:50 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200629102350epcas2p4f4ef326c55c897479643ebcd3e132f50~c-LbGLIPS3182431824epcas2p4Q;
        Mon, 29 Jun 2020 10:23:50 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200629102350epsmtrp23711665e3648542f1633b7acfdb356d3~c-LbFi2Ez0132801328epsmtrp2P;
        Mon, 29 Jun 2020 10:23:50 +0000 (GMT)
X-AuditID: b6c32a46-519ff700000049ba-6a-5ef9c136db28
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E5.A1.08382.531C9FE5; Mon, 29 Jun 2020 19:23:50 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200629102349epsmtip25210435e2d4de3ebdd3c2a12134c8cdd~c-La8M02U0942409424epsmtip2e;
        Mon, 29 Jun 2020 10:23:49 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v2 1/2] ufs: support various values per device
Date:   Mon, 29 Jun 2020 19:15:55 +0900
Message-Id: <21f8e3dd4d68f9ef4009e0a05cfac1ee01dd7213.1593412974.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1593412974.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1593412974.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEKsWRmVeSWpSXmKPExsWy7bCmqa7ZwZ9xBkdnyFnc3HKUxaL7+g42
        ByaPvi2rGD0+b5ILYIrKsclITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21
        VXLxCdB1y8wBGq+kUJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJKTA0LNArTswtLs1L
        10vOz7UyNDAwMgWqTMjJOLqoiaXgtGTFj6N97A2MzaJdjJwcEgImEgtWvmPrYuTiEBLYwShx
        4udCdgjnE6NES99jqMw3Rom7c/czw7S8av3LCJHYyyix6PEcKOcHo8T3NZOYQKrYBDQlnt6c
        CmaLCMhJbF7+lQXEZhZQl9g14QRYXFjASeLTwY/sIDaLgKrE+ScXWEFsXoFoiWdr1rNAbJOT
        uHmuE2wzp4ClxIvb19HYXEA1/ewSU97+hGpwkbh46icrhC0s8er4FnYIW0ri87u9bBB2vcS+
        qQ2sEM09jBJP9/1jhEgYS8x61g5kcwBdqimxfpc+iCkhoCxx5BbU/XwSHYf/skOEeSU62oQg
        GpUlfk2aDDVEUmLmzTtQWz0kOi5/ZoWED9Cm9t6JjBMY5WchLFjAyLiKUSy1oDg3PbXYqMAI
        Ofo2MYITk5bbDsYpbz/oHWJk4mA8xCjBwawkwvvZ+lucEG9KYmVValF+fFFpTmrxIUZTYEBO
        ZJYSTc4Hpsa8knhDUyMzMwNLUwtTMyMLJXHeesULcUIC6YklqdmpqQWpRTB9TBycUg1MLZfX
        feZ/OtmwcUnI9jNRUQsyG96/XmgZ/OPGXdH1uRuPcMb7Lu/lD2p4sr5N57CF+OZsn+ZFC+y2
        vvi/LmThNMVTansd8/6eTI3yc/my7RVf0MuCi6feLKu54u14fc0UteaNoo7bYlUTTBIVN0/I
        2LjWm+3bq2Tx5YUrbQ4yporYXl38qbZPu/0gr9+abSq+OnVKbtNzlm/Jrg81+J9Wun+ZxFm/
        pmje5+e95oWd+Ol2oURh59fSB8qvTB7yx83qEVt4invCIWW/FSZ9zGceNDOe/qX9N8fm7FSD
        t89y+/3NVM6z8PutbTkWv96o9MsvjUP2HnYM7w9muYWffCWTaFHquk5yWvBFcb+1M1+VKLEU
        ZyQaajEXFScCAKTok+/VAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphluLIzCtJLcpLzFFi42LZdlhJXtfs4M84g6l7GS1ubjnKYtF9fQeb
        A5NH35ZVjB6fN8kFMEVx2aSk5mSWpRbp2yVwZRxd1MRScFqy4sfRPvYGxmbRLkZODgkBE4lX
        rX8ZQWwhgd2MEv+aUyHikhIndj5nhLCFJe63HGHtYuQCqvnGKLHo2V42kASbgKbE05tTmUBs
        EQE5ic3Lv7KA2MwC6hK7JpwAiwsLOEl8OviRHcRmEVCVOP/kAiuIzSsQLfFszXoWiAVyEjfP
        dTKD2JwClhIvbl8HsjmAlllIfDkUh0N4AqPAAkaGVYySqQXFuem5xYYFhnmp5XrFibnFpXnp
        esn5uZsYwQGlpbmDcfuqD3qHGJk4GA8xSnAwK4nwfrb+FifEm5JYWZValB9fVJqTWnyIUZqD
        RUmc90bhwjghgfTEktTs1NSC1CKYLBMHp1QD0+KFidJ/GC0DMu4rbWzLF4g12LxF7OjeXWwC
        P+saZjhrXK/+aLEnd0d0XsUB/vKtZVl5P6bOPJ4U/EIjnKVU9PyVJq5Pjv0X34WZ/NsUdOF/
        3fL2SzHz4zoOrJjhlD2Jt+RSwl/nVzy8qurPwh0/nk4XulAecOqABr/UcuEvVw72yuaK+l2v
        mserf2xNjb6jevPR4kjXw+717uxMR21eRYQu+uixlaXH9Nhp6TPT1si+YV3Bbfw6MSfd/MyC
        Fbn7i2vkN39yUO6qEXbnszO6MElm4+EZaScYnv36tV8mPfiTjmNyUGTJlTfWU0PfZi6qO6Ai
        kJf189k6uSt8ofqJklyv93OrsTfeVZI6oGysxFKckWioxVxUnAgAf78415cCAAA=
X-CMS-MailID: 20200629102350epcas2p4f4ef326c55c897479643ebcd3e132f50
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200629102350epcas2p4f4ef326c55c897479643ebcd3e132f50
References: <cover.1593412974.git.kwmad.kim@samsung.com>
        <CGME20200629102350epcas2p4f4ef326c55c897479643ebcd3e132f50@epcas2p4.samsung.com>
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

