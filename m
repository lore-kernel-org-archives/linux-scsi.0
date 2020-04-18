Return-Path: <SRS0=0GAJ=6C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0BFEC38A2F
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 13:53:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0B1A214AF
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 13:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587217984;
	bh=WJRBcsxAK79g61H4Fc/xDp2BX3BUFqWwraXVccApZhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=GPgvbX+ysPV05VIWERFXGOFJefCSOOGKyrVSrQT6k+3rjFhEhAZChEnBHzzsw9DmM
	 Pr/Tg5ek+o+h92yrB1UCf+Eok82VTyBXADaETDJ3CJfO81LfA5S++WqjVweahtSLdE
	 WJK0umuXEizmHVBIk0Q3277v5Vr+sLFnzWkkN4Ds=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgDRNsc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Apr 2020 09:48:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbgDRNs3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 18 Apr 2020 09:48:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62AED21BE5;
        Sat, 18 Apr 2020 13:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587217709;
        bh=WJRBcsxAK79g61H4Fc/xDp2BX3BUFqWwraXVccApZhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GBGGFvXNEZHTl+PlLEJ0zQXjLGmxHTRtUyrbWM11ZX/nysdjCh6C22b9txSO4TX7b
         P18L9Pspnrzyb2iezILFinl8em4EQ0tNzKEqA4Un/Yl37s899wAdxVcGFQEniyVkU0
         CEAjlcyLjA4XHV/xoz74johMQXqrxQIC3xkobSNg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 11/73] scsi: lpfc: Fix crash in target side cable pulls hitting WAIT_FOR_UNREG
Date:   Sat, 18 Apr 2020 09:47:13 -0400
Message-Id: <20200418134815.6519-11-sashal@kernel.org>
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

[ Upstream commit 807e7353d8a7105ce884d22b0dbc034993c6679c ]

Kernel is crashing with the following stacktrace:

  BUG: unable to handle kernel NULL pointer dereference at
    00000000000005bc
  IP: lpfc_nvme_register_port+0x1a8/0x3a0 [lpfc]
  ...
  Call Trace:
  lpfc_nlp_state_cleanup+0x2b2/0x500 [lpfc]
  lpfc_nlp_set_state+0xd7/0x1a0 [lpfc]
  lpfc_cmpl_prli_prli_issue+0x1f7/0x450 [lpfc]
  lpfc_disc_state_machine+0x7a/0x1e0 [lpfc]
  lpfc_cmpl_els_prli+0x16f/0x1e0 [lpfc]
  lpfc_sli_sp_handle_rspiocb+0x5b2/0x690 [lpfc]
  lpfc_sli_handle_slow_ring_event_s4+0x182/0x230 [lpfc]
  lpfc_do_work+0x87f/0x1570 [lpfc]
  kthread+0x10d/0x130
  ret_from_fork+0x35/0x40

During target side fault injections, it is possible to hit the
NLP_WAIT_FOR_UNREG case in lpfc_nvme_remoteport_delete. A prior commit
fixed a rebind and delete race condition, but called lpfc_nlp_put
unconditionally. This triggered a deletion and the crash.

Fix by movng nlp_put to inside the NLP_WAIT_FOR_UNREG case, where the nlp
will be being unregistered/removed. Leave the reference if the flag isn't
set.

Link: https://lore.kernel.org/r/20200322181304.37655-8-jsmart2021@gmail.com
Fixes: b15bd3e6212e ("scsi: lpfc: Fix nvme remoteport registration race conditions")
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index f6c8963c915d4..32b28651039e0 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -382,13 +382,15 @@ lpfc_nvme_remoteport_delete(struct nvme_fc_remote_port *remoteport)
 	if (ndlp->upcall_flags & NLP_WAIT_FOR_UNREG) {
 		ndlp->nrport = NULL;
 		ndlp->upcall_flags &= ~NLP_WAIT_FOR_UNREG;
-	}
-	spin_unlock_irq(&vport->phba->hbalock);
+		spin_unlock_irq(&vport->phba->hbalock);
 
-	/* Remove original register reference. The host transport
-	 * won't reference this rport/remoteport any further.
-	 */
-	lpfc_nlp_put(ndlp);
+		/* Remove original register reference. The host transport
+		 * won't reference this rport/remoteport any further.
+		 */
+		lpfc_nlp_put(ndlp);
+	} else {
+		spin_unlock_irq(&vport->phba->hbalock);
+	}
 
  rport_err:
 	return;
-- 
2.20.1

