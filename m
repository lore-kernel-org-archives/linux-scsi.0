Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D313C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Oct 2023 18:58:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbjJaS67 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Oct 2023 14:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbjJaS66 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Oct 2023 14:58:58 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1771E8
        for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2023 11:58:55 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1cc28719cb0so7299465ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2023 11:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698778735; x=1699383535; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vKVDtxCyH+cFfXXh39weGW+5SXW7JGBusEMPjaWsv1g=;
        b=EVhpFfG6PBMi7FE2oQ4o7NtvQBCAcEFnwT+Ilh9isf1spaGxDZlQAoBTGLi9bw5MWS
         3hprzXpzZWVFgW+EX4T6+s+IrpaaZVoaplvhlFFpOgUTpuS/C2rwFV0odufgEanRTgXa
         1YHIH63fm4Yni21STw4xpSCkI38TmC+dFzS5FC9Bn+onegbrQfb1DLgY1/RQzZMngH2K
         S7zjaHjUj3dmLL+j7d07yF8k8vhEvO1MQybzlD8EO4tgi3sucVFF7eSCiObGqZAuPs1q
         1pOGrM1AvT4cECCxH8BxUOQVfqylbyTVUO1AtaQyLcTfO+uTZRYn5GOHgRIu41Nft91k
         kzzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698778735; x=1699383535;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vKVDtxCyH+cFfXXh39weGW+5SXW7JGBusEMPjaWsv1g=;
        b=LD45bro6271b75lD8ZNQQz1sWQpR/wbLselNiwbqT7JGLGRvdmVuWm3v1Ct/yfdUTT
         /GDtghZHdKK+V2eHNR/BS2G3g/fp4u7h/yIVHY4lUYElhEfsdaSF1I30nX4AysjXbNG0
         eToql+vH6Bp2O0pkGlpBiff20K20s0o/qD3ucQB+CTSTlzykXUldbEIMpi8JHO9G9peq
         V6oGBLSFlCoFSe0HPkb4RFbaR1HVcCbsuCF/jdHd09djYIehGi49C24/gnPNrktfCvf+
         EFnbUltPQrcd7HQ7+qfqE7c1l2T50H0p8OIkpRKi4po+TGZ4oZ/hVEBrVCwiDVmd+T6+
         fQSw==
X-Gm-Message-State: AOJu0Ywit/nPjzl/8X37cihfObXxezgBKNMu4EyGWo21ju11Lun7ZugM
        AJXsIJcJNX9LjOaYiVt3c1VTRZnrJhQ=
X-Google-Smtp-Source: AGHT+IG51EFbhgrePEPzTwVUt9aiXqKnC9iNe4hyNyUmoyQml92iQ2+HGviJg3K4Jw88sCt1AaIQlQ==
X-Received: by 2002:a17:903:3406:b0:1cc:3b88:78b with SMTP id ke6-20020a170903340600b001cc3b88078bmr8324536plb.6.1698778735084;
        Tue, 31 Oct 2023 11:58:55 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bh6-20020a170902a98600b001c9d6923e7dsm1628657plb.222.2023.10.31.11.58.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Oct 2023 11:58:54 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 0/9] lpfc: Update lpfc to revision 14.2.0.16
Date:   Tue, 31 Oct 2023 12:12:15 -0700
Message-Id: <20231031191224.150862-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 14.2.0.16

This patch set contains a user input range check correction, static code
analyzer fixes, refactoring of clean up code, and logging enhancements.

The patches were cut against Martin's 6.7/scsi-queue tree.

Justin Tee (9):
  lpfc: Correct maximum PCI function value for RAS fw logging
  lpfc: Fix possible file string name overflow when updating firmware
  lpfc: Fix list_entry null check warning in lpfc_cmpl_els_plogi
  lpfc: Eliminate unnecessary relocking in lpfc_check_nlp_post_devloss
  lpfc: Return early in lpfc_poll_eratt when the driver is unloading
  lpfc: Refactor and clean up mailbox command memory free
  lpfc: Enhance driver logging for selected discovery events
  lpfc: Update lpfc version to 14.2.0.16
  lpfc: Copyright updates for 14.2.0.16 patches

 drivers/scsi/lpfc/lpfc.h         |  1 +
 drivers/scsi/lpfc/lpfc_attr.c    |  4 +--
 drivers/scsi/lpfc/lpfc_els.c     | 53 ++++++++++++++++++++------------
 drivers/scsi/lpfc/lpfc_hbadisc.c |  2 +-
 drivers/scsi/lpfc/lpfc_init.c    |  4 +--
 drivers/scsi/lpfc/lpfc_mbox.c    |  6 ++--
 drivers/scsi/lpfc/lpfc_mem.c     | 47 ++++++++++++++++------------
 drivers/scsi/lpfc/lpfc_sli.c     | 20 +++++++++---
 drivers/scsi/lpfc/lpfc_sli.h     | 10 +++---
 drivers/scsi/lpfc/lpfc_version.h |  2 +-
 10 files changed, 93 insertions(+), 56 deletions(-)

-- 
2.38.0

