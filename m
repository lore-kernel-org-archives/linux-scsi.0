Return-Path: <SRS0=dnbB=CN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FCCEC433E2
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 20:06:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2821520665
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 20:06:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dEuI1hor"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgIDUGF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Sep 2020 16:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbgIDUGF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Sep 2020 16:06:05 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8FF0C061244
        for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2020 13:06:04 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id b16so3711291pjp.0
        for <linux-scsi@vger.kernel.org>; Fri, 04 Sep 2020 13:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VTiZOrUEwCVKpqxE/AFo1ktXq/+qAF9fLESFNSzH6aE=;
        b=dEuI1horz5xCF85dt1kA0LCWRa9Xe+drIHCSMp2Ny6oPEGSHyjyIgPVNHqPp3ZbBHF
         WLiKwbCE1muYrgMcHTbU9K4zIduV6f9vepv2iz+cC+XyHO6lNvt0+xxU38hocNb8vdJH
         5joggfllSTgJ0Pqwpqv1j1kW/87OqsnyLac5PfAPQaP8lWXl43YbCGRwGwHP8P64IDQV
         +L25s6ZNbXtMLtNVFsNgwxqda25fBZ0mueTkDh4zClFCC2x14A8hpXp3mWNOdgWUjDgT
         M4GK35aYJJ1/2pOIRHO5Swr71D8Lj26uVOSn3fl+zNquKY/Vz+C5iYGzqwlF51/B2aVn
         fUow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VTiZOrUEwCVKpqxE/AFo1ktXq/+qAF9fLESFNSzH6aE=;
        b=WRuFwcYt4a7vBKX57W3YD4vVuXLCYic7HRB3IX8rD3Xu9FS5McD0xVdsylJWtlP8r5
         kkQfSmmRkJYsXSZLDkhDz+9/lqjuFZa2dAM8h3HScbAGn2/pFXsNwVA/KmUFcLwzjjys
         fCeKXvAYCDQaY5Np05jR3PPgc2jI3nOsihgYV85iMDZMundPSjcleoLA5XieOuL1vGWp
         mAxmhpUwS3OTe7k43F2abyEPiwMNk5N6E/cVukHNLECaNu7b1+TKzDcbLiF/f6tNKtH9
         y/FCQhu+07pjGGLsdWcQWugJgeNOgG3njOIrLzlE/7o+j8g0HV3PlC5JBJEaX9FhvuNO
         LrsA==
X-Gm-Message-State: AOAM531YpOb/s9ECD6sW0fekIFM8i1998aXRs9FWo0B4idlP7Tn02n9g
        jNt7dMJLpSmWa6njeeK7j6AOQlZKm3o=
X-Google-Smtp-Source: ABdhPJxY6y5v6wylJFZV9jORtn0++LW3DnVrOByB0cCgZjp8soKYEyA4s5YRsXVEl+f6FlzILn1wMg==
X-Received: by 2002:a17:90b:3014:: with SMTP id hg20mr7468352pjb.128.1599249963842;
        Fri, 04 Sep 2020 13:06:03 -0700 (PDT)
Received: from localhost.localdomain ([161.81.62.213])
        by smtp.gmail.com with ESMTPSA id k5sm21131905pjl.3.2020.09.04.13.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 13:06:02 -0700 (PDT)
From:   Tom Yan <tom.ty89@gmail.com>
To:     linux-scsi@vger.kernel.org, dgilbert@interlog.com
Cc:     stern@rowland.harvard.edu, James.Bottomley@SteelEye.com,
        akinobu.mita@gmail.com, hch@lst.de, jens.axboe@oracle.com,
        Tom Yan <tom.ty89@gmail.com>
Subject: [PATCH 1/4] scsi: sg: fix BLKSECTGET ioctl
Date:   Sat,  5 Sep 2020 04:05:51 +0800
Message-Id: <20200904200554.168979-1-tom.ty89@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <CAGnHSE=fY2wkzNeZTSHC37Sp-uD4D8YMEb7LesDkPcQWAfiK=w@mail.gmail.com>
References: <CAGnHSE=fY2wkzNeZTSHC37Sp-uD4D8YMEb7LesDkPcQWAfiK=w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It should give out the maximum number of sectors per request
instead of maximum number of bytes.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>
---
 drivers/scsi/sg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 20472aaaf630..e57831910228 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -922,6 +922,7 @@ sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
 	int result, val, read_only;
 	Sg_request *srp;
 	unsigned long iflags;
+	unsigned int max_sectors;
 
 	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
 				   "sg_ioctl: cmd=0x%x\n", (int) cmd_in));
@@ -1114,8 +1115,9 @@ sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
 		sdp->sgdebug = (char) val;
 		return 0;
 	case BLKSECTGET:
-		return put_user(max_sectors_bytes(sdp->device->request_queue),
-				ip);
+		max_sectors = min_t(unsigned int, USHRT_MAX,
+				    queue_max_sectors(sdp->device->request_queue));
+		return put_user(max_sectors, ip);
 	case BLKTRACESETUP:
 		return blk_trace_setup(sdp->device->request_queue,
 				       sdp->disk->disk_name,
-- 
2.28.0

