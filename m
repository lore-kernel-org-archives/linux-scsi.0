Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8883EC77B61
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:59:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbjCVT76 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbjCVT73 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:59:29 -0400
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1407D8F
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:07 -0700 (PDT)
Received: by mail-pl1-f180.google.com with SMTP id u5so20280800plq.7
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dAdiI8QeHjoUkeBCYpg9C4zi1sFNt3WL7fHduN+tVF4=;
        b=RW3rJpANmqKAja7RRusPmZIOegtlo55qlRbYxEN/dPiMUZbbIS8yKzpnnYZPRbAPh2
         CejbxjnO5YAg62wriTUf7B8dVFENK7Spqy78D+ddjogzpkcrTEZHgPl2aVEbsl5+ijuc
         47pRlnwaV1cmfY0c1W9ROTDCy3cppCW5/ZJMrWzE9hwkvMovQ17/LubtQwHPfWbmRthI
         MADCgmU1R135oYu3Akyl6NzKEUFXsp/+95j6j4I7kj96B7QPe4XrxSk3iBthrxvYGMzr
         r929Ad80FRznU/c83m5ugU1/T6yVteHyrBKrhvQgQcZRxRLV5VmML6nOvWnn9rG66Jbs
         GFAA==
X-Gm-Message-State: AAQBX9e/ioP65NQ2GDT3ChUqowsDFoq8E6cxYkUt9cy2zp3MSNvkQiv2
        AxZFWhO+YITR4yJbrfQ7QgE=
X-Google-Smtp-Source: AKy350aR0vyurkBIPL/OLZ0VTs4MglVs4nSYuKWD4nV6IOvkfgB4SD31UCBh8ft+kNbIybziozTh2g==
X-Received: by 2002:a17:90b:d98:b0:23d:39e:6054 with SMTP id bg24-20020a17090b0d9800b0023d039e6054mr3237199pjb.5.1679515086316;
        Wed, 22 Mar 2023 12:58:06 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:58:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 52/80] scsi: mesh: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:47 -0700
Message-Id: <20230322195515.1267197-53-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mesh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index 84b541a57b7b..e276583c590c 100644
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -1830,7 +1830,7 @@ static int mesh_shutdown(struct macio_dev *mdev)
 	return 0;
 }
 
-static struct scsi_host_template mesh_template = {
+static const struct scsi_host_template mesh_template = {
 	.proc_name			= "mesh",
 	.name				= "MESH",
 	.queuecommand			= mesh_queue,
