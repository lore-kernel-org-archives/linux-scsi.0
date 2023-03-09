Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11BB4C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:28:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbjCIT2O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:28:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbjCIT2E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:28:04 -0500
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6220311658
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:27:59 -0800 (PST)
Received: by mail-pg1-f176.google.com with SMTP id d6so1725118pgu.2
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:27:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390079;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wc8ynnG/AUp5Bu6EUuP/BB+ayz5OX1mJgbC2WVbd21o=;
        b=R5DzS4IDUlCOq8xZt4zBQsbK609u+3Pz0Bs1q/QLRcNFWqszl8akXJm6yY2epKn3xl
         XqIMHHLTHxTSqrI/iPz8YIzET24V3hHVOMaXVMBCqTCija05YQrPZWePwX5a5q8irTZT
         9S4iPin91MjSUCUExuDNWVywzCkZ336u04JWzIb5hWS8HWUd5ApTKKoRvIxISpnFDNMn
         eqBnuBngUKwMeFSDCLJeoIEavis18PcMACCDG6tc1xE0c4SSLwh6EpU6jXTNi9yasW5B
         xpeJZTDmp4LjIZorZy3knFxw3JvwZQOMyPpvdbAv/ROmDp4aT9IomSU3C2IBvV6bxxnl
         ieJA==
X-Gm-Message-State: AO0yUKU4fjrPOEhCLM2FQRP+ol6NOHaFZCbG/cnFsf0sVmqRWHRNO3qH
        0rSrkna4HEZEto3qTS34BBzPGiBycH9Y7w==
X-Google-Smtp-Source: AK7set+MFbRLMLYJjv6m/rQfhbsvXCRwohlVsG78SuvsTXG0kY5q6GsNGgStF60Ds7jQY/59WjuY5w==
X-Received: by 2002:a62:3814:0:b0:5dc:ed74:b9dd with SMTP id f20-20020a623814000000b005dced74b9ddmr17081578pfa.18.1678390078883;
        Thu, 09 Mar 2023 11:27:58 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:27:58 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 23/82] scsi: arxescsi: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:15 -0800
Message-Id: <20230309192614.2240602-24-bvanassche@acm.org>
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
 drivers/scsi/arm/arxescsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/arm/arxescsi.c b/drivers/scsi/arm/arxescsi.c
index 2527b542bcdd..925d0bd68aa5 100644
--- a/drivers/scsi/arm/arxescsi.c
+++ b/drivers/scsi/arm/arxescsi.c
@@ -238,7 +238,7 @@ arxescsi_show_info(struct seq_file *m, struct Scsi_Host *host)
 	return 0;
 }
 
-static struct scsi_host_template arxescsi_template = {
+static const struct scsi_host_template arxescsi_template = {
 	.show_info			= arxescsi_show_info,
 	.name				= "ARXE SCSI card",
 	.info				= arxescsi_info,
