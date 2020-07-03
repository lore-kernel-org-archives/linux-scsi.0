Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0265C433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 05:38:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAE7B20771
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 05:38:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Wr9rjHtR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725960AbgGCFiF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 01:38:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:24745 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgGCFiD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 01:38:03 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200703053759epoutp012b0a92171d19c80d033dec6e89013166~eJ2-xAGIe2423724237epoutp01x
        for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2020 05:37:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200703053759epoutp012b0a92171d19c80d033dec6e89013166~eJ2-xAGIe2423724237epoutp01x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593754679;
        bh=8z7z+/v9tHoImnK9+4J8GzYCdc8KTKE5pdOGFWD21pg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=Wr9rjHtRGM6p/jfiTDT5oS1RWiFw6n8poqQeOMym7YOkNJ1mTCsucPPvrEx/sP8LL
         QayTpiihGG5uRVp+Q7iyCoAyHxXlnkypSnWLeQ9ySh0lmRsj66NzbaNdUH1+KuwQIF
         juQTCad8ffoCXDiWXoOzO2zxOqZc5bb1iqysXeFg=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200703053759epcas2p134bf534684721f3477a9c5e6cd14cf58~eJ2-KaYDA2348023480epcas2p1G;
        Fri,  3 Jul 2020 05:37:59 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.189]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 49ykJN3SxczMqYkV; Fri,  3 Jul
        2020 05:37:56 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        45.9C.27441.434CEFE5; Fri,  3 Jul 2020 14:37:56 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200703053756epcas2p1f32da04da87c8f56a6052caada95fb9a~eJ28M2mC40052000520epcas2p17;
        Fri,  3 Jul 2020 05:37:56 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200703053756epsmtrp2c60dae03b104fd41e415462e214de39b~eJ28L6nyD0408904089epsmtrp26;
        Fri,  3 Jul 2020 05:37:56 +0000 (GMT)
X-AuditID: b6c32a47-fc5ff70000006b31-65-5efec4345975
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        56.6E.08303.334CEFE5; Fri,  3 Jul 2020 14:37:55 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200703053755epsmtip1f3af98a3e22062ec75d82d1100c3aef1~eJ28Aq6r02755227552epsmtip1H;
        Fri,  3 Jul 2020 05:37:55 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v3 1/2] ufs: support various values per device
