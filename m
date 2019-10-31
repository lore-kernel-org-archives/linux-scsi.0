Return-Path: <SRS0=1SmL=YY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B37F5CA9ECB
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 22:55:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8143C20862
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 22:55:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbfJaWzf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Oct 2019 18:55:35 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34302 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728207AbfJaWzf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Oct 2019 18:55:35 -0400
Received: by mail-pg1-f195.google.com with SMTP id e4so5115482pgs.1
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2019 15:55:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FVJPmx8UPR81L4aj+Pm8bXMN7xjG3Qf4UYlHj72sNng=;
        b=o4cE/G/oWlC3oCtTE249PQchYKXqDwKda65brmkozVNF1FemnIwuz9pZc4u/8xWW54
         qc8wegEysvsWk039aM1TKX6gxcnhGHg6ASGAkh0xJ0wWAgcnN4oMF4qOSQqkLpKQrFeU
         kj7NNvoHvDz79tg8PuvrKJFHMu0eS+90anK7MAGg8Ek/VX5DHFOvoH8AmdMbZ1NdHTx8
         5UtMjEmV15EBtPRe8k6PFyH1ZxqSLNcXu9QCeXmPYaAbf4UpFRlpLi4fApcpADJJc+xM
         iJTs/ICIwqPm7sy5UzFor+dS3FMX4O/GgdsHIVm0/AE3q9DhY0IvZZApnduEak847z3B
         VkaA==
X-Gm-Message-State: APjAAAWG+EKIj2vN7Yb8mcS5nBSJ05woe3HIBSkd/HeFI8GIaZHseouS
        vFwK3CE/P0OYNBMPfijLWBm2b1AB
X-Google-Smtp-Source: APXvYqw3kYQCAoQz78uZTSsf20MDpmSW2tFvoufVyPJFNka0u/4cpyk1urUehjUf6Cvt2dQbYYLMZA==
X-Received: by 2002:a17:90a:a598:: with SMTP id b24mr11008290pjq.46.1572562534133;
        Thu, 31 Oct 2019 15:55:34 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id d139sm8391711pfd.162.2019.10.31.15.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 15:55:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/4] Simplify and optimize the UFS driver
Date:   Thu, 31 Oct 2019 15:55:24 -0700
Message-Id: <20191031225528.233895-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

While reading the UFS source code I noticed that some existing mechanisms
are duplicated in this driver. These patches simplify and optimize the UFS
driver. These patches are entirely untested.

Bart.

Bart Van Assche (4):
  ufs: Avoid busy-waiting by eliminating tag conflicts
  ufs: Simplify the clock scaling mechanism implementation
  ufs: Remove the SCSI timeout handler
  ufs: Remove superfluous memory barriers

 drivers/scsi/ufs/ufshcd.c | 288 +++++++++++---------------------------
 drivers/scsi/ufs/ufshcd.h |  12 +-
 2 files changed, 90 insertions(+), 210 deletions(-)
