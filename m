Return-Path: <SRS0=xqUt=CC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B24ECC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 02:38:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91D67206F7
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 02:38:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="EQZgglKY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728095AbgHXCiY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Aug 2020 22:38:24 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:49517 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727939AbgHXCiU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Aug 2020 22:38:20 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200824023817epoutp011fcb1e16aef96b131b3e63326dfe7da8~uE87lysnc1009510095epoutp01r
        for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2020 02:38:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200824023817epoutp011fcb1e16aef96b131b3e63326dfe7da8~uE87lysnc1009510095epoutp01r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1598236697;
        bh=WfMcrTf4Hn7Ff084m5WIrUgQ2Rr2LGa9aO7xVH0LSSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=EQZgglKYEOLIf0tpssKFyrvDROQY57QEnEUntDKp0CKiEdw0CYB4zffSpMMOHlao/
         M8aNJosIk4/yXaeU71cdNxhHB8ZDuEtlSCVK+C6ps5HmmtVUfZ+6XBjJl8fiu5WWqz
         xDU9vIy4KqwrkXsewVtNzHUg0DO2LQcXCNyuM3e8=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20200824023816epcas2p36993b9231308e25dd5e566279935a863~uE87J-N1L2866228662epcas2p3o;
        Mon, 24 Aug 2020 02:38:16 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.182]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4BZbs14gQKzMqYkZ; Mon, 24 Aug
        2020 02:38:13 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        CC.4F.19322.518234F5; Mon, 24 Aug 2020 11:38:13 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200824023812epcas2p13703641720a1a031e4b0157b224e7ec3~uE83klqmp1928719287epcas2p1m;
        Mon, 24 Aug 2020 02:38:12 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200824023812epsmtrp2647b8fe821d24f5fc7c63f4b3ed650a0~uE83jzVE21376513765epsmtrp28;
        Mon, 24 Aug 2020 02:38:12 +0000 (GMT)
X-AuditID: b6c32a45-797ff70000004b7a-cd-5f432815948d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C8.88.08382.418234F5; Mon, 24 Aug 2020 11:38:12 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200824023812epsmtip291f6e2de43d0da073cfd796dea96dece~uE83X27yv0476704767epsmtip2T;
        Mon, 24 Aug 2020 02:38:12 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v2 1/2] ufs: introduce skipping manual flush for wb
