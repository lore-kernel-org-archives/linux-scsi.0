Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9163988FF;
	Mon,  6 Jul 2026 14:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783349240; cv=none; b=cSaEu6ojCK8kJPH70kcQLj2fEqE9K/OCqpfa1CqUQvvQILJxHVoY131SjudBrwjFdLznoiuhJFkXKAWkmgWdThQo9kfTKPLSChK9aSq3to+4qpzlRgtwTcpXczsOae72hKn+3i+PAuHwBxdYuXnrOJuG1x+1q1C0h0W0n9dMwco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783349240; c=relaxed/simple;
	bh=3KzTAaE/aR1pJt1uByHD2VrPryF+1r2BFA9VYAIWZUo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QlCOzANT6e4PXKEbrs1/YxPBrSOE6DLXXObQMr6L6oVLbD5B/uyRH7hz2gn9vdpmqq2Cb3ealgPCnlBoJGarXMUo8fV0c29x6oz8QDp9Mi0Hj021KZFzlwKMtkCKAEeyb8jk+SDiB5z+KajgjbGkIk4zqR44Tg1s0deuqEi2xkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=CHQLq3sZ; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="CHQLq3sZ"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gv6df6v1Xz1XM6JQ;
	Mon,  6 Jul 2026 14:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1783349235; x=1785941236; bh=sNarlc/Oh3HaSEPdErv+Oong
	SJhiwdHXGmTmxDtQ8nc=; b=CHQLq3sZQVRClRo5Rf5WogaJpSefTM7alO1P1hqi
	A5Z8d9ZX2jqBLXrR8vrT4FGT3+6dB/TI103MuX4BDG3mNCWoX+X3v8/bZPIF2E+b
	WHECiBtJiinBs4Aub1ZUTZXyKeWU53xCBca+f51/cO1PSz0ng8yD4ltZXc06UTDL
	gBYyzmyCti+YcdE96ZSpM4pw9pEG5Yk+1i/t3LwSUDz92em/KHwLSjA+SzPJWWTI
	PjU2oFqO2h+3WQW/nayeFEkH5vJwk8WULec4gctYk4edGpb8WPLgPoYFWH2Xw2Yo
	YjLIV30Fo9ppiVvdDObod4GgIgKwZncAMj0RKj5bh3mG4Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Hz-tL0Ib2VQP; Mon,  6 Jul 2026 14:47:15 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gv6dY07Rfz1XM6J4;
	Mon,  6 Jul 2026 14:47:12 +0000 (UTC)
Message-ID: <086861b7-b040-4651-a2e3-3721d7bc8eba@acm.org>
Date: Mon, 6 Jul 2026 07:47:11 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sg: report request-table problems when any status
 is set
To: raoxu <raoxu@uniontech.com>, dgilbert@interlog.com
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <26BF67F369E2123E+20260706084443.805598-1-raoxu@uniontech.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <26BF67F369E2123E+20260706084443.805598-1-raoxu@uniontech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/6/26 1:44 AM, raoxu wrote:
> From: Xu Rao <raoxu@uniontech.com>
> 
> SG_GET_REQUEST_TABLE reports per-request diagnostic state through
> sg_req_info::problem. The field is meant to indicate whether there is
> an error to report for a completed request.
> 
> sg_fill_request_table() currently combines masked_status, host_status
> and driver_status with bitwise AND. This only reports a problem when all
> three status fields are non-zero at the same time. A normal target check
> condition, for example, has masked_status set while host_status and
> driver_status may both be zero, so the request is incorrectly reported
> as clean.
> 
> Use the same condition as sg_new_read(), which sets SG_INFO_CHECK when
> any of the three status fields is non-zero.
> 
> Signed-off-by: Xu Rao <raoxu@uniontech.com>
> ---
>   drivers/scsi/sg.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 74cd4e8a61c2..5408f002e6c0 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -863,10 +863,9 @@ sg_fill_request_table(Sg_fd *sfp, sg_req_info_t *rinfo)
>   		if (val >= SG_MAX_QUEUE)
>   			break;
>   		rinfo[val].req_state = srp->done + 1;
> -		rinfo[val].problem =
> -			srp->header.masked_status &
> -			srp->header.host_status &
> -			srp->header.driver_status;
> +		rinfo[val].problem = srp->header.masked_status ||
> +					     srp->header.host_status ||
> +					     srp->header.driver_status;
>   		if (srp->done)
>   			rinfo[val].duration =
>   				srp->header.duration;

A "Cc: stable" tag is missing. Otherwise this patch looks good to me.

Thanks,

Bart.
