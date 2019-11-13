Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBB52C17447
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 03:17:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 880B5222C2
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 03:17:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bvh348oJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbfKMDRL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 22:17:11 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38394 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727100AbfKMDRK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 22:17:10 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD39ubg106447;
        Wed, 13 Nov 2019 03:17:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=sZV6H98v0HPlnhfbrGjgaNH6H6SgCrfRRbDmLCVnuUM=;
 b=bvh348oJKNxw0e2166NUEHOHJW/hnhEIJsJqCroLg/mdp4hMYmFpGO+nr8RYHOhbaP5T
 f5TBNdxf435Rg0RkddIPcN1sHXPpB7l1U3EKikYycVpIKXH9IUDC4QyvnFMA5luRxWEF
 vAXMTrBGwJaK5zp83Q5wAjqBaG6VmPPyKRkAIUihbBXM+mGRHe0dVkZgL4Oy4nKwP/Xt
 RQKqNssYC3hGQ4ZZlhVKa1CoRwCB+gqgM+8Qx+NXX7HrLtM4rG1+w2pUjvljjjo2O3Rt
 zynT4UgGRy6txkvpLvVvRzLNsx/f2yPEqyxVyFcplYzTXTmLdsS/GZ41FJOQtW+QWJ5C GQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w5mvts866-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 03:17:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD39D5u179641;
        Wed, 13 Nov 2019 03:15:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2w7vbc1wa5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 03:15:04 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAD3F3IB001063;
        Wed, 13 Nov 2019 03:15:03 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Nov 2019 19:15:03 -0800
To:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Cc:     Daniel Wagner <dwagner@suse.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: Move work items to a stack list
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191105080855.16881-1-dwagner@suse.de>
Date:   Tue, 12 Nov 2019 22:15:00 -0500
In-Reply-To: <20191105080855.16881-1-dwagner@suse.de> (Daniel Wagner's message
        of "Tue, 5 Nov 2019 09:08:55 +0100")
Message-ID: <yq1h838pivf.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911130026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911130026
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James/Dick: Please review!

