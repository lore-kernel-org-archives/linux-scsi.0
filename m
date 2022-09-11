Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D49DEECAAD3
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Sep 2022 22:15:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiIKWPP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Sep 2022 18:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiIKWPN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Sep 2022 18:15:13 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88A913CCE
        for <linux-scsi@vger.kernel.org>; Sun, 11 Sep 2022 15:15:10 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id cb8so5049848qtb.0
        for <linux-scsi@vger.kernel.org>; Sun, 11 Sep 2022 15:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=WcPOqQT5Npfp04TS6aU2lRyFfBh8Y37bGvfkYaXZMss=;
        b=qHaONHOLnLVnqJT3npVqA9YAQKF+Tn1c85qB7lYQUCGEj2u+YTwNZBRhT9eyfHmtZm
         Pnk+ufldH93aHA0QzpsuE2gRotxQpoSSPkvAJnFLjUr0coyJevMRbeSXZGjyXC3zKHif
         U2ujn6t1f4yozCNuKmFEFZ6+nrMoKYTtGUa1jll003yGtWg/IwTsjerrnKSs9y3+d9Ik
         LwEPSVZD5UJjtg3LhJaiOdrfL6pO9Ochf5YXTBdEBGd2G3R3NjfhXQqM3b02EcI8V/Fl
         EpdrQctVwxbWwq9I7ScbXxBPG3MVZ7JkSZJu87daFbCgHs8VXR0jjN/nG+AEqt07Aua3
         jrRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=WcPOqQT5Npfp04TS6aU2lRyFfBh8Y37bGvfkYaXZMss=;
        b=ekDzJSVweFuCxQYvSwkUmLiOcPWqMHFhwE/B9b3Opo+BkIFKfQRQKBLFzUBTu8k5ej
         aGwOkpXu58NUzGmSkkPGjGA2+G5U/fPdKk4zJW9qMNmRGFnCkA2pT09/QMBGqqAWuNQ0
         iWPLIq/x49blSapw38B81H1/KvFFBNvwcKlUqBv6h5LDA2kfyDVSILuCUqfeoJO94m0p
         K9f6z6oIESChfKjsPdP2zpUAcoheIku6YjSXUL+pRf9QqJybPv6UicHbC9Vi2OXu++2b
         o0x5dK8O9gQG4kv2YRm6SgqY92vAmZFcumJ3Ku5y9B5KMmMMszyzpgs8DmIrcUZ/8hhz
         x+6g==
X-Gm-Message-State: ACgBeo2mjfVIZtTpTv1fqUvWDBRt55Gl1B/jNON0cRNXaWdA81HWRZ01
        /HIA6RHvWdHhz4bSccSDWgW+OBh+54o=
X-Google-Smtp-Source: AA6agR5d4HWeMislDoTxZZWCC5Vxw39qhCYphT+rXIZIxR2ZMqAxg8UIWgJVtHw1XmQs55zJavwVbA==
X-Received: by 2002:ac8:58d2:0:b0:344:5698:a2e8 with SMTP id u18-20020ac858d2000000b003445698a2e8mr22002899qta.392.1662934509887;
        Sun, 11 Sep 2022 15:15:09 -0700 (PDT)
Received: from localhost.localdomain (ip98-164-255-77.oc.oc.cox.net. [98.164.255.77])
        by smtp.gmail.com with ESMTPSA id x8-20020a05622a000800b0035a70d82d7bsm5324305qtw.47.2022.09.11.15.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Sep 2022 15:15:09 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 00/13] lpfc: Update lpfc to revision 14.2.0.7
Date:   Sun, 11 Sep 2022 15:14:52 -0700
Message-Id: <20220911221505.117655-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 14.2.0.7

This patch set contains fixes and some code rework for tool warnings.

The patches were cut against Martin's 6.1/scsi-queue tree

James Smart (13):
  lpfc: Fix prli_fc4_req checks in PRLI handling
  lpfc: Fix FLOGI ACC with wrong SID in PT2PT topology
  lpfc: Fix mbuf pool resource detected as busy at driver unload
  lpfc: Add missing free iocb and nlp kref put for early return VMID
    cases
  lpfc: Fix multiple NVME remoteport registration calls for the same
    NPort ID
  lpfc: Move scsi_host_template outside dynamically allocated/freed phba
  lpfc: Update congestion mode logging for Emulex San Manager
    application
  lpfc: Rename mp/bmp dma buffers to rq/rsp in lpfc_fdmi_cmd
  lpfc: Rework lpfc_fdmi_cmd routine for cleanup and consistency
  lpfc: Rework FDMI attribute registration for unintential padding
  lpfc: Add reporting capability for Link Degrade Signaling
  lpfc: Fix various issues reported by tools
  lpfc: Update lpfc version to 14.2.0.7

 drivers/scsi/lpfc/lpfc.h         |   10 +-
 drivers/scsi/lpfc/lpfc_crtn.h    |    2 +
 drivers/scsi/lpfc/lpfc_ct.c      | 1085 +++++++++++-------------------
 drivers/scsi/lpfc/lpfc_debugfs.c |    2 +-
 drivers/scsi/lpfc/lpfc_disc.h    |    1 -
 drivers/scsi/lpfc/lpfc_els.c     |  234 ++++---
 drivers/scsi/lpfc/lpfc_hbadisc.c |   23 +-
 drivers/scsi/lpfc/lpfc_hw.h      |   59 +-
 drivers/scsi/lpfc/lpfc_hw4.h     |   30 +-
 drivers/scsi/lpfc/lpfc_init.c    |  353 +++++-----
 drivers/scsi/lpfc/lpfc_logmsg.h  |    2 +-
 drivers/scsi/lpfc/lpfc_scsi.c    |   27 +
 drivers/scsi/lpfc/lpfc_sli.c     |   73 +-
 drivers/scsi/lpfc/lpfc_sli4.h    |    4 +-
 drivers/scsi/lpfc/lpfc_version.h |    2 +-
 drivers/scsi/lpfc/lpfc_vmid.c    |    4 +-
 16 files changed, 914 insertions(+), 997 deletions(-)

-- 
2.35.3

