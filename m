Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1624FC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 07:56:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE79661040
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 07:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232576AbhJGH6p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 03:58:45 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:10630 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232512AbhJGH6o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 03:58:44 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20211007075649epoutp03331b5db35d08ef7637a1a264302101d6~rsIzz375f2595725957epoutp03N
        for <linux-scsi@vger.kernel.org>; Thu,  7 Oct 2021 07:56:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20211007075649epoutp03331b5db35d08ef7637a1a264302101d6~rsIzz375f2595725957epoutp03N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1633593409;
        bh=zdIU35/ncuj2LJPPzONoKV5DtB+Wo+ahMfAzgrXqjFo=;
        h=From:To:Cc:Subject:Date:References:From;
        b=ALObdoF3IMZ67QvFkhgHG367YwgmRO3FsVhyBLgCrelTt//1ONbfb4WpdFdaR0OGh
         CuXXBbE4pnfYmHW0RktAh8oM7fh4IUVqXXjWcX8Ev/iga1F4ixRN3ur2tJbwkuaTsK
         sbnD104DRACoEVf0vjwOlXHPgN6KWtmrCFaAjO54=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20211007075648epcas2p46f2ce1886d66cb77f9603c46d020300b~rsIy6K6Hi0768507685epcas2p4C;
        Thu,  7 Oct 2021 07:56:48 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.98]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4HQ3Yh54Gsz4x9Pr; Thu,  7 Oct
        2021 07:56:40 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        BD.5E.09816.438AE516; Thu,  7 Oct 2021 16:56:36 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20211007075635epcas2p16af95ce29750417f34f8490b0d8000d4~rsIm-tjLE0350303503epcas2p1T;
        Thu,  7 Oct 2021 07:56:35 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211007075635epsmtrp198e94acdaf282b27bd6ecfeea78e6de3~rsIm_XrMX1229312293epsmtrp1V;
        Thu,  7 Oct 2021 07:56:35 +0000 (GMT)
X-AuditID: b6c32a46-63bff70000002658-e8-615ea834f224
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        80.26.08750.338AE516; Thu,  7 Oct 2021 16:56:35 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211007075635epsmtip2825002006f6b1d6b2d96ca2efe370ea0~rsImwDPzo2866428664epsmtip22;
        Thu,  7 Oct 2021 07:56:35 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        cang@codeaurora.org, adrian.hunter@intel.com, sc.suh@samsung.com,
        hy50.seo@samsung.com, sh425.lee@samsung.com,
        bhoon95.kim@samsung.com, vkumar.1997@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v1] scsi: ufs: clear doorbell for hibern8 errors when using
 ah8
Date:   Thu,  7 Oct 2021 16:40:11 +0900
Message-Id: <1633592411-129911-1-git-send-email-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjk+LIzCtJLcpLzFFi42LZdljTXNdkRVyiwcHX/BYnn6xhs3gwbxub
        xcufV9ksDj7sZLH4uvQZq8Wn9ctYLVYvfsBisejGNiaLm1uOslhc3jWHzaL7+g42i+XH/zFZ
        dN29wWix9N9bFos79z+yOPB7XO7rZfJYvOclk8eERQcYPb6v72Dz+Pj0FotH35ZVjB6fN8l5
        tB/oZgrgiMq2yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXL
        zAG6XkmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xiq5RakJJTYF6gV5yYW1yal66Xl1piZWhg
        YGQKVJiQnbGrk63glVBFV88y9gbGffxdjJwcEgImEle+TmLsYuTiEBLYwSjRNO0LK4TziVHi
        2OK3TBDOZ0aJP51nmWFajq6ezw6R2MUosWL7amYI5wejxIm53awgVWwCmhJPb05lArFFBK4z
        SczbngFiMwuoS+yacAIsLiwQKPFxYiMjiM0ioCrRNOkfC4jNK+Am0XzoGDvENjmJm+c6wRZI
        CDRySMzafRnqDBeJheuOMUHYwhKvjm+BapCSeNnfBmXXS+yb2sAK0dzDKPF03z9GiISxxKxn
        7UA2B9BFmhLrd+mDmBICyhJHbrFA3Mkn0XH4LztEmFeio00IolFZ4tekyVBDJCVm3rwDtclD
        4tLzq2CvCwnESqz9MpV9AqPsLIT5CxgZVzGKpRYU56anFhsVGMEjKTk/dxMjOEFque1gnPL2
        g94hRiYOxkOMEhzMSiK8+faxiUK8KYmVValF+fFFpTmpxYcYTYHhNZFZSjQ5H5ii80riDU0s
        DUzMzAzNjUwNzJXEeef+c0oUEkhPLEnNTk0tSC2C6WPi4JRqYNJgfRNmU5Z4MHqqqdukXSeK
        t92fV9846/f5daevWxYwtE9nSWvYoP3B/HPqpOPr66ZPLBGQL9azMj631dFi5V/NomfXNyh7
        hc6+fO2uz5OAip2ms+ryVwhdDOHb+LX/7wvVKMerziE+777u3jVDaKll+LvTVpW/i33Cw27e
        0XK/0Rm+4VNi3c8jxUUnippsrsZszr7yl2NV8j8B5We/ciQ6D98WOFsyofCUkDn/udt71uaz
        ua+4UPgq/JamynqOidcjposyFfzbWxQV2zJlS1VQecIRoZteGyRPTYlVKU5Ym3fq8vqX2xdo
        TOFr/fdud7ZD8fH5mZEZLh2HpX7nvkx9HzTho+YfqZMFE9MexV9QYinOSDTUYi4qTgQAijiR
        VhkEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsWy7bCSvK7xirhEg6k3OCxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWLxdekzVotP65exWqxe/IDFYtGNbUwWN7ccZbG4vGsOm0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LBZ37n9kceD3uNzXy+SxeM9LJo8Jiw4wenxf38Hm8fHpLRaPvi2rGD0+b5Lz
        aD/QzRTAEcVlk5Kak1mWWqRvl8CVsauTreCVUEVXzzL2BsZ9/F2MnBwSAiYSR1fPZ+9i5OIQ
        EtjBKLHu7x9GiISkxImdz6FsYYn7LUdYQWwhgW+MEsff2YHYbAKaEk9vTmUCaRYReMkk8WLO
        GjaQBLOAusSuCSeYQGxhAX+Jzi0nWEBsFgFViaZJ/8BsXgE3ieZDx9ghFshJ3DzXyTyBkWcB
        I8MqRsnUguLc9NxiwwKjvNRyveLE3OLSvHS95PzcTYzgkNXS2sG4Z9UHvUOMTByMhxglOJiV
        RHjz7WMThXhTEiurUovy44tKc1KLDzFKc7AoifNe6DoZLySQnliSmp2aWpBaBJNl4uCUamBa
        Z9QuLsNRtthGf4+p45R/XqFKX3QCyqdYy/1ePefy1OeZbwJvv5/wbeK/rFV+SXW70xPuaLgc
        a57TvvyA7rOE305dZSvd39zzzDWNVeC6WG1hbnjiE/+xBwaM+gdDrpVGax2eO9vt5FYzv+3L
        V33J2HJgtVn/dyWG+9rin7f9qTr5+JiWXo5p8axbRUyJj55sWGX59ozrVQ+nHe1XHm9nF66Q
        7r3Z4xPDfkaPJ3TK7wdGixpcWa9qcJ08ND1x7/5Z0U1WKw5X8JmKx5jJ1V/6tnjTnqVs63ka
        XrgbbL9XMCNGq/UT28L0GUefNy1gvjp5Fz9P7nmmJae32BbsuWPa1H9KYE3brjMyqkZzDzzz
        UmIpzkg01GIuKk4EAGSKSp7IAgAA
