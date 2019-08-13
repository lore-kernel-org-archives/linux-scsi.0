Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F75BC32750
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 10:18:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1030E2067D
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 10:18:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="tMv7PD0d";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="Ot30WIQF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbfHMKR7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 06:17:59 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54800 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727097AbfHMKR7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Aug 2019 06:17:59 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id E95008EE1F3;
        Tue, 13 Aug 2019 03:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1565691479;
        bh=0x61KgL+epPE4UqSL9XfER8aosdyl0oQssYuIO7NwOM=;
        h=Subject:From:To:Cc:Date:From;
        b=tMv7PD0d08pVBYycgoiVxTDJXXZZnbT/J5PD+KTk/NQtBnAags1//nSBTPcaYl2Wg
         5ayjB0eQOr6JI6+KO7ywa01bUft8UQVyS7cMkGIfvktjCxOgmKoqe+ZRYdrxRbIMgh
         41evSBSdqZu4+X329lcUP6z/G0g6Vh2Ca637GaWo=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 5hD8y0w54OvB; Tue, 13 Aug 2019 03:17:58 -0700 (PDT)
Received: from [172.16.180.52] (unknown [217.16.13.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 8A88C8EE1B4;
        Tue, 13 Aug 2019 03:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1565691478;
        bh=0x61KgL+epPE4UqSL9XfER8aosdyl0oQssYuIO7NwOM=;
        h=Subject:From:To:Cc:Date:From;
        b=Ot30WIQFr11SxLsve0CAtv12Vzo/HJFqLRAM7pOS2JfI+GTxkar3XJdSWRVx3nSfx
         RDcLh6m6+SMBWrtj7yPzYSQjPF0NaHd3mB/EDVBG26xTQw01xK8MSsDfA9BZDFkGha
         7xkKlwc6snPNWUBqc00XK1eY+CicuZPQ+06wT0Hk=
Message-ID: <1565691473.3371.4.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.3-rc4
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Tue, 13 Aug 2019 12:17:53 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

single lpfc fix, for a single cpu corner case.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

James Smart (1):
      scsi: lpfc: Fix crash when cpu count is 1 and null irq affinity mask

And the diffstat

 drivers/scsi/lpfc/lpfc_init.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index faf43b1d3dbe..a7549ae32542 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -10776,12 +10776,31 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 	/* This loop sets up all CPUs that are affinitized with a
 	 * irq vector assigned to the driver. All affinitized CPUs
 	 * will get a link to that vectors IRQ and EQ.
+	 *
+	 * NULL affinity mask handling:
+	 * If irq count is greater than one, log an error message.
+	 * If the null mask is received for the first irq, find the
+	 * first present cpu, and assign the eq index to ensure at
+	 * least one EQ is assigned.
 	 */
 	for (idx = 0; idx <  phba->cfg_irq_chann; idx++) {
 		/* Get a CPU mask for all CPUs affinitized to this vector */
 		maskp = pci_irq_get_affinity(phba->pcidev, idx);
-		if (!maskp)
-			continue;
+		if (!maskp) {
+			if (phba->cfg_irq_chann > 1)
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"3329 No affinity mask found "
+						"for vector %d (%d)\n",
+						idx, phba->cfg_irq_chann);
+			if (!idx) {
+				cpu = cpumask_first(cpu_present_mask);
+				cpup = &phba->sli4_hba.cpu_map[cpu];
+				cpup->eq = idx;
+				cpup->irq = pci_irq_vector(phba->pcidev, idx);
+				cpup->flag |= LPFC_CPU_FIRST_IRQ;
+			}
+			break;
+		}
 
 		i = 0;
 		/* Loop through all CPUs associated with vector idx */
