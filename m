From: Jayamohan Kallickal <Jayamohan.Kallickal@Emulex.Com>
Subject: RE: [PATCH 2/6] be2iscsi: relinquishing control after processing
 512 CQE
Date: Thu, 3 Apr 2014 05:02:55 +0000
Message-ID: <56a99ef4-a583-47ec-b6fc-b2e73fdd1547@CMEXHTCAS2.ad.emulex.com>
References: <1395938371-2149-1-git-send-email-Jayamohan.Kallickal@emulex.com>
 <1395938371-2149-2-git-send-email-Jayamohan.Kallickal@emulex.com>
 <5338FC37.8060906@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:22353 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932857AbaDCFC7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2014 01:02:59 -0400
In-Reply-To: <5338FC37.8060906@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Jayamohan Kallickal <jayamohank@gmail.com>
Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Minh Duc Tran <MinhDuc.Tran@Emulex.Com>, Sony John-N <Sony.John-N@Emulex.Com>



-----Original Message-----
From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
Sent: Sunday, March 30, 2014 10:25 PM
To: Jayamohan Kallickal
Cc: jbottomley@parallels.com; linux-scsi@vger.kernel.org; Jayamohan Kallickal; Minh Duc Tran; Sony John-N
Subject: Re: [PATCH 2/6] be2iscsi: relinquishing control after processing 512 CQE

On 03/27/2014 11:39 AM, Jayamohan Kallickal wrote:
> @@ -2323,14 +2319,33 @@ void beiscsi_process_all_cqs(struct 
> work_struct *work)
>  
>  static int be_iopoll(struct blk_iopoll *iop, int budget)  {
> -	unsigned int ret;
> +	unsigned int ret, num_eq_processed;
>  	struct beiscsi_hba *phba;
>  	struct be_eq_obj *pbe_eq;
> +	struct be_eq_entry *eqe = NULL;
> +	struct be_queue_info *eq;
>  
> +	num_eq_processed = 0;
>  	pbe_eq = container_of(iop, struct be_eq_obj, iopoll);
> +	phba = pbe_eq->phba;
> +	eq = &pbe_eq->q;
> +	eqe = queue_tail_node(eq);
> +
> +	hwi_ring_eq_db(phba, eq->id, 1, num_eq_processed, 0, 1);

>Is this right? num_eq_processed will be 0 above. Should this be moved down below to after num_eq_processed has been incremented?

I am unarming the interrupts so that we are not interrupted while in be_iopoll. So , this is fine

> +
> +	while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32]
> +			& EQE_VALID_MASK) {
> +
> +		AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
> +		queue_tail_inc(eq);
> +		eqe = queue_tail_node(eq);
> +		num_eq_processed++;
> +	}

