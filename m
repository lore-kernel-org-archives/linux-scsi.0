Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 064E9C3F2D4
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 03:30:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6B2E22B48
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 03:30:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgCBDad (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 1 Mar 2020 22:30:33 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:52575 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbgCBDad (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Mar 2020 22:30:33 -0500
Received: by mail-pj1-f67.google.com with SMTP id lt1so1073458pjb.2
        for <linux-scsi@vger.kernel.org>; Sun, 01 Mar 2020 19:30:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VWLLk9LosDUtQeTvjgcPa73FcJbFB5Q5phIYe8NO9qQ=;
        b=sasb6DKHcaOTowyQ3x17E/7tpHAxvzjw5/jemlbN98VGncJZRBSXCja4O+tkL/U8qg
         YXtXdQo3SVI7RkZOpUd4xJCWOBXQUbuTwlCATL39AqzQK71MxC9SXb3A6NP0l+Rjqf3I
         CBuAlGR4WznFYMGpABqNI6Pz6OhjAly1yjI9an1wOpaWC/gDm94Ffp0r81rOXF/KcFXs
         iE8wrKYwC/wU/gpH/OVH95mxx4unO1HixcTYmjsO1Wk3XopbAEZFe8uEmogP8WGDE35P
         TvnVLegG6QhiMaDCB8B/F/ASnbSJ7igm52EYthEfq3vO6HgXyOWCmCnZVilqa4zjwTxq
         Ac4g==
X-Gm-Message-State: APjAAAXAcPXpleZRX6cPamTJQ+JdKvj4AIlZuocyDbxR1Nd8Ppzlpowp
        FHeANhDAbqzWcBU+Ia3lipY=
X-Google-Smtp-Source: APXvYqyjt96UzEZvijVqzOePkRYSw9CyK8QnsvgNTzyC+dgn6esJSr5dKudPi9p4QiU3BwuDrTTmDQ==
X-Received: by 2002:a17:90a:17e5:: with SMTP id q92mr19563425pja.28.1583119830467;
        Sun, 01 Mar 2020 19:30:30 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7869:cc6e:b1f7:9f7d])
        by smtp.gmail.com with ESMTPSA id z3sm18782254pfz.155.2020.03.01.19.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2020 19:30:29 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/4] Fix qla2xxx endianness annotations
Date:   Sun,  1 Mar 2020 19:30:19 -0800
Message-Id: <20200302033023.27718-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series fixes the endianness annotations in the qla2xxx driver.
Please consider this patch series for the v5.7 kernel.

Thanks,

Bart.

Bart Van Assche (4):
  qla2xxx: Use raw_smp_processor_id() where appropriate
  qla2xxx: Fix endianness annotations in header files
  qla2xxx: Fix endianness annotations in source files
  qla2xxx: Fix the code that reads from mailbox registers

 drivers/scsi/qla2xxx/qla_attr.c    |   3 +-
 drivers/scsi/qla2xxx/qla_bsg.c     |   4 +-
 drivers/scsi/qla2xxx/qla_dbg.c     |  90 ++--
 drivers/scsi/qla2xxx/qla_dbg.h     | 442 ++++++++---------
 drivers/scsi/qla2xxx/qla_def.h     | 699 ++++++++++++++-------------
 drivers/scsi/qla2xxx/qla_fw.h      | 738 ++++++++++++++---------------
 drivers/scsi/qla2xxx/qla_init.c    |  88 ++--
 drivers/scsi/qla2xxx/qla_inline.h  |   2 +-
 drivers/scsi/qla2xxx/qla_iocb.c    |  59 +--
 drivers/scsi/qla2xxx/qla_isr.c     |  93 ++--
 drivers/scsi/qla2xxx/qla_mbx.c     |  37 +-
 drivers/scsi/qla2xxx/qla_mr.c      |  35 +-
 drivers/scsi/qla2xxx/qla_mr.h      |   8 +-
 drivers/scsi/qla2xxx/qla_nvme.c    |   8 +-
 drivers/scsi/qla2xxx/qla_nvme.h    |  46 +-
 drivers/scsi/qla2xxx/qla_nx.c      |  93 ++--
 drivers/scsi/qla2xxx/qla_nx.h      |  36 +-
 drivers/scsi/qla2xxx/qla_os.c      |  26 +-
 drivers/scsi/qla2xxx/qla_sup.c     |  73 +--
 drivers/scsi/qla2xxx/qla_target.c  |  76 +--
 drivers/scsi/qla2xxx/qla_target.h  | 208 ++++----
 drivers/scsi/qla2xxx/qla_tmpl.c    |   4 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |   4 +-
 23 files changed, 1455 insertions(+), 1417 deletions(-)

