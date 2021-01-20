Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,
	DATE_IN_FUTURE_06_12,DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CBC4C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 06:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B44762313B
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 06:48:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbhATGsH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jan 2021 01:48:07 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:50141 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727487AbhATGpv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2021 01:45:51 -0500
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210120064452epoutp016140e324a1d65bbcb750105896dc8af1~b3bxfnRNw2430724307epoutp01Y
        for <linux-scsi@vger.kernel.org>; Wed, 20 Jan 2021 06:44:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210120064452epoutp016140e324a1d65bbcb750105896dc8af1~b3bxfnRNw2430724307epoutp01Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611125092;
        bh=OpEdYODaMr3s1N6gkFWXLr0B/tXSAti22x4LWgLdmFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S4pw2w+YSxZgJ1z0DjbWu6MH4dxpkkhSyUbRMVkTW9v2EJYA0ZM94F/cWAzgCJYm1
         WfJmr8To13s/wWqfyQiNWZVewG3ziX3WQlXOvEwnTeSU7dnl59Dvo7Y36V+iflp3RO
         bUPvbFtF28LFVLq2FwrQdpye6XxebQuUNPtbp+5g=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20210120064451epcas1p39a2541c5d9c89455975e56a66fc2a86d~b3bwaaZa_0331103311epcas1p3n;
        Wed, 20 Jan 2021 06:44:51 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.40.159]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4DLGGp5BbMz4x9QJ; Wed, 20 Jan
        2021 06:44:50 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        F3.91.09582.261D7006; Wed, 20 Jan 2021 15:44:50 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210120064450epcas1p1b00b7a040e0951a2da44abce916e1698~b3bu3c8am0078500785epcas1p1h;
        Wed, 20 Jan 2021 06:44:50 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210120064450epsmtrp233ed4989ecc58a5e9aa46fd4683c8acd~b3bu2SIPl1904619046epsmtrp2T;
        Wed, 20 Jan 2021 06:44:50 +0000 (GMT)
X-AuditID: b6c32a37-899ff7000000256e-ba-6007d16223a2
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        A1.DC.08745.161D7006; Wed, 20 Jan 2021 15:44:49 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.98.109]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210120064449epsmtip28e3dd560a8414182a36a372d416b2e10~b3bumYJ3V0436304363epsmtip2E;
        Wed, 20 Jan 2021 06:44:49 +0000 (GMT)
From:   Manjong Lee <mj0123.lee@samsung.com>
To:     mj0123.lee@samsung.com, hch@lst.de, michael.christie@oracle.com,
        damien.lemoal@wdc.com, oneukum@suse.com, arnd@arndb.de,
        martin.petersen@oracle.com
Cc:     jejb@linux.ibm.com, jisoo2146.oh@samsung.com,
        junho89.kim@samsung.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nanich.lee@samsung.com,
        seunghwan.hyun@samsung.com, sookwan7.kim@samsung.com,
        woosung2.lee@samsung.com, yt0928.kim@samsung.com
Subject: RE: [PATCH 1/1] scsi: sd: use max_xfer_blocks for set rw_max if
 max_xfer_blocks is available
