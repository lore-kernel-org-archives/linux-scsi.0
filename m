Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DBEFC433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 05:38:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60CD420772
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 05:38:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="VgWiBPCd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725984AbgGCFiH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 01:38:07 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:17394 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgGCFiG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 01:38:06 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200703053804epoutp023e7f6ced27dc0a93469efc863acea426~eJ3Dr9BFw1766317663epoutp02-
        for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2020 05:38:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200703053804epoutp023e7f6ced27dc0a93469efc863acea426~eJ3Dr9BFw1766317663epoutp02-
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593754684;
        bh=2pjz71oUTjidQIgpnWnMela1RqN5S8mbju02vjVVznI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=VgWiBPCdxBKAH/BHZvHAgpwk74NpTQks3qsUJquJhYMXJotmNPWMIRvE2ZMkbVqpV
         ufwoVdcoKH77GRmurmcAVG5DJVhiGuWhXPhZWR8QtGpeF9e2hObOGKXLVBAHXDUMCq
         km+XcIccXvvROAJZhMspCZlv5zY2gVvW3KIrWvHM=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20200703053803epcas2p33805daf2f1cfb9773945c481fbbea685~eJ3DHtQFd3267032670epcas2p3Y;
        Fri,  3 Jul 2020 05:38:03 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.185]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 49ykJQ16tRzMqYkd; Fri,  3 Jul
        2020 05:37:58 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        1B.F8.19322.634CEFE5; Fri,  3 Jul 2020 14:37:58 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200703053757epcas2p3416b0a10e4419015da549a9c4bfbf37f~eJ29rCgn-3267032670epcas2p3Q;
        Fri,  3 Jul 2020 05:37:57 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200703053757epsmtrp221e08ef42aad8475f16b90d2b3d4bf37~eJ29qSUgJ0409004090epsmtrp2z;
        Fri,  3 Jul 2020 05:37:57 +0000 (GMT)
X-AuditID: b6c32a45-797ff70000004b7a-57-5efec436fb12
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CA.8A.08382.534CEFE5; Fri,  3 Jul 2020 14:37:57 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200703053757epsmtip14788e9dc84361771254d9275ced991fc~eJ29dqNEM2555325553epsmtip1l;
        Fri,  3 Jul 2020 05:37:57 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v3 2/2] ufs: change the way to complete fDeviceInit
Date:   Fri,  3 Jul 2020 14:30:02 +0900
Message-Id: <08bc1641fdce941175596fe106fd5c02161683bf.1593753896.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1593753896.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1593753896.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFJsWRmVeSWpSXmKPExsWy7bCmua7ZkX9xBjd+slo8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7K4ueUoi0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58HpeveHtc7utl8piw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAEc
        UTk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUB3KymU
        JeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKDA0L9IoTc4tL89L1kvNzrQwNDIxMgSoT
        cjL67l1jLugVrbiydC5LA2OHYBcjJ4eEgInE+WsLGLsYuTiEBHYwSpzcMIMFJCEk8IlRYsM3
        RYjEN0aJ/edXssJ0LHl3gB2iaC+jxOkrXhBFPxgllj7+xwSSYBPQlHh6cyoTSEJEYDOTxKsF
        95lBEswC6hK7JpwAKxIWcJdYd2UmmM0ioCrxbftXsKm8AtESZ35C1EsIyEncPNcJZnMKWEp8
        PPmUDZXNBVQzlUNid+8uFogGF4nFX68xQdjCEq+Ob2GHsKUkPr/bywZh10vsm9rACtHcwyjx
        dN8/RoiEscSsZ+1ANgfQpZoS63fpg5gSAsoSR26xQNzPJ9Fx+C87RJhXoqNNCKJRWeLXpMlQ
        QyQlZt68A7XVQ+Lwze2skAAC2vTt3TXmCYzysxAWLGBkXMUollpQnJueWmxUYIgce5sYwYlU
        y3UH4+S3H/QOMTJxMB5ilOBgVhLhTVD9FyfEm5JYWZValB9fVJqTWnyI0RQYkBOZpUST84Gp
        PK8k3tDUyMzMwNLUwtTMyEJJnDdX8UKckEB6YklqdmpqQWoRTB8TB6dUA1PtHrXIKLMsKYVH
        EzZ+0VooVWDdVTDlvFbjnN11F2VLlPwq2W5ndhUElHRu7AiIs4t+crftCPtcdcsSj/RvKTy9
        KrO/bjqa7bU+5MkRnTN+36SLFxn635rfNiNFMPND7alXFgapm7i/5W0JjQpV2/O869E52RyD
        TW3Vjx5fv1ci6rTkCs//piNb5q9xE6qd/LlGvKqjcsaeEzbLDKKDl+26na7TfjbAfW+6Akv7
        K4b7n9+a7+P0NmOovWq5Yr6mdc4PLgObWWevR2nx3rzevOv7PP+MFbsFSsK8U3/etGaLXTq7
        9+5qfr/tWWE/ftxL2C6UdHJn5Zb5D2fMeH2tks13qfkmxsLznR+Fdi+snaLEUpyRaKjFXFSc
        CAA+JnOZLQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWy7bCSnK7pkX9xBrMmKFg8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7K4ueUoi0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58HpeveHtc7utl8piw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAEc
        UVw2Kak5mWWpRfp2CVwZffeuMRf0ilZcWTqXpYGxQ7CLkZNDQsBEYsm7A+xdjFwcQgK7GSUu
        HprAApGQlDix8zkjhC0scb/lCCtE0TdGiWc9TWwgCTYBTYmnN6cygSREBA4zSfzf+pwdJMEs
        oC6xa8IJJhBbWMBdYt2VmWA2i4CqxLftX8FqeAWiJc78vM8MsUFO4ua5TjCbU8BS4uPJp2AL
        hAQsJA68mcCKS3wCo8ACRoZVjJKpBcW56bnFhgWGeanlesWJucWleel6yfm5mxjBsaCluYNx
        +6oPeocYmTgYDzFKcDArifAmqP6LE+JNSaysSi3Kjy8qzUktPsQozcGiJM57o3BhnJBAemJJ
        anZqakFqEUyWiYNTqoHpTFLEm3LrxpeHix6s62UM2BWzfXHbSVbr6LO63K3m2yIDLl7JZuA4
        3W1TezhPuufmZsF8ZvEtLRILbIQfNp1TnbjzX135osNBW5lTmbbwd31fGxNxsi/5f/LCabKd
        m7uuH3L8LDA7J/nVnrO3w7P3fEnZWq8Zu/l351UdyTXfG0KOasRfZu5hENnYXh+y92VgdeWf
        iGMPulYyvbZ8d/mUwGmNP3lrp9z/v4/hRmPINIG7/maqK7Su/Y37H6a30Or0jwv9mxY0NJgr
        i06JmnBBw3LSBWNfpb075M3OH11bbxI9b4tni+XihfwZD4rXZWcdSAyV61qWxt01Y6KChYzT
        qdaEKZ0Xz3tu3nDh+rVLSizFGYmGWsxFxYkAedoHxPQCAAA=
