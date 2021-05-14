Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84138C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 19:56:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 560FD61492
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 19:56:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbhENT5R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 15:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbhENT5Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 15:57:16 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9ABC061574
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 12:56:05 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id b13-20020a17090a8c8db029015cd97baea9so1850188pjo.0
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 12:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x17MGnHaA+1zNXG7Y19zjRXci+zQMFbaS8YTmXUq+pY=;
        b=U72e7SlNUiwJxSRs7MjXDtMiwfKoDX5gCM4X3Nb8Kt/cMz3QJHNMdPum3U6isq+Mf+
         fDJ5Ox0Uajw0q2rs+fplLRfdz9uqL+pL7xMx7gGwaDf//3PktJS+we7omFoMAh2rZKkq
         QZJSIyGBeJWjlle5XntLqtJr4EQHMqqRuEFI7hZ7CVm0Lb74W4UNw4kVHETjLSRpI62m
         ARTRSsCBXLISL4//p5XIdoNuCv21qgSbauhczb4FD8kO8o5ZA7iLSxjCk1AdiZt+K/o7
         hYutu8wfcyiP903TdMTYltJvKkQhgejAtYWm1Cz7RZVoJX020acha4KXwBP7Q+c+URLa
         5OIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x17MGnHaA+1zNXG7Y19zjRXci+zQMFbaS8YTmXUq+pY=;
        b=dSbMipnCtujSPicYYIGvh4KLmwQeGw+byA3dt1+NPpTAJxHdPE0IXXSy7m6c3GunhN
         yFfyqEGVZb+iHYE47YfhGz6O7fWi/HnTKVWl+NKoHsJ5+8fom6djLAR6rlKBirFKc5KB
         sIrO1veWxwTG2gP+aV41MgMgNArJmelmxStpI/8X4QPEwJBkNhmLh1Ci4XTn/CjqUm/R
         +HgX5RqNPMV+Z3RQFxFNZr2Fl6T5XfBMj8RTHa2mNNWlZ1IrWPFZoVmHDFpfCeqvxzHc
         gbwiZkHiQPUFFXqayTaDJMzvuY3/LmxluBVo3HSQ//uLt48u1TnujBMNjZwrjCIrfmE1
         zd3w==
X-Gm-Message-State: AOAM5326tPk01WysesiWw0rZFIadz2B+4RCe7GKyR8MUh71TVFobmYOw
        LMfRkdbQBsyaHdr6QIvfzCfym1b40nI=
X-Google-Smtp-Source: ABdhPJwskEABO/6KGOOx4Dp4D/Jce1rY8pG99Cf+CwRZ5tk6H8EbtBbOx2SI4UaEgsKdI/Y67fpP0Q==
X-Received: by 2002:a17:90b:604:: with SMTP id gb4mr13032311pjb.178.1621022164681;
        Fri, 14 May 2021 12:56:04 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id v15sm4961850pgc.57.2021.05.14.12.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 12:56:04 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 00/11] lpfc: Update lpfc to revision 12.8.0.10
Date:   Fri, 14 May 2021 12:55:48 -0700
Message-Id: <20210514195559.119853-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 12.8.0.10

This patch set contains fixes, a new abort behavior, and an RDF
enhancment.

The patches were cut against Martin's 5.14/scsi-queue tree


James Smart (11):
  lpfc: Fix unreleased RPIs when NPIV ports are created
  lpfc: Fix non-optimized ERSP handling
  lpfc: Fix "Unexpected timeout" error in direct attach topology
  lpfc: Add ndlp kref accounting for resume rpi path
  lpfc: Fix Node recovery when driver is handling simultaneous PLOGIs
  lpfc: Fix node handling for Fabric Controller and Domain Controller
  lpfc: Ignore GID-FT response that may be received after a link flip
  lpfc: Fix crash when lpfc_sli4_hba_setup fails to initialize the SGLs
  lpfc: Add a option to enable interlocked ABTS before job completion
  lpfc: Reregister FPIN types if receive ELS_RDF from fabric controller
  lpfc: Update lpfc version to 12.8.0.10

 drivers/scsi/lpfc/lpfc.h           |   2 +
 drivers/scsi/lpfc/lpfc_attr.c      |  11 ++
 drivers/scsi/lpfc/lpfc_crtn.h      |   1 +
 drivers/scsi/lpfc/lpfc_ct.c        |  43 ++++-
 drivers/scsi/lpfc/lpfc_debugfs.c   |  11 +-
 drivers/scsi/lpfc/lpfc_disc.h      |   1 +
 drivers/scsi/lpfc/lpfc_els.c       | 299 +++++++++++++++++++++++++++--
 drivers/scsi/lpfc/lpfc_hbadisc.c   |  81 +++++++-
 drivers/scsi/lpfc/lpfc_init.c      |   7 -
 drivers/scsi/lpfc/lpfc_mbox.c      |   3 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  40 +++-
 drivers/scsi/lpfc/lpfc_nvme.c      |  14 +-
 drivers/scsi/lpfc/lpfc_scsi.c      |  45 ++++-
 drivers/scsi/lpfc/lpfc_sli.c       |  39 +++-
 drivers/scsi/lpfc/lpfc_sli.h       |   3 +-
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 16 files changed, 529 insertions(+), 73 deletions(-)

-- 
2.26.2