Date:   Thu, 21 Jan 2021 00:49:46 +0900
Message-ID: <20210113155009.9592-1-mj0123.lee@samsung.com> (raw)
X-Mailer: git-send-email 2.29.0
In-Reply-To: <CGME20210113064521epcas1p32f0e65bc54d559b55db65bc5556103e8@epcas1p3.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJsWRmVeSWpSXmKPExsWy7bCmrm7SRfYEg6Z16hZ/Jx1jt2ht/8Zk
        sXL1USaLRTe2MVn0PGlitfj6sNji8q45bBbd13ewWSw//o8JqPYGq8X0zXOYLa7dP8Nu0fV4
        JZvFuZOfWC3mPXawOLVjMrPF+r0/2RwEPX7/msToMWHRAUaP3Tcb2Dw+Pr3F4tG3ZRWjx/ot
        V1k8Pm+S82g/0M0UwBGVY5ORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtq
        q+TiE6DrlpkD9IWSQlliTilQKCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8DQoECvODG3uDQv
        XS85P9fK0MDAyBSoMiEn4+8Ry4Lf0hXbFgk0MPaLdzFycEgImEi038roYuTiEBLYwSjx+Vor
        E4TziVHi+dUeIIcTyPnMKLFwNpgN0vBv0mkWiPguRonrnwMgGoBq5rVMBUuwCWhJLH92gR0k
        ISIwm1Fi69OvzCAOs0Ank8Sv/ousIFXCAukS7Z9awDpYBFQlrm95zAhi8wo4SOxf3ssIsU5e
        4s/9HmYQm1MgTuLpmVlMEDWCEidnPgHrZQaqad46G2yBhMAJDolz386wQjS7SNyd28wGYQtL
        vDq+hR3ClpL4/G4vG0RDM6NE76dzUA0tjBI7LpZB2MYSnz5/ZgSFErOApsT6XfoQYUWJnb/n
        MkIs5pN497WHFRKQvBIdbUIQJSoSu5u/wa168+oA1C8eEgvf7mKBBFcfo8TNNTPZJzAqzELy
        zywk/8xC2LyAkXkVo1hqQXFuemqxYYExcgRvYgSnai3zHYzT3n7QO8TIxMF4iFGCg1lJhLfp
        L1uCEG9KYmVValF+fFFpTmrxIUZTYGhPZJYSTc4HZou8knhDUyNjY2MLEzNzM1NjJXHeJIMH
        8UIC6YklqdmpqQWpRTB9TBycUg1MPk7CC1VqGrV3JW64fcZXc2n0rcP/NP9t3+9R+7LpiZWQ
        M6vZQ98di7eG+HDWXb+jV7Ek0kQyZ3lbx3LLz5zCjqrJPD0LCl+Vfl8xkc1YJGbFxw1aV08d
        No6ri7J4Mf3Yq+Tz9y7Mf26llS8pbpKj1zjNMKXlxiphzcbCDr/VBQXvIrt++0SVxm+O+DMn
        h+Mf9zdDBfmK6R6/Xk4UUmXk3rNJlfnkwrmT7t24mRkxa/eCZXmnNp/c8KBh1rUeFe/1onOv
        Sa2cZ9xZsixpgq3+pctFs+47lLE7fvqxl5vFWb3VrzZgxp1j/6d+cn1cfcJ00V6OT76JXq93
        7jJ4EZjDltZ21vpu9YIb12UnHqw4rMRSnJFoqMVcVJwIAEt9+kleBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42LZdlhJXjfxInuCwcd+c4u/k46xW7S2f2Oy
        WLn6KJPFohvbmCx6njSxWnx9WGxxedccNovu6zvYLJYf/8cEVHuD1WL65jnMFtfun2G36Hq8
        ks3i3MlPrBbzHjtYnNoxmdli/d6fbA6CHr9/TWL0mLDoAKPH7psNbB4fn95i8ejbsorRY/2W
        qywenzfJebQf6GYK4IjisklJzcksSy3St0vgyvh7xLLgt3TFtkUCDYz94l2MnBwSAiYS/yad
        Zuli5OIQEtjBKLFx/ycmiISUxLy1DWxdjBxAtrDE4cPFIGEhgY+MEuufh4DYbAJaEsufXWAH
        sUUEFjNKXFggCTKHWWAqk8TKv/PA5ggLpErsuPaeFcRmEVCVuL7lMSOIzSvgILF/eS8jxC55
        iT/3e5hBbE6BOImnZ2YxQSyzkui8PYcVol5Q4uTMJywgNjNQffPW2cwTGAVmIUnNQpJawMi0
        ilEytaA4Nz232LDAKC+1XK84Mbe4NC9dLzk/dxMjOJ60tHYw7ln1Qe8QIxMH4yFGCQ5mJRHe
        pr9sCUK8KYmVValF+fFFpTmpxYcYpTlYlMR5L3SdjBcSSE8sSc1OTS1ILYLJMnFwSjUwuYnO
        qJ8vU7Fay9fSMmjq/Ovy/aYNrldD0zKeJWW05iyuD9wdqe3V1xTxQXxtR8L81V1yH08Zcy2a
        a/DzYfAGpT9nMho/S1v0La7ottmV3BbK93jVgd9y56xZVs3bbjFxTbLYV1k/tj1Pbwc5Bjzd
        89pSUOnH1qdXRBZEyt97slj+2BWDTzqTq2ZZbrFNkHnwcmfHSfGPR5xvrXTT/qwV+P1viN35
        b5vr6j13TNp4xfLg3V1hu70dlz5mmxsSwrfkQIt2zzbJiUnR0ZUnrZ/6p+2V1j6w959m5+bV
        0tK/2TjEj6ZMlPnLytch1799t/SyljqNa4WH57dy7V7wnGFTp72A6Hv2RcVy69s/3ZOPV2Ip
        zkg01GIuKk4EAMrYAnAWAwAA
X-CMS-MailID: 20210120064450epcas1p1b00b7a040e0951a2da44abce916e1698
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210120064450epcas1p1b00b7a040e0951a2da44abce916e1698
References: <20210113155009.9592-1-mj0123.lee@samsung.com>
        <CGME20210120064450epcas1p1b00b7a040e0951a2da44abce916e1698@epcas1p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
