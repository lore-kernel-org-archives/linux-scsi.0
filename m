Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58070ECAAD2
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Aug 2022 00:34:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiH3Ad7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Aug 2022 20:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiH3Ad6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Aug 2022 20:33:58 -0400
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086E482867
        for <linux-scsi@vger.kernel.org>; Mon, 29 Aug 2022 17:33:58 -0700 (PDT)
Received: by mail-pf1-f181.google.com with SMTP id z187so9769166pfb.12
        for <linux-scsi@vger.kernel.org>; Mon, 29 Aug 2022 17:33:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=+dEmgPXDglsxvN5V/uCyGdonhPx8cCA0F/aYTMuaPJA=;
        b=0Xjb9KRCFGNuIhRM1KzkIx9HDlJWh8iRjgwDBV7/QK2f4BGsaM1MVDnRm11VsUeIF3
         1QFuNZwjXmwCTbow2IAmeuqTzCuQUGzReJQSpUzuGmW/hCMiQDrpLcukvrjtJo9/ZMdx
         aSA1CS+M5RBuVNggEsuMclOFB2L+ZO0/Ce7ZDs+++jIFWRY/Db9d9jt2ylMNEeiwp/kH
         d+ztMMZJf8XwbcdTmY5egCNbf59vsBVJPqXFI/tt1ySUakyyLJI1FMZhCLXbIaeKLL6C
         TrFPsKETGQaMH5WVrjgSf9IB/qF5TX18GK1ZFmo/ZgyE5rBRBJ6IiAItuHow7Y/flf2I
         X6Yw==
X-Gm-Message-State: ACgBeo3C3RQwbRcgekEYcJb5zBfyn7Gm62mqRxPwJjia+FjkwCiOSlxB
        Woxqtk5UvIHncU7QgZXxgwsAZS9to44=
X-Google-Smtp-Source: AA6agR4WttFD2LDgFL57mAbc1k61G0OwuLWAo1evkhhstbk01qsxOw6XrANo/SsU57hl/u55u+d8Xw==
X-Received: by 2002:a65:408b:0:b0:42a:55fb:60b0 with SMTP id t11-20020a65408b000000b0042a55fb60b0mr16023581pgp.431.1661819637351;
        Mon, 29 Aug 2022 17:33:57 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([12.219.165.6])
        by smtp.gmail.com with ESMTPSA id w131-20020a627b89000000b00537dfd6e67esm6201359pfc.48.2022.08.29.17.33.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 17:33:56 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/2] Prepare for constifying SCSI host templates
Date:   Mon, 29 Aug 2022 17:33:48 -0700
Message-Id: <20220830003350.1395173-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series prepares for constifying SCSI host templates by moving the
members that are not constant out of the SCSI host template. Please consider
this patch series for the next merge window.

Thanks,

Bart.

Bart Van Assche (2):
  scsi: esas2r: Introduce scsi_template_proc_dir()
  scsi: core: Introduce a new list for SCSI proc directory entries

 drivers/scsi/esas2r/esas2r_main.c |  18 +++--
 drivers/scsi/scsi_proc.c          | 106 ++++++++++++++++++++++++++----
 include/scsi/scsi_host.h          |  16 ++---
 3 files changed, 108 insertions(+), 32 deletions(-)

