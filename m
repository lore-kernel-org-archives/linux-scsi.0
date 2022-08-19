Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89619C28B2B
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Aug 2022 01:18:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238029AbiHSBSR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Aug 2022 21:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbiHSBSQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Aug 2022 21:18:16 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFBCA9
        for <linux-scsi@vger.kernel.org>; Thu, 18 Aug 2022 18:18:10 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id h21so2429310qta.3
        for <linux-scsi@vger.kernel.org>; Thu, 18 Aug 2022 18:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=mw4F1fK1BNg+tEvA5pgPKkP93XPXn2A/5VDm8b0F9wo=;
        b=fOQbS5huozL2VxXCGcBHZCObbTqsrgcq62znZyI2Q2dmPk569gkEphcArtUBujM/DB
         p0Gwsn8lE0LG0GeT/UNlgo9XGQ5s3HEWgL/QxlZz+3bTeqdXO2gyXC6JFnCyoX1EF7XA
         hHyvqdwJWJyvL0mR5UgLejOhN5tsg7gm0Qj1Ha07IEYwtSvz9EA45rjJmY9fGO4hw9A/
         1Jnkzxk3m5CZtDc1GL6NCRiMToI57ZtNaUdwulc9hFmd8uAsqEql8HsbZE3plDTVzza5
         RAB4mbxaPDlYtx/CbAM2nMBTtWAr+pe2mPvrSzFkVvaCeGMsw1+Chr2Rs3s8WR1vudQ/
         t24g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=mw4F1fK1BNg+tEvA5pgPKkP93XPXn2A/5VDm8b0F9wo=;
        b=LOcJllrbB1JlAyFw9DpWyOasiJqRhHBRs7sr46ul00CYGeZsp2Kkyuf2V52CRqdsg1
         OXLSAilJSOcg09PUmOwQKMib5w8jm19jJ3aHwsv4lU1hezjns5OK6F4kYCinSp0aczpG
         R8Syqccwpd3/fan9oR5aPuNnGsNddmmcFLBDsLMp4O2exTaZ9bmG4pUJgWlQzwP/DImv
         kzLuPu3KmM00lp0RvaH5ieUPLBk+PF73nDQOTjn70ek8NL+9M8wjlkG08XdkXePe9pdM
         d2Pqc2npwHCQZbj13O6ovEsDxG87IHdTwVngkyVHgpDussFSuu8iuRpD51WJBVJivTkv
         29Wg==
X-Gm-Message-State: ACgBeo2n0Lp4nnx2ESNpYPYgNMVxlzc2J5hRnPR45QlK4f8gJdYekkov
        eysWmvFLKrQ9YMWlQTRm8aL4FBiXFVo=
X-Google-Smtp-Source: AA6agR4EKCh3x0sLxruvDA5M5cAgiYDNPhGXMVSyqIVrfQSIZlvBgOdGErnHuU0DpfxXpEJmfhzVBw==
X-Received: by 2002:ac8:5f09:0:b0:343:67b3:96f5 with SMTP id x9-20020ac85f09000000b0034367b396f5mr4918206qta.470.1660871889267;
        Thu, 18 Aug 2022 18:18:09 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com (ip98-164-255-77.oc.oc.cox.net. [98.164.255.77])
        by smtp.gmail.com with ESMTPSA id u5-20020a05620a0c4500b006b5e296452csm2612502qki.54.2022.08.18.18.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 18:18:08 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 0/7] lpfc: Update lpfc to revision 14.2.0.6
Date:   Thu, 18 Aug 2022 18:17:29 -0700
Message-Id: <20220819011736.14141-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 14.2.0.6

This patch set contains fixes and removal of dead code.

The patches were cut against Martin's 5.20/scsi-queue tree

James Smart (7):
  lpfc: Fix unsolicited FLOGI receive handling during PT2PT discovery
  lpfc: Fix null ndlp ptr dereference in abnormal exit path for GFT_ID
  lpfc: Rework MIB Rx Monitor debug info logic
  lpfc: Add warning notification period to CMF_SYNC_WQE
  lpfc: Remove SANDiags related code
  lpfc: Update lpfc version to 14.2.0.6
  lpfc: Copyright updates for 14.2.0.6 patches

 drivers/scsi/lpfc/lpfc.h         |  27 +--
 drivers/scsi/lpfc/lpfc_attr.c    | 344 +------------------------------
 drivers/scsi/lpfc/lpfc_crtn.h    |   8 +
 drivers/scsi/lpfc/lpfc_ct.c      |   7 +-
 drivers/scsi/lpfc/lpfc_debugfs.c |  59 +-----
 drivers/scsi/lpfc/lpfc_debugfs.h |   4 +-
 drivers/scsi/lpfc/lpfc_disc.h    |   3 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c |  18 --
 drivers/scsi/lpfc/lpfc_hw4.h     |   4 +
 drivers/scsi/lpfc/lpfc_init.c    |  83 +++-----
 drivers/scsi/lpfc/lpfc_mem.c     |  11 +-
 drivers/scsi/lpfc/lpfc_scsi.c    |  59 ------
 drivers/scsi/lpfc/lpfc_scsi.h    |   6 +-
 drivers/scsi/lpfc/lpfc_sli.c     | 196 +++++++++++++++++-
 drivers/scsi/lpfc/lpfc_version.h |   2 +-
 drivers/scsi/lpfc/lpfc_vport.c   |  71 -------
 drivers/scsi/lpfc/lpfc_vport.h   |   6 +-
 17 files changed, 263 insertions(+), 645 deletions(-)

-- 
2.26.2

