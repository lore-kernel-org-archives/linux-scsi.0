From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] scsi: lpfc: NVME Initiator: Merge into FC discovery
Date: Mon, 27 Feb 2017 19:34:29 +0300
Message-ID: <20170227163429.GA30640@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:22721 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751251AbdB0Qh3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2017 11:37:29 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v1RGarAm011746
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Mon, 27 Feb 2017 16:36:54 GMT
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsmart2021@gmail.com
Cc: linux-scsi@vger.kernel.org

Hello James Smart,

This is a semi-automatic email about new static checker warnings.

The patch a0f2d3ef374f: "scsi: lpfc: NVME Initiator: Merge into FC 
discovery" from Feb 12, 2017, leads to the following Smatch complaint:

drivers/scsi/lpfc/lpfc_ct.c:943 lpfc_cmpl_ct_cmd_gft_id()
	 error: we previously assumed 'ndlp' could be null (see line 928)

drivers/scsi/lpfc/lpfc_ct.c
   927			ndlp = lpfc_findnode_did(vport, did);
   928			if (ndlp) {
                            ^^^^
Check.

   929				/* The bitmask value for FCP and NVME FCP types is
   930				 * the same because they are 32 bits distant from
   931				 * each other in word0 and word0.
   932				 */
   933				if (fc4_data_0 & LPFC_FC4_TYPE_BITMASK)
   934					ndlp->nlp_fc4_type |= NLP_FC4_FCP;
   935				if (fc4_data_1 &  LPFC_FC4_TYPE_BITMASK)
   936					ndlp->nlp_fc4_type |= NLP_FC4_NVME;
   937				lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
   938						 "3064 Setting ndlp %p, DID x%06x with "
   939						 "FC4 x%08x, Data: x%08x x%08x\n",
   940						 ndlp, did, ndlp->nlp_fc4_type,
   941						 FC_TYPE_FCP, FC_TYPE_NVME);
   942			}
   943			ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
                        ^^^^^^^^^^^^^^^^^^^^
Not checked.

   944			lpfc_nlp_set_state(vport, ndlp, NLP_STE_PRLI_ISSUE);
   945			lpfc_issue_els_prli(vport, ndlp, 0);

	drivers/scsi/lpfc/lpfc_nvmet.c:1694 lpfc_nvmet_unsol_issue_abort()
	error: we previously assumed 'ndlp' could be null (see line 1690)

drivers/scsi/lpfc/lpfc_nvmet.c
  1688  
  1689          ndlp = lpfc_findnode_did(phba->pport, sid);
  1690          if (!ndlp || !NLP_CHK_NODE_ACT(ndlp) ||
                    ^^^^^
Check.

  1691              ((ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
  1692              (ndlp->nlp_state != NLP_STE_MAPPED_NODE))) {
  1693                  atomic_inc(&tgtp->xmt_abort_rsp_error);
  1694                  lpfc_printf_log(phba, KERN_WARNING, LOG_NVME_ABTS,
  1695                                  "6134 Drop ABTS - wrong NDLP state x%x.\n",
  1696                                  ndlp->nlp_state);
                                        ^^^^^^^^^^^^^^^
Potential Oops.

  1697  
  1698                  /* No failure to an ABTS request. */
  1699                  return 0;
  1700          }

	drivers/scsi/lpfc/lpfc_nvmet.c:1792 lpfc_nvmet_sol_fcp_issue_abort()
	error: we previously assumed 'ndlp' could be null (see line 1788)

drivers/scsi/lpfc/lpfc_nvmet.c
  1786  
  1787          ndlp = lpfc_findnode_did(phba->pport, sid);
  1788          if (!ndlp || !NLP_CHK_NODE_ACT(ndlp) ||
                    ^^^^^
Check.

  1789              ((ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
  1790              (ndlp->nlp_state != NLP_STE_MAPPED_NODE))) {
  1791                  atomic_inc(&tgtp->xmt_abort_rsp_error);
  1792                  lpfc_printf_log(phba, KERN_WARNING, LOG_NVME_ABTS,
  1793                                  "6160 Drop ABTS - wrong NDLP state x%x.\n",
  1794                                  ndlp->nlp_state);
                                        ^^^^^^^^^^^^^^^
Potential Oops.

  1795  
  1796                  /* No failure to an ABTS request. */
  1797                  return 0;
  1798          }

regards,
dan carpenter
