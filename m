Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.40
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792572980;
	b=jVbCjNyE9KIvUMiXVI8OPVgkY2qf5m5Zo372u2qLzUttPsPaSryC45HH6W3OqwpNcGv4
	 EiWNbmNc3mhflL+udCPnjkxdRa+MGQX7ThVwrvwu96b/y8FHT2qYCUqa3eZliLIhUYZi4
	 oATNWlAdpDndIQLfPx4jC0TQQ40VOMQ6J3mgBRcn2P8hcfkPIbeEETWGQxDW0gnrzIz5W
	 qVAXcV6Bs1BMotmJgnf0Wjd6EZXqlyKr+xWokPZDTzPWgQaN7hUadHn/KAiqbRpbv5zA4
	 PjJ3hgOxK/f9Y6ExG12FH6/qAx6SiAuL2o0dncxHljV3T9ZQ6WB/hhUCdcIK5ROylGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792572980;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=rGAUX7WyHtctAYQgZ/UWtEbDP48u5/oD/M4xo9z35DM=;
	b=l3e7DCIV0iSkCGeGsreXZ+ZE/Lwc5L8i5fIGRtlm5HkQo2LsqYhuHpple7fc2FzgwiCX
	 omdVzce99n0TmIo4YtVFnnme776xzAc5ig1/sOXrRFMoil8mpHttxzkxsGzIzEADKaKSa
	 Eo9Cxm8VhvnUUPVqWIXotMc0TMy6UDW67qnoB9ALzdWogdRXO+uBwEqRNpDl/aiKzP/LF
	 XJmXapz2F9suPcIvz55jJCQvGr/EGWtFLdxyDKcq5qyVSX0bj71DVzgIn9bphUoDOWvjD
	 doJHZYgaLi+wn/w8ls1BqFr2zevOfeq3hPHBWkvjMoJTYYE3cUdHoi7rHQWkSPr6tHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cMtazZgr;
	arc=none smtp.remote-ip=91.218.175.40
Received: from mta0.migadu.com (out-40.mta0.migadu.com [91.218.175.40])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D12606A319
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 08:56:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C2D12606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cMtazZgr
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=b0hMr3I61lFJI5IrfBvnsnfONukXMVBIX2vAjQ5aK5A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792572976; v=1; x=1793177776;
 b=cMtazZgrmuHDOBt/B0DWhbnun2z5lTHkZkOlWG8RZM6ynVMUqj7JwK9D437lOWWrj8xq45GD
 KhD0H4OhziBFyJwLhoSirxfYolwuf4xjgIxu85tUd/1QEgvnaTXsnY0kxpNLi5ePg+DrgxycSVk
 kA/lzHAuBi79360gUTQ2mibQ=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 1a71eac2f28c557e;
	Wed, 21 Oct 2026 08:56:16 +0000
X-Mizu-Trace-ID: 1a71eac2f28c557e
X-Migadu-Flow: FLOW_OUT
Message-ID: <c1282924-f91c-440b-b683-b663765a3e38@linux.dev>
Date: Wed, 21 Oct 2026 09:56:13 +0100
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: libsas: Add __printf attribute to sas_ata_printk()
To: =?UTF-8?Q?Adri=C3=A1n_Garc=C3=ADa_Casado?=
 <adriangarciacasado42@gmail.com>, "Martin K . Petersen" <mkp@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261020195934.250768-1-adriangarciacasado42@gmail.com>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20261020195934.250768-1-adriangarciacasado42@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/20/26 20:59, Adrián García Casado wrote:
> sas_ata_printk() formats its variadic arguments via struct va_format and
> %pV before passing them to printk().
> 
> Because %pV hides the format string from the compiler, GCC does not suggest
> the format attribute under -Wsuggest-attribute=format, and callers do not
> get compile-time format string validation.
> 
> Add the __printf(3, 4) attribute to sas_ata_printk() to enable compile-time
> format string checking for its callers.
> 
> Signed-off-by: Adrián García Casado <adriangarciacasado42@gmail.com>
> ---
>   drivers/scsi/libsas/sas_ata.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index 61368e55bf..53eac56c3a 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -372,6 +372,7 @@ static int local_ata_check_ready(struct ata_link *link)
>   	}
>   }

I checked 
https://gcc.gnu.org/onlinedocs/gcc/Common-Attributes.html#Common-Function-Attributes 
format section, and this looks sane, so:
Reviewed-by: John Garry <john.garry@linux.dev>


>   
> +__printf(3, 4)
>   static int sas_ata_printk(const char *level, const struct domain_device *ddev,
>   			  const char *fmt, ...)
>   {

