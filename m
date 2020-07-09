Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF6E9C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 06:31:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 894D520663
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 06:31:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="TwSzF+fF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgGIGbJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 02:31:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:60942 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgGIGbI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 02:31:08 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200709063105epoutp01f171005d5992a5d060bfc2cd970e1748~gAdEEOkmF1810718107epoutp01L
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jul 2020 06:31:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200709063105epoutp01f171005d5992a5d060bfc2cd970e1748~gAdEEOkmF1810718107epoutp01L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594276265;
        bh=Vyg2TrBRb7FmtvixfeuQIoBwTEcmtLkcz1KtvSt/Jkg=;
        h=From:To:Cc:Subject:Date:References:From;
        b=TwSzF+fFfzBWZw9yDApHuIB+x9PtyHhaSSEj1u3jSxcgrMoGWrOgxlIuhRPZ7s3Ci
         PXAP22VVuE7C4HLvAAT0AEIx02yYbEiMGf7weppIvPhqFD37vlX/sq2tz7hI54ULl3
         5As6srw+NpdEXik9TZNcJChHO51567lrON1CZnPk=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20200709063104epcas2p28c1dec07b94cef20e2291c25ee8979f8~gAdDfkof40377503775epcas2p2G;
        Thu,  9 Jul 2020 06:31:04 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.191]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4B2RBv2rqzzMqYkg; Thu,  9 Jul
        2020 06:31:03 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        A2.1F.27013.7A9B60F5; Thu,  9 Jul 2020 15:31:03 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200709063102epcas2p1e2a624bd881d02b6d3f137f9955eb4b8~gAdB39OAo1334513345epcas2p1K;
        Thu,  9 Jul 2020 06:31:02 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200709063102epsmtrp22c566e1c11cd31052b030d1f6735de8a~gAdB3G3ax0181901819epsmtrp2V;
        Thu,  9 Jul 2020 06:31:02 +0000 (GMT)
X-AuditID: b6c32a48-d1fff70000006985-84-5f06b9a78017
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        8C.E7.08382.6A9B60F5; Thu,  9 Jul 2020 15:31:02 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200709063102epsmtip2ff4cc53f2491c882db1480b3f7f55d5b~gAdBo05bR3164431644epsmtip2P;
        Thu,  9 Jul 2020 06:31:02 +0000 (GMT)
