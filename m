Return-Path: <SRS0=BOoC=CD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37AECC433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 01:52:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E842020738
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 01:52:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="tJkSXBiJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbgHYBwN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Aug 2020 21:52:13 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:44717 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgHYBwJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Aug 2020 21:52:09 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200825015207epoutp022d87dd58fe6745312267b281440c7bc9~uX96DTBpm0851508515epoutp02Z
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2020 01:52:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200825015207epoutp022d87dd58fe6745312267b281440c7bc9~uX96DTBpm0851508515epoutp02Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1598320327;
        bh=ZhBrS9BNLYRj3gx55I5LwkqWQYPXhOuyLLxGRKp5U9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=tJkSXBiJ0TVkXg0pAnjE/tKlpTopRIw1LwfRRv2yTiO7bjLDKduwLCv9Ix0ssEPdG
         HRMquKHsu8kWNWY4buH/EGvhknR9FNYGot0couJxpxgzunIRCjkVJiyBp3l/YTmQu7
         tU0u3SLGsLgH9gzhp6IcE6kt7IOroTxZL/tmj6Zw=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20200825015206epcas2p2ba6f349549abf7652cd81c0f22fc3e17~uX95T7OrP1690816908epcas2p2L;
        Tue, 25 Aug 2020 01:52:06 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.187]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4BbBnJ0qq9zMqYmC; Tue, 25 Aug
        2020 01:52:04 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        1B.9F.27441.3CE644F5; Tue, 25 Aug 2020 10:52:03 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200825015202epcas2p4d323c37ea40790ad27034b2f84855bf5~uX92IjWxp2197321973epcas2p49;
        Tue, 25 Aug 2020 01:52:02 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200825015202epsmtrp2b0487a761feb1f1cef626134138dd163~uX92E6MrE2497724977epsmtrp2u;
        Tue, 25 Aug 2020 01:52:02 +0000 (GMT)
X-AuditID: b6c32a47-fafff70000006b31-6f-5f446ec3ed1d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        03.B8.08303.2CE644F5; Tue, 25 Aug 2020 10:52:02 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200825015202epsmtip2848e72baf28a2ea9a437bf8014da99ce~uX9111l-M2237122371epsmtip2h;
        Tue, 25 Aug 2020 01:52:02 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v3 1/2] ufs: introduce skipping manual flush for wb
