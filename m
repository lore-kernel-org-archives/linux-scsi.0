Return-Path: <SRS0=hsTv=24=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D22C7C282DD
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jan 2020 19:25:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB65920656
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jan 2020 19:25:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbgAGTZk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jan 2020 14:25:40 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40655 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728307AbgAGTZk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jan 2020 14:25:40 -0500
Received: by mail-pl1-f196.google.com with SMTP id s21so101900plr.7
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jan 2020 11:25:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xpba0xHQYj8EP6e8532i04U/YEDM6cJ5KNID5LVb6/I=;
        b=E4JRSLOBicK3jdXwvSTv5wIoLs5MfpG/dfr6YzKpPeG8PTRrq62BOb0uUpHJ1wDT9e
         1wuiraTkYwCEv48FiTz3NlyBFRG9ItiFDjg9t7+LI3JnNWfkR/BPVfK6dtkSIIE5VGtV
         H6wfOgNYml2jQ7qyE/lktGCL80UpRI9F8eKFQfW/5o7pEgpx8E8713bGn04QzW/QwHV8
         DXltLP6lIwFmjFMh5iTPYQtLG1EYvRK32PHRfR0cpaevAl7MbW4JsF9OTtgQ7sBUXFda
         ytEBj5Tb27nwwIZSKVOZFrOse5+Gv8a88jHJqrRan49GCCyQk1QtmygUMEI4rIQAe7Sm
         B8mA==
X-Gm-Message-State: APjAAAXzjmY3yk+be8NIvby7I1ZPHsbnJjCzUVQOeoLWEyVkfnEoO+2x
        wYa/jyfDOyAye9scKcb1Xhg=
X-Google-Smtp-Source: APXvYqwd9GG1LPi7zyoKF8544k74cqnJSOSpi5F46YepVQHCQxdIctqrt62H2v1jvimvc9oX0TxO/A==
X-Received: by 2002:a17:902:b186:: with SMTP id s6mr1257025plr.333.1578425139645;
        Tue, 07 Jan 2020 11:25:39 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id c2sm329051pjq.27.2020.01.07.11.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 11:25:38 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/4] ufs: Let the SCSI core allocate per-command UFS data
Date:   Tue,  7 Jan 2020 11:25:27 -0800
Message-Id: <20200107192531.73802-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series lets the SCSI core allocate per-command UFS data and hence
simplifies the UFS driver. Please consider this patch series for the v5.6
kernel.

Thanks,

Bart.

Bart Van Assche (4):
  Introduce {init,exit}_cmd_priv()
  ufs: Introduce ufshcd_init_lrb()
  ufs: Simplify two tests
  ufs: Let the SCSI core allocate per-command UFS data

 drivers/scsi/scsi_lib.c   |  29 ++++-
 drivers/scsi/ufs/ufshcd.c | 247 ++++++++++++++++++++++++--------------
 drivers/scsi/ufs/ufshcd.h |   5 -
 include/scsi/scsi_host.h  |   3 +
 4 files changed, 183 insertions(+), 101 deletions(-)

