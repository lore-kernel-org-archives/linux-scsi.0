Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EEB8C64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:29:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjCIT3n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:29:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbjCIT2w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:28:52 -0500
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2097FEBF82
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:28:51 -0800 (PST)
Received: by mail-pl1-f181.google.com with SMTP id i10so3093407plr.9
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:28:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q5YcXSUW/MYMp0sgEwmo/vVQvOhQmpTmjGGC3D+urCQ=;
        b=BdTqR3FAXS5xP+xBr/1K7fm1qReO650RP6VZ9fiF+4flNMT1ao1R7vTk6P0wDFjsZ6
         Boou8+aEwfiL0eNEKmMYqCtY65n5RjghHSMZtSNeOiVRuOcvaBJ/YuiorHpSDwscZvc/
         AAvHAti0KQj/bcHI8v5wyVWVOUJPPgwBhp6vwy2ZVBN1xKIBw33FOG2Ql3jtnsdvljC4
         uUXAmx+Sd9LjO/z7jYH6n3pELx8YjuWTYwnt3izS5NW9ScLPsEuVcua4ybzqC4k9wiom
         hXcqTKNx2fTqiJ8wq5ts7p2I0yWNpoO/NGB0fd+Or9BH4y1WymEM9N5EbjatWHtoQhJj
         q7lw==
X-Gm-Message-State: AO0yUKWX3rtzdoSQ9kz26l9eUNVcM0I9UveYI6pY6Gp2VehQIvsQ9tGO
        p+lWO6WIbj/kswSk58M/ed4=
X-Google-Smtp-Source: AK7set9A1odLnagENZqNcHOZ0zsA7a8rFg5iAgP6Xco8QX47FthMBkfjBJPFYMTCHSTM0qqYG0SaDQ==
X-Received: by 2002:a05:6a20:430f:b0:d0:4361:9720 with SMTP id h15-20020a056a20430f00b000d043619720mr10514895pzk.61.1678390130552;
        Thu, 09 Mar 2023 11:28:50 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:28:49 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 48/82] scsi: isci: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:40 -0800
Message-Id: <20230309192614.2240602-49-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the ISCI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/isci/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index e294d5d961eb..ac1e04b86d8f 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -149,7 +149,7 @@ static struct attribute *isci_host_attrs[] = {
 
 ATTRIBUTE_GROUPS(isci_host);
 
-static struct scsi_host_template isci_sht = {
+static const struct scsi_host_template isci_sht = {
 
 	.module				= THIS_MODULE,
 	.name				= DRV_NAME,
