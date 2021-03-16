Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0D92C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:57:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5303650D5
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbhCPD5T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 23:57:19 -0400
Received: from mail-pg1-f180.google.com ([209.85.215.180]:47024 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbhCPD5B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2021 23:57:01 -0400
Received: by mail-pg1-f180.google.com with SMTP id 16so15317062pgo.13
        for <linux-scsi@vger.kernel.org>; Mon, 15 Mar 2021 20:57:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3LFspRPureJLTZJOtYwbIwpbp986KimI385CmxQKpx4=;
        b=ntQDd3kIxRfgAja1cMsWLV9EZfIsZQTvBWwUJmUzaSLs6AkCsT/cBYdcLevmCdny2r
         FglTuwSwaHrHP30Jr4So9UlvgjUc94do7FAc8hlfULjHkoeuHoeHFEUaTZ1ZBy64uW2d
         IfH8+xA+XlG/dvm4rnDKZxotIwsVzPdUaT+i2QYhzE7yzGQ4XgFSh3bb9g0oNIOTEy+5
         u9o3GbeocGvfN9zaQPFFo8byFrne/bMyIHTCXRcYhaPqBV973Mbq4oRHMjCCRNDwyFVv
         0mjpAsaspYRXhYLqNwu2TRzP7fBQhsBgX0Gi+dyLRGVXtqxz0gdnlVAgWggk5575z9g7
         oLiA==
X-Gm-Message-State: AOAM533wpcnqmqkZl6m5QvmdrLQ9MRNqPUSluTjYWFLxBwfMtseRqEzH
        kMLRetcUplF+Z4vFoZGn3vlsfJW9L2Q=
X-Google-Smtp-Source: ABdhPJzJptptmyxymz9DSl9ogUxfAdKr4sbA3UHmL89tcszqLFmTbb9uufuJfOvQGuQb2Lvdms5pLA==
X-Received: by 2002:aa7:99c6:0:b029:1f5:c49d:dce7 with SMTP id v6-20020aa799c60000b02901f5c49ddce7mr12948812pfi.78.1615867021413;
        Mon, 15 Mar 2021 20:57:01 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:8641:766a:ce30:8278])
        by smtp.gmail.com with ESMTPSA id fs9sm1031673pjb.40.2021.03.15.20.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 20:57:00 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/7] qla2xxx patches for kernel v5.12 and v5.13
Date:   Mon, 15 Mar 2021 20:56:48 -0700
Message-Id: <20210316035655.2835-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Please consider the first patch in this series for kernel v5.12 and the
remaining patches for kernel v5.13.

Thanks,

Bart.

Bart Van Assche (7):
  Revert "qla2xxx: Make sure that aborted commands are freed"
  qla2xxx: Constify struct qla_tgt_func_tmpl
  qla2xxx: Fix endianness annotations
  qla2xxx: qla82xx_pinit_from_rom(): Initialize 'n' before using it
  qla2xxx: Suppress Coverity complaints about dseg_r*
  qla2xxx: Simplify qla8044_minidump_process_control()
  qla2xxx: Always check the return value of qla24xx_get_isp_stats()

 drivers/scsi/qla2xxx/qla_attr.c    |  5 ++++-
 drivers/scsi/qla2xxx/qla_def.h     |  4 ++--
 drivers/scsi/qla2xxx/qla_iocb.c    |  3 ++-
 drivers/scsi/qla2xxx/qla_isr.c     |  2 +-
 drivers/scsi/qla2xxx/qla_mr.c      | 12 ++++++------
 drivers/scsi/qla2xxx/qla_mr.h      |  4 ++--
 drivers/scsi/qla2xxx/qla_nx.c      |  2 +-
 drivers/scsi/qla2xxx/qla_nx2.c     |  8 --------
 drivers/scsi/qla2xxx/qla_sup.c     |  9 +++++----
 drivers/scsi/qla2xxx/qla_target.c  | 13 +++++--------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  6 +-----
 11 files changed, 29 insertions(+), 39 deletions(-)