Date:   Mon, 24 Aug 2020 11:29:26 +0900
Message-Id: <62ef1c22df6e3fb3c7fa532523b2cf437cd4fcbc.1598236010.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1598236010.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1598236010.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNJsWRmVeSWpSXmKPExsWy7bCmqa6ohnO8wbQlXBYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        VI5NRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDdSgpl
        iTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwCQ8MCveLE3OLSvHS95PxcK0MDAyNToMqE
        nIxHvWfYChbzVFyac4SpgXEuVxcjJ4eEgInE1BkvWLoYuTiEBHYwSsx7+YYRwvnEKPGs/Q07
        hPONUeLowQ4WmJbJv5ezg9hCAnsZJc7ekIIo+sEo8W7TK0aQBJuApsTTm1OZQBIiApuZJF4t
        uM8MkmAWUJfYNeEEE4gtLOAs0bLiINgkFgFVidfrXrOB2LwC0RKvJsxnhdgmJ3HzXCdYL6eA
        pcTnzZPZUNlcQDVTOSQOT9wC1eAisfz8FqhThSVeHd/CDmFLSXx+t5cNwq6X2De1gRWiuYdR
        4um+f4wQCWOJWc/agWwOoEs1Jdbv0gcxJQSUJY7cYoG4n0+i4/Bfdogwr0RHmxBEo7LEr0mT
        oYZISsy8eQdqq4fE3dcLWCEBBLSp5dkClgmM8rMQFixgZFzFKJZaUJybnlpsVGCIHH2bGMGp
        VMt1B+Pktx/0DjEycTAeYpTgYFYS4b29yT5eiDclsbIqtSg/vqg0J7X4EKMpMCAnMkuJJucD
        k3leSbyhqZGZmYGlqYWpmZGFkjhvruKFOCGB9MSS1OzU1ILUIpg+Jg5OqQYm+1vd8RMyr1wT
        ePfWU18/yaGofvVpX7V2kW3/Phzu+ZeXd1C2PnVdwwSfQ4urc3RMXpy7dXx2TE51tmWwfH5M
        oTUfs1akqPnbl1/nJV9sSJsU+SgiubfpwKdbzStCtTgSPfQt6ySWHWhZo5O5kjto0v/dr6av
        8b7vJeu6bdKM3Xp7xHI3SJdpF3r9WMFVG6q9ZuaGJ30rZ29fNG1n95ydwq8bc459fuATPGty
        38o3yckzH1dOu7wzcUHFpZzl4m7eS64n+8Ss1VvB+sm/dYnuNBsJ38lcxQtDH65fr2F2u2ti
        mkNFkviLKfetdTnOC52fkCIU9sCLk/WyBvPCK3OnxGS8mrJzvdurgoqS95qlSizFGYmGWsxF
        xYkApHMJpC4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsWy7bCSvK6IhnO8wbYJWhYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        FJdNSmpOZllqkb5dAlfGo94zbAWLeSouzTnC1MA4l6uLkZNDQsBEYvLv5exdjFwcQgK7GSWm
        PLzFBpGQlDix8zkjhC0scb/lCCtE0TdGiU0f14El2AQ0JZ7enMoEkhAROMwk8X/rc3aQBLOA
        usSuCSeYQGxhAWeJlhUHweIsAqoSr9e9BtvAKxAt8WrCfFaIDXISN891MoPYnAKWEp83Twaq
        4QDaZiGxd5U1DuEJjAILGBlWMUqmFhTnpucWGxYY5qWW6xUn5haX5qXrJefnbmIEx4GW5g7G
        7as+6B1iZOJgPMQowcGsJMJ7e5N9vBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeG4UL44QE0hNL
        UrNTUwtSi2CyTBycUg1MebtZM/RmZXHlb7xxb+XPNerc+Y8WvXuUXlnce08vauOOTBdr43ht
        4e9NIf/zBRzPGq8R8uhKdF946doU3nfXT7uq6izuCmj+ubNP+lrarfpNnE+/BOyJ5dmakMu2
        Jtnx5NvirY8vhSiG84gtyD6yeK6UbuSzKYFv2e+/sVbZZa1qv7dZsiv4r/6C5szFv9ew2LP4
        PC3nYdqx98VdoxlXP6pM5vGVXLH1rHVzGzdvDk9goKSm8pJsHtkbdaVWsxhVFk+1esu4+I+n
        TKyrk12y9EyV+4k3vtj/ODfhStI+u60vk04u7s3NWN++l9nnzSGNT3wzArwFZJXMdAW/LfQt
        2i77VWje3EnaO6/dn9KuxFKckWioxVxUnAgAOClIMvICAAA=
X-CMS-MailID: 20200824023812epcas2p13703641720a1a031e4b0157b224e7ec3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200824023812epcas2p13703641720a1a031e4b0157b224e7ec3
References: <cover.1598236010.git.kwmad.kim@samsung.com>
        <CGME20200824023812epcas2p13703641720a1a031e4b0157b224e7ec3@epcas2p1.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We have two knobs to flush for write booster, i.e.
fWriteBoosterEn, fWriteBoosterBufferFlushEn.
However, many product makers uses only fWriteBoosterBufferFlushEn,
because this can reportedly cover most scenarios and
there have been some reports that flush by fWriteBoosterEn could
lead raise power consumption thanks to unexpected internal
operations. So we need a way to enable or disable fWriteBoosterEn.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 drivers/scsi/ufs/ufshcd.h | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ed03051..7c79a8f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5277,6 +5277,9 @@ static int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set)
 
 static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable)
 {
+	if (hba->quirks & UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL)
+		return;
+
 	if (enable)
 		ufshcd_wb_buf_flush_enable(hba);
 	else
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index e5353d6..cfafd6e 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -511,6 +511,11 @@ enum ufshcd_quirks {
 	 * OCS FATAL ERROR with device error through sense data
 	 */
 	UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR		= 1 << 10,
+
+	/*
+	 * This quirk needs to disable manual flush for write booster
+	 */
+	UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL		= 1 << 11,
 };
 
 enum ufshcd_caps {
-- 
2.7.4

