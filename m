From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 5/4] scsi: remove MSG_*_TAG defines
Date: Fri, 28 Nov 2014 10:58:58 +0100
Message-ID: <54784762.8020304@acm.org>
References: <1416839781-26988-1-git-send-email-hch@lst.de> <20141124150725.GA23165@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sf1.bxl.stone.is ([87.238.167.36]:41041 "EHLO sf1.bxl.stone.is"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbaK1KrV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Nov 2014 05:47:21 -0500
In-Reply-To: <20141124150725.GA23165@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org
Cc: Doug Ledford <dledford@redhat.com>

On 11/24/14 16:07, Christoph Hellwig wrote:
> index 6719a33..2c5ce48 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -7921,9 +7921,9 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
>   	 */
>   	if ((asc_dvc->cur_dvc_qng[scp->device->id] > 0) &&
>   	    (boardp->reqcnt[scp->device->id] % 255) == 0) {
> -		asc_scsi_q->q2.tag_code = MSG_ORDERED_TAG;
> +		asc_scsi_q->q2.tag_code = ORDERED_QUEUE_TAG;
>   	} else {
> -		asc_scsi_q->q2.tag_code = MSG_SIMPLE_TAG;
> +		asc_scsi_q->q2.tag_code = SIMPLE_QUEUE_TAG;
>   	}
>
>   	/* Build ASC_SCSI_Q */
> @@ -8351,7 +8351,7 @@ static int AscPutReadyQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq, uchar q_no)
>   	}
>   	q_addr = ASC_QNO_TO_QADDR(q_no);
>   	if ((scsiq->q1.target_id & asc_dvc->use_tagged_qng) == 0) {
> -		scsiq->q2.tag_code &= ~MSG_SIMPLE_TAG;
> +		scsiq->q2.tag_code &= ~SIMPLE_QUEUE_TAG;
>   	}
>   	scsiq->q1.status = QS_FREE;
>   	AscMemWordCopyPtrToLram(iop_base,
> @@ -8669,7 +8669,7 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
>   		}
>   	}
>   	if (disable_syn_offset_one_fix) {
> -		scsiq->q2.tag_code &= ~MSG_SIMPLE_TAG;
> +		scsiq->q2.tag_code &= ~SIMPLE_QUEUE_TAG;
>   		scsiq->q2.tag_code |= (ASC_TAG_FLAG_DISABLE_ASYN_USE_SYN_FIX |
>   				       ASC_TAG_FLAG_DISABLE_DISCONNECT);
>   	} else {

One of the statements in advansys.c (tag_code &= 0xDC) makes assumptions 
about the numeric value of MSG_SIMPLE_TAG. This makes me wonder whether 
it is safe to change MSG_SIMPLE_TAG into another value ?

Bart.
