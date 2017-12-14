From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] scsi: lpfc: Correct driver deregistrations with host
 nvme transport
Date: Thu, 14 Dec 2017 10:58:37 +0300
Message-ID: <20171214075837.bb33pzf5k3xpglnu@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:46178 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750785AbdLNIJI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Dec 2017 03:09:08 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsmart2021@gmail.com
Cc: linux-scsi@vger.kernel.org

Hello James Smart,

This is a semi-automatic email about new static checker warnings.

The patch add9d6be3d65: "scsi: lpfc: Correct driver deregistrations
with host nvme transport" from Nov 20, 2017, leads to the following
Smatch complaint:

    drivers/scsi/lpfc/lpfc_nvme.c:969 lpfc_nvme_io_cmd_wqe_cmpl()
    error: we previously assumed 'ndlp' could be null (see line 938)

drivers/scsi/lpfc/lpfc_nvme.c
   937	
   938		if (ndlp && NLP_CHK_NODE_ACT(ndlp))
                    ^^^^
Existing code assumes ndlp can be NULL.

   939			atomic_dec(&ndlp->cmd_pending);
   940	
   941		/* Update stats and complete the IO.  There is
   942		 * no need for dma unprep because the nvme_transport
   943		 * owns the dma address.
   944		 */
   945	#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
   946		if (lpfc_ncmd->ts_cmd_start) {
   947			lpfc_ncmd->ts_isr_cmpl = pwqeIn->isr_timestamp;
   948			lpfc_ncmd->ts_data_nvme = ktime_get_ns();
   949			phba->ktime_last_cmd = lpfc_ncmd->ts_data_nvme;
   950			lpfc_nvme_ktime(phba, lpfc_ncmd);
   951		}
   952		if (phba->cpucheck_on & LPFC_CHECK_NVME_IO) {
   953			if (lpfc_ncmd->cpu != smp_processor_id())
   954				lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_IOERR,
   955						 "6701 CPU Check cmpl: "
   956						 "cpu %d expect %d\n",
   957						 smp_processor_id(), lpfc_ncmd->cpu);
   958			if (lpfc_ncmd->cpu < LPFC_CHECK_CPU_CNT)
   959				phba->cpucheck_cmpl_io[lpfc_ncmd->cpu]++;
   960		}
   961	#endif
   962		freqpriv = nCmd->private;
   963		freqpriv->nvme_buf = NULL;
   964	
   965		/* NVME targets need completion held off until the abort exchange
   966		 * completes unless the NVME Rport is getting unregistered.
   967		 */
   968		if (!(lpfc_ncmd->flags & LPFC_SBUF_XBUSY) ||
   969		    ndlp->upcall_flags & NLP_WAIT_FOR_UNREG) {
                    ^^^^^^^^^^^^^^^^^
The patch adds an unchecked dereference.

   970			/* Clear the XBUSY flag to prevent double completions.
   971			 * The nvme rport is getting unregistered and there is

regards,
dan carpenter
