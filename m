From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: lpfc: Modularize and cleanup FDMI code in driver
Date: Thu, 11 Feb 2016 10:07:33 -0500
Message-ID: <yq137sz5lqi.fsf@sermon.lab.mkp.net>
References: <20160201110129.GA24069@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47220 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbcBKPHi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2016 10:07:38 -0500
In-Reply-To: <20160201110129.GA24069@mwanda> (Dan Carpenter's message of "Mon,
	1 Feb 2016 14:01:29 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dick Kennedy <dick.kennedy@broadcom.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, james.smart@broadcom.com, linux-scsi@vger.kernel.org

>>>>> "Dan" == Dan Carpenter <dan.carpenter@oracle.com> writes:

Dick,

Please look into this...

---8<---

The patch 4258e98ee386: "lpfc: Modularize and cleanup FDMI code in
driver" from Dec 16, 2015, leads to the following static checker
warning:

	drivers/scsi/lpfc/lpfc_ct.c:2547 lpfc_fdmi_cmd()
	error: __memcpy() '&rh->rpl.pe' too small (4 vs 8)

drivers/scsi/lpfc/lpfc_ct.c
  2534          /* Next fill in the specific FDMI cmd information */
  2535          switch (cmdcode) {
  2536          case SLI_MGMT_RHAT:
  2537          case SLI_MGMT_RHBA:
  2538                  rh = (struct lpfc_fdmi_reg_hba *)&CtReq->un.PortID;
  2539                  /* HBA Identifier */
  2540                  memcpy(&rh->hi.PortName, &phba->pport->fc_sparam.portName,
  2541                         sizeof(struct lpfc_name));
  2542  
  2543                  if (cmdcode == SLI_MGMT_RHBA) {
  2544                          /* Registered Port List */
  2545                          /* One entry (port) per adapter */
  2546                          rh->rpl.EntryCnt = cpu_to_be32(1);
  2547                          memcpy(&rh->rpl.pe, &phba->pport->fc_sparam.portName,
                                       ^^^^^^^^^^^
.pe is a u32.

  2548                                 sizeof(struct lpfc_name));
                                       ^^^^^^^^^^^^^^^^^^^^^^^^
lpfc_name is an 8 byte union.

  2549  

regards,
dan carpenter

---8<---

-- 
Martin K. Petersen	Oracle Linux Engineering
