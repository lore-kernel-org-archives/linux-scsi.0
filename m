Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DC53B4E8B
	for <linux-scsi@vger.kernel.org>; Wed,  1 Jul 2026 07:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782889925; cv=none; b=tYkXnYRPxcPOOpsbACeLU4mYaPozoYjpm43yxa0eUKA5jwFoOaXP9Lg55VAjlyHN2IUbSVjJtI6E2xpH8uub34HwaulwY4W4mq+6u1bSX0Ep4q6/tNCQzyH+GHLYsdj04s8CbMUKay150AtSFzUL1WZarepcFFFpg96GBTZD6EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782889925; c=relaxed/simple;
	bh=M+tlOieiqe9VTehuccEv9JoE5ofZu5aY/gM7zDk/je4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NB2HgUd9Tfmk1L3CewoLq5Znff43E1E3R99kbf1+sjEzkC65VpV2lGavk4nfDUDF+qTsowvCjEzEF46tP/Fe6fnX0goxno2N2TB75KqFoS47BFKWXql8u2rQBxFNGN9u6Kn6vQHJEEaWnmQcPJUKBqZrClmqIGEgAJkeUiDMWDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=f/NB3/BT; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="f/NB3/BT"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-475cb71a4ebso271130f8f.0
        for <linux-scsi@vger.kernel.org>; Wed, 01 Jul 2026 00:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782889920; x=1783494720; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Frs6Emcy9pNNZIaepK2NrL0xBcYA3u3r9RRnho4i+Lk=;
        b=f/NB3/BTrtXKg9+sMcjez2F7WUqisz4tcfURyaBQ6TP+nogZwuBYpf5BdKDoJHg8YS
         yFqtcLMLzfZZehRmiNvKzM0qYbpZq7z6NiyzlbWyQLyDNFWPH3bjK9lzHbPco0q3CVDO
         nkXanfyoPUSVflvwujENE3eZDAUR7nfh3UNePoABprOhY62WG+wX9fjfKsr9ylrb2jOx
         ohBgAdIg9XkYDb/W8DfK1RYwujQFPP4US1nkNp8UsD7FBnr9wl3Blln3YK8pSa+MCk2G
         8AjtE558x92l+a1MDXVdlEvZbsLmkt5Jmq16BSI9G+n0Ac5lnXwtMj6DA5/xKEqKci9G
         4OGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782889920; x=1783494720;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Frs6Emcy9pNNZIaepK2NrL0xBcYA3u3r9RRnho4i+Lk=;
        b=WAlnzBMJwXsZ6HwH5/adxcoDb1V6DKEdLwS//ueRepXhabMvMBTPXPk/N7MajCEgbE
         +vF/lRUfmE1YBGtO4EHCSIM9WcCkc8uMSvqje3AB55TF2+FiwV2vRpjcKUT3hHODAS1J
         sOZdMHZ/I3sVhjDD3bPOHff1z5yuLBc2eYoA/FF1iBxu5nh0BZSKrXIT+zQZ8ZXl3mYN
         SaibZq2mmOn0P52Y186Q+Ps9GNP2xDNW0Goovhdw5e5opzeunzHfQuEME61IbJZaK6kq
         s/vv5pSErib1S2YsJK/9d8uZTaTiDgn8bbvbbAdFQXswPVKYwq3LUjJHUvfxoHpCWXNL
         aZDA==
X-Forwarded-Encrypted: i=1; AHgh+RquJuIpVRalLin7TbDTzfnnsooI141cUvcK4pyBodNw9c0ntooNl/i5KvHazC2G1FuO5lPqv4okad9G@vger.kernel.org
X-Gm-Message-State: AOJu0YzTesVTMcTerIdO0FfQiqjQp4FI/MK9JWacLQInNW7UEM44SGRE
	Uuz49g74AQKh7ry9CIaMDH6J4mUun15eh1I2P9RfCzFeKdWoNLsA/YuuxHI9KFkplK0DcbOvxU7
	Ig6uW