Date:   Fri,  3 Jul 2020 14:30:01 +0900
Message-Id: <dc21b368f44c8a9a257d1b00549e3b5aeec00755.1593753896.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1593753896.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1593753896.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFJsWRmVeSWpSXmKPExsWy7bCmqa7JkX9xBiv/Slo8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7K4ueUoi0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58HpeveHtc7utl8piw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAEc
        UTk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUB3KymU
        JeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKDA0L9IoTc4tL89L1kvNzrQwNDIxMgSoT
        cjL+vVnNWHBGsmLn6Y8sDYy/RboYOTkkBEwkru7YzNrFyMUhJLCDUeJTy2smkISQwCdGiWnt
        gRCJz4wS+05fZYXrWPCYHSKxi1Fiz+rLTBDOD0aJdbcOsIBUsQloSjy9ORUsISKwmUni1YL7
        zCAJZgF1iV0TToDtEBZwkljYcQJsLIuAqsT0Kd1gNbwC0RKT7rxiglgnJ3HzXCdYnFPAUuLj
        yadsqGwuoJqpHBLzTvQBORxAjovEm1XmEL3CEq+Ob2GHsKUkPr/bywZh10vsm9rACtHbwyjx
        dN8/RoiEscSsZ+2MIHOYgT5Yv0sfYqSyxJFbLBDn80l0HP7LDhHmlehoE4JoVJb4NWky1BBJ
        iZk370Bt9ZDo23EXGrxAmy79/cw6gVF+FsKCBYyMqxjFUguKc9NTi40KjJFjbxMjOJFque9g
        nPH2g94hRiYOxkOMEhzMSiK8Car/4oR4UxIrq1KL8uOLSnNSiw8xmgLDcSKzlGhyPjCV55XE
        G5oamZkZWJpamJoZWSiJ8xZbXYgTEkhPLEnNTk0tSC2C6WPi4JRqYDL97eb39Oui3lkmfVvU
        Z690VmJfu3P944k7WA7npzEtWuZsUHO07BpzqFrgJnPHFw9kpO1+btHQi4w7VhZdK53MWH7x
        GMuRAg6RciON9HeSn7tOdi2Q8dNj2OxnLrbQ45T7gYnVRWHbz1d9aJ6kl9az991mOYk3H8tK
        dKSvnUxbIlpo+eC+68WNlx7+WWzlWb1HVdi3aOpcWaMNFzdyaiZ56Mp2st+sCpn4tHDy/G8q
        6w69in2884Kt4YmbGR+Un69gnJTz1HJ+xtvfpvUauRl37mUJnhCcfsZg19xLDGnpXuvb1s4V
        S8gVZyipumFR2szzqLHhYqi335IHTyYfPFX88VVJT8qkPVvCZ6yqzldiKc5INNRiLipOBABq
        7aNlLQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWy7bCSnK7xkX9xBs8WWVk8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7K4ueUoi0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58HpeveHtc7utl8piw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAEc
        UVw2Kak5mWWpRfp2CVwZ/96sZiw4I1mx8/RHlgbG3yJdjJwcEgImElcXPGbvYuTiEBLYwSjx
        58cnJoiEpMSJnc8ZIWxhifstR1ghir4xSiz4vpANJMEmoCnx9OZUJpCEiMBhJon/W5+zgySY
        BdQldk04ATZJWMBJYmHHCVYQm0VAVWL6lG5mEJtXIFpi0p1XUNvkJG6e6wSLcwpYSnw8+RRs
        gZCAhcSBNxNYcYlPYBRYwMiwilEytaA4Nz232LDAKC+1XK84Mbe4NC9dLzk/dxMjOBa0tHYw
        7ln1Qe8QIxMH4yFGCQ5mJRHeBNV/cUK8KYmVValF+fFFpTmpxYcYpTlYlMR5v85aGCckkJ5Y
        kpqdmlqQWgSTZeLglGpguvhxnrWktR3zzMdMkt+4Jq1fwXc8ob5G40v65aeSond2F+ZenTxt
        7/Nv10T4LKXDj7x3uDh9avvrDo/qvfpTT7JpBhy5tfGjukCh0NxXu6dMn+7qrW6744k8y08x
        5ZvbLJ2PL+zN3mqesuUz29b1/U8WzBH5VPhsQ18fd9T80rptMqfsy8sDZnqcfX3O8fF8r1v8
        0flLZ7434NglG3pyDpeT+IlZjOs+tjMwOn6XFPnrZKn5kuX7ReeMdwffPFRc+82pSaA/fDmj
        dKn9lZoH97v/cV04VXlho8U0pqSK+i1TuOI/O+e88py1+1cPf+vf3CqWCGueMBPnyMYiN4GE
        2Fvv0srsZM6svjRlneGdO0osxRmJhlrMRcWJACqVhTj0AgAA
X-CMS-MailID: 20200703053756epcas2p1f32da04da87c8f56a6052caada95fb9a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200703053756epcas2p1f32da04da87c8f56a6052caada95fb9a
References: <cover.1593753896.git.kwmad.kim@samsung.com>
        <CGME20200703053756epcas2p1f32da04da87c8f56a6052caada95fb9a@epcas2p1.samsung.com>
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
index 52abe82..b26f182 100644
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
 
+static void ufshcd_set_dev_values(struct ufs_hba *hba,
+				  const struct ufs_dev_value *value)
+{
+	struct ufs_dev_value *f;
+	struct ufs_dev_info *dev_info = &hba->dev_info;
+
+	if (!value)
+		return;
+
+	for (f = (struct ufs_dev_value *)value; f->val; f++) {
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

