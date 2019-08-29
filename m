Return-Path: <SRS0=0byZ=WZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED7D6C3A59F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 12:32:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEAB32189D
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 12:32:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbfH2McT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Aug 2019 08:32:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:36414 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727315AbfH2McG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Aug 2019 08:32:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E9C05B023;
        Thu, 29 Aug 2019 12:32:04 +0000 (UTC)
From:   Michal Suchanek <msuchanek@suse.de>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Michal Suchanek <msuchanek@suse.de>,
        "Manoj N. Kumar" <manoj@linux.ibm.com>,
        "Matthew R. Ochs" <mrochs@linux.ibm.com>,
        Uma Krishnan <ukrishn@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] scsi: cxlflash: Fix fallthrough warnings.
Date:   Thu, 29 Aug 2019 14:32:00 +0200
Message-Id: <279d33f05007e9f3e3fb4e6ea19634b2608ffbd3.1567081143.git.msuchanek@suse.de>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <cover.1567081143.git.msuchanek@suse.de>
References: <cover.1567081143.git.msuchanek@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add fallthrough comments where missing.

Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 drivers/scsi/cxlflash/main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index b1f4724efde2..f402fa9a7bec 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -753,10 +753,13 @@ static void term_intr(struct cxlflash_cfg *cfg, enum undo_level level,
 		/* SISL_MSI_ASYNC_ERROR is setup only for the primary HWQ */
 		if (index == PRIMARY_HWQ)
 			cfg->ops->unmap_afu_irq(hwq->ctx_cookie, 3, hwq);
+		/* fall through */
 	case UNMAP_TWO:
 		cfg->ops->unmap_afu_irq(hwq->ctx_cookie, 2, hwq);
+		/* fall through */
 	case UNMAP_ONE:
 		cfg->ops->unmap_afu_irq(hwq->ctx_cookie, 1, hwq);
+		/* fall through */
 	case FREE_IRQ:
 		cfg->ops->free_afu_irqs(hwq->ctx_cookie);
 		/* fall through */
@@ -973,14 +976,18 @@ static void cxlflash_remove(struct pci_dev *pdev)
 	switch (cfg->init_state) {
 	case INIT_STATE_CDEV:
 		cxlflash_release_chrdev(cfg);
+		/* fall through */
 	case INIT_STATE_SCSI:
 		cxlflash_term_local_luns(cfg);
 		scsi_remove_host(cfg->host);
+		/* fall through */
 	case INIT_STATE_AFU:
 		term_afu(cfg);
+		/* fall through */
 	case INIT_STATE_PCI:
 		cfg->ops->destroy_afu(cfg->afu_cookie);
 		pci_disable_device(pdev);
+		/* fall through */
 	case INIT_STATE_NONE:
 		free_mem(cfg);
 		scsi_host_put(cfg->host);
@@ -3017,6 +3024,7 @@ static ssize_t num_hwqs_store(struct device *dev,
 		wait_event(cfg->reset_waitq, cfg->state != STATE_RESET);
 		if (cfg->state == STATE_NORMAL)
 			goto retry;
+		/* fall through */
 	default:
 		/* Ideally should not happen */
 		dev_err(dev, "%s: Device is not ready, state=%d\n",
-- 
2.12.3

