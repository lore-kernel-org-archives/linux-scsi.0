Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BA13C432C0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 22:09:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 359D2206CB
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 22:09:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbfKUWJH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Nov 2019 17:09:07 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38039 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbfKUWJH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Nov 2019 17:09:07 -0500
Received: by mail-pg1-f196.google.com with SMTP id t3so1890571pgl.5
        for <linux-scsi@vger.kernel.org>; Thu, 21 Nov 2019 14:09:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gpq6FM+fvcyP0popf1lOvHeNPRgc7LuVtAHS2ZdLKuA=;
        b=rJ5olcpU3JhFpMn9GeLpBsMredFI7HTuAfD2ipv4TvsMLsY2ocKj+7sqhDMUU9mlbl
         rRvGZlkpZZJ8LdheDJ3SVFCDYNmYcxxL6/FgGdxeJKiXGDXJAGVWGY+k/t3C3Bdcx3wM
         XWRl3A1rF55aJvGFNRN0n7KFlJZkg91Hlhg6nsZQSrr6oOA0n07HwfQ/sIhYGlzYOM3S
         zRoHJgcuNRLKfHSaXvrhEKL9ZEU+nSTAewSWIW8MAKFUgTuYysiRl8cL/Hg1am6IJ21Y
         7XeX1vlzoGsB/Udw3Do+1NkRF89ww15VB494heEpoWtbaSWiagQAK17UQzNbbvmmtsVM
         sOBg==
X-Gm-Message-State: APjAAAW0Iw6aWyZo3NXx34vu4bXEqUmeLJZ/z4X1pNoSmrDOjq5u/YKg
        kCRHn/jqUninoi4aEG9Hul0=
X-Google-Smtp-Source: APXvYqzk4ba/UtOp6mFdiTzzyUqdZwgWVvAesPCjp0OBUIzOpp64QCrglh6V+b5C49CvYL8zgWhXvw==
X-Received: by 2002:a62:7dd2:: with SMTP id y201mr13990665pfc.90.1574374146549;
        Thu, 21 Nov 2019 14:09:06 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id m15sm4617714pfh.19.2019.11.21.14.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 14:09:05 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     Bean Huo <beanhuo@micron.com>, Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v6 0/4] Simplify and optimize the UFS driver
Date:   Thu, 21 Nov 2019 14:08:46 -0800
Message-Id: <20191121220850.16195-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
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

Bart Van Assche (4):
  ufs: Serialize error handling and command submission
  ufs: Avoid busy-waiting by eliminating tag conflicts
  ufs: Use blk_{get,put}_request() to allocate and free TMFs
  ufs: Simplify the clock scaling mechanism implementation

Bart Van Assche (4):
  ufs: Serialize error handling and command submission
  ufs: Avoid busy-waiting by eliminating tag conflicts
  ufs: Use blk_{get,put}_request() to allocate and free TMFs
  ufs: Simplify the clock scaling mechanism implementation

 drivers/scsi/ufs/ufshcd.c | 386 +++++++++++++++++---------------------
 drivers/scsi/ufs/ufshcd.h |  19 +-
 2 files changed, 182 insertions(+), 223 deletions(-)

