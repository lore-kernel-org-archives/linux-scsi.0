Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CDD9C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43753613B8
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347112AbhDMRIB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 13:08:01 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:33625 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347096AbhDMRHv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 13:07:51 -0400
Received: by mail-pg1-f176.google.com with SMTP id t22so12429577pgu.0
        for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2021 10:07:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jlia9mFkxf+1O2GS+1+5o6VXqsIZLpimcEJ8NdFf5fo=;
        b=ACbM/S8wu+5UNHMP+yiK3KezvG4qk2lHLc9oDi7nMUMKq9hq/hae843czaQSHcJvpB
         vpQ8+wuwU7qTapfawxiF0VrUMeVM3osxIooiUotvswEzXUs7c3HlZu2p4IbAgAxQzb/S
         LkdJ8ObyZFj7FGhyWMy7YpGy5tbZRYNnAoZ37h9WAAJX6rSttKATVwrr2MjjLzuHgnZB
         e3ClI9PUa3KZx4AAGzTJ5UNM47hmVWBCsumsDv6vQj7WVSN6fguZfCucyz6oFZxt0K5C
         omgn2FWVU0vbaNwamHmqfh9QowG+PdXqU1phQoKV4dfqv3hPN1P+N4A1xsqnFufXApYi
         GLKA==
X-Gm-Message-State: AOAM533Q6NsH3nV/cTJEjQSofVLv5eoU3N/21k3wlVsVbes1HVoqQH9w
        6LSaTayOlUZeEqW1ON9tDFZgvkx23LTycQ==
X-Google-Smtp-Source: ABdhPJzzIP7O+z3nvx2Ejgl/Vfigg3DlEFFaAvmVUVDJ9mZUb9IZfvcG8MNv/nPTl6KEuF7M0PurYQ==
X-Received: by 2002:a62:5cc7:0:b029:24b:3525:9dbd with SMTP id q190-20020a625cc70000b029024b35259dbdmr13511804pfb.3.1618333651609;
        Tue, 13 Apr 2021 10:07:31 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:345f:c70d:97e0:e2ef])
        by smtp.gmail.com with ESMTPSA id z10sm6736078pfe.218.2021.04.13.10.07.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 10:07:31 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
Subject: [PATCH 09/20] iscsi: Suppress two clang format mismatch warnings
Date:   Tue, 13 Apr 2021 10:07:03 -0700
Message-Id: <20210413170714.2119-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210413170714.2119-1-bvanassche@acm.org>
References: <20210413170714.2119-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Suppress two instances of the following clang compiler warning:

warning: format specifies type 'unsigned short'
      but the argument has type 'int' [-Wformat]

Cc: Lee Duncan <lduncan@suse.com>
Cc: Chris Leech <cleech@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/libiscsi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 7ad11e42306d..0c3082d09712 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3587,10 +3587,11 @@ int iscsi_conn_get_addr_param(struct sockaddr_storage *addr,
 	case ISCSI_PARAM_CONN_PORT:
 	case ISCSI_PARAM_LOCAL_PORT:
 		if (sin)
-			len = sprintf(buf, "%hu\n", be16_to_cpu(sin->sin_port));
+			len = sprintf(buf, "%hu\n",
+				      (u16)be16_to_cpu(sin->sin_port));
 		else
 			len = sprintf(buf, "%hu\n",
-				      be16_to_cpu(sin6->sin6_port));
+				      (u16)be16_to_cpu(sin6->sin6_port));
 		break;
 	default:
 		return -EINVAL;