Message-ID: <20210120154946.tAcIo8gckdtqWf8MO10e70Nbe_V29P6GR1I5ncd5CLg@z>

Add recipients for more reviews.

>SCSI device has max_xfer_size and opt_xfer_size,
>but current kernel uses only opt_xfer_size.
>
>It causes the limitation on setting IO chunk size,
>although it can support larger one.
>
>So, I propose this patch to use max_xfer_size in case it has valid value.
>It can support to use the larger chunk IO on SCSI device.
>
>For example,
>This patch is effective in case of some SCSI device like UFS
>with opt_xfer_size 512KB, queue depth 32 and max_xfer_size over 512KB.
>
>I expect both the performance improvement
>and the efficiency use of smaller command queue depth.
>
>Signed-off-by: Manjong Lee <mj0123.lee@samsung.com>
>---
>drivers/scsi/sd.c | 56 +++++++++++++++++++++++++++++++++++++++++++----
>1 file changed, 52 insertions(+), 4 deletions(-)
>
>diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>index 679c2c025047..de59f01c1304 100644
>--- a/drivers/scsi/sd.c
>+++ b/drivers/scsi/sd.c
>@@ -3108,6 +3108,53 @@ static void sd_read_security(struct scsi_disk *sdkp, unsigned char *buffer)
>sdkp->security = 1;
>}
>
>+static bool sd_validate_max_xfer_size(struct scsi_disk *sdkp,
>+				      unsigned int dev_max)
>+{
>+	struct scsi_device *sdp = sdkp->device;
>+	unsigned int max_xfer_bytes =
>+		logical_to_bytes(sdp, sdkp->max_xfer_blocks);
>+
>+	if (sdkp->max_xfer_blocks == 0)
>+		return false;
>+
>+	if (sdkp->max_xfer_blocks > SD_MAX_XFER_BLOCKS) {
>+		sd_first_printk(KERN_WARNING, sdkp,
>+				"Maximal transfer size %u logical blocks " \
>+				"> sd driver limit (%u logical blocks)\n",
>+				sdkp->max_xfer_blocks, SD_DEF_XFER_BLOCKS);
>+		return false;
>+	}
>+
>+	if (sdkp->max_xfer_blocks > dev_max) {
>+		sd_first_printk(KERN_WARNING, sdkp,
>+				"Maximal transfer size %u logical blocks "
>+				"> dev_max (%u logical blocks)\n",
>+				sdkp->max_xfer_blocks, dev_max);
>+		return false;
>+	}
>+
>+	if (max_xfer_bytes < PAGE_SIZE) {
>+		sd_first_printk(KERN_WARNING, sdkp,
>+				"Maximal transfer size %u bytes < " \
>+				"PAGE_SIZE (%u bytes)\n",
>+				max_xfer_bytes, (unsigned int)PAGE_SIZE);
>+		return false;
>+	}
>+
>+	if (max_xfer_bytes & (sdkp->physical_block_size - 1)) {
>+		sd_first_printk(KERN_WARNING, sdkp,
>+				"Maximal transfer size %u bytes not a " \
>+				"multiple of physical block size (%u bytes)\n",
>+				max_xfer_bytes, sdkp->physical_block_size);
>+		return false;
>+	}
>+
>+	sd_first_printk(KERN_INFO, sdkp, "Maximal transfer size %u bytes\n",
>+			max_xfer_bytes);
>+	return true;
>+}
>+
>/*
>* Determine the device's preferred I/O size for reads and writes
>* unless the reported value is unreasonably small, large, not a
>@@ -3233,12 +3280,13 @@ static int sd_revalidate_disk(struct gendisk *disk)
>
>/* Initial block count limit based on CDB TRANSFER LENGTH field size. */
>dev_max = sdp->use_16_for_rw ? SD_MAX_XFER_BLOCKS : SD_DEF_XFER_BLOCKS;
>-
>-	/* Some devices report a maximum block count for READ/WRITE requests. */
>-	dev_max = min_not_zero(dev_max, sdkp->max_xfer_blocks);
>q->limits.max_dev_sectors = logical_to_sectors(sdp, dev_max);
>
>-	if (sd_validate_opt_xfer_size(sdkp, dev_max)) {
>+	if (sd_validate_max_xfer_size(sdkp, dev_max)) {
>+		q->limits.io_opt = 0;
>+		rw_max = logical_to_sectors(sdp, sdkp->max_xfer_blocks);
>+		q->limits.max_dev_sectors = rw_max;
>+	} else if (sd_validate_opt_xfer_size(sdkp, dev_max)) {
>q->limits.io_opt = logical_to_bytes(sdp, sdkp->opt_xfer_blocks);
>rw_max = logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
>} else {
>-- 
>2.29.0
>
>
