From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] scsi: lpfc: NVME Target: Base modifications
Date: Mon, 27 Feb 2017 19:48:48 +0300
Message-ID: <20170227164848.GA30526@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48904 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751538AbdB0QtM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2017 11:49:12 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsmart2021@gmail.com
Cc: linux-scsi@vger.kernel.org

Hello James Smart,

This is a semi-automatic email about new static checker warnings.

The patch f358dd0ca26c: "scsi: lpfc: NVME Target: Base modifications" 
from Feb 12, 2017, leads to the following Smatch complaint:

drivers/scsi/lpfc/lpfc_mem.c:650 lpfc_sli4_nvmet_alloc()
	 warn: variable dereferenced before check 'dma_buf->iocbq' (see line 649)

drivers/scsi/lpfc/lpfc_mem.c
   648		dma_buf->iocbq = lpfc_sli_get_iocbq(phba);
   649		dma_buf->iocbq->iocb_flag = LPFC_IO_NVMET;
                ^^^^^^^^^^^^^^^^^^^^^^^^^
Dereference.

   650		if (!dma_buf->iocbq) {
                     ^^^^^^^^^^^^^^
Check.

   651			kfree(dma_buf->context);
   652			pci_pool_free(phba->lpfc_drb_pool, dma_buf->dbuf.virt,

regards,
dan carpenter
