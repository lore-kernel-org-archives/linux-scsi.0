Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96070C43603
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 18:13:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72741206D3
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 18:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfLISNR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 13:13:17 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41962 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfLISNQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 13:13:16 -0500
Received: by mail-pf1-f194.google.com with SMTP id s18so7625374pfd.8
        for <linux-scsi@vger.kernel.org>; Mon, 09 Dec 2019 10:13:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OeosUjpu+46AA7kmmJfJbavNGuf92h1I04hK8lJGIgg=;
        b=QwfnsoIkqOR/BmYEF8rikolQI1WeqRDb1BEvejOZzbWr8vGnjZDp2ec5HH2ghVrbhq
         csn47oYEysjkAts55uVRjLJEECSX51/bzklhUo8Ksr/4nkdY5CxYm8x2zSL9haING0qo
         MOkBD5KL3/1ywMWRctddxoAVO8FJldgm0qWIuTSOG7Owu6lIoFCIU5oEpulBHdGQs2ek
         EvpgwSdnusuQTkv78WnHWn5GcIJ0s6TyciYYr2aeI/jNUnSVtoeXtNL1xUGc5WIkJveT
         JZUAxN13EY/+8d5f0z7Tbm0D5lYNnDluSYLI9sPQPsQGRUtfj6UfECeS62eITtEyc7yw
         /1eQ==
X-Gm-Message-State: APjAAAUJQMlFkyyYlRMDuBY6O53bnh9G29tRSU+Q0tke6gdF3K/c9GBm
        JIl/sV/HxXo/ciVP9hWXk9NC9S9A
X-Google-Smtp-Source: APXvYqxyDqlbcn+LSt762sa0VGQVlpoDY81DpUaiR2R6KlzF4y0R57sGr8URuHPAAszhfFLUk/7Yww==
X-Received: by 2002:a63:d351:: with SMTP id u17mr19590417pgi.84.1575915196068;
        Mon, 09 Dec 2019 10:13:16 -0800 (PST)
Received: from bvanassche-glaptop.roam.corp.google.com ([216.9.110.10])
        by smtp.gmail.com with ESMTPSA id q21sm139129pff.105.2019.12.09.10.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 10:13:15 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v7 0/2] ufs: Rework tag allocation
Date:   Mon,  9 Dec 2019 10:13:07 -0800
Message-Id: <20191209181309.196233-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series simplifies and optimizes the UFS driver. Please consider
this patch series for kernel v5.6.

Thanks,

Bart.

Changes compared to v6:
- Reduced this patch series to include only those patches that received
  positive reviews.

Changes compared to v5:
- Reworked patch 4/4 such that it only modifies the clock scaling code and
  no other code. Added more comments in the code and improved the patch
  description.
- Rebased this patch series on top of the 5.5/scsi-queue branch.

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
Bart Van Assche (2):
  ufs: Avoid busy-waiting by eliminating tag conflicts
  ufs: Use blk_{get,put}_request() to allocate and free TMFs

 drivers/scsi/ufs/ufshcd.c | 249 +++++++++++++++++++-------------------
 drivers/scsi/ufs/ufshcd.h |  18 +--
 2 files changed, 129 insertions(+), 138 deletions(-)

