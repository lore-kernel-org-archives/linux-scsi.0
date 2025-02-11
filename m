Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6138F26BD8E
	for <linux-scsi@vger.kernel.org>; Tue, 11 Feb 2025 17:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739294666; cv=none; b=RJuDb2UjlyAHH/XuXNzq0p5pYseu//Qks6MWMkUPfkY9cyyxhiEWKBRPN0OJLPPMCQ3UIzsOeyHHABS8DY4xrIABs2x79kAMAGSg9d6PqUlfZa0r8BXFsYLHXMnvytPkS9eOzyDFv3BhOqrqSV98oQHSJI6kHN4uA3Exj8iALaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739294666; c=relaxed/simple;
	bh=ViI5iGVrbhe4JXs/6U+n/ZWXGn+jdWdC1rqTx0CZKac=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=bQ/vTfdoq+trx/aXLpnSPG6mkp0BDkv+Zmj20PcBQYlHSJhRC1cGOXYal/xNDn52HnDsC9pCgggd+baZ5PLuuqSVRsYI2IokaaOs9zsDDWGbxDUfNrWyEKoBaaByGDbY+o7HGeN7sfDj0pZ8fDEZoAnYDBj64kF/sftH2pXcrbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=XUS5uib1; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="XUS5uib1"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4YspGH5VGrz6CmM6d;
	Tue, 11 Feb 2025 17:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1739294660; x=1741886661; bh=I1eZO8KeNoS2ksQTHBSL6STA
	UhNLUJf6Eyfw2ktdV/Q=; b=XUS5uib1YdKRzPKYiZyzmjv9FWA88tDlQcG3yKm/
	iOe21twdl206+yWAvv3QeuUGIfEaLnVWlkopgjhVytmUS2G+RX5koXIosqCRhQWC
	v57LpvlbNnTDK54zyk9kUevkqbQu0BJxtJ1k8n94V4UYlVxxSIIU1IAQjyp4mms+
	cC3sAiZD0//N8SCMdNLGMCg7BG6QZbUdEnCW5JYVSQ3x9jIcZC5cdik+Ui8xF/eG
	QSznhZk9CMrNLLi8JjuSlKzkVtOtma7qc/MRwNsTt7t9SJKqMn+nqlLNgechIb9m
	NesRfiX0BmPQ3jiFoobWNlo93Y2qo3JyDYiGE9rIJArGPQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id KSo2aWChcX67; Tue, 11 Feb 2025 17:24:20 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4YspGC2r33z6CmQtQ;
	Tue, 11 Feb 2025 17:24:19 +0000 (UTC)
Message-ID: <ee7f80e5-6024-4ab0-97c8-b7817e2e2e0c@acm.org>
Date: Tue, 11 Feb 2025 09:24:18 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: clear driver private data when retry request
To: Ye Bin <yebin@huaweicloud.com>, jejb@linux.ibm.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org
References: <20250210140333.3899021-1-yebin@huaweicloud.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250210140333.3899021-1-yebin@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/10/25 6:03 AM, Ye Bin wrote:
> From: Ye Bin <yebin10@huawei.com>
> 
> After commit 1bad6c4a57ef
> ("scsi: zero per-cmd private driver data for each MQ I/O"),
> xen-scsifront/virtio_scsi/snic driver remove code that zeroes
> driver-private command data. If request do retry will lead to
> driver-private command data remains. Before commit 464a00c9e0ad
> ("scsi: core: Kill DRIVER_SENSE") if virtio_scsi do capacity
> expansion, first request may return UA then request will do retry,
> as driver-private command data remains, request will return UA
> again. As a result, the request keeps retrying, and the request
> times out and fails.
> So zeroes driver-private command data when request do retry.
> 
> Fixes: f7de50da1479 ("scsi: xen-scsifront: Remove code that zeroes driver-private command data")
> Fixes: c2bb87318baa ("scsi: virtio_scsi: Remove code that zeroes driver-private command data")
> Fixes: c3006a926468 ("scsi: snic: Remove code that zeroes driver-private command data")
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>   drivers/scsi/scsi_lib.c | 19 +++++++++++++------
>   1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index be0890e4e706..5b0c109c89bb 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1645,6 +1645,17 @@ static unsigned int scsi_mq_inline_sgl_size(struct Scsi_Host *shost)
>   		sizeof(struct scatterlist);
>   }
>   
> +static inline void scsi_clear_lld_private_data(struct scsi_cmnd *cmd,
> +					       struct Scsi_Host *shost)
> +{
> +	/*
> +	 * Only clear the driver-private command data if the LLD does not supply
> +	 * a function to initialize that data.
> +	 */
> +	if (!shost->hostt->init_cmd_priv && shost->hostt->cmd_size)
> +		memset(cmd + 1, 0, shost->hostt->cmd_size);
> +}
> +
>   static blk_status_t scsi_prepare_cmd(struct request *req)
>   {
>   	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
> @@ -1669,12 +1680,7 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
>   	if (in_flight)
>   		__set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
>   
> -	/*
> -	 * Only clear the driver-private command data if the LLD does not supply
> -	 * a function to initialize that data.
> -	 */
> -	if (!shost->hostt->init_cmd_priv)
> -		memset(cmd + 1, 0, shost->hostt->cmd_size);
> +	scsi_clear_lld_private_data(cmd, shost);
>   
>   	cmd->prot_op = SCSI_PROT_NORMAL;
>   	if (blk_rq_bytes(req))
> @@ -1848,6 +1854,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>   			goto out_dec_host_busy;
>   		req->rq_flags |= RQF_DONTPREP;
>   	} else {
> +		scsi_clear_lld_private_data(cmd, shost);
>   		clear_bit(SCMD_STATE_COMPLETE, &cmd->state);
>   	}

Thanks for the detailed analysis. Has the following (untested) simpler
alternative been considered?

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d776f13cd160..6ee2903b4adb 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1664,13 +1664,6 @@ static blk_status_t scsi_prepare_cmd(struct 
request *req)
  	if (in_flight)
  		__set_bit(SCMD_STATE_INFLIGHT, &cmd->state);

-	/*
-	 * Only clear the driver-private command data if the LLD does not supply
-	 * a function to initialize that data.
-	 */
-	if (!shost->hostt->init_cmd_priv)
-		memset(cmd + 1, 0, shost->hostt->cmd_size);
-
  	cmd->prot_op = SCSI_PROT_NORMAL;
  	if (blk_rq_bytes(req))
  		cmd->sc_data_direction = rq_dma_dir(req);
@@ -1837,6 +1830,13 @@ static blk_status_t scsi_queue_rq(struct 
blk_mq_hw_ctx *hctx,
  	if (!scsi_host_queue_ready(q, shost, sdev, cmd))
  		goto out_dec_target_busy;

+	/*
+	 * Only clear the driver-private command data if the LLD does not supply
+	 * a function to initialize that data.
+	 */
+	if (!shost->hostt->init_cmd_priv && shost->hostt->cmd_size)
+		memset(scsi_cmd_priv(cmd), 0, shost->hostt->cmd_size);
+
  	if (!(req->rq_flags & RQF_DONTPREP)) {
  		ret = scsi_prepare_cmd(req);
  		if (ret != BLK_STS_OK)

