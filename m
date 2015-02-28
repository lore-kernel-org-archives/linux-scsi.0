From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH V2 3/4] be2iscsi : Fix memory leak in the unload path
Date: Sat, 28 Feb 2015 15:13:12 -0600
Message-ID: <54F22F68.4010502@cs.wisc.edu>
References: <c943192d-954f-4f3a-bb3a-ca527164c9a0@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47962 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756AbbB1VNU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Feb 2015 16:13:20 -0500
In-Reply-To: <c943192d-954f-4f3a-bb3a-ca527164c9a0@CMEXHTCAS1.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Soni Jose <sony.john-n@emulex.com>, linux-scsi@vger.kernel.org
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

On 12/19/14, 6:53 PM, John Soni Jose wrote:
>   Driver was not freeing the DMA memory allocated for EQ/CQ in the
>   unload path. This patch frees the DMA memory during the driver unload.
>
> Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
> Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> ---
>   drivers/scsi/be2iscsi/be_main.c |    8 ++++++--
>   1 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index 2f5eb9c..93c4d07 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -3748,8 +3748,10 @@ static void hwi_cleanup(struct beiscsi_hba *phba)
>
>   	for (i = 0; i < (phba->num_cpus); i++) {
>   		q = &phwi_context->be_cq[i];
> -		if (q->created)
> +		if (q->created) {
> +			be_queue_free(phba, q);
>   			beiscsi_cmd_q_destroy(ctrl, q, QTYPE_CQ);
> +		}
>   	}
>
>   	be_mcc_queues_destroy(phba);
> @@ -3759,8 +3761,10 @@ static void hwi_cleanup(struct beiscsi_hba *phba)
>   		eq_for_mcc = 0;
>   	for (i = 0; i < (phba->num_cpus + eq_for_mcc); i++) {
>   		q = &phwi_context->be_eq[i].q;
> -		if (q->created)
> +		if (q->created) {
> +			be_queue_free(phba, q);
>   			beiscsi_cmd_q_destroy(ctrl, q, QTYPE_EQ);
> +		}
>   	}
>   	be_cmd_fw_uninit(ctrl);
>   }
>

Why in this patch do you only call be_queue_free if q->created is set, 
but in be_mcc_queues_destroy you do not.
