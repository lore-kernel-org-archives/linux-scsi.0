Received: from mta0.migadu.com (out-219.mta0.migadu.com [91.218.175.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948AB480951
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 09:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790327764; cv=none; b=KOwI1s7u4/APjExlIc6y4nIgdPLkvoPGAXrNBBuKmeLDo4IE2bY8nyP/Z+Y2OXH2mtIaZyycVbDq9o7OfLtnok6WGEJCh/OfB/7kh0U2PM+v5lL98TfvBHHUaEZM4ceFdtaDC8w60Dk4xpP6tPbPvryYbArIYZKjiCFvmoliQGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790327764; c=relaxed/simple;
	bh=oE5AYCWqu/oxk+qCxiEUaYAw03VZ5W2+x7tVzMFgvFI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cd7UcAYR3jhUxebcuyXhrcD4ZhZGFAdHbyrQgJ2M4oRIuuppDadBJZY7EzLLzBuyMwr+VpfY6D6IRJo5sNlh3KTTkYEJvhzFMBEGkWoy4UbnxZzCeHzhUjlBrfHydwfIuZcQMHVuDuP5Gd0vYUpi28iinsSM81WccFhIG+IdLqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Rsq30wfl; arc=none smtp.client-ip=91.218.175.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Rsq30wfl"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=oE5AYCWqu/oxk+qCxiEUaYAw03VZ5W2+x7tVzMFgvFI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790327759; v=1; x=1790932559;
 b=Rsq30wfl0d16fogf4mshkNg8t1vwZUUaRQyfAPPfixeT4gKID4ncoUizL9cUFKC+8mVg4Fey
 JhRye5xIDATCwr5m1j10CCj4/WH+1xMwsk8R5cargpozI4kaV4RuC6KFzbEHit+7cmJrjwavSeY
 SRH1Mi/Dxbu8da2dTDGBha58=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 945d234437bd8de6;
	Fri, 25 Sep 2026 09:15:58 +0000
X-Mizu-Trace-ID: 945d234437bd8de6
X-Migadu-Flow: FLOW_OUT
Message-ID: <1fa5a1b7-f35f-49b9-8d87-dd4e0aa3bf68@linux.dev>
Date: Fri, 25 Sep 2026 10:15:58 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/7] scsi: scsi_debug: Improve lock context annotations
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Christoph Hellwig <hch@lst.de>
References: <cover.1790290089.git.bvanassche@acm.org>
 <68c72eed87c663b4b99f63af71971c718166d3c8.1790290090.git.bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <68c72eed87c663b4b99f63af71971c718166d3c8.1790290090.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/24/26 23:54, Bart Van Assche wrote:
>   static inline void
>   sdeb_data_lock(struct sdeb_store_info *sip, bool atomic)
> +	__acquires(&sip->macc_data_lck)

Is this proper?

sdeb_data_lock() can call sdeb_data_read_lock(), and 
sdeb_data_read_lock() uses __acquires_shared().

Indeed, but functions which sdeb_data_lock() call already have lock 
context annotations, so I wonder if this annotation is even needed.

> +	__context_unsafe(/*conditional locking*/)
>   {
>   	if (atomic)
>   		sdeb_data_write_lock(sip);
> @@ -4164,6 +4174,8 @@ sdeb_data_lock(struct sdeb_store_info *sip, bool atomic)
>   
>   static inline void
>   sdeb_data_unlock(struct sdeb_store_info *sip, bool atomic)
> +	__releases(&sip->macc_data_lck)

