Return-Path: <SRS0=0GAJ=6C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 948FEC38A2F
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 13:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 676282220A
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 13:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587217713;
	bh=gvP88TuYS0Tu8ZGSBMab+0GO4uQP7gZYPcgac7x2P9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=n9ayZZKy+pUcyUjLtKqCl4RO60P02ipa8SvKPEW1tRgmoHoWRRjodyeRUhg4Of2eq
	 OVEy5XOOfkPRW+ZZwxL+PEf5ZdewCsyzm6+QNgJ9JBEzwKe+ueFFhutclDZOohp9kw
	 GSrqArMprvnREUsXhRhWZBhv7Cao9vKGEP67mfMk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgDRNsc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Apr 2020 09:48:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbgDRNs2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 18 Apr 2020 09:48:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 204B422202;
        Sat, 18 Apr 2020 13:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587217707;
        bh=gvP88TuYS0Tu8ZGSBMab+0GO4uQP7gZYPcgac7x2P9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1QCYN7qYB9khOh6kUmcef825uu81O/+TwXXzrHadILwk1saYEl5PiLrJUjr28TbK/
         +A1F05dLpzl4X9A8q7FgL7TOOcHzNDINiRwHNdZxZ/GSF/OfAgdEimKIy05pvMCeea
         X0OcnrH51iCu6BlFLL8S96nhA01jmMnxi8NlVydk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 10/73] scsi: lpfc: Fix crash after handling a pci error
Date:   Sat, 18 Apr 2020 09:47:12 -0400
Message-Id: <20200418134815.6519-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418134815.6519-1-sashal@kernel.org>
References: <20200418134815.6519-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 4cd70891308dfb875ef31060c4a4aa8872630a2e ]

Injecting EEH on a 32GB card is causing kernel oops

The pci error handler is doing an IO flush and the offline code is also
doing an IO flush. When the 1st flush is complete the hdwq is destroyed
(freed), yet the second flush accesses the hdwq and crashes.

Added a check in lpfc_sli4_fush_io_rings to check both the HBA_IOQ_FLUSH
flag and the hdwq pointer to see if it is already set and not already
freed.

Link: https://lore.kernel.org/r/20200322181304.37655-6-jsmart2021@gmail.com
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 5939ea0e3b1eb..de97727458fc7 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4046,6 +4046,11 @@ lpfc_sli_flush_io_rings(struct lpfc_hba *phba)
 	struct lpfc_iocbq *piocb, *next_iocb;
 
 	spin_lock_irq(&phba->hbalock);
+	if (phba->hba_flag & HBA_IOQ_FLUSH ||
+	    !phba->sli4_hba.hdwq) {
+		spin_unlock_irq(&phba->hbalock);
+		return;
+	}
 	/* Indicate the I/O queues are flushed */
 	phba->hba_flag |= HBA_IOQ_FLUSH;
 	spin_unlock_irq(&phba->hbalock);
-- 
2.20.1