> Move all work items to a list which lives on the stack while holding
> the corresponding lock.
>
> With this we avoid a race between testing if the list is empty and
> extracting an element of the list. Although, the list_remove_head()
> macro tests will return an NULL pointer if the list is empty the two
> functions lpfc_sli_handle_slow_ring_event_s4() and
> lpfc_sli4_els_xri_abort_event_proc() do not test the return element if
> it's NULL.
>
> Instead adding another test if the pointer is NULL just avoid this
> access pattern by using the stack list. This also avoids toggling the
> interrupts on/off for every item.
>
> Fixes: 4f774513f7b3 ("[SCSI] lpfc 8.3.2 : Addition of SLI4 Interface - Queues")
> Cc: James Smart <james.smart@broadcom.com>
> Cc: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
>
> Hi,
>
> While trying to understand what's going on in the Oops below I figured
> that it could be the result of the invalid pointer access. The patch
> still needs testing by our customer but indepent of this I think the
> patch fixes a real bug.
>
> [  139.392029] general protection fault: 0000 [#1] SMP PTI
> [  139.397862] CPU: 5 PID: 998 Comm: kworker/5:13 Tainted: G                   4.12.14-226.g94364da-default #1 SLE15-SP1 (unreleased)
> [  139.410962] Hardware name: Dell Inc. PowerEdge R730/072T6D, BIOS 2.9.1 12/04/2018
> [  139.419339] Workqueue: lpfc_wq lpfc_sli4_hba_process_cq [lpfc]
> [  139.425847] task: ffff95c996051440 task.stack: ffffaa038601c000
> [  139.432459] RIP: 0010:lpfc_set_rrq_active+0xa6/0x2a0 [lpfc]
> [  139.438676] RSP: 0018:ffffaa038601fcf8 EFLAGS: 00010046
> [  139.444504] RAX: 0000000000000292 RBX: ffff95c5a9a0a000 RCX: 000000000000ffff
> [  139.452466] RDX: ffff95c5accbb7b8 RSI: 0064695f74726f70 RDI: ffff95c5a9a0b160
> [  139.460427] RBP: ffff95c5a9a0b160 R08: 0000000000000001 R09: 0000000000000002
> [  139.468389] R10: ffffaa038601fdd8 R11: 61c8864680b583eb R12: 0000000000000001
> [  139.476350] R13: 000000000000ffff R14: 00000000000002bb R15: 0064695f74726f70
> [  139.484311] FS:  0000000000000000(0000) GS:ffff95c9bfc80000(0000) knlGS:0000000000000000
> [  139.493340] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  139.499749] CR2: 0000560354607098 CR3: 00000007a000a003 CR4: 00000000001606e0
> [  139.507711] Call Trace:
> [  139.510451]  lpfc_sli4_io_xri_aborted+0x1a7/0x250 [lpfc]
> [  139.516386]  lpfc_sli4_sp_handle_abort_xri_wcqe.isra.56+0xa0/0x180 [lpfc]
> [  139.523964]  ? __switch_to_asm+0x40/0x70
> [  139.528338]  ? __switch_to_asm+0x34/0x70
> [  139.532718]  ? lpfc_sli4_fp_handle_cqe+0xc3/0x450 [lpfc]
> [  139.538649]  lpfc_sli4_fp_handle_cqe+0xc3/0x450 [lpfc]
> [  139.544383]  ? __switch_to_asm+0x34/0x70
> [  139.548762]  __lpfc_sli4_process_cq+0xea/0x220 [lpfc]
> [  139.554393]  ? lpfc_sli4_sp_handle_abort_xri_wcqe.isra.56+0x180/0x180 [lpfc]
> [  139.562557]  __lpfc_sli4_hba_process_cq+0x29/0xc0 [lpfc]
> [  139.568486]  process_one_work+0x1da/0x400
> [  139.572959]  worker_thread+0x2b/0x3f0
> [  139.577044]  ? process_one_work+0x400/0x400
> [  139.581710]  kthread+0x113/0x130
> [  139.585310]  ? kthread_create_worker_on_cpu+0x50/0x50
> [  139.590945]  ret_from_fork+0x35/0x40
>
> Thanks,
> Daniel
>
>  drivers/scsi/lpfc/lpfc_sli.c | 32 ++++++++++++++++++++++----------
>  1 file changed, 22 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 294f041961a8..cbeb1f408ccc 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -3903,16 +3903,16 @@ lpfc_sli_handle_slow_ring_event_s4(struct lpfc_hba *phba,
>  	struct lpfc_cq_event *cq_event;
>  	unsigned long iflag;
>  	int count = 0;
> +	LIST_HEAD(work_list);
>  
>  	spin_lock_irqsave(&phba->hbalock, iflag);
>  	phba->hba_flag &= ~HBA_SP_QUEUE_EVT;
> +	list_splice_init(&phba->sli4_hba.sp_queue_event, &work_list);
>  	spin_unlock_irqrestore(&phba->hbalock, iflag);
> -	while (!list_empty(&phba->sli4_hba.sp_queue_event)) {
> +	while (!list_empty(&work_list)) {
>  		/* Get the response iocb from the head of work queue */
> -		spin_lock_irqsave(&phba->hbalock, iflag);
> -		list_remove_head(&phba->sli4_hba.sp_queue_event,
> -				 cq_event, struct lpfc_cq_event, list);
> -		spin_unlock_irqrestore(&phba->hbalock, iflag);
> +		list_remove_head(&work_list, cq_event,
> +				 struct lpfc_cq_event, list);
>  
>  		switch (bf_get(lpfc_wcqe_c_code, &cq_event->cqe.wcqe_cmpl)) {
>  		case CQE_CODE_COMPL_WQE:
> @@ -3941,6 +3941,17 @@ lpfc_sli_handle_slow_ring_event_s4(struct lpfc_hba *phba,
>  		if (count == 64)
>  			break;
>  	}
> +
> +	/*
> +	 * If the limit stops the processing of events, move the
> +	 * remaining events back to the main event queue.
> +	 */
> +	spin_lock_irqsave(&phba->hbalock, iflag);
> +	if (!list_empty(&work_list)) {
> +		phba->hba_flag |= HBA_SP_QUEUE_EVT;
> +		list_splice(&work_list, &phba->sli4_hba.sp_queue_event);
> +	}
> +	spin_unlock_irqrestore(&phba->hbalock, iflag);
>  }
>  
>  /**
> @@ -12877,18 +12888,19 @@ lpfc_sli_intr_handler(int irq, void *dev_id)
>  void lpfc_sli4_els_xri_abort_event_proc(struct lpfc_hba *phba)
>  {
>  	struct lpfc_cq_event *cq_event;
> +	LIST_HEAD(work_list);
>  
>  	/* First, declare the els xri abort event has been handled */
>  	spin_lock_irq(&phba->hbalock);
>  	phba->hba_flag &= ~ELS_XRI_ABORT_EVENT;
> +	list_splice_init(&phba->sli4_hba.sp_els_xri_aborted_work_queue,
> +			 &work_list);
>  	spin_unlock_irq(&phba->hbalock);
>  	/* Now, handle all the els xri abort events */
> -	while (!list_empty(&phba->sli4_hba.sp_els_xri_aborted_work_queue)) {
> +	while (!list_empty(&work_list)) {
>  		/* Get the first event from the head of the event queue */
> -		spin_lock_irq(&phba->hbalock);
> -		list_remove_head(&phba->sli4_hba.sp_els_xri_aborted_work_queue,
> -				 cq_event, struct lpfc_cq_event, list);
> -		spin_unlock_irq(&phba->hbalock);
> +		list_remove_head(&work_list, cq_event,
> +				 struct lpfc_cq_event, list);
>  		/* Notify aborted XRI for ELS work queue */
>  		lpfc_sli4_els_xri_aborted(phba, &cq_event->cqe.wcqe_axri);
>  		/* Free the event processed back to the free pool */

-- 
Martin K. Petersen	Oracle Linux Engineering
