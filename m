Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D34371893;
	Fri, 20 Mar 2026 18:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774032278; cv=none; b=UqYmf9N822l3SX3tdT/zufDVmc43cXs/WQIuGFzE1lNI8+BuHQK/bEIioE6IJRghkzP2IB8QGtRVd6iCQm3Qb+McH81dA15PHoJI46WPhGZNYMOSmV/yPR1KGzyvYLZNG1s7PvuIcQlXBfRi+xw/R1/Js1TpfYaMqmeW4f/b5gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774032278; c=relaxed/simple;
	bh=7i1rG6PG3ykihkZ4yrVh8L2ubLbwcCmWgqmqTy9p6Cw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ufCr/3myLuMTP9XNd94NUcvXoyB/CI0oJloUX/I8H3pJyARN4Nd/7G4gut95TN/hV8zNNIMeEKfzJeZqi15zb2DultRsxvzGWk0Rs2TKtBxF8CPBVSXiOo+9WQQ1zVJWPHZiTyfCbtqo4MWnkZcO9ZGi6bjvkdlWVTWrB8C9H94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fcJSiQvC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fcJSiQvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B95AC4CEF7;
	Fri, 20 Mar 2026 18:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774032277;
	bh=7i1rG6PG3ykihkZ4yrVh8L2ubLbwcCmWgqmqTy9p6Cw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fcJSiQvCGOazbbWLMQqy4uX+ioUfJVNypjcpQPpi55y4aY+Yy65UDGNkd6hADB5Ad
	 GN3ax+Pc4JCK4YFQ2YR0fhbey6LotWnInFDVD8HUSmLpjc7ukdWF6aw/pVjX6wO0Ng
	 DaM6p6Sj/ZUw2jwQDHlCmc3Xdca+9LiZ+R0lxfiVkXaaR+6pGyHDrnQNz7GuiSdoVH
	 vwH9paTeEMxedU4Hq5+aYrCL2rQUoQNFXWf4/CfztE1xNUQEgFdt9/pHjR+5mt1nJG
	 xA8r8z6IMXrs/ykdBkoiw6Eo0Q8J1zMf3j9sPc4eb/TJp7gfwKsU3FdwpJZ9WFjIrK
	 pY8SBh0kGUJRA==
Date: Fri, 20 Mar 2026 11:44:37 -0700
From: Kees Cook <kees@kernel.org>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-scsi@vger.kernel.org, Ketan Mukadam <ketan.mukadam@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:KERNEL HARDENING (not covered by other areas):Keyword:b__counted_by(_le|_be)?b" <linux-hardening@vger.kernel.org>
Subject: Re: [PATCH] scsi: be2iscsi: kzalloc + kcalloc to kzalloc_flex
Message-ID: <202603201143.A1EABE5876@keescook>
References: <20260320010957.32355-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320010957.32355-1-rosenp@gmail.com>

On Thu, Mar 19, 2026 at 06:09:57PM -0700, Rosen Penev wrote:
> Simplifies allocation by using a flexible array member
> 
> Added __counted_by for extra runtime analysis.

This is make changes to 2 structs. For easier review, I'd split this
patch up. For the wrb_context change, perhaps explain why a __counted_by
is not added.

-Kees

