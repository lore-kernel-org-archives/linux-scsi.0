Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24E03EDAA2;
	Thu,  2 Apr 2026 15:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775145542; cv=none; b=pSpch07rPdrebk65Ls5fBppC0hkH3lJdb0mWLC9ukWG+w8WlmFuK9QnKA0L9KocmHJuZzWphLjZ0k0nZISpt3uyDKfT1xQNGZX12ZNLy2ttACI9/FD/upnS0iWOTnAK2y40KoMIrF7WmruVy1mjHnOC5mXSfQuw+v6iblXgFywo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775145542; c=relaxed/simple;
	bh=zynPblNX9L58TOxMGYvGCOFTI0aFili2wwrBvB/P/8I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LhMw+eU4GLLO+WrqnUJgLMvWX0sDPnaTohf/Lf5B2um/dwp/cBJIzBjlIVAauEf4ulamhaJdDhNUhxh08lxVGzhzGdVLP3xR38KHgeuymQMUaeB5iawcvy1BMKkUX+8whZxGhvcjzD6E4TuGk9aIt4Ztxml62cVHzC391UrTUuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=e2zuwvar; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="e2zuwvar"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fmmkB31rpzlfvqC;
	Thu,  2 Apr 2026 15:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1775145534; x=1777737535; bh=R5R9nbvY7fSoLU03i5BEPe1r
	38HHMw0mj0T8TG98QMo=; b=e2zuwvarzCZdzfH4hP31TXBr8tY/6yPDaBmgCAD/
	wjl2GLQQXNfKSYWSYqhhSdXvs+ykwg7BSbAzAxsYOndfNAvLegxxkY69mBZ+vTFr
	dauHKb/f5uYLrpQCgqQraiHFKi1vF0E+n9AzHdLgB1ypIO5jAck24V1a0PUj771U
	rZ7YnLC/iSeSpmf3DY09JxBGPTUUmbMZA5aA69m2W6bftfE29EBOwr+PUPJT8YbZ
	TmIf42WfnUNY2W0R12IwOnmQzmOW0bhQiw+kIvbkek+fsqXOrqnZm/an877ZJVU5
	tdBAgYNoOvwoAWkP88kA6mR/qIGM+j0NkXhjniG9Rp2NWA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id cMatIIXUEUY5; Thu,  2 Apr 2026 15:58:54 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fmmk36859zlfvq7;
	Thu,  2 Apr 2026 15:58:51 +0000 (UTC)
Message-ID: <fd582bae-a090-48d4-a4eb-b2db6c10c26c@acm.org>
Date: Thu, 2 Apr 2026 08:58:50 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] scsi: align scsi_device iodone_cnt to avoid cache
 line contention
To: Sumit Saxena <sumit.saxena@broadcom.com>, martin.petersen@oracle.com,
 axboe@kernel.dk
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 mpi3mr-linuxdrv.pdl@broadcom.com, James Rizzo <james.rizzo@broadcom.com>
References: <20260402074637.92417-1-sumit.saxena@broadcom.com>
 <20260402074637.92417-4-sumit.saxena@broadcom.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260402074637.92417-4-sumit.saxena@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/2/26 12:46 AM, Sumit Saxena wrote:
> From: James Rizzo <james.rizzo@broadcom.com>
> 
> Place iodone_cnt on its own cache line so it does not share a cache line
> with iorequest_cnt, avoiding significant performance hits from false
> sharing when request and completion paths update these counters on some
> CPU architectures.
> 
> Signed-off-by: James Rizzo <james.rizzo@broadcom.com>
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> ---
>   include/scsi/scsi_device.h | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 9c2a7bbe5891..86c2a3a6b206 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -272,7 +272,9 @@ struct scsi_device {
>   #define SCSI_DEFAULT_DEVICE_BLOCKED	3
>   
>   	atomic_t iorequest_cnt;
> -	atomic_t iodone_cnt;
> +	/* ensure iorequest_cnt and iodone_cnt are on different cache lines to avoid significant
> +	   performance hits on cache line contention on some CPU architectures */
> +	atomic_t iodone_cnt ____cacheline_aligned_in_smp;
>   	atomic_t ioerr_cnt;
>   	atomic_t iotmo_cnt;

Has it been considered to change both iorequest_cnt and iodone_cnt into
per-cpu counters?

Thanks,

Bart.
