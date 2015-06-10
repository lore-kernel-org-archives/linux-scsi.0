From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: lpfc: Add support for ELS LCB.
Date: Wed, 10 Jun 2015 18:44:05 +0300
Message-ID: <20150610154405.GH10549@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43678 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964999AbbFJPoT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2015 11:44:19 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@avagotech.com
Cc: linux-scsi@vger.kernel.org

Hello James Smart,

The patch 8b017a30a313: "lpfc: Add support for ELS LCB." from May 21,
2015, leads to the following static checker warning:

	drivers/scsi/lpfc/lpfc_els.c:5243 lpfc_els_rcv_lcb()
	error: potential null dereference 'lcb_context'.  (kmalloc returns null)

drivers/scsi/lpfc/lpfc_els.c
  5205          if (phba->sli_rev < LPFC_SLI_REV4 ||
  5206              (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) !=
  5207              LPFC_SLI_INTF_IF_TYPE_2)) {
  5208                  rjt_err = LSRJT_CMD_UNSUPPORTED;
  5209                  goto rjt;
  5210          }
  5211          lcb_context = kmalloc(sizeof(struct lpfc_lcb_context), GFP_KERNEL);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
No check for allocation failure.

  5212  
  5213          if (phba->hba_flag & HBA_FCOE_MODE) {
  5214                  rjt_err = LSRJT_CMD_UNSUPPORTED;
  5215                  goto rjt;
  5216          }
  5217          if (beacon->lcb_frequency == 0) {
  5218                  rjt_err = LSRJT_CMD_UNSUPPORTED;
  5219                  goto rjt;
  5220          }
  5221          if ((beacon->lcb_type != LPFC_LCB_GREEN) &&
  5222              (beacon->lcb_type != LPFC_LCB_AMBER)) {

Also:
	drivers/scsi/lpfc/lpfc_els.c:5261 lpfc_els_rcv_lcb()
	warn: possible memory leak of 'lcb_context'

regards,
dan carpenter