X-Gm-Gg: AfdE7ckMr1OoG2yxU5Z70BfRwIF/nCFgHmvlrxMycz9o7bWk/wuEA7tESsDEyUXdpCv
	Tsfia0COuA8KOU4kRNBHAsXBqcqckNxsgEwT/N82+uGkktU6gO4NNiCQQC0nf+HiTItFb3bzz2Y
	gSnot7wDcFiYE/+3kNechIOpbqErmS0d0fodoLUMyBqMcUhgzUyJ/PnarDPpFyqjMc7+8u+SluR
	4JW09RclktE6hTBiwZekp5DMOdeP1XZTZEpzIpRPqvQ0Zkki2/BAkZ6d2Mob2eQfI3m8kQtMdQi
	e89oMz0WqPKle/KDQsTRDnIC6lUF2xQUgmi61FXmbK4b+pGIpMUxWUYZT8aabv5NZdbJfqYjEPU
	YsHv3KV8DtzP7npOr2k2JhrGoaOXBaBqKcX3+mWAnC8S4ZuKKLpyaCQMqBoLIDN4nQTISXc2Jg5
	Nh3Syg6UUbjVnshjPf/MM0ZhhmurO93BoSFcdEb17VETj3aiM=
X-Received: by 2002:a05:600c:3e14:b0:492:437a:a653 with SMTP id 5b1f17b1804b1-493c2b9022dmr4676775e9.26.1782889445790;
        Wed, 01 Jul 2026 00:04:05 -0700 (PDT)
Received: from ?IPV6:2001:a62:1403:d01:fcc2:cfc6:9af3:a0c1? ([2001:a62:1403:d01:fcc2:cfc6:9af3:a0c1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493be81df2asm94738895e9.12.2026.07.01.00.04.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2026 00:04:05 -0700 (PDT)
Message-ID: <9bc4021f-0648-4cea-9f27-8ee2bd9e7088@suse.com>
Date: Wed, 1 Jul 2026 09:04:04 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] scsi: sym53c8xx_2: replace __get_free_pages() with
 kmalloc()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Brian King <brking@us.ibm.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
 <20260630-b4-scsi-v1-4-494fb37ebe7b@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260630-b4-scsi-v1-4-494fb37ebe7b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/30/26 12:54 PM, Mike Rapoport (Microsoft) wrote:
> sym53c8xx_2 driver has an internal memory allocator for small
> allocations of the driver structures. The backing memory for that
> allocator is allocated with __get_free_pages().
> 
> This memory can be allocated with kmalloc() as there's nothing special
> about it to go directly to the page allocator.
> 
> kmalloc() provides a better API that does not require ugly casts and
> kfree() does not need to know the size of the freed object.
> 
> Performance difference between kmalloc() and __get_free_pages() is not
> measurable as both allocators take an object/page from a per-CPU list for
> fast path allocations.
> 
> For the slow path the performance is anyway determined by the amount of
> reclaim involved rather than by what allocator is used.
> 
> Replace use of __get_free_pages() with kmalloc() and free_pages() with
> kfree().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   drivers/scsi/sym53c8xx_2/sym_hipd.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.h b/drivers/scsi/sym53c8xx_2/sym_hipd.h
> index 9231a2899064..aa365e8ba66f 100644
> --- a/drivers/scsi/sym53c8xx_2/sym_hipd.h
> +++ b/drivers/scsi/sym53c8xx_2/sym_hipd.h
> @@ -1110,9 +1110,9 @@ sym_build_sge(struct sym_hcb *np, struct sym_tblmove *data, u64 badd, int len)
>    */
>   
>   #define sym_get_mem_cluster()	\
> -	(void *) __get_free_pages(GFP_ATOMIC, SYM_MEM_PAGE_ORDER)
> +	kmalloc(PAGE_SIZE << SYM_MEM_PAGE_ORDER, GFP_ATOMIC)
>   #define sym_free_mem_cluster(p)	\
> -	free_pages((unsigned long)p, SYM_MEM_PAGE_ORDER)
> +	kfree(p)
>   
>   /*
>    *  Link between free memory chunks of a given size.
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
