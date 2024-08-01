Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3661EB48A
	for <linux-scsi@vger.kernel.org>; Thu,  1 Aug 2024 20:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722543134; cv=none; b=bK22+UkUmWcysQHF3ZYdthHa9xU5bekHcW8K0lgxL3O2dKOGJ5RFwjDZTPajXGGRP/vchQD+uLV1A9D7MsPJ0BcZ6bkGX/XfLcnZKFoMm+5ZLC/q0FgO85bFWkYLwDNTTdB73C1eiLtnw9lnX/Pa9/YoXrDz5p2c58In6fFxZXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722543134; c=relaxed/simple;
	bh=AUvbl9R8EtqljpKr6srbsnObdEmh4tDnMpVW727WLA8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l802FuiOOGSINS69pio3UW5yTyuCxt0rN+nhNCqVbsPIwqJOOPgh0bh1bp0J6AiqFkYidyhF3d5Gb5XUK/Zj/5ARCRIYJddprvswxUFavGTz0bk0sf0bzegef/K0k+tn77v2gBqqugiASTYnp5bF3kmm4oaySaTj+w0JkkfO8/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=xholxFPn; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="xholxFPn"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WZg9R6HjRzlgT1H;
	Thu,  1 Aug 2024 20:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1722543127; x=1725135128; bh=CU50YuToYTNmOSb7gp2txiWe
	CzprP0veJqFyBNYPv+k=; b=xholxFPnPj10n2QfM7ypsUS//IOEV5gZ/TyONPFl
	QX8WAMFO+E0jsW9DQBpqQ7dbx5xUJaoWBVPGfGJtrUvmyXFctUE8iq5xrlz5/SzO
	72cMzvwabdNHQtVothhgfKVYQ88FPx7+/Y02QM/RyMu3BGPhw2s97fb9y33RR5vK
	qdUX0I5nUkhYbt6KfzT+udjTbO55gUq28d5uZT2MAuWF/SpNlPllh9vwvGxAIdC8
	XmZZf3Lwf3T1dEKAA7NTAhLaXXQSc9F+CjG2wOcmAwVUhHK5Yc6+Q007dXFuERAr
	Jl2zo0kvtdYT3QkpcsNLlOwWpmv3j5+QkNwg+KYE+fvsDQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id zwz9mJ9d3GxH; Thu,  1 Aug 2024 20:12:07 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WZg9M21ykzlgVnN;
	Thu,  1 Aug 2024 20:12:07 +0000 (UTC)
Message-ID: <1e79816d-02eb-4997-81d2-4b6ec0201dd5@acm.org>
Date: Thu, 1 Aug 2024 13:12:06 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RFC: Retrying SCSI pass-through commands
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Hannes Reinecke <hare@suse.de>, Mike Christie <michael.christie@oracle.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@lst.de>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <b0f92045-d10f-4038-a746-e3d87e5830e8@acm.org>
 <a23d7a8c-4a4a-4687-ae18-87b2b2fb9fcb@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a23d7a8c-4a4a-4687-ae18-87b2b2fb9fcb@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/31/24 8:33 PM, Damien Le Moal wrote:
> Looking at the code, e.g. sd_start_stop_device():
> 
> 	res = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, NULL, 0, SD_TIMEOUT,
>                                 sdkp->max_retries, &exec_args);
> 
> It seems that it is expected that the retry count will be honored. But that
> indeed is not the case as scsi_noretry_cmd() will always return false for
> REQ_OP_DRV_* commands.
> 
> So may be we should have a RQF_USER_OP_DRV flag to differentiate user
> REQ_OP_DRV_* passthrough commands from internally issued REQ_OP_DRV_* commands.
> Or the reverse flag, e.g. RQF_INTERNAL_OP_DRV, that we can set in e.g.
> scsi_execute_cmnd().

Hmm ... how about using the simplest possible patch? The patch below seems
to work fine.

Thanks,

Bart.

[PATCH] scsi: core: Retry commands submitted by the SCSI core

Pass-through commands either come from user space (SG_IO ioctl,
SCSI_IOCTL_*, BSG), from the SCSI core or from a SCSI driver (ch,
cxlflash, pktcdvd, scsi_scan, scsi_dh_*, scsi_transport_spi, sd,
sg, st, virtio_scsi). All this code sets scsi_cmnd.allowed to the
maximum number of allowed retries. Hence, removing the
blk_rq_is_passthrough() check from scsi_noretry_cmd() has the
effect that scsi_cmnd.allowed is respected for pass-through
commands.

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 612489afe8d2..c09f65cfa898 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1855,7 +1855,7 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
  	 * assume caller has checked sense and determined
  	 * the check condition was retryable.
  	 */
-	if (req->cmd_flags & REQ_FAILFAST_DEV || blk_rq_is_passthrough(req))
+	if (req->cmd_flags & REQ_FAILFAST_DEV)
  		return true;

  	return false;

