Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32827C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15482613B8
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347110AbhDMRH7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 13:07:59 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:46871 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347093AbhDMRHu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 13:07:50 -0400
Received: by mail-pg1-f176.google.com with SMTP id t140so12379904pgb.13
        for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2021 10:07:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dI5y2pj+Al0+2aC0ZPqBvqEqkhXKrklWG5otUSr/XY4=;
        b=JBUplI6k+7Oqkxk10/ty2yttDhw/BH/ofItlq8mQAfnxQiSd4l2AfX7HbQedtQVAbS
         myDO3iHDmrg10s4ozKSmRt8mVCI6I+9zbznGpNSk9fHgmumA/P/pN/ZjP1HdWaPjsSC5
         4OqfasPhMtTXAJ/9OTpwW6LizsybSMjDCrKYcbSpQxId+b1MBli8GRZH8pb6pR2REw1G
         4cYBDaWbU6jywwtdq5aWDix6rsBLLMUrI3T8+e9zTqwkfupX2JUzU7EvKa7WcNIl4FTi
         bqXF9QO6ZgFGHd77F5Pgwv1TZZBXsjEbflYJRomfczCNFRclNZOMQDBpcs4oW2wiva51
         yZAw==
X-Gm-Message-State: AOAM5318OaJdewiCh7ne3DuDT8k5WqBwFnCq6boZ+6N35+VltBmbr6U1
        I99zwg36mgnFRyTYHVUEqFw=
X-Google-Smtp-Source: ABdhPJwo6b01WnuS89QISFZwIDRy4ASQwT4W7mO/gNPvNzZ3Z5H7lHHsaYCg8gojhmzVWzTPHnS4uA==
X-Received: by 2002:a63:6a05:: with SMTP id f5mr33314804pgc.433.1618333650408;
        Tue, 13 Apr 2021 10:07:30 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:345f:c70d:97e0:e2ef])
        by smtp.gmail.com with ESMTPSA id z10sm6736078pfe.218.2021.04.13.10.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 10:07:29 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/20] fcoe: Suppress a compiler warning
Date:   Tue, 13 Apr 2021 10:07:02 -0700
Message-Id: <20210413170714.2119-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210413170714.2119-1-bvanassche@acm.org>
References: <20210413170714.2119-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Suppress the following compiler warning:

warning: cast to smaller integer type
      'enum fip_mode' from 'void *' [-Wvoid-pointer-to-enum-cast]
        enum fip_mode fip_mode = (enum fip_mode)kp->arg;
                                 ^~~~~~~~~~~~~~~~~~~~~~

Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/fcoe/fcoe_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index b927b3d84523..4d0e19e7c84b 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -863,7 +863,7 @@ static int fcoe_transport_create(const char *buffer,
 	int rc = -ENODEV;
 	struct net_device *netdev = NULL;
 	struct fcoe_transport *ft = NULL;
-	enum fip_mode fip_mode = (enum fip_mode)kp->arg;
+	enum fip_mode fip_mode = (enum fip_mode)(uintptr_t)kp->arg;
 
 	mutex_lock(&ft_mutex);
 
