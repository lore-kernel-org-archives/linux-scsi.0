From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: lpfc: Add support for RDP ELS command.
Date: Wed, 10 Jun 2015 18:43:26 +0300
Message-ID: <20150610154326.GG10549@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43239 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965578AbbFJPnj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2015 11:43:39 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@avagotech.com
Cc: linux-scsi@vger.kernel.org

Hello James Smart,

The patch 86478875eb4d: "lpfc: Add support for RDP ELS command." from
May 21, 2015, leads to the following static checker warning:

	drivers/scsi/lpfc/lpfc_mbox.c:2307 lpfc_mbx_cmpl_rdp_page_a2()
	error: dereferencing freed memory 'mp'

drivers/scsi/lpfc/lpfc_mbox.c
  2279  void
  2280  lpfc_mbx_cmpl_rdp_page_a2(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
  2281  {
  2282          struct lpfc_dmabuf *mp = (struct lpfc_dmabuf *) mbox->context1;
  2283          struct lpfc_rdp_context *rdp_context =
  2284                          (struct lpfc_rdp_context *)(mbox->context2);
  2285  
  2286          if (bf_get(lpfc_mqe_status, &mbox->u.mqe))
  2287                  goto error;
  2288  
  2289          lpfc_sli_bemem_bcopy(mp->virt, &rdp_context->page_a2,
  2290                                  DMP_SFF_PAGE_A2_SIZE);
  2291  
  2292          /* We don't need dma buffer for link stat. */
  2293          lpfc_mbuf_free(phba, mp->virt, mp->phys);
  2294          kfree(mp);
                ^^^^^^^^
  2295  
  2296          memset(mbox, 0, sizeof(*mbox));
  2297          lpfc_read_lnk_stat(phba, mbox);
  2298          mbox->vport = rdp_context->ndlp->vport;
  2299          mbox->mbox_cmpl = lpfc_mbx_cmpl_rdp_link_stat;
  2300          mbox->context2 = (struct lpfc_rdp_context *) rdp_context;
  2301          if (lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT) == MBX_NOT_FINISHED)
  2302                  goto error;
                        ^^^^^^^^^^
  2303  
  2304          return;
  2305  
  2306  error:
  2307          lpfc_mbuf_free(phba, mp->virt, mp->phys);
                                     ^^^^^^^^
  2308          kfree(mp);
                ^^^^^^^^^
  2309          lpfc_sli4_mbox_cmd_free(phba, mbox);
  2310          rdp_context->cmpl(phba, rdp_context, FAILURE);
  2311  }



regards,
dan carpenter