> 
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  drivers/scsi/be2iscsi/be_main.c | 27 ++-------------------------
>  drivers/scsi/be2iscsi/be_main.h |  4 ++--
>  2 files changed, 4 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index fd18d4d3d219..782a21af01a3 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -2470,22 +2470,15 @@ static int beiscsi_alloc_mem(struct beiscsi_hba *phba)
>  	struct mem_array *mem_arr, *mem_arr_orig;
>  	unsigned int i, j, alloc_size, curr_alloc_size;
>  
> -	phba->phwi_ctrlr = kzalloc(phba->params.hwi_ws_sz, GFP_KERNEL);
> +	phba->phwi_ctrlr = kzalloc_flex(*phba->phwi_ctrlr, wrb_context, phba->params.cxns_per_ctrl);
>  	if (!phba->phwi_ctrlr)
>  		return -ENOMEM;
>  
>  	/* Allocate memory for wrb_context */
>  	phwi_ctrlr = phba->phwi_ctrlr;
> -	phwi_ctrlr->wrb_context = kzalloc_objs(struct hwi_wrb_context,
> -					       phba->params.cxns_per_ctrl);
> -	if (!phwi_ctrlr->wrb_context) {
> -		kfree(phba->phwi_ctrlr);
> -		return -ENOMEM;
> -	}
>  
>  	phba->init_mem = kzalloc_objs(*mem_descr, SE_MEM_MAX);
>  	if (!phba->init_mem) {
> -		kfree(phwi_ctrlr->wrb_context);
>  		kfree(phba->phwi_ctrlr);
>  		return -ENOMEM;
>  	}
> @@ -2493,7 +2486,6 @@ static int beiscsi_alloc_mem(struct beiscsi_hba *phba)
>  	mem_arr_orig = kmalloc_objs(*mem_arr_orig, BEISCSI_MAX_FRAGS_INIT);
>  	if (!mem_arr_orig) {
>  		kfree(phba->init_mem);
> -		kfree(phwi_ctrlr->wrb_context);
>  		kfree(phba->phwi_ctrlr);
>  		return -ENOMEM;
>  	}
> @@ -3992,25 +3984,12 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
>  
>  	for (ulp_num = 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++) {
>  		if (test_bit(ulp_num, (void *)&phba->fw_config.ulp_supported)) {
> -			ptr_cid_info = kzalloc_obj(struct ulp_cid_info);
> -
> +			ptr_cid_info = kzalloc_flex(*ptr_cid_info, cid_array, BEISCSI_GET_CID_COUNT(phba, ulp_num));
>  			if (!ptr_cid_info) {
>  				ret = -ENOMEM;
>  				goto free_memory;
>  			}
>  
> -			/* Allocate memory for CID array */
> -			ptr_cid_info->cid_array =
> -				kcalloc(BEISCSI_GET_CID_COUNT(phba, ulp_num),
> -					sizeof(*ptr_cid_info->cid_array),
> -					GFP_KERNEL);
> -			if (!ptr_cid_info->cid_array) {
> -				kfree(ptr_cid_info);
> -				ptr_cid_info = NULL;
> -				ret = -ENOMEM;
> -
> -				goto free_memory;
> -			}
>  			ptr_cid_info->avlbl_cids = BEISCSI_GET_CID_COUNT(
>  						   phba, ulp_num);
>  
> @@ -4061,7 +4040,6 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
>  			ptr_cid_info = phba->cid_array_info[ulp_num];
>  
>  			if (ptr_cid_info) {
> -				kfree(ptr_cid_info->cid_array);
>  				kfree(ptr_cid_info);
>  				phba->cid_array_info[ulp_num] = NULL;
>  			}
> @@ -4175,7 +4153,6 @@ static void beiscsi_cleanup_port(struct beiscsi_hba *phba)
>  			ptr_cid_info = phba->cid_array_info[ulp_num];
>  
>  			if (ptr_cid_info) {
> -				kfree(ptr_cid_info->cid_array);
>  				kfree(ptr_cid_info);
>  				phba->cid_array_info[ulp_num] = NULL;
>  			}
> diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
> index 71c95d144560..77c9b1a1a488 100644
> --- a/drivers/scsi/be2iscsi/be_main.h
> +++ b/drivers/scsi/be2iscsi/be_main.h
> @@ -241,10 +241,10 @@ struct hwi_wrb_context {
>  };
>  
>  struct ulp_cid_info {
> -	unsigned short *cid_array;
>  	unsigned short avlbl_cids;
>  	unsigned short cid_alloc;
>  	unsigned short cid_free;
> +	unsigned short cid_array[] __counted_by(avlbl_cids);
>  };
>  
>  #include "be.h"
> @@ -968,10 +968,10 @@ struct be_ring {
>  };
>  
>  struct hwi_controller {
> -	struct hwi_wrb_context *wrb_context;
>  	struct be_ring default_pdu_hdr[BEISCSI_ULP_COUNT];
>  	struct be_ring default_pdu_data[BEISCSI_ULP_COUNT];
>  	struct hwi_context_memory *phwi_ctxt;
> +	struct hwi_wrb_context wrb_context[];
>  };
>  
>  enum hwh_type_enum {
> -- 
> 2.53.0
> 

-- 
Kees Cook
