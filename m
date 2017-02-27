From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] scsi: lpfc: NVME Initiator: Base modifications
Date: Mon, 27 Feb 2017 18:55:44 +0300
Message-ID: <20170227155544.GA29033@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:50631 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751327AbdB0P62 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2017 10:58:28 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v1RFvWwV021493
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Mon, 27 Feb 2017 15:57:34 GMT
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsmart2021@gmail.com
Cc: linux-scsi@vger.kernel.org

Hello James Smart,

The patch 895427bd012c: "scsi: lpfc: NVME Initiator: Base
modifications" from Feb 12, 2017, leads to the following static
checker warning:

[  Heck...  I just decided to report all the static checker warnings for
   this file.  - dan ]

	drivers/scsi/lpfc/lpfc_hbadisc.c:316 lpfc_dev_loss_tmo_handler()
	warn: we tested 'vport->load_flag & 2' before and it was 'false'

   248          /* Don't defer this if we are in the process of deleting the vport
   249           * or unloading the driver. The unload will cleanup the node
   250           * appropriately we just need to cleanup the ndlp rport info here.
   251           */
   252          if (vport->load_flag & FC_UNLOADING) {
   253                  if (ndlp->nlp_sid != NLP_NO_SID) {
   254                          /* flush the target */
   255                          lpfc_sli_abort_iocb(vport,
   256                                              &phba->sli.sli3_ring[LPFC_FCP_RING],
   257                                              ndlp->nlp_sid, 0, LPFC_CTX_TGT);
   258                  }
   259                  put_node = rdata->pnode != NULL;
   260                  rdata->pnode = NULL;
   261                  ndlp->rport = NULL;
   262                  if (put_node)
   263                          lpfc_nlp_put(ndlp);
   264                  put_device(&rport->dev);
   265  
   266                  return fcf_inuse;
   267          }

[ snip ]


   315  
   316          if (!(vport->load_flag & FC_UNLOADING) &&
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Delete this dead code.

   317              !(ndlp->nlp_flag & NLP_DELAY_TMO) &&
   318              !(ndlp->nlp_flag & NLP_NPR_2B_DISC) &&
   319              (ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
   320              (ndlp->nlp_state != NLP_STE_REG_LOGIN_ISSUE) &&  2201          /* Check the FCF record against the connection list */
   321              (ndlp->nlp_state != NLP_STE_PRLI_ISSUE))
   322                  lpfc_disc_state_machine(vport, ndlp, NULL, NLP_EVT_DEVICE_RM);
   323  
   324          return fcf_inuse;
   325  }

	drivers/scsi/lpfc/lpfc_hbadisc.c:701 lpfc_work_done()
	warn: test_bit() takes a bit number

   698                  if (pring->flag & LPFC_STOP_IOCB_EVENT) {
   699                          pring->flag |= LPFC_DEFERRED_RING_EVENT;
   700                          /* Set the lpfc data pending flag */
   701                          set_bit(LPFC_DATA_READY, &phba->data_flags);
                                        ^^^^^^^^^^^^^^^
Not harmful because 1 << 0 is still 1.  But still wrong.

   702                  } else {
   703                          if (phba->link_state >= LPFC_LINK_UP) {
   704                                  pring->flag &= ~LPFC_DEFERRED_RING_EVENT;
   705                                  lpfc_sli_handle_slow_ring_event(phba, pring,
   706                                                                  (status &
   707                                                                  HA_RXMASK));
   708                          }
   709                  }

	drivers/scsi/lpfc/lpfc_hbadisc.c:2206 lpfc_mbx_cmpl_fcf_scan_read_fcf_rec()
	error: uninitialized symbol 'vlan_id'.
	drivers/scsi/lpfc/lpfc_hbadisc.c:2582 lpfc_mbx_cmpl_fcf_rr_read_fcf_rec()
	error: uninitialized symbol 'vlan_id'.
	drivers/scsi/lpfc/lpfc_hbadisc.c:2683 lpfc_mbx_cmpl_read_fcf_rec() error:
	uninitialized symbol 'vlan_id'.

  2201          /* Check the FCF record against the connection list */
  2202          rc = lpfc_match_fcf_conn_list(phba, new_fcf_record, &boot_flag,
  2203                                        &addr_mode, &vlan_id);
  2204  
  2205          /* Log the FCF record information if turned on */
  2206          lpfc_sli4_log_fcf_record_info(phba, new_fcf_record, vlan_id,
                                                                    ^^^^^^^
Perhaps move this under the check for if (!rc) {?

  2207                                        next_fcf_index);
  2208  
  2209          /*
  2210           * If the fcf record does not match with connect list entries
  2211           * read the next entry; otherwise, this is an eligible FCF
  2212           * record for roundrobin FCF failover.
  2213           */
  2214          if (!rc) {
                    ^^^

	drivers/scsi/lpfc/lpfc_hbadisc.c:4025 lpfc_register_remote_port()
	error: we previously assumed 'rdata' could be null (see line 4023)

  4018          rport = ndlp->rport;
  4019          if (rport) {
  4020                  rdata = rport->dd_data;
  4021                  /* break the link before dropping the ref */
  4022                  ndlp->rport = NULL;
  4023                  if (rdata && rdata->pnode == ndlp)
                            ^^^^^
Check.

  4024                          lpfc_nlp_put(ndlp);
  4025                  rdata->pnode = NULL;
                        ^^^^^^^^^^^^
Unchecked.

  4026                  /* drop reference for earlier registeration */
  4027                  put_device(&rport->dev);
  4028          }

	drivers/scsi/lpfc/lpfc_hbadisc.c:4613 lpfc_sli4_dequeue_nport_iocbs()
	error: double unlock 'irq:'

drivers/scsi/lpfc/lpfc_hbadisc.c
  4597  static void
  4598  lpfc_sli4_dequeue_nport_iocbs(struct lpfc_hba *phba,
  4599                  struct lpfc_nodelist *ndlp, struct list_head *dequeue_list)
  4600  {
  4601          struct lpfc_sli_ring *pring;
  4602          struct lpfc_queue *qp = NULL;
  4603  
  4604          spin_lock_irq(&phba->hbalock);
  4605          list_for_each_entry(qp, &phba->sli4_hba.lpfc_wq_list, wq_list) {
  4606                  pring = qp->pring;
  4607                  if (!pring)
  4608                          continue;
  4609                  spin_lock_irq(&pring->ring_lock);
  4610                  __lpfc_dequeue_nport_iocbs(phba, ndlp, pring, dequeue_list);
  4611                  spin_unlock_irq(&pring->ring_lock);

spin_lock_irq() is not nestable.   It should just be
spin_lock(&pring->ring_lock); and we leave the IRQs as-is (locked).

  4612          }
  4613          spin_unlock_irq(&phba->hbalock);
  4614  }

regards,
dan carpenter