From:   Lee Sang Hyun <sh425.lee@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        kwmad.kim@samsung.com
Cc:     Lee Sang Hyun <sh425.lee@samsung.com>
Subject: [RFC PATCH v1] sd: drain a request queue during sd_shutdown()
Date:   Thu,  9 Jul 2020 15:23:11 +0900
Message-Id: <1594275791-20662-1-git-send-email-sh425.lee@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPKsWRmVeSWpSXmKPExsWy7bCmhe7ynWzxBjsuilg8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7K4ueUoi0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58HpeveHtc7utl8piw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAEc
        UTk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUB3KymU
        JeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKDA0L9IoTc4tL89L1kvNzrQwNDIxMgSoT
        cjJe3X/CUrCVs+Lh2veMDYyv2bsYOTkkBEwk7qy/wgpiCwnsYJQ4PiWwi5ELyP7EKHHv+DZG
        COcbo8TZ9ilMXYwcYB29P70g4nsZJd693cQM0f2DUeLmF10Qm01AW+LutVnsIEUiApuZJNbM
        WQq2gllAU2LKrwNgDcICbhLvlz1kBLFZBFQlGpZdYwOxeQVcJV6+7GGBOE9O4ua5TmYI+y+7
        xOXF1RC2i8Sv6X+YIGxhiVfHt0C9IyXx+d1eNgi7XGJ331U2kCMkBFoYJd6v3QQ1yFhi1rN2
        RpBvQA5av0sf4jFliSO3WCDO5JPoOPyXHSLMK9HRJgTRqCxx5t1aqE2SEg9bN0Fd4CGxu2US
        GyQYYiXen17MOoFRdhbC/AWMjKsYxVILinPTU4uNCkyQo2gTIzglannsYJz99oPeIUYmDsZD
        jBIczEoivAaKrPFCvCmJlVWpRfnxRaU5qcWHGE2BwTWRWUo0OR+YlPNK4g1NjczMDCxNLUzN
        jCyUxHnfWV2IExJITyxJzU5NLUgtgulj4uCUamBaHLs5y0LpQNd/60cpDnk3For9Zp4lIefT
        JNfCHpl6OVE67pSomemdI/6366J3rrmy0nNLW0r659lKd6qu7W64U/daYzuTxnOeO1/vaLdr
        JK9ZulhI/s6EV2Lpjy9YnS3x8cxuK3vK7nvLLi/uu0H6JStBi1WF/X9c7PbNt1GT+SI8o3//
        MpeV3sH1+7W0z156bpgvJMwbbKx/s2b/h60eLsudI05cTU/JPvzCV1V9bkoMw93VNgeP/Tlx
        /mWY25KN36V+f+ysYaiO/Chx5wbbf4HacPlTC7mP+ElyeZ+yyLAvzzu8gPGAdt7b4z+Od+6V
        WfA1NjbbPaP8wY5ubQvZhS4vej0EhQye3bn1ar0SS3FGoqEWc1FxIgBCou/6EgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsWy7bCSvO6ynWzxBrdXm1k8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7K4ueUoi0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58HpeveHtc7utl8piw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAEc
        UVw2Kak5mWWpRfp2CVwZr+4/YSnYylnxcO17xgbG1+xdjBwcEgImEr0/vboYOTmEBHYzShye
        qA1iSwhISky81MQIYQtL3G85wtrFyAVU841R4t3xPUwgCTYBbYm712axgyREBA4zSSzuusMO
        kmAW0JSY8usAM4gtLOAm8X7ZQ7BJLAKqEg3LrrGB2LwCrhIvX/awQGyQk7h5rpN5AiPPAkaG
        VYySqQXFuem5xYYFhnmp5XrFibnFpXnpesn5uZsYwWGqpbmDcfuqD3qHGJk4GA8xSnAwK4nw
        GiiyxgvxpiRWVqUW5ccXleakFh9ilOZgURLnvVG4ME5IID2xJDU7NbUgtQgmy8TBKdXAtM6p
        9FSUeVLU4UNvjS065sobimXMFwha5WTsdO5Mh3bqF4vJadc/1T6ZOEXnom/Sraz59xoF3WW6
        TmmryZVuOWv2hmf+pNliN5VbVi66mf9ewI1F/KBnVZC8vMGVfLUHO9qE25/833lT8Xzt+lmX
        GQ/pdJ/6M0nmp/x5zffmycXz51xg3ic5N/ncxMpux8sf9y2yqK25V9hnHngvqO+dqvFCb8aH
        W/PTnJaurFBI50l4nnH8BPMxDsfPS0STvyclpZ1a1vZCbGHURUXZfN3Nsw4WHa8NZ+Y58qla
        c7natepCqV2em46FeC92yFxu1Lb2ouli8aL93l4fM//M3pdxdcvRPzJHXL6Z/VGfsWPyfyWW
        4oxEQy3mouJEAKQro+/CAgAA
X-CMS-MailID: 20200709063102epcas2p1e2a624bd881d02b6d3f137f9955eb4b8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200709063102epcas2p1e2a624bd881d02b6d3f137f9955eb4b8
References: <CGME20200709063102epcas2p1e2a624bd881d02b6d3f137f9955eb4b8@epcas2p1.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Need to set a request queue like below in sd_shutdown()
to prevent pending IOs before UFS shutdown.

Change-Id: I2818cf95944d85baa50b626fcf538f19d06d6d54
Signed-off-by: Lee Sang Hyun <sh425.lee@samsung.com>
---
 drivers/scsi/sd.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d90feff..7418d27 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3564,6 +3564,8 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 static void sd_shutdown(struct device *dev)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
+	struct request_queue *q = sdp->request_queue;
+	unsigned long flags;
 
 	if (!sdkp)
 		return;         /* this can happen */
@@ -3580,6 +3582,12 @@ static void sd_shutdown(struct device *dev)
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		sd_start_stop_device(sdkp, 0);
 	}
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	queue_flag_set(QUEUE_FLAG_DYING, q);
+	__blk_drain_queue(q, true);
+	queue_flag_set(QUEUE_FLAG_DEAD, q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
 static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
-- 
2.7.4

