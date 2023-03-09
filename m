Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99B8FC61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:30:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbjCITaw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:30:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbjCITaJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:30:09 -0500
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748CDF6903
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:29:32 -0800 (PST)
Received: by mail-pf1-f169.google.com with SMTP id a7so2184791pfx.10
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:29:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390172;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mt+SALTZpgtMKMj3j2WTDo1ienCuaV/TBXYIRZ/PdNk=;
        b=j/Sc4zaFm+vGBH8q+X2OQZQw9xW/ITamlkUBhOHEgYlXGU3JKozaOrVPugJnrAk6Cs
         wwo/bliXIdJcimc4olhQL6/bN8I/x4ONASjG9D5r7xP6Y+VnXAgneE/VoCO/OVccNCIO
         TY/6zrJxnPHvFYqyMhwxomykhrwvJzSg23Gszpg710u4UTVjbFCUuhx2m2xbZbZ2IkpW
         7Jfr5JrumWXX5r5CapjZ0R3+fZZCjbYivA2ikMhfWpTvD/BNoTIrBqswnYlQkixoyYXK
         fTp0mVncM1yN+Wt3pT2RxK7mmEjv8rZ0BvFbNHrWWtu96h8FXQRft3b9EeQfWGaNd3mK
         Rw4g==
X-Gm-Message-State: AO0yUKXfWB9GkS9slGlxwFyMjf4cmY3OLd/vGJ9p9Oj5EAmd5GPX3ih4
        dIiHusTU3Q+6fSxTVwSB7IQ=
X-Google-Smtp-Source: AK7set/1cYVuh6RX64ERvIPDmVNYGtBy/xLOSHQYZ7+fv7iVQsqxbeNTPWCYanGigd1VAe+EPz0vug==
X-Received: by 2002:a62:1ad4:0:b0:5cf:4755:66d9 with SMTP id a203-20020a621ad4000000b005cf475566d9mr16435268pfa.24.1678390171651;
        Thu, 09 Mar 2023 11:29:31 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:29:30 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 58/82] scsi: mvumi: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:50 -0800
Message-Id: <20230309192614.2240602-59-bvanassche@acm.org>
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
 drivers/scsi/mvumi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 60c65586f30e..73aa7059b556 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2168,7 +2168,7 @@ mvumi_bios_param(struct scsi_device *sdev, struct block_device *bdev,
 	return 0;
 }
 
-static struct scsi_host_template mvumi_template = {
+static const struct scsi_host_template mvumi_template = {
 
 	.module = THIS_MODULE,
 	.name = "Marvell Storage Controller",
