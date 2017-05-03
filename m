From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] scsi: lpfc: NVME Initiator: Merge into FC discovery
Date: Thu, 4 May 2017 00:21:47 +0300
Message-ID: <20170503212147.q7myatlilhreq2kf@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49886 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750716AbdECVV5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 May 2017 17:21:57 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsmart2021@gmail.com
Cc: linux-scsi@vger.kernel.org

Hello James Smart,

This is a semi-automatic email about new static checker warnings.

The patch a0f2d3ef374f: "scsi: lpfc: NVME Initiator: Merge into FC
discovery" from Feb 12, 2017, leads to the following Smatch complaint:

drivers/scsi/lpfc/lpfc_ct.c:982 lpfc_cmpl_ct_cmd_gft_id()
	 error: we previously assumed 'ndlp' could be null (see line 966)

drivers/scsi/lpfc/lpfc_ct.c
   965			ndlp = lpfc_findnode_did(vport, did);
   966			if (ndlp) {
                            ^^^^
Check.

   967				/* The bitmask value for FCP and NVME FCP types is
   968				 * the same because they are 32 bits distant from
   969				 * each other in word0 and word0.
   970				 */
   971				if (fc4_data_0 & LPFC_FC4_TYPE_BITMASK)
   972					ndlp->nlp_fc4_type |= NLP_FC4_FCP;
   973				if (fc4_data_1 &  LPFC_FC4_TYPE_BITMASK)
   974					ndlp->nlp_fc4_type |= NLP_FC4_NVME;
   975				lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
   976						 "3064 Setting ndlp %p, DID x%06x with "
   977						 "FC4 x%08x, Data: x%08x x%08x\n",
   978						 ndlp, did, ndlp->nlp_fc4_type,
   979						 FC_TYPE_FCP, FC_TYPE_NVME);
   980				ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
   981			}
   982			lpfc_nlp_set_state(vport, ndlp, NLP_STE_PRLI_ISSUE);
                                                  ^^^^
Dereferenced inside the function call.

   983			lpfc_issue_els_prli(vport, ndlp, 0);
   984		} else

regards,
dan carpenter
