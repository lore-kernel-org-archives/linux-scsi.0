Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAC48C6FD19
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjCIT1e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:27:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbjCIT11 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:27:27 -0500
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A7FEBDAE
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:27:23 -0800 (PST)
Received: by mail-pl1-f181.google.com with SMTP id u5so3098653plq.7
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:27:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390042;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NNIBPT74zB8cP9y9PhKNlxYuRy1lcz2hltLytVbDwLc=;
        b=eUc1XlMcIss9dl4QOcJOUZ7/eBF9xX+LA44drUxHPKkSaheOjs5FEA0oQNP5S3Jt4x
         qJUYBofbr+EUCQ4hdBks2eerrweTTTaxVweNR35+dWaP8MOVFnxTzO9zzCyAeFXUJbF+
         yFfVXxYlSSCcwSjen1zQxErE7uji/buQQRo/Kqxd+LC3Kuw4f9+5Q6kg+blfGaX1uKKa
         lY3pz4d7jSsjMizh+NvVDzugyJRFvg1NKG3JgTlIzgKhlvnfUwkKmztVxf2C8S4mw/uZ
         jN4WpzzsnfA7cvviYFvDe6mFzlp9XhXuJSlo67yGDd/1aLDw4YWkkzUsKyIpxUc/Z/Sl
         ZOJw==
X-Gm-Message-State: AO0yUKXkPcJM7hSHI2QghMJ5e9xJ/HPb6lXe+Uhx4E6+lEFyhqZdqQ27
        kA0vN5HLHADrMNZuSmB2ESA=
X-Google-Smtp-Source: AK7set/4EBK77RaqA0kJOEgA9XfHVTBVHTWFdLr8WU1QIvsfTzxKhaZ2TlEwxcqKq45w9EN/5ABddg==
X-Received: by 2002:a05:6a20:1b28:b0:cd:478b:a9c9 with SMTP id ch40-20020a056a201b2800b000cd478ba9c9mr20234896pzb.6.1678390042552;
        Thu, 09 Mar 2023 11:27:22 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.27.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:27:21 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 11/82] scsi: 3w-xxxx: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:03 -0800
Message-Id: <20230309192614.2240602-12-bvanassche@acm.org>
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
 drivers/scsi/3w-xxxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index ffdecb12d654..36c34ced0cc1 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -2229,7 +2229,7 @@ static int tw_slave_configure(struct scsi_device *sdev)
 	return 0;
 } /* End tw_slave_configure() */
 
-static struct scsi_host_template driver_template = {
+static const struct scsi_host_template driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "3ware Storage Controller",
 	.queuecommand		= tw_scsi_queue,
