Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96821C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 03:55:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388860AbiEFD7N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 May 2022 23:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388851AbiEFD7M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 May 2022 23:59:12 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F426540
        for <linux-scsi@vger.kernel.org>; Thu,  5 May 2022 20:55:28 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id x52so5254124pfu.11
        for <linux-scsi@vger.kernel.org>; Thu, 05 May 2022 20:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1RZuvVhmvLAC0SxqGKLfNX7xe2phMhrsVzlzxDC7F+c=;
        b=mhwYN+6eHb221pb7ekY7+46JyB2DbtNQWTElYfw5HyIMq3MHrwlK3/qtjmeW4v58i9
         PxIH1KuLZjp8trlmOB5anZFV2CQSExhXOEAWhot15xAOV9f0+nJVefMvC6+5jDsAiv+5
         NAhGXZJjpm7AWkOewcck187qMnqnQlAgAPaVG+jlGRI8RYKecFDFcRhpRP59lIhkTWrr
         oUrD1h39ySstmWHyubr6AhBblUHBMxFe3lXraVDYbnOMoLP3ZxT4m6PzCqby6zEhCCBs
         KAX348R/Pj+AlHnsAgH+qdYYqKtQ3Bu6iXHaTjl+fv+8+VnT4SkBIDmVqu4XTrvp5jEt
         js7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1RZuvVhmvLAC0SxqGKLfNX7xe2phMhrsVzlzxDC7F+c=;
        b=qHNhGzoR4oBu+iAkhtMuKDyfRoSwi5AoGsPrst0t92CI6SX7JsVFpxiqsm5+Ppa43i
         invgSXqXhovzRz1FPBzlKhCjZzTYu/BQiNWmRlwU0Wg2SX4411OpVobxD+am2Otk7ikS
         fk2zE7XmcL7MpAyJ40VVlFZvGgFEb0CqUGmAGx5NPM9MuPfOhO3TnROWWi/yOOnCbyD4
         pIhV4iF8/PlIOrxJKbaadd8XIbuG86em6JBWozLUUJUpdOJBe02BExaTH+H9VB8P8HTk
         HigXicX/KrGDkXbsVWds1NqrO2FZXw131DnWlOaWwngCcsIRjlbI/cgD2s7nExs3YHSh
         xIbQ==
X-Gm-Message-State: AOAM5324sVfOdSxqQRYPcuDxFH5UAyDVUqAdQ98tXwABQskbs/CjxfaK
        +wc2mM2KXT0N/TaZuHaFCOT+GpSKXj8=
X-Google-Smtp-Source: ABdhPJzIcFyrW5xfUGdiGZ3URIcoX0q7xnQbCYTiv5l5nzPbBEm9c/aaFPFBiO1yqZPV9z5dzU0u1g==
X-Received: by 2002:a63:86c6:0:b0:3ab:2c2c:42e9 with SMTP id x189-20020a6386c6000000b003ab2c2c42e9mr1175519pgd.230.1651809327437;
        Thu, 05 May 2022 20:55:27 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id ck3-20020a17090afe0300b001cd4989feebsm6065187pjb.55.2022.05.05.20.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 20:55:26 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 00/12] lpfc: Update lpfc to revision 14.2.0.3
Date:   Thu,  5 May 2022 20:55:07 -0700
Message-Id: <20220506035519.50908-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 14.2.0.3

This patch set contains fixes in several different areas including
ref counting areas, oops, I/O length failures, etc.

The patches were cut against Martin's 5.19/scsi-queue tree

James Smart (12):
  lpfc: Fix element offset in __lpfc_sli_release_iocbq_s4()
  lpfc: Fill in missing ndlp kref puts in error paths
  lpfc: Fix ndlp put following a LOGO completion
  lpfc: Inhibit aborts if external loopback plug is inserted
  lpfc: Fix dmabuf ptr assignment in lpfc_ct_reject_event
  lpfc: Use list_for_each_entry_safe on fc_nodes list in
    rscn_recovery_check
  lpfc: Decrement outstanding gidft_inp counter if lpfc_err_lost_link
  lpfc: Change VMID registration to be based on fabric parameters
  lpfc: Rework FDMI initialization after link up
  lpfc: Alter FPIN stat accounting logic
  lpfc: Use sg_dma_address and sg_dma_len macros for NVMe I/O
  lpfc: Update lpfc version to 14.2.0.3

 drivers/scsi/lpfc/lpfc.h           |   4 +
 drivers/scsi/lpfc/lpfc_crtn.h      |   1 +
 drivers/scsi/lpfc/lpfc_ct.c        | 114 ++++++++++++++++++++++++++---
 drivers/scsi/lpfc/lpfc_els.c       |  79 +++++++++-----------
 drivers/scsi/lpfc/lpfc_hbadisc.c   |  21 ++++--
 drivers/scsi/lpfc/lpfc_init.c      |  65 ++++++++--------
 drivers/scsi/lpfc/lpfc_nportdisc.c |  15 +++-
 drivers/scsi/lpfc/lpfc_nvme.c      |   9 ++-
 drivers/scsi/lpfc/lpfc_scsi.c      |  17 +++--
 drivers/scsi/lpfc/lpfc_sli.c       |  35 ++++-----
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 11 files changed, 242 insertions(+), 120 deletions(-)

-- 
2.26.2