Date:   Tue, 25 Aug 2020 10:43:15 +0900
Message-Id: <ffdb0eda30515809f0ad9ee936b26917ee9b4593.1598319701.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1598319701.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1598319701.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFJsWRmVeSWpSXmKPExsWy7bCmme7hPJd4gw2/2C0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        qBybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC7lRTK
        EnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFhoYFesWJucWleel6yfm5VoYGBkamQJUJ
        ORkbJhUULOSt2Lt5FVMDYw93FyMnh4SAicTGTadZuxi5OIQEdjBKPHjcwwThfGKUaHv1lQXC
        +cwocWTlUhaYlquv50O17GKUeHq3C6rqB6PEn38HwarYBDQlnt6cCjZLRGAzk8SrBfeZQRLM
        AuoSuyacYAKxhQWcJf43rABq4OBgEVCVuP7XDyTMKxAtcf/DEqhtchI3z3WCtXIKWEp827iX
        FZXNBVQzlUPi8M5rjBANLhJ/z0xhhbCFJV4d38IOYUtJfH63lw3CrpfYN7UBqrkH6IV9/6Ca
        jSVmPWtnBDmIGeiD9bv0QUwJAWWJI7dYIM7nk+g4/JcdIswr0dEmBNGoLPFr0mSoIZISM2/e
        gdrqIXHwzH9GSPgAbXq7cTbzBEb5WQgLFjAyrmIUSy0ozk1PLTYqMEaOvU2M4ESq5b6Dccbb
        D3qHGJk4GA8xSnAwK4nwCl50jhfiTUmsrEotyo8vKs1JLT7EaAoMx4nMUqLJ+cBUnlcSb2hq
        ZGZmYGlqYWpmZKEkzltsdSFOSCA9sSQ1OzW1ILUIpo+Jg1OqgcnKLYpb8+ObO067558pmLVj
        P6+H0b1bh8SlM7Ml1xhc5349xcJmxr7vM3b5sR1hPzuladP3JzPEzBY9LvDuzFZ00t/G9WlZ
        ax/znaPBEjuT1ie1XfqUJSm3RTRnmaWnI4upqrnZdsNe39UfChVbt/ptv8o9u+Mm142yGEnF
        gKIJe6P3MS66FxNW6LawtiziYzvL3Y0JL3UTfAUrb09atOH8PzPH44eLvpu0JtetEPL5Lqde
        dsh/9ff1rDvfvehb6hp8bF2f7sbg/WlVe7JTnZ+/FW44Itw3k1v9zfU7v0PnTBf8xH0z8+yn
        n3FGPtJX+tJ1Dp+Uj/z2dY9NesxEpokJySU3n8cw+/08xL/pSIgSS3FGoqEWc1FxIgAWbRwz
        LQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsWy7bCSvO6hPJd4g3uTNSwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        KC6blNSczLLUIn27BK6MDZMKChbyVuzdvIqpgbGHu4uRk0NCwETi6uv5rF2MXBxCAjsYJb63
        HGaDSEhKnNj5nBHCFpa433IEqugbo8SyHXOZQBJsApoST29OZQJJiAgcZpL4v/U5O0iCWUBd
        YteEE2BFwgLOEv8bVrB0MXJwsAioSlz/6wcS5hWIlrj/YQkLxAI5iZvnOplBbE4BS4lvG/ey
        gpQLCVhIvGzixSE8gVFgASPDKkbJ1ILi3PTcYsMCo7zUcr3ixNzi0rx0veT83E2M4BjQ0trB
        uGfVB71DjEwcjIcYJTiYlUR4BS86xwvxpiRWVqUW5ccXleakFh9ilOZgURLn/TprYZyQQHpi
        SWp2ampBahFMlomDU6qBSSLb8XVI+vXjfZ3zldbuNZBQm1NYY+st+sZpF+c6n3UVVXHixbui
        BCODt/5LK1M5NtXo6Dv/iXIGIZYTbb7zOTi0P7zaGWxdIjJl8vQV72dbKEit7RXbxt70Tj/R
        Q+rRXw//9f8+9/jnXuR6NnPKuo+uH24+urvJ/Y71ArHtc0t33Ft9cL/PT65ugSB/47QgsUcB
        Kkvcbt7O2vbrsba3xoIgqXlfos6q+rROkNGau/1coply/L+fFiZHGv8sLlg1terc5icsqd0e
        5lffXzFR8GCcZR/SJHNuna/i2ZsqN18VP7GZmLvkVu31Bin95VfXGrFP/xB6M8xUlO1JoktZ
        tsuqW6JsGfN2vn2/qC1grxJLcUaioRZzUXEiAE4ga9/wAgAA
X-CMS-MailID: 20200825015202epcas2p4d323c37ea40790ad27034b2f84855bf5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200825015202epcas2p4d323c37ea40790ad27034b2f84855bf5
References: <cover.1598319701.git.kwmad.kim@samsung.com>
        <CGME20200825015202epcas2p4d323c37ea40790ad27034b2f84855bf5@epcas2p4.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We have two knobs to flush for write booster, i.e.
fWriteBoosterBufferFlushDuringHibernate and fWriteBoosterBufferFlushEn.
However, many product makers uses only fWriteBoosterBufferFlushDuringHibernate,
because this can reportedly cover most scenarios and
there have been some reports that flush by fWriteBoosterBufferFlushEn
could lead to raise power consumption thanks to unexpected internal
operations. So we need a way to enable or disable fWriteBoosterEn
operations. For those case, this quirk will allow to avoid manual flush

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