X-CMS-MailID: 20200703053757epcas2p3416b0a10e4419015da549a9c4bfbf37f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200703053757epcas2p3416b0a10e4419015da549a9c4bfbf37f
References: <cover.1593753896.git.kwmad.kim@samsung.com>
        <CGME20200703053757epcas2p3416b0a10e4419015da549a9c4bfbf37f@epcas2p3.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently, UFS driver checks if fDeviceInit
is cleared at several times, not period. This patch
is to wait its completion with the period, not retrying.
Many device vendors usually provides the specification on
it with just period, not a combination of a number of retrying
and period. So it could be proper to regard to the information
coming from device vendors.

I first added one device specific value regarding the information.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b26f182..6c08ed2 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -208,6 +208,7 @@ static struct ufs_dev_fix ufs_fixups[] = {
 };
 
 static const struct ufs_dev_value ufs_dev_values[] = {
+	{UFS_VENDOR_TOSHIBA, UFS_ANY_MODEL, DEV_VAL_FDEVICEINIT, 2000, false},
 	{0, 0, 0, 0, false},
 };
 
@@ -4162,9 +4163,12 @@ EXPORT_SYMBOL_GPL(ufshcd_config_pwr_mode);
  */
 static int ufshcd_complete_dev_init(struct ufs_hba *hba)
 {
-	int i;
+	u32 dev_init_compl_in_ms = 1000;
+	unsigned long timeout;
 	int err;
 	bool flag_res = true;
+	bool is_dev_val;
+	u32 val;
 
 	err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_SET_FLAG,
 		QUERY_FLAG_IDN_FDEVICEINIT, 0, NULL);
@@ -4175,20 +4179,28 @@ static int ufshcd_complete_dev_init(struct ufs_hba *hba)
 		goto out;
 	}
 
-	/* poll for max. 1000 iterations for fDeviceInit flag to clear */
-	for (i = 0; i < 1000 && !err && flag_res; i++)
-		err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
-			QUERY_FLAG_IDN_FDEVICEINIT, 0, &flag_res);
+	/* Poll fDeviceInit flag to be cleared */
+	is_dev_val = ufs_get_dev_specific_value(hba, DEV_VAL_FDEVICEINIT, &val);
+	dev_init_compl_in_ms = (is_dev_val) ? val : 500;
+	timeout = jiffies + msecs_to_jiffies(dev_init_compl_in_ms);
+	do {
+		err = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,
+					QUERY_FLAG_IDN_FDEVICEINIT, 0, &flag_res);
+		if (!flag_res)
+			break;
+		usleep_range(5, 10);
+	} while (time_before(jiffies, timeout));
 
-	if (err)
+	if (err) {
 		dev_err(hba->dev,
-			"%s reading fDeviceInit flag failed with error %d\n",
-			__func__, err);
-	else if (flag_res)
+				"%s reading fDeviceInit flag failed with error %d\n",
+				__func__, err);
+	} else if (flag_res) {
 		dev_err(hba->dev,
-			"%s fDeviceInit was not cleared by the device\n",
-			__func__);
-
+				"%s fDeviceInit was not cleared by the device\n",
+				__func__);
+		err = -EBUSY;
+	}
 out:
 	return err;
 }
-- 
2.7.4

