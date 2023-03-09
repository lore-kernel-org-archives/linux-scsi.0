Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CD9DC61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:27:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbjCIT1w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbjCIT1f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:27:35 -0500
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1ECCEB89F
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:27:33 -0800 (PST)
Received: by mail-pg1-f170.google.com with SMTP id 16so1694276pge.11
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:27:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0DwKfQtFgIgqVRLk7CJqp+SWpc3PgTs6DS8lVIZ4b8Q=;
        b=1/hWrUJdrSr46ltkMffGdMcDtFcDDnmDLaCGMEjBbRViun9w/rQhPx4qDIMrmxVmXT
         pXZ5pKDloD/yr4Sg0NRRalDcis7cCS6Rc4zOBwgBjNGkZAn0HXYnBAVAWdOEkeA44u9G
         lEcdwDMfa1j0v17D75fZLji7TlmZzZdANhjQDJzt2gd0GTC/peQ9auxuc6Q0iLvK3ysV
         xqbK5J1itZM3re5N4xWLMrrvN7+LqG6W/cGnChTbBHKz6JXedDQ07cT78qLFJ8/iYxDo
         YbThfaxam1+382tppQufIMlfdj4U382F8l1v6THy9H6gmCo249KAbwwTaI44BefwWNrN
         704A==
X-Gm-Message-State: AO0yUKXnmx/ObLC9YAhfU8ME98dyb9leRpgu0H+JWTpQRS0Ye3P5/YlC
        uyq4qzxNFZ1iWpskr5ip01M=
X-Google-Smtp-Source: AK7set/y3YnCnvQDHbggNrQ2hXVo1IUnNJAaG/Ngq585Cesql1017hNlrUhot/W1EwTnTFFJ+J26Zw==
X-Received: by 2002:aa7:96f9:0:b0:593:2289:f01c with SMTP id i25-20020aa796f9000000b005932289f01cmr16747182pfq.25.1678390053413;
        Thu, 09 Mar 2023 11:27:33 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:27:32 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 17/82] scsi: advansys: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:09 -0800
Message-Id: <20230309192614.2240602-18-bvanassche@acm.org>
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
 drivers/scsi/advansys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index f301aec044bb..ab066bb27a57 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -10602,7 +10602,7 @@ static int AdvInitGetConfig(struct pci_dev *pdev, struct Scsi_Host *shost)
 }
 #endif
 
-static struct scsi_host_template advansys_template = {
+static const struct scsi_host_template advansys_template = {
 	.proc_name = DRV_NAME,
 #ifdef CONFIG_PROC_FS
 	.show_info = advansys_show_info,
