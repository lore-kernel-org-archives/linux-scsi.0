Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90B0BC4332B
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AC2E64D5D
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbhCQJNf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbhCQJNA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:13:00 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA8AC061762
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:51 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id r10-20020a05600c35cab029010c946c95easo831806wmq.4
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mmVm22Z3SbJdFCwvYkYccZgvkOVfVFM6WIi4/sN6y+8=;
        b=a8vNEuCVQ+NCgglSdOUubA+3RisCfA1ki5nIjhK0BEddlRmSgWfN4sHriI2fdIdBuf
         8Pth22d+tt8RMPzpAZgGELwc2SBNboK2J+nKe9KsqiWyQ4cA7PskHQm7w7o/JsxyWwVT
         29vbkqQ8w1yQfAI6qmM5cbLoZvHf4PL21ialqbZEr4YwjN2AtvXQqShzQFugx7uhQqUM
         hJaaLDDaQ4Sx3IdKTqHHtOUwWq7Kx3oKDrmROilDu+Cf3gYXsjbJJ1/rxe5YPLvQS8Od
         +4CXHI4DRZ9GOdwFBK0H8+bw6MMhPyqS3DuHLRxlc5xfC6hxEzEt5AcLoqkg68mr3nq1
         EyfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mmVm22Z3SbJdFCwvYkYccZgvkOVfVFM6WIi4/sN6y+8=;
        b=syvN6HGGW1REoQgzcvxHlU06+SDJP/pA6+u0Pac2LXBGyhlQ5B/qVng3UjRMEwmqf4
         bWSEz3SGnBlvjis9hAwrh5MaiwO4R7WYdQzAcjiNjx2rZeGtph0UCEF3+hN1/JfwlRH+
         36cQxB3KZOEi5I6AIbWIrvS4fJ4d+cZkbj5HB+CwVWGFZBT+tjXmpKQUkUuxJGCObwIT
         ATkH2a07qllrWDUY8UBqvZyTW4RPYIFVL8xXKIXwQ4zd0Yi36fQ2kthYfuzz4dtp5vFh
         /IoDQVdwVW/6HmA2X1naZURqVUhBNX+yFK0jLAWIUvgNt818vNGiwYHYYbuZzLYlom83
         E1lQ==
X-Gm-Message-State: AOAM531Z7RcFA/BTW+p5JHYlDcgV1p6LsK9T6j8q4NdqTXIk5KUx7A3C
        sOSfCuZJq9XdE3vIGctS9ELqrw==
X-Google-Smtp-Source: ABdhPJw7EMIb9bS68YOooMq3rBQZZw2tnoOqcsXNbSihzHDgIh/vF+rIIHU7lbgm9dZu7dWn8cGMxg==
X-Received: by 2002:a7b:cc85:: with SMTP id p5mr2759000wma.148.1615972369955;
        Wed, 17 Mar 2021 02:12:49 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id e18sm12695886wru.73.2021.03.17.02.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:12:49 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bas Vermeulen <bvermeul@blackstar.xs4all.nl>,
        Christoph Hellwig <hch@lst.de>,
        Brian Macy <bmacy@sunshinecomputing.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 10/36] scsi: initio: Fix a few kernel-doc misdemeanours
Date:   Wed, 17 Mar 2021 09:12:04 +0000
Message-Id: <20210317091230.2912389-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091230.2912389-1-lee.jones@linaro.org>
References: <20210317091230.2912389-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/initio.c:560: warning: Excess function parameter 'num_scbs' description in 'initio_init'
 drivers/scsi/initio.c:1899: warning: expecting prototype for int_initio_scsi_resel(). Prototype was for int_initio_resel() instead
 drivers/scsi/initio.c:2615: warning: expecting prototype for i91u_queuecommand(). Prototype was for i91u_queuecommand_lck() instead
 drivers/scsi/initio.c:2667: warning: Function parameter or member 'dev' not described in 'i91u_biosparam'
 drivers/scsi/initio.c:2667: warning: expecting prototype for i91u_biospararm(). Prototype was for i91u_biosparam() instead
 drivers/scsi/initio.c:2740: warning: Function parameter or member 'host_mem' not described in 'i91uSCBPost'
 drivers/scsi/initio.c:2740: warning: Function parameter or member 'cblk_mem' not described in 'i91uSCBPost'
 drivers/scsi/initio.c:2740: warning: Excess function parameter 'host' description in 'i91uSCBPost'
 drivers/scsi/initio.c:2740: warning: Excess function parameter 'cmnd' description in 'i91uSCBPost'

Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bas Vermeulen <bvermeul@blackstar.xs4all.nl>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Brian Macy <bmacy@sunshinecomputing.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/initio.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 926a7045c2e5c..9b75e19a9bab1 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -546,7 +546,6 @@ static int initio_reset_scsi(struct initio_host * host, int seconds)
 /**
  *	initio_init		-	set up an InitIO host adapter
  *	@host: InitIO host adapter
- *	@num_scbs: Number of SCBS
  *	@bios_addr: BIOS address
  *
  *	Set up the host adapter and devices according to the configuration
@@ -1887,7 +1886,7 @@ static int int_initio_scsi_rst(struct initio_host * host)
 }
 
 /**
- *	int_initio_scsi_resel	-	Reselection occurred
+ *	int_initio_resel	-	Reselection occurred
  *	@host: InitIO host adapter
  *
  *	A SCSI reselection event has been signalled and the interrupt
@@ -2601,7 +2600,7 @@ static void initio_build_scb(struct initio_host * host, struct scsi_ctrl_blk * c
 }
 
 /**
- *	i91u_queuecommand	-	Queue a new command if possible
+ *	i91u_queuecommand_lck	-	Queue a new command if possible
  *	@cmd: SCSI command block from the mid layer
  *	@done: Completion handler
  *
@@ -2650,9 +2649,9 @@ static int i91u_bus_reset(struct scsi_cmnd * cmnd)
 }
 
 /**
- *	i91u_biospararm			-	return the "logical geometry
+ *	i91u_biosparam			-	return the "logical geometry
  *	@sdev: SCSI device
- *	@dev; Matching block device
+ *	@dev: Matching block device
  *	@capacity: Sector size of drive
  *	@info_array: Return space for BIOS geometry
  *
@@ -2727,10 +2726,8 @@ static void i91u_unmap_scb(struct pci_dev *pci_dev, struct scsi_cmnd *cmnd)
 	}
 }
 
-/**
+/*
  *	i91uSCBPost		-	SCSI callback
- *	@host: Pointer to host adapter control block.
- *	@cmnd: Pointer to SCSI control block.
  *
  *	This is callback routine be called when tulip finish one
  *	SCSI command.
-- 
2.27.0

