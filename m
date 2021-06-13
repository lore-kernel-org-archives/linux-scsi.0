Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 051E1C48BDF
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 21:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEF6D610C8
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 21:04:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbhFMVGL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Jun 2021 17:06:11 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:45537 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232107AbhFMVGK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Jun 2021 17:06:10 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d46 with ME
        id Gl462500721Fzsu03l467y; Sun, 13 Jun 2021 23:04:07 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 13 Jun 2021 23:04:07 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 0/1] scsi: mptctl: switch from 'pci_' to 'dma_' API
Date:   Sun, 13 Jun 2021 23:04:04 +0200
Message-Id: <cover.1623617903.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This cover letter is only there to draw attention on the fact that I'm a bit
unsure about the use of GFP_KERNEL in 'kbuf_alloc_2_sgl()'.

In all conversion that I've done, GFP_USER was never used. I don't fully
understand the difference between GFP_USER and GFP_KERNEL.

So please review with care :).


For the 3 other functions, I'm much more confident. I've put the explanation
of why I think that GFP_KERNEL is safe in patch 1/1.
Basically, these functions already call fome functions that can sleep.


Christophe JAILLET (1):
  scsi: mptctl: switch from 'pci_' to 'dma_' API

 drivers/message/fusion/mptctl.c | 82 ++++++++++++++++++++-------------
 1 file changed, 49 insertions(+), 33 deletions(-)

-- 
2.30.2

