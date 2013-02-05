From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] lpfc 8.3.37: Provide support for FCoE protocol dual-chute
 (ULP) operation
Date: Tue, 5 Feb 2013 12:04:26 +0300
Message-ID: <20130205090425.GA5941@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25364 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab3BEJHJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2013 04:07:09 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org

Hello James Smart,

The patch 962bc51b04b2: "[SCSI] lpfc 8.3.37: Provide support for FCoE
protocol dual-chute (ULP) operation" from Jan 3, 2013, leads to the
following warning:
"drivers/scsi/lpfc/lpfc_sli.c:12818 lpfc_wq_create()
	 warn: 0x800 is larger than 8 bits"

[ This is from a not ready for release Smatch check. ]

drivers/scsi/lpfc/lpfc_sli.c
 12818          if (phba->sli4_hba.fw_func_mode & LPFC_DUA_MODE)
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
fw_func_mode is unsigned char.
LPFC_DUA_MODE is 0x800.
This condition is always false because 0xff & 0x800 is zero.

 12819                  bf_set(lpfc_mbx_wq_create_dua, &wq_create->u.request, 1);
 12820  
 12821          rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
 12822          /* The IOCTL status is embedded in the mailbox subheader. */
 12823          shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
 12824          shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
 12825          if (shdr_status || shdr_add_status || rc) {
 12826                  lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 12827                                  "2503 WQ_CREATE mailbox failed with "
 12828                                  "status x%x add_status x%x, mbx status x%x\n",
 12829                                  shdr_status, shdr_add_status, rc);
 12830                  status = -ENXIO;
 12831                  goto out;
 12832          }
 12833          wq->queue_id = bf_get(lpfc_mbx_wq_create_q_id, &wq_create->u.response);
 12834          if (wq->queue_id == 0xFFFF) {
 12835                  status = -ENXIO;
 12836                  goto out;
 12837          }
 12838          if (phba->sli4_hba.fw_func_mode & LPFC_DUA_MODE) {
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Same.

 12839                  wq->db_format = bf_get(lpfc_mbx_wq_create_db_format,
 12840                                         &wq_create->u.response);
 12841                  if ((wq->db_format != LPFC_DB_LIST_FORMAT) &&

regards,
dan carpenter

