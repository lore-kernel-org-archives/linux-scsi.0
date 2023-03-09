Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02866C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:27:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjCIT1k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbjCIT1c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:27:32 -0500
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D79F1445
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:27:30 -0800 (PST)
Received: by mail-pl1-f169.google.com with SMTP id a9so3084261plh.11
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:27:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9O+CFHroXeGMQJXjLpdEI2pqL5MGU1cKW/jyaRLyaNA=;
        b=L+VUogk1pXzVuqADAweZhOxAOET+uT1zSgru2IOAiRgWxUMYpHStXPTSM6GRY29B+d
         iz8xNA9+MmvOBDrbT0dEqmxFzXM7QMiXVAF8Ir4LCpDpOMSbQP20hFuA+ergOJizvxQC
         felpS8grV+qqUtZyveUmOnndQXgomFAoAy1qiIIdliUToRi/ZqGZcrrHMtc/WKFlu0Vr
         iJNiELQtZzIy29JDMABpgHZn7OX5dQFN/EQaVlfjWsSvv+dNO+6fYhXkb+85Y1pgZkvw
         LynWVyLswmLw2ysL36xHbCXjvulTkBbtuO/VV/OQlw94ny/Ce9d2eWxAa+V7yoVC0Nt1
         /zAA==
X-Gm-Message-State: AO0yUKXSyQWiE0FmNX3e6pj9zD95I/qeMyvANE/Bl1cne0eE7JondGwj
        r8dVPGLQanbaSVx0h3QU3yw=
X-Google-Smtp-Source: AK7set9H1B/2By/xifCkkUaSO+FPzHlgDd7W98+ay7U4quztZLmC1xwbDN83a5/NpHIAGZNc9K0Oqw==
X-Received: by 2002:a05:6a20:6a1c:b0:c7:61cc:11d4 with SMTP id p28-20020a056a206a1c00b000c761cc11d4mr27095766pzk.44.1678390049867;
        Thu, 09 Mar 2023 11:27:29 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:27:29 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 15/82] scsi: a3000: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:07 -0800
Message-Id: <20230309192614.2240602-16-bvanassche@acm.org>
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
 drivers/scsi/a3000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index 2c5cb1a02e86..c3028726bbe4 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -197,7 +197,7 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 	}
 }
 
-static struct scsi_host_template amiga_a3000_scsi_template = {
+static const struct scsi_host_template amiga_a3000_scsi_template = {
 	.module			= THIS_MODULE,
 	.name			= "Amiga 3000 built-in SCSI",
 	.show_info		= wd33c93_show_info,
