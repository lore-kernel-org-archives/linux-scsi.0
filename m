Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D94EC433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 07:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6CE061163
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 07:13:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhETHPM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 May 2021 03:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhETHPL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 May 2021 03:15:11 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F40CC06175F
        for <linux-scsi@vger.kernel.org>; Thu, 20 May 2021 00:13:50 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d78so10821344pfd.10
        for <linux-scsi@vger.kernel.org>; Thu, 20 May 2021 00:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=/FZogyMJylWtzS0eidX0k1eno6muyKoInIXOv6M+ByM=;
        b=DrJ/o5Y6r98D7LiHaOQqQdgv67bnQTekP2Lz8uwmnHCnoXeikFHS1UWXdH3YZIFjE5
         0sJ10LbC0IgJG1d89ZZsnHMB4AjQdArcFPPOdbUaHPQJjKpu8xmYZZTtaIqtFaiBWCA8
         SquxN/7ElfbtCN2b227sxwT6BgXj/xL4x3RKFBJ8dnKJEJg09HZB6vG8mKGNYHwT2RB6
         /vfn5l2EXFK3D0dTZL/8P/stsfwURB/VpkkcVSXg/w7l9t2A/V/x4OCjEZn2TRnOsE4d
         CzMVqpxDQEbAQItql7tImECh7dFLYCnWlLgurSBmTPcaqQa6LbJxHByqyGKtybbERX9A
         FiNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=/FZogyMJylWtzS0eidX0k1eno6muyKoInIXOv6M+ByM=;
        b=GHivJ71NhiOTJNujYCMDFJsrjRUwvdDOBUC9VTqAnRG7SFPTi9JamIGDkAhene76bN
         BSmwDyuHfKeEOS5uiPqY5Ab4T4S0XPKmVyojth8+srvpWaD/YddyX6SqfK5+JR9HaCQZ
         AlBZMN2cOgtNpuHd5ppsT8hd8nBFvDfjS3OeGg5IW/z+PNrXfAsBRYbdLdZYJ8tQCp4u
         BbtnTMwZFY2QV42AhGzIuZCNYpE/94zBxcDVM0JOHKThKplLToJUQHMylNkPfUwoEHo7
         yUAFWqXb/rrE4IRKPtyIo8oTXaViLbRi2WhHx3KsTsV9eW0r2vtxmaIO+IxfYyhizcWJ
         4/8w==
X-Gm-Message-State: AOAM5333VA9WR2VGJ03Zgr4sf/Cy3fEj+70KBBiqN0IBumMRGtOpQNbx
        UHxfpmVrO9nZtQfnIPgtINg4n445wYscZg==
X-Google-Smtp-Source: ABdhPJxk1iqei3q6Z+wifKmSwxkuDpy5mFlZdNY6CV5wI8PgPuHlhNIUiWve/ymmfsA557xD7C5Iog==
X-Received: by 2002:a65:5a81:: with SMTP id c1mr3081613pgt.111.1621494829559;
        Thu, 20 May 2021 00:13:49 -0700 (PDT)
Received: from centos78 (60-248-88-209.HINET-IP.hinet.net. [60.248.88.209])
        by smtp.gmail.com with ESMTPSA id o3sm1220688pgh.22.2021.05.20.00.13.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 May 2021 00:13:49 -0700 (PDT)
Message-ID: <d0c6dc6431f0e46db6583dc0d04d7983b420d4da.camel@areca.com.tw>
Subject: [PATCH 2/2] scsi: arcmsr: update driver version to
 v1.50.00.05-20210429
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Thu, 20 May 2021 15:13:49 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ching Huang <ching2048@areca.com.tw>

Update driver version to v1.50.00.05-20210429.

Signed-off-by: ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
index eb0ef73..6ce57f0 100644
--- a/drivers/scsi/arcmsr/arcmsr.h
+++ b/drivers/scsi/arcmsr/arcmsr.h
@@ -49,7 +49,7 @@ struct device_attribute;
 #define ARCMSR_MAX_OUTSTANDING_CMD	1024
 #define ARCMSR_DEFAULT_OUTSTANDING_CMD	128
 #define ARCMSR_MIN_OUTSTANDING_CMD	32
-#define ARCMSR_DRIVER_VERSION		"v1.50.00.04-20210414"
+#define ARCMSR_DRIVER_VERSION		"v1.50.00.05-20210429"
 #define ARCMSR_SCSI_INITIATOR_ID	255
 #define ARCMSR_MAX_XFER_SECTORS		512
 #define ARCMSR_MAX_XFER_SECTORS_B	4096

