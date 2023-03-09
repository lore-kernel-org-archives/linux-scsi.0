Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E08ACC64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:28:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjCIT23 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:28:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjCIT2L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:28:11 -0500
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B49FF28D08
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:28:09 -0800 (PST)
Received: by mail-pf1-f174.google.com with SMTP id c10so2167981pfv.13
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:28:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390089;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ts+vWJKv0MXDJEA4JIO9+AM9uvvvxXowXRyy3KeGtYI=;
        b=mwOOERH4wkNbxyEu6RbIt9CURCItAGscjBcbWnI3g+3c8jX4oTeWhEbevm69rgIg6n
         0jlkimWydn+pLXR45KKAGeMyBWjRMOsRxuk6rQ48UY9xmKfNyM4P6dkJFO0q6vOvYV7D
         cPYZ/AMF4YPcFTR+SIMf+SlNChxYD74nLXAWV3hhB6e/6m1PQv+5OPO7T4QKJiM1/5O0
         Rxno7NaiQ9h9EFJnMoaIKCqkHmvij1YFvrakt0uZkLeqU1yO/uD0jsr94Lr0FRtyZgrd
         jr2qvZ3LEwWiDbmmIMJGJkF4OdxYKRp5QKDQ+lk9O5mzpVgPyhF9/86TXQ31sxJX8Evw
         C4aw==
X-Gm-Message-State: AO0yUKUqD5jk3bmcMRSK1GGQQNivGJk0NexlsoHu523Ix2iRph8MClO9
        2eS1GJNY+QxeyVI8wrlmHjU=
X-Google-Smtp-Source: AK7set+4LeH98mTYKOvLFJCTK6ZucVQYBezHfah/syIuZTi6ZI/U3F7M7ksioNytLmT33IJZ/FHf6w==
X-Received: by 2002:a62:2586:0:b0:5d3:81b4:db5c with SMTP id l128-20020a622586000000b005d381b4db5cmr2902115pfl.4.1678390089163;
        Thu, 09 Mar 2023 11:28:09 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:28:08 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 29/82] scsi: atp870u: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:21 -0800
Message-Id: <20230309192614.2240602-30-bvanassche@acm.org>
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
 drivers/scsi/atp870u.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 7143418d690f..2a748af269c2 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -40,7 +40,7 @@
 
 #include "atp870u.h"
 
-static struct scsi_host_template atp870u_template;
+static const struct scsi_host_template atp870u_template;
 static void send_s870(struct atp_unit *dev,unsigned char c);
 static void atp_is(struct atp_unit *dev, unsigned char c, bool wide_chip,
 		   unsigned char lvdmode);
@@ -1726,7 +1726,7 @@ static void atp870u_remove (struct pci_dev *pdev)
 }
 MODULE_LICENSE("GPL");
 
-static struct scsi_host_template atp870u_template = {
+static const struct scsi_host_template atp870u_template = {
      .module			= THIS_MODULE,
      .name			= "atp870u"		/* name */,
      .proc_name			= "atp870u",
