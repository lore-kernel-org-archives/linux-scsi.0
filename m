Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C74E8C64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbjCIT2k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:28:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbjCIT2O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:28:14 -0500
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001574200
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:28:11 -0800 (PST)
Received: by mail-pj1-f47.google.com with SMTP id h11-20020a17090a2ecb00b00237c740335cso2910804pjs.3
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:28:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BvVVQ+ktXujbe64yu0zbTHHU9T+PctoEBb3huhrnTek=;
        b=sH+nYhz6qpTVjVtZ7NcoFZVSpPzNOmwcSpcscEqznG7Mv7w9FgnDZUOxJXW2kE85TA
         qOuPfXOOSNH4BAKAAf6sjzyeAdp6+XzCXjANm50gJLwhQO/d8ROqBX+HsRCXbw9e7koE
         CtbZ8bKFXgRvgNlRYD2xWttXJdlRk5l+llbmUlMyxOFlLsQsuJgktXEcMSFKvatW2V91
         ABUmob4aSF3LBiIVHOT2PmeaUaMx+4DcOR/YGdmi3MQtt0E4doMudv63e2i0Euzt0bU+
         JTp9mvdl+yXOFUGu18oB4KTLs6MhiKYN0bykWSsn40iuDz52bFn7uf9vjHvQOJjtq80w
         ooow==
X-Gm-Message-State: AO0yUKVLREXwxD7lZ4PV0r0E8VbnHGw4HIWIE8u0DU9V44XQ8/jhbNJP
        JdEgoJJg7pWWwnR8+CFdKPE=
X-Google-Smtp-Source: AK7set+K/F80dUMvv9kzLRv4Vs/U68ZgJkx78DPss7jd4EqiW3M4EmuFDnKGAPFWe+z/EDaq24SUmA==
X-Received: by 2002:a05:6a20:4b0f:b0:c6:c0c1:b1fe with SMTP id fp15-20020a056a204b0f00b000c6c0c1b1femr2756533pzb.57.1678390091437;
        Thu, 09 Mar 2023 11:28:11 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:28:10 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Oliver Neukum <oliver@neukum.org>,
        Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 30/82] scsi: dc395x: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:22 -0800
Message-Id: <20230309192614.2240602-31-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/dc395x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 670a836a6ba1..c8e86f8a631e 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -4541,7 +4541,7 @@ static int dc395x_show_info(struct seq_file *m, struct Scsi_Host *host)
 }
 
 
-static struct scsi_host_template dc395x_driver_template = {
+static const struct scsi_host_template dc395x_driver_template = {
 	.module                 = THIS_MODULE,
 	.proc_name              = DC395X_NAME,
 	.show_info              = dc395x_show_info,
