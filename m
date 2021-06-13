Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31CDFC48BCF
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 10:26:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0443261264
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 10:25:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbhFMK2A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Jun 2021 06:28:00 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:59107 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbhFMK17 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Jun 2021 06:27:59 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d10 with ME
        id GaRw2500M21Fzsu03aRwab; Sun, 13 Jun 2021 12:25:57 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 13 Jun 2021 12:25:57 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 0/2] scsi: mptsas: switch from 'pci_' to 'dma_' API
Date:   Sun, 13 Jun 2021 12:25:53 +0200
Message-Id: <cover.1623579808.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In order to convert this file to the dma_ API, 2 steps are proposed.

The first one is purely mechanical. All the updated memory allocations can
use GFP_KERNEL because of 'mpt_config()' calls. This function can sleep so
it sounds like a reasonable assumption to use GFP_KERNEL.

The 2nd patch is slighly more subtle. It is sent separatly to ease review.

Christophe JAILLET (2):
  scsi: mptsas: switch from 'pci_' to 'dma_' API
  scsi: mptsas: switch from 'pci_' to 'dma_' API in
    'mptsas_exp_repmanufacture_info()'

 drivers/message/fusion/mptsas.c | 138 ++++++++++++++++----------------
 1 file changed, 70 insertions(+), 68 deletions(-)

-- 
2.30.2

