Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 368D7C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:30:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjCITaV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbjCIT3R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:29:17 -0500
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5FA82343
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:29:15 -0800 (PST)
Received: by mail-pg1-f174.google.com with SMTP id 132so1696259pgh.13
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:29:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390155;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dAdiI8QeHjoUkeBCYpg9C4zi1sFNt3WL7fHduN+tVF4=;
        b=lAP3dAoK0qgZHsam0nxYCCv4tkzEyB4e+LA9DSdxQ/YmZwLx2zui9SrI6Uq9hoytP3
         IPb241s2nRiu6LShQkA703Hga0sTNuVkqnO+4qUONy2o8ZOeOShz6IbJVAqNjj4Etsas
         F4fjrdykGx6h3JOnAhALEPa68nSdXiKzF5xUKLMt+r5TzGwORTxqescPbjfIWE8B75ib
         1yACfKZ23yq4PP9NQE86As6jHY0CaklUeFNDR/+K1znhL8tdtWjj89BjP8JfKsggAeS+
         06p6ryqNw6acf0eumVfgLnEUkHjmQH52yzPnjeFJvZtggR8JmG2ZcdLG0ev2luAlEoXK
         zshQ==
X-Gm-Message-State: AO0yUKVmYQ6+K4hpx4n0ehJR4J2nBkXOc5fwCI/vWoo7YKXM7MSRinxd
        n9ohzUsHkw2gDnrcJprbAAtFA1Q0LknLIA==
X-Google-Smtp-Source: AK7set+7kDptN0GMlYvJG3B/dyj2LyJIyD3fB+zI/BAyT4nOqOwUFoe+ILfq/SLqD3D8fF5vRSScww==
X-Received: by 2002:aa7:9504:0:b0:5db:ba06:1825 with SMTP id b4-20020aa79504000000b005dbba061825mr20059852pfp.3.1678390155053;
        Thu, 09 Mar 2023 11:29:15 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:29:14 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 53/82] scsi: mesh: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:45 -0800
Message-Id: <20230309192614.2240602-54-bvanassche@acm.org>
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
