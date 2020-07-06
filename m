Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CCADC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 19:10:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08D12206CD
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 19:10:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CwAWmXT7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgGFTKW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 15:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbgGFTKW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 15:10:22 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B1DC061755
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jul 2020 12:10:22 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id gp8so29726529pjb.9
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jul 2020 12:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=qMpXfYo24wLWibBzNZ/x1ax6BwCiJO+0C3OEJbg7dXM=;
        b=CwAWmXT7P22DkWhqA2a6MK669KjbTjzP8JxFl9voYHlOg4kaSumm1dy2moBf1zQnvL
         sl0I/8zyTWdUaBBT2y0e66R3fRR6PM34ClgvjQBUOzouE/BQYRqW6lqB+1Pp7lI2zICz
         Oza6osQZLg6UMEt2ARTG5g2wOIOOM+G1e8mFlFdb32B/nCaf1KHb6m8GrvezeMgQ286B
         Xhl1rNt4V57A/jF+EJ0mKONAnmYJlXzNB6rss0mI7HvNcL/hDX4gaFPfzE92tfNZRl+n
         A/UTACvrYBDblj3CKf6Ru9xXa/WYuFmp3PrK4ih559bifNhfxG1O6s+pn84Jy3sWZgW6
         9Z+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=qMpXfYo24wLWibBzNZ/x1ax6BwCiJO+0C3OEJbg7dXM=;
        b=oWkP/R0HhW/y45ZyUPX5Bp2TOBewRSAv+V2c8+Ex84LgOrY0gI4dYos2BrKzzfcxza
         W5QVT8kJAs26M6RaC4ZTqmlNTY0FvIJfQbO9J5adW4+UZTuAnEIbuEqYWGikF8o4R+Yi
         Dwz3izP4AxSH6LcKBzJ5NifjXIFH8moQyrIBUMyjmzBEEELPA1yonBHHesLDxtI+6kGi
         vi1y4Z+L+GxWgIxbERj1UzHWBlZcJFc8wYqrOMuyfwoGNPUYwKeNotwWOOyCdC+uUG4j
         oz295ZB81I02cQ1v7+iYUMz9vXY4BtEO+VPF2XoraMk3PqjecTEwyVQsD08PiGKkaX88
         Kmtg==
X-Gm-Message-State: AOAM530fhh1QCp7vszhzAm03HDdgWmpvxI96wr77b13Bnr/b22bjts1p
        Tixbnp7IIUVPDKd8/rPSuaU2rqYtH9tXL3pZ2EDp53x2smwizLLiOOCo6xyPvHIfCwDwGYohixN
        0Aszzdc9ZsDOf8O7DqYYptgQVeiinKSI+RLvkWdTDcZPCr1/+bLxL4y43yVGYpoyU8oU=
X-Google-Smtp-Source: ABdhPJzPnLUIKxtgnTGeny8TXwgUE+/GEUilClbKORhYlTWJcgpgF45Oo5rAC/0Z1gkAt12+OM8FMYwlvOc=
X-Received: by 2002:a17:90b:3555:: with SMTP id lt21mr658870pjb.234.1594062621032;
 Mon, 06 Jul 2020 12:10:21 -0700 (PDT)
Date:   Mon,  6 Jul 2020 19:10:13 +0000
Message-Id: <20200706191016.2012191-1-satyat@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
Subject: [PATCH v3 0/3] Inline Encryption Support for UFS
From:   Satya Tangirala <satyat@google.com>
To:     linux-scsi@vger.kernel.org
Cc:     Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch series adds support for inline encryption to UFS using
the inline encryption support in the block layer. It follows the JEDEC
UFSHCI v2.1 specification, which defines inline encryption for UFS.

This patch series previously went through a number of iterations as
part of the "Inline Encryption Support" patchset (last version was v13:
https://lkml.kernel.org/r/20200514003727.69001-1-satyat@google.com).
This patch series is rebased on v5.8-rc4.

Patch 1 introduces the crypto registers and struct definitions defined
in the UFSHCI v2.1 spec.

Patch 2 introduces functions to manipulate the UFS inline encryption
hardware (again in line with the UFSHCI v2.1 spec) via the block
layer keyslot manager. Device specific drivers must set the
UFSHCD_CAP_CRYPTO in hba->caps before ufshcd_hba_init_crypto is called
to opt-in to inline encryption support.

Patch 3 wires up ufshcd.c with the UFS crypto API introduced in Patch 2.

This patch series has been tested on some Qualcomm chipsets (on the
db845c, sm8150-mtp and sm8250-mtp) using some additional patches at
https://lkml.kernel.org/linux-scsi/20200501045111.665881-1-ebiggers@kernel.org/
and on some Mediatek chipsets using the additional patch in
https://lkml.kernel.org/linux-scsi/20200304022101.14165-1-stanley.chu@mediatek.com/.
These additional patches are required because these chipsets need certain
additional behaviour not specified within the UFSHCI v2.1 spec.

Thanks a lot to all the folks who tested this out!

Changes v2 => v3:
 - introduce ufshcd_prepare_req_desc_hdr_crypto to clean up code slightly
 - split up ufshcd_hba_init_crypto into ufshcd_hba_init_crypto_capabilities
   and ufshcd_init_crypto. The first function is called from
   ufshcd_hba_capabilities, and only reads crypto capabilities from device
   registers and sets up appropriate crypto structures. The second function
   is called from ufshcd_init, and actually initializes the inline crypto
   hardware.

Changes v1 => v2
 - handle OCS_DEVICE_FATAL_ERROR explicitly in ufshcd_transfer_rsp_status

Satya Tangirala (3):
  scsi: ufs: UFS driver v2.1 spec crypto additions
  scsi: ufs: UFS crypto API
  scsi: ufs: Add inline encryption support to UFS

 drivers/scsi/ufs/Kconfig         |   9 ++
 drivers/scsi/ufs/Makefile        |   1 +
 drivers/scsi/ufs/ufshcd-crypto.c | 238 +++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd-crypto.h |  79 ++++++++++
 drivers/scsi/ufs/ufshcd.c        |  51 ++++++-
 drivers/scsi/ufs/ufshcd.h        |  24 ++++
 drivers/scsi/ufs/ufshci.h        |  67 ++++++++-
 7 files changed, 460 insertions(+), 9 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshcd-crypto.c
 create mode 100644 drivers/scsi/ufs/ufshcd-crypto.h

-- 
2.27.0.212.ge8ba1cc988-goog

