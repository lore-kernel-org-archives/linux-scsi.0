Return-Path: <SRS0=X8O6=76=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64319C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 08:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41698207DD
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 08:18:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DF5+uUuD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgFQISq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 04:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgFQISp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2020 04:18:45 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F075C061573
        for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2020 01:18:45 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id 204so1217907qki.20
        for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2020 01:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=k5RLLmYaQkbSAtGCOv6KMT5VRze0EAFLap2P04UfQpM=;
        b=DF5+uUuDxRJ6NkH4x6Pckjwvhdq9jkKY97UOpvtvRe/dP9eDttP925pbhfZner5ItL
         94zz8sL36npohvUmvPUoOkEZIgSdHnOQgf2spQXqt8/YTgFuGuvn17ItOMKZlo2EM0yC
         y/HMlRRcZIjDxr6NxPRB6baXteJHcTzOqB5BA+5q+AYH18Rv2UbBmaljwWSdNYw/LWPO
         7Z3no8h/kHgz5nOuXyruQ2yUb2q8m0LmZaS1aw64mHBbdMaulslYtg8c5usTruWelKpn
         8mrqYXgdKjTqXcrUBWkCwJcyJ0P5K5X6GnMk9YG1O9ALx/WcHzg/EYH2w0h34xYmMTpv
         7d0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=k5RLLmYaQkbSAtGCOv6KMT5VRze0EAFLap2P04UfQpM=;
        b=rU4RwOcb6euS63CfRunqvqdpYBngZ2jIKl0AQNozwf/eDduV1VYLgOX25PX6HLrcgm
         YthhMVOmg+XI54FW1HK1ehPq8NoKwEyhOXh0K/LWwd9mzDlsxoCilHcDvrernLcJhJyE
         zesSdmgA9sUHm80znTiIYQK+UAbrElji505GT62nkBaHQC59kkPLcI9wNKv9JFaa6N95
         VQAubMjVtFYdlITKjsyKyqqy3eQ/+M9TylNostWF6xjLaAUbpW0HlJ/O7+eZFxJeUJ2H
         MxQp7vDLmViTEUXeLmnyWSq9Cnl2y1nYEweLHKNmXP/6cOrc0ureJZ+hCWFKxF/0VQD3
         7WWA==
X-Gm-Message-State: AOAM531lnLWtDdMiI83/cdqOAsci9Inau+uWre1lG+xRxSkUw+b9OaL+
        3mu3lmP/hQnRqq4jaWqb6PKLl5RIbOdBoAimTJPYLMCX1WDtckB+MchfKiZm5SYD+wi8FqwEOUT
        HH0k+GCXAilt9/Dc9X53CGGPGSTc1J/VCLA3CE6uAqV3z4Jh3sIhQ+qkYmdyzN5yACKw=
X-Google-Smtp-Source: ABdhPJxpj++WTNAC9kZH8/cyqwzN4yg36oZJNgGTcRUnGsfUBISBQwPQtt3mSIRtZJ3fCcqNbM/7MogWDVQ=
X-Received: by 2002:ad4:54ea:: with SMTP id k10mr6506949qvx.66.1592381924446;
 Wed, 17 Jun 2020 01:18:44 -0700 (PDT)
Date:   Wed, 17 Jun 2020 08:18:38 +0000
Message-Id: <20200617081841.218985-1-satyat@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH 0/3] Inline Encryption Support for UFS
From:   Satya Tangirala <satyat@google.com>
To:     linux-scsi@vger.kernel.org
Cc:     Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch series adds support for inline encryption to UFS using
the inline encryption support in the block layer. It follows the JEDEC
UFSHCI v2.1 specification, which defines inline encryption for UFS.
This patch series is based on v5.8-rc1.

Patch 1 introduces the crypto registers and struct definitions defined
in the UFSHCI v2.1 spec.

Patch 2 introduces functions to manipulate the UFS inline encryption
hardware (again in line with the UFSHCI v2.1 spec) via the block
layer keyslot manager. Device specific drivers must set the
UFSHCD_CAP_CRYPTO in hba->caps before ufshcd_hba_init_crypto is called
to opt-in to inline encryption support.

Patch 3 wires up ufshcd.c with the UFS crypto API introduced in Patch 2.

Satya Tangirala (3):
  scsi: ufs: UFS driver v2.1 spec crypto additions
  scsi: ufs: UFS crypto API
  scsi: ufs: Add inline encryption support to UFS

 drivers/scsi/ufs/Kconfig         |   9 ++
 drivers/scsi/ufs/Makefile        |   1 +
 drivers/scsi/ufs/ufshcd-crypto.c | 226 +++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd-crypto.h |  60 ++++++++
 drivers/scsi/ufs/ufshcd.c        |  46 ++++++-
 drivers/scsi/ufs/ufshcd.h        |  24 ++++
 drivers/scsi/ufs/ufshci.h        |  67 ++++++++-
 7 files changed, 426 insertions(+), 7 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshcd-crypto.c
 create mode 100644 drivers/scsi/ufs/ufshcd-crypto.h

-- 
2.27.0.290.gba653c62da-goog

