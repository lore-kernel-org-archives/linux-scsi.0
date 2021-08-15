Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D434C4320A
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Aug 2021 03:13:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DF8261002
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Aug 2021 03:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234385AbhHODNg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 14 Aug 2021 23:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbhHODNf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Aug 2021 23:13:35 -0400
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD7EC061764;
        Sat, 14 Aug 2021 20:13:06 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 8DE67128037B;
        Sat, 14 Aug 2021 20:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1628997178;
        bh=rl9kYc74n8lnrEkjB/p9JncXEvAWK+gLVnJIzKpjUmY=;
        h=Message-ID:Subject:From:To:Date:From;
        b=IsDZ14arqq9SmNETfHTANCZAHYil4LZKkXTY/tNdKX/8qNaMc6OcYyNUFSVNblN7j
         pjwridy5rempAN5XI8ZWD4XZ5/bbAQ6PDqxLKBSWt7GDZlbg6XH4n1SRFINDxNbdfa
         6TQOEF97qqiyFbedhWD5xoI2XpCG0YbasZ2xGSYI=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id a75EmV1lwCc8; Sat, 14 Aug 2021 20:12:58 -0700 (PDT)
Received: from [172.20.3.52] (unknown [216.54.114.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 90FAD128035C;
        Sat, 14 Aug 2021 20:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1628997178;
        bh=rl9kYc74n8lnrEkjB/p9JncXEvAWK+gLVnJIzKpjUmY=;
        h=Message-ID:Subject:From:To:Date:From;
        b=IsDZ14arqq9SmNETfHTANCZAHYil4LZKkXTY/tNdKX/8qNaMc6OcYyNUFSVNblN7j
         pjwridy5rempAN5XI8ZWD4XZ5/bbAQ6PDqxLKBSWt7GDZlbg6XH4n1SRFINDxNbdfa
         6TQOEF97qqiyFbedhWD5xoI2XpCG0YbasZ2xGSYI=
Message-ID: <9672767623d4ca908c9405c0e7242b6e3131df7d.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.14-rc5
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 14 Aug 2021 23:12:55 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Three minor fixes, all in drivers.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Colin Ian King (1):
      scsi: mpt3sas: Fix incorrectly assigned error return and check

Ewan D. Milne (1):
      scsi: lpfc: Move initialization of phba->poll_list earlier to avoid crash

Michael Kelley (1):
      scsi: storvsc: Log TEST_UNIT_READY errors as warnings

And the diffstat:

 drivers/scsi/lpfc/lpfc_init.c       |  3 ++-
 drivers/scsi/mpt3sas/mpt3sas_base.c |  2 +-
 drivers/scsi/storvsc_drv.c          | 14 ++++++++++++--
 3 files changed, 15 insertions(+), 4 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 5983e05b648f..e29523a1b530 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -13193,6 +13193,8 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 	if (!phba)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&phba->poll_list);
+
 	/* Perform generic PCI device enabling operation */
 	error = lpfc_enable_pci_dev(phba);
 	if (error)
@@ -13327,7 +13329,6 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 	/* Enable RAS FW log support */
 	lpfc_sli4_ras_setup(phba);
 
-	INIT_LIST_HEAD(&phba->poll_list);
 	timer_setup(&phba->cpuhp_poll_timer, lpfc_sli4_poll_hbtimer, 0);
 	cpuhp_state_add_instance_nocalls(lpfc_cpuhp_state, &phba->cpuhp);
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 19b1c0cf5f2a..cf4a3a2c22ad 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -7851,7 +7851,7 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER *ioc)
 			return r;
 	}
 
-	rc = _base_static_config_pages(ioc);
+	r = _base_static_config_pages(ioc);
 	if (r)
 		return r;
 
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 328bb961c281..37506b3fe5a9 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1199,14 +1199,24 @@ static void storvsc_on_io_completion(struct storvsc_device *stor_device,
 		vstor_packet->vm_srb.sense_info_length);
 
 	if (vstor_packet->vm_srb.scsi_status != 0 ||
-	    vstor_packet->vm_srb.srb_status != SRB_STATUS_SUCCESS)
-		storvsc_log(device, STORVSC_LOGGING_ERROR,
+	    vstor_packet->vm_srb.srb_status != SRB_STATUS_SUCCESS) {
+
+		/*
+		 * Log TEST_UNIT_READY errors only as warnings. Hyper-V can
+		 * return errors when detecting devices using TEST_UNIT_READY,
+		 * and logging these as errors produces unhelpful noise.
+		 */
+		int loglevel = (stor_pkt->vm_srb.cdb[0] == TEST_UNIT_READY) ?
+			STORVSC_LOGGING_WARN : STORVSC_LOGGING_ERROR;
+
+		storvsc_log(device, loglevel,
 			"tag#%d cmd 0x%x status: scsi 0x%x srb 0x%x hv 0x%x\n",
 			request->cmd->request->tag,
 			stor_pkt->vm_srb.cdb[0],
 			vstor_packet->vm_srb.scsi_status,
 			vstor_packet->vm_srb.srb_status,
 			vstor_packet->status);
+	}
 
 	if (vstor_packet->vm_srb.scsi_status == SAM_STAT_CHECK_CONDITION &&
 	    (vstor_packet->vm_srb.srb_status & SRB_STATUS_AUTOSENSE_VALID))

