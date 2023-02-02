Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90BDAC636D3
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Feb 2023 22:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbjBBWEZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Feb 2023 17:04:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjBBWEY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Feb 2023 17:04:24 -0500
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C14D8D
        for <linux-scsi@vger.kernel.org>; Thu,  2 Feb 2023 14:04:21 -0800 (PST)
Received: by mail-pg1-f174.google.com with SMTP id q9so2369863pgq.5
        for <linux-scsi@vger.kernel.org>; Thu, 02 Feb 2023 14:04:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2PQk7CMIHzjELd8/vq4PD1YIQGO6nV37KIwfR+KP46I=;
        b=EtJhEJ+ryxCUjTVpdF3L4aE6K+V+RC8IQwvQXZMuV1Nxe8etzySp9Eo9Gtu8HvLoYy
         tOOkWgGDLMs4myfHWTGWiP1cHKhog97GS5yAjmTfm2pMpdtKgVKRfGwx7Yb+8ykflShI
         aTUBk/IEqccX0vE1t7D4SAgYzXeWWt9RWjac8Suq0ef5ByxVjelhoxB9pLuQVH/zD0V9
         UhlNklO15iSuGSXs8UNCkjMUz1DtRyi5wG+MctvSOQVBxriJbWYXnUHd/65tt36kppox
         Re4InuFlOfIHJMfpl2MVe5+msfwTYRjDxeQxl2t3SuNXtI1uuFU6FfgboL8mPHQ7Uixi
         4o4w==
X-Gm-Message-State: AO0yUKWpG0e8+6YHRsCBE1riwqOF07WXKQ9Fw/BTo+mBA0A+roisMpnf
        EQD5/6o+VUirLoUFbOm9RYM=
X-Google-Smtp-Source: AK7set8nzEf5yQXFPO6dzSWZQl0x4x7GF9GtnfHVRnYHrEMNjqj7AQYK1/rbGjAHsVqssGHJfDLz1w==
X-Received: by 2002:a05:6a00:124a:b0:590:32a9:b276 with SMTP id u10-20020a056a00124a00b0059032a9b276mr8793046pfi.22.1675375460473;
        Thu, 02 Feb 2023 14:04:20 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf7f:37aa:6a01:bf09])
        by smtp.gmail.com with ESMTPSA id x28-20020aa78f1c000000b0057fec210d33sm160530pfr.152.2023.02.02.14.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 14:04:19 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/2] Simplify ufshcd_execute_start_stop()
Date:   Thu,  2 Feb 2023 14:04:10 -0800
Message-Id: <20230202220412.561487-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series simplifies ufshcd_execute_start_stop() by using the new
scsi_execute_cmd() function instead of open-coding it. Please consider this
patch for the next merge window.

Thanks,

Bart.

Bart Van Assche (2):
  scsi: core: Extend struct scsi_exec_args
  scsi: ufs: Simplify ufshcd_execute_start_stop()

 drivers/scsi/scsi_lib.c    |  3 ++-
 drivers/ufs/core/ufshcd.c  | 36 +++++++++---------------------------
 include/scsi/scsi_device.h |  2 ++
 3 files changed, 13 insertions(+), 28 deletions(-)

