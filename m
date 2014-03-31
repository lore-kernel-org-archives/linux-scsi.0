From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/6] be2iscsi: relinquishing control after processing
 512 CQE
Date: Mon, 31 Mar 2014 00:25:11 -0500
Message-ID: <5338FC37.8060906@cs.wisc.edu>
References: <1395938371-2149-1-git-send-email-Jayamohan.Kallickal@emulex.com> <1395938371-2149-2-git-send-email-Jayamohan.Kallickal@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:56273 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120AbaCaFZW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Mar 2014 01:25:22 -0400
In-Reply-To: <1395938371-2149-2-git-send-email-Jayamohan.Kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kallickal <jayamohank@gmail.com>
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, Jayamohan Kallickal <Jayamohan.Kallickal@emulex.com>, Minh Tran <minhduc.tran@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

On 03/27/2014 11:39 AM, Jayamohan Kallickal wrote:
> @@ -2323,14 +2319,33 @@ void beiscsi_process_all_cqs(struct work_struct *work)
>  
>  static int be_iopoll(struct blk_iopoll *iop, int budget)
>  {
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

Is this right? num_eq_processed will be 0 above. Should this be moved
down below to after num_eq_processed has been incremented?


> +
> +	while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32]
> +			& EQE_VALID_MASK) {
> +
> +		AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
> +		queue_tail_inc(eq);
> +		eqe = queue_tail_node(eq);
> +		num_eq_processed++;
> +	}

