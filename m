Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67DAFC33CAA
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 03:56:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A55321835
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 03:56:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbgAWD4o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jan 2020 22:56:44 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40957 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgAWD4o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jan 2020 22:56:44 -0500
Received: by mail-pl1-f196.google.com with SMTP id s21so753094plr.7
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jan 2020 19:56:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a/lSWCtV47AoNKh2E33R6f8L51ZAoVpgQCs8xsYvlqs=;
        b=CmF5qyKCcqAmZ/wJjbpnaZpkWYqsgMuFY0hm1jJtJLPwdQscDFMifWKiQ5baEKUhLV
         C4FntglRnZgGOxuokVuN3Q1pSGP8EOqTWFMciYGf2hEvSxfLnExw79U9hGzUSrtNY9Rf
         vxGb96D9cZxDG9Yd91otL+LtwSV7I04PJhrpFqzNGKzwGkWo2MQ6rbFlbz9H3WQs+bPd
         4h9O4D5rvip/O7+CoWjHWoMsyNx4khK15J8ngMTiri2/p0DSXJjPc8ERlz9FlPXJ5d5c
         QAYeQPZqr3/8ZJeG0XSmqAv+i9l4YrQwD9v0uKVYfM9l9/XwmBTxMPrmMQBZKHoM47mC
         7+HA==
X-Gm-Message-State: APjAAAU5aZKyzytTH8m224GnZpge4TzULndvF2gxPq/zmB2o7EiCekAg
        /tflhelebjAFhuj/zLNP0ItxYkKE
X-Google-Smtp-Source: APXvYqzeiYO6VrnJhN32ySmWLWNIj/q3s/qp8dB7addx72tPRjjkLJcFd3tzwqwGf2LuygL0qOUKGw==
X-Received: by 2002:a17:902:6b8a:: with SMTP id p10mr14353807plk.47.1579751804044;
        Wed, 22 Jan 2020 19:56:44 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:d957:4568:237a:bc62])
        by smtp.gmail.com with ESMTPSA id x197sm435287pfc.1.2020.01.22.19.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 19:56:43 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/4] ufs: Let the SCSI core allocate per-command UFS data
Date:   Wed, 22 Jan 2020 19:56:33 -0800
Message-Id: <20200123035637.21848-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series lets the SCSI core allocate per-command UFS data and hence
simplifies and micro-optimizes the UFS driver. Please consider this patch
series for the v5.6 kernel.

Thanks,

Bart.

Changes compared to v1:
- Restored an accidentally removed ufshcd_release() call in an error path in
  ufshcd_queuecommand().
- Check whether ufshcd_tag_to_lrb() returns a non-NULL pointer in
  ufshcd_eh_device_reset_handler().

Bart Van Assche (4):
  Introduce {init,exit}_cmd_priv()
  ufs: Introduce ufshcd_init_lrb()
  ufs: Simplify two tests
  ufs: Let the SCSI core allocate per-command UFS data

 drivers/scsi/scsi_lib.c   |  29 ++++-
 drivers/scsi/ufs/ufshcd.c | 238 ++++++++++++++++++++++++--------------
 drivers/scsi/ufs/ufshcd.h |   5 -
 include/scsi/scsi_host.h  |   3 +
 4 files changed, 177 insertions(+), 98 deletions(-)

