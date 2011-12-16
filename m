From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] lpfc 8.3.28: Add support for ABTS failure handling
Date: Fri, 16 Dec 2011 23:27:45 +0300
Message-ID: <20111216202745.GE18570@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:20912 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760471Ab1LPU1v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Dec 2011 15:27:51 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org

Hello James Smart,

This is a semi-automatic email about new static checker warnings.

The patch cb69f7decc37: "[SCSI] lpfc 8.3.28: Add support for ABTS 
failure handling" from Dec 13, 2011, leads to the following Smatch 
complaint:

drivers/scsi/lpfc/lpfc_sli.c +8391 lpfc_sli4_abts_err_handler()
	 error: we previously assumed 'ndlp' could be null (see line 8387)

drivers/scsi/lpfc/lpfc_sli.c
  8386	
  8387		if (!ndlp || !NLP_CHK_NODE_ACT(ndlp))
                    ^^^^^
New check.

  8388			lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
  8389					"3115 Node Context not found, driver "
  8390					"ignoring abts err event\n");
  8391		vport = ndlp->vport;
                        ^^^^^^^^^^^
New dereference.  Maybe the intent was to return after the print
statement?

  8392		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
  8393				"3116 Port generated FCP XRI ABORT event on "

regards,
dan carpenter

