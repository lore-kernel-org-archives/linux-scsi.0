From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] scsi: lpfc: Fix handling of FCP and NVME FC4 types in
 Pt2Pt topology
Date: Fri, 25 Aug 2017 00:10:12 +0300
Message-ID: <20170824211011.ik5uwrsph7a7nkqz@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51713 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753457AbdHXVK3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2017 17:10:29 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dick.kennedy@broadcom.com
Cc: linux-scsi@vger.kernel.org

Hello Dick Kennedy,

This is a semi-automatic email about new static checker warnings.

The patch 8fd5f79a9cf4: "scsi: lpfc: Fix handling of FCP and NVME FC4 
types in Pt2Pt topology" from Aug 23, 2017, leads to the following 
Smatch complaint:

drivers/scsi/lpfc/lpfc_els.c:2010 lpfc_issue_els_plogi()
	 error: we previously assumed 'ndlp' could be null (see line 1998)

drivers/scsi/lpfc/lpfc_els.c
  1997		ndlp = lpfc_findnode_did(vport, did);
  1998		if (ndlp && !NLP_CHK_NODE_ACT(ndlp))
  1999			ndlp = NULL;
                        ^^^^^^^^^^^
ndlp can be NULL.

  2000	
  2001		/* If ndlp is not NULL, we will bump the reference count on it */
  2002		cmdsize = (sizeof(uint32_t) + sizeof(struct serv_parm));
  2003		elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp, did,
  2004					     ELS_CMD_PLOGI);
  2005		if (!elsiocb)
  2006			return 1;
  2007	
  2008		shost = lpfc_shost_from_vport(vport);
  2009		spin_lock_irq(shost->host_lock);
  2010		ndlp->nlp_flag &= ~NLP_FCP_PRLI_RJT;
                ^^^^^^^^^^^^^^
We added a new unchecked dereference.

  2011		spin_unlock_irq(shost->host_lock);
  2012	

regards,
dan carpenter
