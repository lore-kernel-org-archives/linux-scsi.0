Received: from mta0.migadu.com (out-233.mta0.migadu.com [91.218.175.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136903E3C5F
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 09:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790327786; cv=none; b=hdVpW3o5yLp/Zh3YMg0aVKy7BnXkvGSydjav09Id2+7+qwdY580vJOlZ3kOG4uRll/PKDWtlkZw1DfbfJTuxjsUTYBVAKjZX5/yB7uK27dcO8CcgaBVjaLUFz01VMlQjcuQ4ohadx3jVL1nYRu6BI6Mfq1cl5Hx3RiR6a2JUp74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790327786; c=relaxed/simple;
	bh=ovVCalqJ2Djedx6NuPWRbE/J3hImOHaPlSN67MO0GXg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lJ4Xx6mpWtC7VFzt8Mc8n69aZdgk4afwmWhisuLOExGjzhy9ryWOJ7QamyrifCz9/i/hkMytOZgLaGgYqQDW1T0H/h0CNlRXVLnmffpAcSIS2qRn4Pv3NbVvxFKHjXxXttb7Cik4sQAHAoVuh4F3AVh3Ar4JzYmHS5572LACz4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X5ui8Mwi; arc=none smtp.client-ip=91.218.175.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X5ui8Mwi"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ovVCalqJ2Djedx6NuPWRbE/J3hImOHaPlSN67MO0GXg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790327783; v=1; x=1790932583;
 b=X5ui8Mwi6K5TWSloZPcL0X5Y6e2erAxJuVvE/MzwKMIoxP8UJ5RynegjsRXsGT31tjXmFZFd
 GsOZMNxCABnfhLfCtjLDVhu5q/4ip6R3EnFA52REjJSMXR8PL1bI7DP+SC2nupn/GTDA5uqRPYT
 Pspucoi8DGREtZHxD5m+o8hg=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 5b5e98357e1188a2;
	Fri, 25 Sep 2026 09:16:22 +0000
X-Mizu-Trace-ID: 5b5e98357e1188a2
X-Migadu-Flow: FLOW_OUT
Message-ID: <373421a8-03bd-4f6a-8297-eaa9f0437554@linux.dev>
Date: Fri, 25 Sep 2026 10:16:22 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/7] scsi: core: Enable lock context analysis for the
 scsi_debug driver
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Christoph Hellwig <hch@lst.de>
References: <cover.1790290089.git.bvanassche@acm.org>
 <4e2a141483142d490753b07a118dacd1221294e8.1790290090.git.bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <4e2a141483142d490753b07a118dacd1221294e8.1790290090.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/24/26 23:54, Bart Van Assche wrote:
> Enable lock context analysis now that all lock context analysis warnings
> have been fixed.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: John Garry <john.garry@linux.dev>

> ---
>   drivers/scsi/Makefile | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index 533623382eca..32d816e942d6 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -18,6 +18,7 @@ CONTEXT_ANALYSIS_constants.o := y
>   CONTEXT_ANALYSIS_hosts.o := y
>   CONTEXT_ANALYSIS_scsi.o := y
>   CONTEXT_ANALYSIS_scsi_common.o := y
> +CONTEXT_ANALYSIS_scsi_debug.o := y
>   CONTEXT_ANALYSIS_scsi_devinfo.o := y
>   CONTEXT_ANALYSIS_scsi_dh.o := y
>   CONTEXT_ANALYSIS_scsi_error.o := y

