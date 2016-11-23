From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH] lpfc: fix oops/BUG in lpfc_sli_ringtxcmpl_put()
Date: Wed, 23 Nov 2016 10:33:19 -0200
Message-ID: <1479904399-19496-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38746 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933392AbcKWMda (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Nov 2016 07:33:30 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uANCT3ZR002775
        for <linux-scsi@vger.kernel.org>; Wed, 23 Nov 2016 07:33:29 -0500
Received: from e24smtp02.br.ibm.com (e24smtp02.br.ibm.com [32.104.18.86])
        by mx0b-001b2d01.pphosted.com with ESMTP id 26wb2hrdae-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 23 Nov 2016 07:33:29 -0500
Received: from localhost
        by e24smtp02.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Wed, 23 Nov 2016 10:33:27 -0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@broadcom.com, martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The BUG_ON() recently introduced in lpfc_sli_ringtxcmpl_put()
is hit in the lpfc_els_abort() > lpfc_sli_issue_abort_iotag()
 > lpfc_sli_abort_iotag_issue() function path [similar names],
due to 'piocb->vport == NULL':

	BUG_ON(!piocb || !piocb->vport);

This happens because lpfc_sli_abort_iotag_issue() doesn't set
the 'abtsiocbp->vport' pointer -- but this is not the problem.

Previously, lpfc_sli_ringtxcmpl_put() accessed 'piocb->vport'
only if 'piocb->iocb.ulpCommand' is neither CMD_ABORT_XRI_CN
nor CMD_CLOSE_XRI_CN, which are the only possible values for
lpfc_sli_abort_iotag_issue():

    lpfc_sli_ringtxcmpl_put():

        if ((unlikely(pring->ringno == LPFC_ELS_RING)) &&
           (piocb->iocb.ulpCommand != CMD_ABORT_XRI_CN) &&
           (piocb->iocb.ulpCommand != CMD_CLOSE_XRI_CN) &&
            (!(piocb->vport->load_flag & FC_UNLOADING)))

    lpfc_sli_abort_iotag_issue():

        if (phba->link_state >= LPFC_LINK_UP)
                iabt->ulpCommand = CMD_ABORT_XRI_CN;
        else
                iabt->ulpCommand = CMD_CLOSE_XRI_CN;

So, this function path would not have hit this possible NULL
pointer dereference before.

In order to fix this regression, move the second part of the
BUG_ON() check prior to the pointer dereference that it does
check for.

For reference, this is the stack trace observed. The problem
happened because an unsolicited event was received - a PLOGI
was received after our PLOGI was issued but not yet complete,
so the discovery state machine goes on to sw-abort our PLOGI.

    kernel BUG at drivers/scsi/lpfc/lpfc_sli.c:1326!
    Oops: Exception in kernel mode, sig: 5 [#1]
    <...>
    NIP [...] lpfc_sli_ringtxcmpl_put+0x1c/0xf0 [lpfc]
    LR  [...] __lpfc_sli_issue_iocb_s4+0x188/0x200 [lpfc]
    Call Trace:
    [...] [...] __lpfc_sli_issue_iocb_s4+0xb0/0x200 [lpfc] (unreliable)
    [...] [...] lpfc_sli_issue_abort_iotag+0x2b4/0x350 [lpfc]
    [...] [...] lpfc_els_abort+0x1a8/0x4a0 [lpfc]
    [...] [...] lpfc_rcv_plogi+0x6d4/0x700 [lpfc]
    [...] [...] lpfc_rcv_plogi_plogi_issue+0xd8/0x1d0 [lpfc]
    [...] [...] lpfc_disc_state_machine+0xc0/0x2b0 [lpfc]
    [...] [...] lpfc_els_unsol_buffer+0xcc0/0x26c0 [lpfc]
    [...] [...] lpfc_els_unsol_event+0xa8/0x220 [lpfc]
    [...] [...] lpfc_complete_unsol_iocb+0xb8/0x138 [lpfc]
    [...] [...] lpfc_sli4_handle_received_buffer+0x6a0/0xec0 [lpfc]
    [...] [...] lpfc_sli_handle_slow_ring_event_s4+0x1c4/0x240 [lpfc]
    [...] [...] lpfc_sli_handle_slow_ring_event+0x24/0x40 [lpfc]
    [...] [...] lpfc_do_work+0xd88/0x1970 [lpfc]
    [...] [...] kthread+0x108/0x130
    [...] [...] ret_from_kernel_thread+0x5c/0xbc
    <...>

Cc: stable@vger.kernel.org # v4.8
Fixes: 22466da5b4b7 ("lpfc: Fix possible NULL pointer dereference")
Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index c5326055beee..f4f77c5b0c83 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1323,18 +1323,20 @@ struct lpfc_iocbq *
 {
 	lockdep_assert_held(&phba->hbalock);
 
-	BUG_ON(!piocb || !piocb->vport);
+	BUG_ON(!piocb);
 
 	list_add_tail(&piocb->list, &pring->txcmplq);
 	piocb->iocb_flag |= LPFC_IO_ON_TXCMPLQ;
 
 	if ((unlikely(pring->ringno == LPFC_ELS_RING)) &&
 	   (piocb->iocb.ulpCommand != CMD_ABORT_XRI_CN) &&
-	   (piocb->iocb.ulpCommand != CMD_CLOSE_XRI_CN) &&
-	    (!(piocb->vport->load_flag & FC_UNLOADING)))
-		mod_timer(&piocb->vport->els_tmofunc,
-			  jiffies +
-			  msecs_to_jiffies(1000 * (phba->fc_ratov << 1)));
+	   (piocb->iocb.ulpCommand != CMD_CLOSE_XRI_CN)) {
+		BUG_ON(!piocb->vport);
+		if (!(piocb->vport->load_flag & FC_UNLOADING))
+			mod_timer(&piocb->vport->els_tmofunc,
+				  jiffies +
+				  msecs_to_jiffies(1000 * (phba->fc_ratov << 1)));
+	}
 
 	return 0;
 }
-- 
1.8.3.1

