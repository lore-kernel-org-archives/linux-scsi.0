From: Sony John-N <Sony.John-N@Emulex.Com>
Subject: RE: [PATCH V2 3/4] be2iscsi : Fix memory leak in the unload path
Date: Wed, 4 Mar 2015 07:26:00 +0000
Message-ID: <2fe041b0-c4ab-4aa6-90bf-eb55a747f212@CMEXHTCAS1.ad.emulex.com>
References: <c943192d-954f-4f3a-bb3a-ca527164c9a0@CMEXHTCAS1.ad.emulex.com>
 <54F22F68.4010502@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:39105 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933459AbbCDH03 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2015 02:26:29 -0500
In-Reply-To: <54F22F68.4010502@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Jayamohan Kallickal <Jayamohan.Kallickal@Emulex.Com>



-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Mike Christie
Sent: Sunday, March 01, 2015 2:43 AM
To: Sony John-N; linux-scsi@vger.kernel.org
Cc: Jayamohan Kallickal
Subject: Re: [PATCH V2 3/4] be2iscsi : Fix memory leak in the unload path

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
> diff --git a/drivers/scsi/be2iscsi/be_main.c 
> b/drivers/scsi/be2iscsi/be_main.c index 2f5eb9c..93c4d07 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -3748,8 +3748,10 @@ static void hwi_cleanup(struct beiscsi_hba 
> *phba)
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

> Why in this patch do you only call be_queue_free if q->created is set, but in be_mcc_queues_destroy you do not.
 We missed doing the changes in be_mcc_queues_destroy(). We will fix this in the next-patchset release.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
