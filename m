Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3426FC77B7F
	for <linux-scsi@archiver.kernel.org>; Wed,  3 May 2023 23:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjECXHD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 May 2023 19:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjECXHB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 May 2023 19:07:01 -0400
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099CF5FD3
        for <linux-scsi@vger.kernel.org>; Wed,  3 May 2023 16:07:01 -0700 (PDT)
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-64115e652eeso8613229b3a.0
        for <linux-scsi@vger.kernel.org>; Wed, 03 May 2023 16:07:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683155220; x=1685747220;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VMfiM7dupaW5I9oVMpJh7DtIUJd7HSVONDAUdPpRN68=;
        b=ehVmSK3KuSiCzhc8N5gdBXHFWZsXD0imRh3o1cAV4tocBiKpj8n3zLqRV4PQ73iVdU
         6Ze0Ixh6p/Se980h6QCnjlCDjcjcGlICfNR6WquOHgr9tIu6fWczbFJKY2H2MruuCoek
         gUd6IW9O2hXc/EgaeMalnUgfOmpwyOU8lUuiEXc51Ka+8gNLFiKaX0uEiWqnvRs9nzmt
         gzbzCpJ7JlH5mlL/TU8ZwZZg0RzxvvrrtpJHtXm7uPxKsn5l0o3GSJFLrR4aQ+l432BF
         GXE4k//j69vHDvBXqSRRcNBEMfuojvRJ2J7ia/vNInJ99tgxlYIbQGlPqnh/TLGt3tvZ
         lg9w==
X-Gm-Message-State: AC+VfDyx/Y6sHzeSi4cBR9/NXnuWOQ28LIcIyHOu5KXflWYOhr6y/Bu3
        KdcbQJUPZqZIllNVWfaWuA+cDqkArgU=
X-Google-Smtp-Source: ACHHUZ5FQJaf5B7YT9obGDIQc4vWB6nxFDt3gXZPnCpbU+D4HmODTeneuehLci49KqGtHSDmaMrSUQ==
X-Received: by 2002:a05:6a20:7da0:b0:f3:3ea5:5185 with SMTP id v32-20020a056a207da000b000f33ea55185mr71136pzj.10.1683155220385;
        Wed, 03 May 2023 16:07:00 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:2c3b:81e:ce21:2437])
        by smtp.gmail.com with ESMTPSA id u3-20020a056a00158300b0063f3aac78b9sm19531603pfk.79.2023.05.03.16.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 16:06:59 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/5] SCSI core patches
Date:   Wed,  3 May 2023 16:06:49 -0700
Message-ID: <20230503230654.2441121-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Please consider these SCSI core patches for the next merge window.

Thanks,

Bart.

Changes compared to v1:
- Improved the SCSI tracing patch as requested by Steven Rostedt and
  Niklas Cassel.
- Added patch "scsi: core: Delay running the queue if the host is blocked"

Bart Van Assche (5):
  scsi: core: Use min() instead of open-coding it
  scsi: core: Update a source code comment
  scsi: core: Trace SCSI sense data
  scsi: core: Only kick the requeue list if necessary
  scsi: core: Delay running the queue if the host is blocked

 drivers/scsi/scsi_common.c  |  3 +--
 drivers/scsi/scsi_lib.c     | 20 ++++++++++++++------
 include/scsi/scsi_host.h    |  2 +-
 include/trace/events/scsi.h | 21 +++++++++++++++++++--
 4 files changed, 35 insertions(+), 11 deletions(-)

