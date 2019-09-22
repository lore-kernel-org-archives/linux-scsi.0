Return-Path: <SRS0=kJCz=XR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC140C3A5A6
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B746420820
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MgmMMUH3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbfIVD7Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Sep 2019 23:59:16 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:45253 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727423AbfIVD7Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Sep 2019 23:59:16 -0400
Received: by mail-ot1-f67.google.com with SMTP id 41so9363827oti.12
        for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2019 20:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+jhqFRhql6OtZ0HTXKifTSD7HlyzJYnaAYGNKwZ+Heo=;
        b=MgmMMUH3bxNutbA2GV25EOtiXc1XK45X3tlBNP8ggb384xLKIe/P2e5m4lTbj/KNvH
         WFP9ucqHOA9fGKKU5KRQGnxeH6QfuyjSwQ4HtGvazC3UV0rNf9/IyWq/FxylIT3Ee+Xy
         o6hqq08gCPBDtSYIFl9UtKcksvMR+6VHmiImiVCbKZatk9PZ0n1JW9/go3wbggTZ4Ull
         9Sn1wfJA9rYqLKIZcSyzFigORH2f2iGsiyoXSE0KdfDAFOWwsNXNM2tSFpBZSGmw+EJ4
         cS47+pqc3zhH7gosqV9RlwirnYcY5ltNDtAiF7SijlUKB0nP/BnyGn99akglnVqLDX49
         VD9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+jhqFRhql6OtZ0HTXKifTSD7HlyzJYnaAYGNKwZ+Heo=;
        b=VhSQwfjbwJAiUDQTL7XWIzLlJc9h6/URm0/F9pxTLMnxgOQQFNKY+xxBHsfZ0nS/yq
         0gweot4QQdR6CnCuBApwNgVbTQg6wvB1en7XbA6dOJ/0ifwKqJFaSpkm8ye5RqR79HlI
         f+E/bBVVG5LDho7Qx9wRfS4Wz55O0j7qa19ARnvjiIfDIolREwdDSOP57UXZ/YrPJJvB
         DpRq+WYluDWBAMtNfPVaLN/B+bU6HD0f1S9OI/e/1Az1nmhE6Oui/zOn9guJXD02IikW
         lXv9IyWmaNaZMhjev8q99C2Bs4sCM3GOJ9lrvX1O5VeCGLEr7vEV39NuneSvJEsxEQT6
         6F3g==
X-Gm-Message-State: APjAAAVxVD2rMLrGHN+JlicMRsbNHcNWTtbFqtR8gFDwQ2DQhGgZ7jfP
        y3McU+6MoF5gD8rSaTDxSVXY2njE
X-Google-Smtp-Source: APXvYqyglsSZkYeBdI9zo8/FkLivvktlP1mNGa0F4ASUkKO3VyoasKK3eyJExxknePNnm62w6vCuhQ==
X-Received: by 2002:a05:6830:1414:: with SMTP id v20mr15161781otp.40.1569124754773;
        Sat, 21 Sep 2019 20:59:14 -0700 (PDT)
Received: from os42.localdomain (ip68-5-145-143.oc.oc.cox.net. [68.5.145.143])
        by smtp.gmail.com with ESMTPSA id a9sm2395889otc.75.2019.09.21.20.59.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 21 Sep 2019 20:59:14 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 00/20] lpfc: Update lpfc to revision 12.4.0.1
Date:   Sat, 21 Sep 2019 20:58:46 -0700
Message-Id: <20190922035906.10977-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 12.4.0.1

This patch set contains fixes as well as a few cleanups.

The patches were cut against Martin's 5.4/scsi-queue tree


James Smart (20):
  lpfc: Fix pt2pt discovery on SLI3 HBAs
  lpfc: Fix premature re-enabling of interrupts in lpfc_sli_host_down
  lpfc: Fix miss of register read failure check
  lpfc: Fix NVME io abort failures causing hangs
  lpfc: Fix rpi release when deleting vport
  lpfc: Fix device recovery errors after PLOGI failures
  lpfc: Fix locking on mailbox command completion
  lpfc: Fix GPF on scsi command completion
  lpfc: Fix discovery failures when target device connectivity bounces
  lpfc: Fix NVMe ABTS in response to receiving an ABTS
  lpfc: Fix coverity errors on NULL pointer checks
  lpfc: Fix host hang at boot or slow boot
  lpfc: Fix list corruption in lpfc_sli_get_iocbq
  lpfc: Fix spinlock_irq issues in lpfc_els_flush_cmd()
  lpfc: Fix hdwq sgl locks and irq handling
  lpfc: Fix list corruption detected in lpfc_put_sgl_per_hdwq
  lpfc: Update async event logging
  lpfc: Complete removal of FCoE T10diff support on SLI-4 adapters
  lpfc: cleanup: remove unused fcp_txcmlpq_cnt
  lpfc: Update lpfc version to 12.4.0.1

 drivers/scsi/lpfc/lpfc.h           |   1 -
 drivers/scsi/lpfc/lpfc_attr.c      |  32 +++++---
 drivers/scsi/lpfc/lpfc_crtn.h      |   1 +
 drivers/scsi/lpfc/lpfc_ct.c        |   6 ++
 drivers/scsi/lpfc/lpfc_els.c       |  24 ++++--
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 144 +++++++++++++++++++++++------------
 drivers/scsi/lpfc/lpfc_hw4.h       |   2 +
 drivers/scsi/lpfc/lpfc_init.c      |  66 ++++++++--------
 drivers/scsi/lpfc/lpfc_nportdisc.c | 141 ++++++++++++++++++++++++++++-------
 drivers/scsi/lpfc/lpfc_nvme.c      |  73 ++++++++++--------
 drivers/scsi/lpfc/lpfc_nvmet.c     |  53 +++++--------
 drivers/scsi/lpfc/lpfc_scsi.c      |  12 +--
 drivers/scsi/lpfc/lpfc_sli.c       | 149 ++++++++++++++++++++++++-------------
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 14 files changed, 459 insertions(+), 247 deletions(-)

-- 
2.13.7

