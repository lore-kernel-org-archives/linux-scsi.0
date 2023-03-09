Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFB01C64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:27:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjCIT1c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjCIT1T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:27:19 -0500
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3655E9F3E
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:27:17 -0800 (PST)
Received: by mail-pf1-f175.google.com with SMTP id x7so2190819pff.7
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:27:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390037;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9oXRTU4ppzyaVUobHzxub2u25mIEKjp/3zCfs4JzFS8=;
        b=Vy2sC35sDFCFI587UPcl85XtUAiKMew/AHWUz1ZtTDY6iUDA2XwYpNJXHE4Ovr7tem
         7AwlFvc+0AbNDbwKuFFyeLUjGg1nlWrY+l/vHVBLtipNYy2vphbqElP0y7DiQ8SHpUcp
         SPqU1j77AqtvoHCMYkZCjidF0F7mWU/eEE7KYWTeoWI4a6PbJwtzxS22PY3W92uN2LCm
         QNhoENyoGWn73TnVthN9wR61RyctDd1Ljs832nm2PcMGkaMLLDeEarurWUyxwOyeV+nN
         FO5pNSsa5xN/P8UjL0zbwhXCxrMY97NjLALRsocO4Njhjpry4SrXg0oCUDGH1hutvZpc
         HJnw==
X-Gm-Message-State: AO0yUKUXD1aKW/bzUYF3h3wejmElKK0G0T91ahRg7rZCjNWLvH2DmljK
        Av2coO+hHB+B0NpVcTV9H6PSWcJ3xpJzPg==
X-Google-Smtp-Source: AK7set/aO0rDqCyKnVXi9QIIM38+sChZbIzejnsCCm9hqFenM9oS4T6lWsCrJZnKyoSgK3N4hWA3XA==
X-Received: by 2002:a62:1709:0:b0:5a8:b6ec:3aac with SMTP id 9-20020a621709000000b005a8b6ec3aacmr21694400pfx.15.1678390037057;
        Thu, 09 Mar 2023 11:27:17 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:27:16 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH v2 08/82] scsi: zfcp: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:00 -0800
Message-Id: <20230309192614.2240602-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Acked-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/s390/scsi/zfcp_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 3dbf4b21d127..b2a8cd792266 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -418,7 +418,7 @@ static int zfcp_scsi_sysfs_host_reset(struct Scsi_Host *shost, int reset_type)
 
 struct scsi_transport_template *zfcp_scsi_transport_template;
 
-static struct scsi_host_template zfcp_scsi_host_template = {
+static const struct scsi_host_template zfcp_scsi_host_template = {
 	.module			 = THIS_MODULE,
 	.name			 = "zfcp",
 	.queuecommand		 = zfcp_scsi_queuecommand,