X-CMS-MailID: 20211007075635epcas2p16af95ce29750417f34f8490b0d8000d4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211007075635epcas2p16af95ce29750417f34f8490b0d8000d4
References: <CGME20211007075635epcas2p16af95ce29750417f34f8490b0d8000d4@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When an scsi command is dispatched right after host complete
all the pending requests goes to idle and ufs driver tries
to ring a doorbell, host might be still during entering into
hibern8. If an error occurrs during that period, the doorbell
might not be zero. In this case, clearing it should be needed
to requeue its command.
Currently, ufshcd_err_handler goes directly to reset when the
driver's link state is broken. This patch is to make it clear
doorbells in the case. In the situation, communication would
be disabled, so TM isn't necessary or we can say it's not
available.

Here's an actual symptom that I've faced. At the time, tag #17
is still pended even after host reset. And then the block timer
is expired.

exynos-ufs 11100000.ufs: ufshcd_check_errors: Auto Hibern8
Enter failed - status: 0x00000040, upmcrs: 0x00000001
..
host_regs: 00000050: b8671000 00000008 00020000 00000000
..
exynos-ufs 11100000.ufs: ufshcd_abort: Device abort task at tag 17

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9faf02c..13f406d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6076,6 +6076,7 @@ static void ufshcd_err_handler(struct Scsi_Host *host)
 	int err = 0, pmc_err;
 	int tag;
 	bool needs_reset = false, needs_restore = false;
+	bool link_broken_in_ah8 = false;
 
 	down(&hba->host_sem);
 	spin_lock_irqsave(hba->host->host_lock, flags);
@@ -6138,7 +6139,12 @@ static void ufshcd_err_handler(struct Scsi_Host *host)
 	     (hba->saved_uic_err & (UFSHCD_UIC_DL_NAC_RECEIVED_ERROR |
 				    UFSHCD_UIC_DL_TCx_REPLAY_ERROR)))) {
 		needs_reset = true;
-		goto do_reset;
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		if (!hba->ahit && ufshcd_is_link_broken(hba))
+			link_broken_in_ah8 = true;
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		if (!link_broken_in_ah8)
+			goto do_reset;
 	}
 
 	/*
@@ -6168,6 +6174,9 @@ static void ufshcd_err_handler(struct Scsi_Host *host)
 		}
 	}
 
+	if (link_broken_in_ah8)
+		goto lock_skip_pending_xfer_clear;
+
 	/* Clear pending task management requests */
 	for_each_set_bit(tag, &hba->outstanding_tasks, hba->nutmrs) {
 		if (ufshcd_clear_tm_cmd(hba, tag)) {
-- 
2.7.4

