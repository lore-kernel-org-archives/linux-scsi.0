Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDAB1F7084;
	Tue, 12 Nov 2024 13:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731419399; cv=none; b=qCAYwaf41qq6YIXuwewE1gCbYDEexkc4rxX2WPyadNQJdSdE5AWfCBveRzyrQTGCjWskINePS/aSEjN6CErUFHoM0QtCWiAXpw9aiobBUlBU7qHKbBeiWQaWWcKvvh9uJ/ntpzreTNJV9zgWRi9d+hC7h8MPAsKCRyrQ1G3nqsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731419399; c=relaxed/simple;
	bh=xxqZjKyyIL0XXUeabUZZHhuFFj2N9TvWPGK5fiBuKK4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kng3BKNn/Ln+MWq69ypaaRCxVU8npQw3sujcwZZZIAieJS0g+DkF7YNJJ6M9oEz2Urd2yK25baYTKjoHsKPTyGNkSkhJFsqE6lKGMzUGCO6PyrpVtiuohm83EAzAQc41MlJdKyyrkfGJ1NoJw0GI53AkniQ0VX7L9YhSGQcWM6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QUrVSkhl; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QUrVSkhl"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a9ec86a67feso981811566b.1;
        Tue, 12 Nov 2024 05:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731419396; x=1732024196; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l+iykLBkBRw5dPDO2BZR6hZTQ61YSR4pkCwvNoRVC54=;
        b=QUrVSkhlf+MeMRYrWDCeGdR/OlXuM23a7n9VMeEjTNQIGvF3s9/9uO1n5GshoHCN7B
         kTrFxAtKGUhiXehs8TKkrE/jpCAntKiY8fUeCaJBZnH0Ok5uhVHM54StQUUYLMjuJvSz
         2TLLBZi7yUHyNcWaMeGc0GtwH88koVKjXo6cN3Hieb+19OZzv4k/AWDza5EvYkKZTmQS
         TjJeztSIUEPa3x4lJ2TGd97wWZemMIffCENvsaLG3LhUAWg8ehd/GuUSZ98Hgj4j9jcZ
         EDoE1rqPeLQIjdw/xbP41zJ784jx0/zytuqcS+vCtoDkNtwUZOykNOF5T0YxIQsQt/MO
         Xb3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731419396; x=1732024196;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l+iykLBkBRw5dPDO2BZR6hZTQ61YSR4pkCwvNoRVC54=;
        b=uRu8/93lUV5N59jolqRwalS1te+HVYxc9y5cRam9nd4aK2bZGvfz9qvv0O5jnp+bHM
         gWszrOWpAKv09uEiHeP4s9cuxMkWsVEA32xlcfqWK7W7tolghtD/7SRjH2NA4UCVE8tx
         4ntm7AxBQGeOlfKEaHy9bNAAa58UGVADZ4SrUM4TAGxiQcxrLIKqhURLDbGfChJSOJE2
         UNihHfOEru5sjSKE4yYMj1X3Lc/cBofFzsITqNK2u87T8fPP3PqOtB/BS+UNT2zW8WBF
         FeIHHgKv9phVSZoz8Wrbm5DE5BlqUQ/bapNiqdsMJK8PF8s03rS87bw6v6GKt4HxRJ1t
         IShw==
X-Forwarded-Encrypted: i=1; AJvYcCVBijBcYgZwIueoUETfTJDpj5qteWSeZtxE1foIpjuALVVSxqV3AerqfU4Mt+cxzvtPIykSiiaNBKHGyA==@vger.kernel.org, AJvYcCXkblE5rSDqS1zY4LnOzbxtjnmOPqrTioo/MdikOu4e+cFrJYAEFk7/qi5TOsE9mrLd27C/+PWzyML1UhCwbHo=@vger.kernel.org, AJvYcCXsVJj6IXGDC46dNgDpcN8QffxeWMUiNdDh4nyRQYMaxVUdfU75LpoRfRWY/r2jqNjd6KhsqQ0DHWS91C6D@vger.kernel.org
X-Gm-Message-State: AOJu0YwHDTliUojJL9hN9FfM+n+OMFwtilzM2qIaAhje6R+4+n1HaGih
	O/NU1edHeuesieQe8MtdD3uApXJRhsOrsKbsoCZm0g35e22MgEhXpD27+w==
X-Google-Smtp-Source: AGHT+IEQfwW72fiopWEaiGYHQOMt1gcRAAKz84sp3Cng0TvQds9rT+IUnil1tQ90Bb7C2glXhnM3SA==
X-Received: by 2002:a17:907:7e8e:b0:a9e:b2da:b4a3 with SMTP id a640c23a62f3a-a9ef00190b1mr1683013266b.42.1731419396312;
        Tue, 12 Nov 2024 05:49:56 -0800 (PST)
Received: from [192.168.178.40] ([146.52.232.33])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee0dc4933sm718334266b.99.2024.11.12.05.49.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 05:49:55 -0800 (PST)
Message-ID: <e01952e3-8098-4490-a813-ed0d9457eb3e@gmail.com>
Date: Tue, 12 Nov 2024 14:49:55 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: target: tcmu: Constify some structures
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <f83cd8469cc17391178e1181e8c26c4c1fb6028f.1731330634.git.christophe.jaillet@wanadoo.fr>
From: Bodo Stroesser <bostroesser@gmail.com>
Content-Language: en-US
In-Reply-To: <f83cd8469cc17391178e1181e8c26c4c1fb6028f.1731330634.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11.11.24 14:10, Christophe JAILLET wrote:
> 'struct nla_policy' and 'struct match_table_t' are not modified in this
> driver.
> 
> Constifying these structures moves some data to a read-only section, so
> increase overall security, especially when the structure holds some
> function pointers, which is the case of struct nla_policy.
> 
> On a x86_64, with allmodconfig:
> Before:
> ======
>     text	   data	    bss	    dec	    hex	filename
>    93188	   6933	    338	 100459	  1886b	drivers/target/target_core_user.o
> 
> After:
> =====
>     text	   data	    bss	    dec	    hex	filename
>    93508	   6581	    338	 100427	  1884b	drivers/target/target_core_user.o
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Compile tested only
> ---
>   drivers/target/target_core_user.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 717931267bda..0f5d820af119 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -361,7 +361,7 @@ static const struct genl_multicast_group tcmu_mcgrps[] = {
>   	[TCMU_MCGRP_CONFIG] = { .name = "config", },
>   };
>   
> -static struct nla_policy tcmu_attr_policy[TCMU_ATTR_MAX+1] = {
> +static const struct nla_policy tcmu_attr_policy[TCMU_ATTR_MAX + 1] = {
>   	[TCMU_ATTR_DEVICE]	= { .type = NLA_STRING },
>   	[TCMU_ATTR_MINOR]	= { .type = NLA_U32 },
>   	[TCMU_ATTR_CMD_STATUS]	= { .type = NLA_S32 },
> @@ -2430,7 +2430,7 @@ enum {
>   	Opt_cmd_ring_size_mb, Opt_err,
>   };
>   
> -static match_table_t tokens = {
> +static const match_table_t tokens = {
>   	{Opt_dev_config, "dev_config=%s"},
>   	{Opt_dev_size, "dev_size=%s"},
>   	{Opt_hw_block_size, "hw_block_size=%d"},


Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>

Thanks,
Bodo
