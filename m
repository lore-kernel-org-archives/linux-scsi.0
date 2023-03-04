Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 777FAC64EC4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjCDAbw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:31:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjCDAbu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:31:50 -0500
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7312669231
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:31:49 -0800 (PST)
Received: by mail-pl1-f176.google.com with SMTP id a9so4499982plh.11
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:31:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889909;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TRaBidyNT0CPspAryOSAJzVfbEYXDVCy844lk4y4E34=;
        b=13rqYBn3KBvsetCghQjrLjCGM36AqXSD7IoqlEiHKzLgPSz8YGWfKoO3AO7fCFF9Eq
         T4FIMdOPddrbWKxs63ifyqxYULzjduvcT24YCMiSbBAUltW6n9heUWV4d31hoL27fCXX
         zUARMEv2lZ8ib+pYqtwqc4OhA3TQW7nRLe8Io3qjLyoAuHJXuxlRzcAN2uxKZdB5Pht2
         7+kEzYBLa1HWLFhy2lwH3I+ze6U3L5AviJsuHOeFuYKfkC/FWDjFLwmwuHgaVPiWvAm6
         ZGS7YgL7InjTWotvdVx/vkscYpCn+GQdC0G3FAzoMku8s3BeD75NY4tVl7R9Fscfsc3U
         WgjQ==
X-Gm-Message-State: AO0yUKX6YxOPYYde+8/iI3dcFV3SAUYLhEw6/QPytBBwfEfvn5noFHgT
        N4yKlrEdY6g63XJksptTopk=
X-Google-Smtp-Source: AK7set8hUhE7/TFiFiysdFdlfBQ5ZCoc5pmhseZjN/+/vxJkRRfbWDEOhhaEJxdiakf87sv0pYAIMg==
X-Received: by 2002:a17:903:228f:b0:19a:9945:a7aa with SMTP id b15-20020a170903228f00b0019a9945a7aamr4404923plh.20.1677889908857;
        Fri, 03 Mar 2023 16:31:48 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:31:48 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 06/81] RDMA/srp: Declare the SCSI host template const
Date:   Fri,  3 Mar 2023 16:29:48 -0800
Message-Id: <20230304003103.2572793-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SRP host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index df21b30b7735..3446fbf5a560 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3077,7 +3077,7 @@ static struct attribute *srp_host_attrs[] = {
 
 ATTRIBUTE_GROUPS(srp_host);
 
-static struct scsi_host_template srp_template = {
+static const struct scsi_host_template srp_template = {
 	.module				= THIS_MODULE,
 	.name				= "InfiniBand SRP initiator",
 	.proc_name			= DRV_NAME,
