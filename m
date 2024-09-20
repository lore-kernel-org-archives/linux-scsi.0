Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E031BF37;
	Fri, 20 Sep 2024 16:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726850623; cv=none; b=JYGX7+nWwM0FuAWTwJyd3Rx86Cf4lPGEwqvcbc61QxKU802B9J/FNx59kMNLv3Ly0OorIKo1PyRPN17TIE/VA7zN2hu/GtIqQeqIpGmbt2gBT/7TVKLFJQNYOG45SVwNi1Vp+3jAg+oWw4cF3RUcSZkL4/yicHgF81hmuzlHLs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726850623; c=relaxed/simple;
	bh=+Zap9zqPGuJo1BSpXRKHhF2mt5zTIAldbW/2Gf/zzYo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tMiSRW/d0XvphX9lpd3ZH4hitk5sMLnxUd+w4HliXGtTIXadbTftlg7UNROmPVvN++t/sC/D1lB7L8/D5yh7ANZ9M8GlrwaKm6NChdg3z3yCcEFeX2M24Zn3E+9LG68RLNQkVJKHAcKuNMaK9R2KRLBL56Yn30N5wsofgSt204Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=j4+aR0b3; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="j4+aR0b3"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X9J9g1Hl9z6CmM79;
	Fri, 20 Sep 2024 16:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1726850611; x=1729442612; bh=tmivwF6SDoMGCbACzd8943bL
	vECGKuQQ5RBsxEiym9Y=; b=j4+aR0b3n2b0IOTwc8lO5YrFkiWQStdeNNl+isAV
	8YGSqDv4j0Pg1v6S+oM2kODs1JQHCkbR8bGRM+yR9fwoWX3JIV/RavvdOyiDemX3
	mlpFSp/0E/FDFyfbzx4Uw+F9pHBLO64JfeYN6bM4VcM2M3P0Q6yp2k40OC3VRAmH
	HQZW50Yr+HHAkcUqHTNq2F5UPXnp5gI00Mk6MqNeJ/T3ZCLRujGcb4FnZggd/zgd
	DElRbS/jGEUA+tw77+XO/sl7KK1mA8i4h2zf9jHO1NBDEwgQRHtA6UWef5yYOima
	41Jnk43VjUJn4Rt59JhvHt8m23JqgRZq4BorLgk7/mPgAw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id awr-l63dXVUp; Fri, 20 Sep 2024 16:43:31 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X9J9Y48gFz6CmM6c;
	Fri, 20 Sep 2024 16:43:29 +0000 (UTC)
Message-ID: <fb00ce7a-6f11-4769-b9eb-4011f076aa83@acm.org>
Date: Fri, 20 Sep 2024 09:43:27 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] scsi: qedf: Fix potential null pointer dereference
To: Liao Chen <liaochen4@huawei.com>, GR-QLogic-Storage-Upstream@marvell.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: skashyap@marvell.com, jhasan@marvell.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
References: <20240920020835.1857251-1-liaochen4@huawei.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240920020835.1857251-1-liaochen4@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/19/24 7:08 PM, Liao Chen wrote:
> qedf is checked to be null in this if branch, accessing its member will
> cause a null pointer dereference. As suggested by Bart, fix it by
> deleting the logic since qedf cannot be NULL in this function.
> 
> Signed-off-by: Liao Chen <liaochen4@huawei.com>
> ---
>   drivers/scsi/qedf/qedf_main.c | 5 -----
>   1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
> index cf13148ba281..df756f3eef3e 100644
> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
> @@ -4018,11 +4018,6 @@ void qedf_stag_change_work(struct work_struct *work)
>   	struct qedf_ctx *qedf =
>   	    container_of(work, struct qedf_ctx, stag_work.work);
>   
> -	if (!qedf) {
> -		QEDF_ERR(&qedf->dbg_ctx, "qedf is NULL");
> -		return;
> -	}
> -
>   	if (test_bit(QEDF_IN_RECOVERY, &qedf->flags)) {
>   		QEDF_ERR(&qedf->dbg_ctx,
>   			 "Already is in recovery, hence not calling software context reset.\n");

The patch looks good to me but the patch description could be more
clear and the subject is wrong. How about this?

[PATCH] scsi: qedf: Remove dead code

If container_of() is used correctly, its result is never NULL. Remove
the code that depends on container_of() returning a NULL pointer.

