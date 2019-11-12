Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBD5FC43331
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 17:37:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 933CF214E0
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 17:37:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfKLRhw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 12:37:52 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45956 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbfKLRhw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 12:37:52 -0500
Received: by mail-pl1-f196.google.com with SMTP id w7so720405plz.12
        for <linux-scsi@vger.kernel.org>; Tue, 12 Nov 2019 09:37:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0erNgzRVlSJA+jnLq/QuizqiD0WjsCgHdeR3E3h3X88=;
        b=WK6QTbCpmua5PQyT34D+4fKS9w765RDY0f5iyR4cMRopwrITl8Jkx3DNhlLmqAnblI
         VmXsV8Uwai9w5cWsYHR3cqW8HnszJgT8PBJjHKsMqy3J/h68yN5pyzOwmebC0VVMryiN
         AtIfLqcyJ26dVt6Sb5hnhpm4TwEg21vEiBIegaoHz+kThSXnHkaZ7kR8iGmfh93VtBpe
         RGdZkHPSZBCddMpmqm+ctG9/8n8aL/WHg4wfey5I3GZY8bN1QUEeY8z480tmCloRE4id
         fhI/Zk1ZN0LkHDK7402bH2amorb/7JqP3yNb7154W/4Jk+T15bkWVRpEoF3+vpEdShKd
         dQdg==
X-Gm-Message-State: APjAAAVA/z6Ejk4Ryc9ib3K3pH5RjkgUcmIOYLQle9MCAtnL0tkhOXqw
        lPYSHFX1SwypUv6viVQbVRI8HkoG
X-Google-Smtp-Source: APXvYqzr7uG41SjjFVPaqGkkPFu1JDIoBJNF2t09lkeamMvPaD8N8GbNvp5liLlzdyoX8JxCfThY2A==
X-Received: by 2002:a17:902:8308:: with SMTP id bd8mr32943727plb.86.1573580271304;
        Tue, 12 Nov 2019 09:37:51 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id w19sm12930969pga.83.2019.11.12.09.37.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 09:37:50 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     Bean Huo <beanhuo@micron.com>, Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v5 0/4] Simplify and optimize the UFS driver
Date:   Tue, 12 Nov 2019 09:37:39 -0800
Message-Id: <20191112173743.141503-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Martin,

This patch series that simplifies and optimizes the UFS driver. Please consider
this patch series for kernel v5.5.

Thanks,

Bart.

Changes compared to v4:
- Reverted back to scsi_block_requests() / scsi_unblock_requests() for the
  UFS error handler.
- Added a new patch that serializes error handling and command submission.
- Fixed a blk_mq_init_queue() return value check.

Changes compared to v3:
- Left out "scsi" from the name of the functions that suspend and resume
  command processing.

Changes compared to v2:
- Use a separate tag set for TMF tags.

Changes compared to v1:
- Use the block layer tag infrastructure for managing TMF tags.

Bart Van Assche (4):
  ufs: Serialize error handling and command submission
  ufs: Avoid busy-waiting by eliminating tag conflicts
  ufs: Use blk_{get,put}_request() to allocate and free TMFs
  ufs: Simplify the clock scaling mechanism implementation

 drivers/scsi/ufs/ufshcd.c | 396 +++++++++++++++++---------------------
 drivers/scsi/ufs/ufshcd.h |  21 +-
 2 files changed, 186 insertions(+), 231 deletions(-)

