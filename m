Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B75BC61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbjCITbq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:31:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbjCITbD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:31:03 -0500
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FDD9F16B6
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:30:05 -0800 (PST)
Received: by mail-pj1-f50.google.com with SMTP id u3-20020a17090a450300b00239db6d7d47so2911674pjg.4
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:30:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390205;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xpoH3ZmMyEfzGffayIrMYkM/us+uEKnG/TchdnkTiAk=;
        b=6xUKhN16Y1ful5fFB6Owj2W6f/XwoU1AedMgeN1A69XFoAuVKA2UQLx1Q+ycDhd8dA
         uqoZXlOKNBwPBulsMIl0tVzNdUo1nFJx+tpcmK72zBo9v0ezyfUztdrWPrN0wnICH93N
         6qWa7Fk2AM8GhUZNEyyHimOVESQVIcNvn3MUBaqXHBpDi7UZbehR/eLgyJxTGWraGpgP
         bUa9y5hsbMahHv6StAMk69s9w/0hWjwEpKYRq5cw66Yd7L3rNjDwUcc0N104nnCp7RrO
         3cAOTI5UeCibr/yXqbzUbImSINJmFhA0u/26AoX6Cs8PBkGdxdmp64YQ4ru2+bQBP2Tv
         JyRg==
X-Gm-Message-State: AO0yUKVlgXQ9fPjaezcwv3uF9XlTQjCOveLm+QSxtVpvMTebgkqUEd71
        cqridYOLsZ+TZQUN1WVR4y8=
X-Google-Smtp-Source: AK7set+0NnMod1GBShniXjcxF73w2VJrGVOqRTRawFYgWgXoT3qKsIkxb6JGSTNSCI29AgOv0FoOjA==
X-Received: by 2002:a05:6a20:6a0c:b0:cc:a93:2b82 with SMTP id p12-20020a056a206a0c00b000cc0a932b82mr29111659pzk.58.1678390204759;
        Thu, 09 Mar 2023 11:30:04 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:30:04 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 73/82] scsi: stex: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:26:05 -0800
Message-Id: <20230309192614.2240602-74-bvanassche@acm.org>
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
 drivers/scsi/stex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 8def242675ef..5b230e149c3d 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1472,7 +1472,7 @@ static int stex_biosparam(struct scsi_device *sdev,
 	return 0;
 }
 
-static struct scsi_host_template driver_template = {
+static const struct scsi_host_template driver_template = {
 	.module				= THIS_MODULE,
 	.name				= DRV_NAME,
 	.proc_name			= DRV_NAME,
