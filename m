Received: from mta0.migadu.com (out-4.mta0.migadu.com [91.218.175.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5919431A5C
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 14:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790002075; cv=none; b=sVZE/u3m5SIgKk0u883aYwbWRzPTSNiKZEXVi4zdlQUjqF1qNmtNAscM0Wv+Q5I+qZZtW2+8EzqDZy3AjBsBjWQtvZqJJvZvibpXtg86A6Qn1k0phNQ2W6/9SncM5DdlsD5y4FYPG1ZFRZDeGcemzbrjSZaVv2BZoovZ/6S61OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790002075; c=relaxed/simple;
	bh=e9WM4rzZg05MFYQKfKbZiGk/o3dn3vwUGCuQuS6yn6c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fgWu1ANptNITrm8eUpJDy+5zyrRMKcu/tJP/x38xnf6GVFtdXY34sEK5iQbYRJmdhK7sqbC8KFLCIjrf3lBfDUlcwUYj9cGauI3BJsq4AC4A4j4FySdd04zPlh+VncH58wD2vrvF+K+k7h7Ek3MUo8S4na/0iKrF1XXraABB1U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ld3sRngL; arc=none smtp.client-ip=91.218.175.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ld3sRngL"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=e9WM4rzZg05MFYQKfKbZiGk/o3dn3vwUGCuQuS6yn6c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790002071; v=1; x=1790606871;
 b=ld3sRngLEFY83WYVb4DcyWRAtCHOBmgczKxT1zVDmbcS4HiayOqHamvFn68pWlY+kmO3mrWn
 k9UL8VgJMaZNoPsYe8pmcb4jBpmsTxqiZ2pN/eNMKeJGKZNMDZwk/WH0ildte/JOfQGNBNSV8RC
 jXt3dbnKPrvLOkraj/z3OHfg=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 87632ad2fc37c4e0;
	Mon, 21 Sep 2026 14:47:41 +0000
X-Mizu-Trace-ID: 87632ad2fc37c4e0
X-Migadu-Flow: FLOW_OUT
Message-ID: <69218179-d750-4880-8be0-2ccab7d76a6d@linux.dev>
Date: Mon, 21 Sep 2026 15:47:41 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sg: clean up request on error paths in sg_read()
To: Hui Peng <benquike@gmail.com>, Doug Gilbert <dgilbert@interlog.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260919204814.2815374-1-benquike@gmail.com>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260919204814.2815374-1-benquike@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/19/26 21:48, Hui Peng wrote:
> In sg_read(), once sg_get_rq_mark() locates a completed Sg_request and
> transitions srp->done from 1 to 2, an allocation failure in kzalloc() or
> a user-copy fault (-EFAULT) in copy_to_user() / sg_read_oxfer() returns
> or jumps to free_old_hdr without calling sg_finish_rem_req(srp) and
> sg_remove_request(sfp, srp).
> 
> Because srp->done is already 2, subsequent sg_read() calls skip the
> request, permanently leaking srp->bio and keeping sfp->res_in_use = 1
> (blocking SG_SET_RESERVED_SIZE with -EBUSY and wedging non-SG_FLAG_NO_DXFER
> writes with -EDOM) until the file descriptor is closed.
> 
> Always call sg_finish_rem_req(srp) and sg_remove_request(sfp, srp) under
> the free_old_hdr cleanup label, matching sg_new_read().
> 
> Fixes: cb59e8408381 ("[PATCH] sg.c: update")
> Assisted-by: LLM
> Signed-off-by: Hui Peng <benquike@gmail.com>

How was this tested?

> ---
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -480,8 +480,10 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
>   
>   	hp = &srp->header;
>   	old_hdr = kzalloc(SZ_SG_HEADER, GFP_KERNEL);
> -	if (!old_hdr)
> -		return -ENOMEM;
> +	if (!old_hdr) {
> +		retval = -ENOMEM;
> +		goto free_old_hdr;
> +	}
>   
>   	old_hdr->reply_len = (int) hp->timeout;
>   	old_hdr->pack_len = old_hdr->reply_len; /* old, strange behaviour */
> @@ -543,10 +545,10 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
>   		}
>   	} else
>   		count = (old_hdr->result == 0) ? 0 : -EIO;
> -	sg_finish_rem_req(srp);
> -	sg_remove_request(sfp, srp);
>   	retval = count;
>   free_old_hdr:

This is no longer a fully appropriate label name

> +	sg_finish_rem_req(srp);
> +	sg_remove_request(sfp, srp);
>   	kfree(old_hdr);
>   	return retval;
>   }

