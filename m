Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A6D4C07E9C
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 614BC61CD1
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbhGGSqk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 14:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232606AbhGGSqg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 14:46:36 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F081CC061574
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jul 2021 11:43:55 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id f17so3041401pfj.8
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jul 2021 11:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=16fTH8Lr76lfrx4h8UEFhnvpJS9wU8DQjTREB35Y1ps=;
        b=qNS6EXEtTLXeDSClNgnfc4r0U450iBkMCPk3Hp7HueAACuZ1vsmCUxMyslsI1PMBtJ
         sX6dwTUYpvAW79cqU9QP1AGswDETssKWaJbAuI2X2gt2CuErWZcOb8EkGxqiI2bLcS6v
         tb/LZZgrmC6XhqFhwoom4ww9EA5/YiV6A4sJlwlsRW+c9Xo1FygsUYOzQH206DmC+Qo/
         DoQFhRlp9OPASpbULThg+rab6bh7QSbnbUDB2gQUYuTnktAJT15DCAntolD5CDDPyKIx
         mN1kF+//ILGN8Y0289V96vNc6q79obHyC4e1rwjrmKqpSzjI5rh6jYAf3docLLqqiLVj
         BZHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=16fTH8Lr76lfrx4h8UEFhnvpJS9wU8DQjTREB35Y1ps=;
        b=jMr28f9oAIQjUW1zkKTO7Gd8P5IMHgNupjXX3XAFo3M0aF9ZXccXF9RLsF737g71+W
         qM7I7Zggv8c+yoJ48obEhT353qJh0IlD9byh3HarAz/wlKkfI9Xw+ydgnZg+mGkM6cK9
         GFgwGM3qWvAHwi1U7Dge9bEqpVj7R5UYGkU6TptiwP+HYy/GkJAzNZjIr06ZNvEsfyID
         4UeMQ79AMcmqUfPqScwnroFZ0gwlHM4TSfGW1oWJVRyQRyJaStYwyZDuniaeQzSO3oLD
         dfniYOfSnD34U7GkiacurWDqcM6IKDAaPebG9IGSgYl5udwhO+bobGlxr11a6eBaDek3
         Ua2Q==
X-Gm-Message-State: AOAM531nnYRNAisS/MNSqMR+qXZpvjp2rTc9aK25kB3WErtMg63fMqV7
        P3Ei1M/UYLkjVly+ZzLNk+anXCZ3pv0=
X-Google-Smtp-Source: ABdhPJwJq0HccFxbXdihXWUR4IaM1Y7zdKyf1ugnbctQvTLAJGDcsRqVL07QYhKwLEcrjgJ7Min/BQ==
X-Received: by 2002:a63:5d5c:: with SMTP id o28mr27648394pgm.22.1625683435467;
        Wed, 07 Jul 2021 11:43:55 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id z3sm23578631pgl.77.2021.07.07.11.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 11:43:55 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 00/20] lpfc: Update lpfc to revision 12.8.0.11
Date:   Wed,  7 Jul 2021 11:43:31 -0700
Message-Id: <20210707184351.67872-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 12.8.0.11

This patch set contains fixes and improvements for the lpfc driver

The patches were cut against Martin's 5.14/scsi-queue tree

James Smart (20):
  lpfc: Fix NVME support reporting in log message
  lpfc: Remove use of kmalloc in trace event logging
  lpfc: Improve firmware download logging
  lpfc: Fix function description comments for vmid routines
  lpfc: Discovery state machine fixes for LOGO handling
  lpfc: Fix target reset handler from falsely returning FAILURE
  lpfc: Keep ndlp reference until after freeing the iocb after els
    handling
  lpfc: Fix null ptr dereference with NPIV ports for RDF handling
  lpfc: Fix memory leaks in error paths while issuing ELS RDF/SCR
    request
  lpfc: Remove REG_LOGIN check requirement to issue an ELS RDF
  lpfc: Fix KASAN slab-out-of-bounds in lpfc_unreg_rpi routine
  lpfc: Clear outstanding active mailbox during PCI function reset
  lpfc: Use PBDE feature enabled bit to determine PBDE support
  lpfc: Enable adisc discovery after RSCN by default
  lpfc: Delay unregistering from transport until GIDFT or ADISC
    completes
  lpfc: Call discovery state machine when handling PLOGI/ADISC
    completions
  lpfc: Skip reg_vpi when link is down for SLI3 in ADISC cmpl path
  lpfc: Skip issuing ADISC when node is in NPR state
  lpfc: Update lpfc version to 12.8.0.11
  lpfc: Copyright updates for 12.8.0.11 patches

 drivers/scsi/lpfc/lpfc.h           |   1 -
 drivers/scsi/lpfc/lpfc_attr.c      |   4 +-
 drivers/scsi/lpfc/lpfc_crtn.h      |   2 +
 drivers/scsi/lpfc/lpfc_ct.c        |   5 +-
 drivers/scsi/lpfc/lpfc_disc.h      |   9 +-
 drivers/scsi/lpfc/lpfc_els.c       | 120 ++++++++++--------
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 197 ++++++++++++++++++++++-------
 drivers/scsi/lpfc/lpfc_hw4.h       |  20 ++-
 drivers/scsi/lpfc/lpfc_init.c      |  51 +++++---
 drivers/scsi/lpfc/lpfc_nportdisc.c |  43 ++++---
 drivers/scsi/lpfc/lpfc_nvme.c      |  10 +-
 drivers/scsi/lpfc/lpfc_nvme.h      |   6 +-
 drivers/scsi/lpfc/lpfc_scsi.c      |  68 +++++-----
 drivers/scsi/lpfc/lpfc_sli.c       | 192 +++++++++++++++++++++-------
 drivers/scsi/lpfc/lpfc_sli4.h      |   4 +-
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 16 files changed, 497 insertions(+), 237 deletions(-)

-- 
2.26.2

