Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353D354B1C6
	for <linux-scsi@vger.kernel.org>; Wed,  9 Sep 2026 16:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788971553; cv=none; b=Ewoc3oY3kWkdPC0H45yTAd/9gQBMyfvd8ViK0myd9s6a1zDjjSk6YN2viaXBx4y7ZRr+KM3YDuhufdYVnTK7RZFFLx0m1DSocHCdAR8/Gg1vOqr7Iad7ulAoAg6WvF9CXaiiYNfJSxlhhM/jW3gQCiZV/2+jrJ2E26plu6S2i8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788971553; c=relaxed/simple;
	bh=0ym61aHLrKvliS+UhL+XHgxaqnL4YH9TPJtjKsyDlts=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fM+X5I7t9OkqsLowiqMrJlBXm0eKyBOR3QRJ+WIMaFffxP5wpBnJdIvhgYHJu2pLLwUSJpWi0s38MzqLLf4L7DD216wPwDsJzeHIRFCCeOFBnnwg3ic0fDDtsgSPPLnaAkW19Le1nvNkUvySB0kxNeqk6fnTwRX/9l5ocSaYdmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Hz0GZP+D; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Hz0GZP+D"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hg5v34k7zz1XM311;
	Wed,  9 Sep 2026 16:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1788971547; x=1791563548; bh=tAcTU+oLh0v1raNybuzaAfra
	4Wbm941Vm5QOFSxPdwM=; b=Hz0GZP+DCBczr2Q9AFz2ypnTsb5NfibP0tgYcYo5
	uRyDBefHAr8AO/zZvqS/EehnXFGbCPGJPYesSRWsobBAY7N49MVQLNGQSWp/VyZP
	cFbiKzsJLCh5pmqrwfLyvXDbZMgBG0red81l0Pz+2RtQGNJp5soQ3OhQgizuhFP7
	qMd9UUgcaavWi5EmYpjntq1KH9q/yWmVONhPqiUG2gioe77Cyh/Kq1YNmicZLPxI
	vu7N1xioQ9EUqgspVhJZrzhbU1UkERBLUD3DSvlZ4E8Rn0hsVFlp7sp+1Vo4sRI4
	+rBoU25Kpngwhham4l2oEjavlifbZ7u4u+ZF9hQ7T/maZQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id hUriZmsV5YHf; Wed,  9 Sep 2026 16:32:27 +0000 (UTC)
Received: from [100.86.178.220] (unknown [104.133.214.192])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hg5tx6WDGz1XM4Sx;
	Wed,  9 Sep 2026 16:32:25 +0000 (UTC)
Message-ID: <c46f6c74-2aa0-4aad-a234-7ff4ba367bdb@acm.org>
Date: Wed, 9 Sep 2026 09:32:24 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] scsi: core: Clear cmd->flags for terminal queuing
 error
To: John Garry <john.garry@linux.dev>, James.Bottomley@HansenPartnership.com,
 mkp@kernel.org
Cc: linux-scsi@vger.kernel.org, hare@suse.de
References: <20260908120841.185742-1-john.garry@linux.dev>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260908120841.185742-1-john.garry@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/8/26 5:08 AM, John Garry wrote:
> If a request can't be queued in scsi_queue_rq(), then we error out with
> a blk_status_t code. Such a scenario may be the scsi_device has its
> transport offline.
> 
> For BLK_STS_RESOURCE or BLK_STS_AGAIN, the request will be requeued in the
> block layer. For other errors, the block layer ends the request and so
> we won't see it again (until recycled).
> 
> Normally when a request completes scmd->flags is cleared in
> scsi_end_request().
> 
> However for the error scenario mentioned above, scsi_end_request() is
> not called and so scmd->flags is not cleared. As such, when the request
> is recycled we see the old value in scmd->flags.
> 
> Fix this issue by clearing scmd->flags in the error scenario mentioned.
> 
> Signed-off-by: John Garry <john.garry@linux.dev>
> ---
> Setting as an RFC as I am not 100% sure that this is correct as there are
> lots of paths involved. Sashiko pointed out a related issue in
> https://lore.kernel.org/linux-scsi/20260729161243.C918D1F00A3A@smtp.kernel.org/,
> but blk_mq_cleanup_rq() -> scsi_cleanup_rq() -> cmd->flags = 0 is only
> called for by DM code.
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index af27fd3df8d4..295f8b4afaa7 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1967,6 +1967,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>   		 */
>   		if (req->rq_flags & RQF_DONTPREP)
>   			scsi_mq_uninit_cmd(cmd);
> +		cmd->flags = 0;
>   		scsi_run_queue_async(sdev);
>   		break;
>   	}

Is there agreement that all block drivers are affected that define a
.cleanup_rq() callback? Would this be a valid alternative (untested)?

diff --git a/block/blk-mq.c b/block/blk-mq.c
index a26a11c73ee3..0be933e26d67 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2126,6 +2126,12 @@ bool blk_mq_dispatch_rq_list(struct blk_mq_hw_ctx 
*hctx, struct list_head *list,
  			blk_mq_handle_dev_resource(rq, list);
  			goto out;
  		default:
+			/*
+			 * Make sure to release all allocated resources when
+			 * we hit an error, as we will never see this command
+			 * again.
+			 */
+			blk_mq_cleanup_rq(rq);
  			blk_mq_end_request(rq, ret);
  		}
  	} while (!list_empty(list));
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 48aab0df30b7..636854bffd1e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1960,13 +1960,6 @@ static blk_status_t scsi_queue_rq(struct 
blk_mq_hw_ctx *hctx,
  			cmd->result = DID_NO_CONNECT << 16;
  		else
  			cmd->result = DID_ERROR << 16;
-		/*
-		 * Make sure to release all allocated resources when
-		 * we hit an error, as we will never see this command
-		 * again.
-		 */
-		if (req->rq_flags & RQF_DONTPREP)
-			scsi_mq_uninit_cmd(cmd);
  		scsi_run_queue_async(sdev);
  		break;
  	}

Thanks,

Bart.
