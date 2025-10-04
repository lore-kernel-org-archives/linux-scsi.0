Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C369C2E0
	for <linux-scsi@vger.kernel.org>; Sat,  4 Oct 2025 04:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759551929; cv=none; b=eUPTpdl1TFzcb/KitbFOda3Q0CIwcOZ+GNKBKn7wkmHtP2K9mW7Xy+T7sHzvot9n7vaOlzRJ89VBPWxTfGtjoPndUCLjBdYPXODhqh/gmdvEhC6imzB8qxygrj/ZACc8BotOoqc9OVHQHh9DYckZmtZ157YDQDLBiB9ZL3dT1hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759551929; c=relaxed/simple;
	bh=fiW27OmyjIXRkHL2pKrvpjBTPjkKsM5SbUHrCosesFY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qWO0YvxHlRmD98zroSLSxGBfDLwqmQFw96qKtTLB0RT9VgngmSJR2eT5SvbUO9xT+OXTCkm6PT/xAtXcwyoRT11mzzI6NvfsHYsxzxFeJ0CQu/7wYBsGpd1JRchLsqjyyK9y3zitSP3zgbAF/tXuz2jUSslwGl3wdivgi5agj6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ges+vk12; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ges+vk12"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-330b4739538so2922920a91.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Oct 2025 21:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759551928; x=1760156728; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WBv4tgqW+U6sIw33UNpfqYOK3QxRW+OpJ8XW1KRAlQQ=;
        b=Ges+vk12rOg8RKBl/P0ALqMUGL8Tr/tqjq6tYrEw63ixBfeL7YmcQqNNVbvjCKL3Lq
         7pmoeOU9pTCH//vZU2SjruAoGqN5jmqCmzAkmiKt7Bt9BVAw6bKIs8T18VdKk/iZk5+5
         8Hf/X1dnpY7h+64qpt8H42Qo7ED68QAG+Jx2wH/URq9S2I9M+3wGRhlHi98+jKsd3yyJ
         qYuNRPsyqb7aSTX+A9d8obTpfQJshdpJ5pvrc6QKkV4sH2CLuG7Q6eMuQI3FYvywwZYd
         JT37Ot1Y5DVwcY54vEYgSeeViQACYMcTJTPOuRQlg4Fgl1jAX7YacaWy98Cn9infJ9GT
         MsyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759551928; x=1760156728;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WBv4tgqW+U6sIw33UNpfqYOK3QxRW+OpJ8XW1KRAlQQ=;
        b=oEP17rfXKXU3U7BAOgC01dXqxZGQkDUCLx9/vn6k3emi1Kl1WqwMTGhDz9WX/To4jm
         7JmUFlMEf1If21wUWoy/raFBdP1zsvacn5Mp+xKaqtf3aQheRl0Cy8d2Xywqk8S5CExW
         7D8VuQeu1JkM5A+QZxgYpEiZUc/+us44KcN4lQQQPC8HH1BHSzQz/corLlyc+d6DpYxb
         XQgyqtetnWBYCA48fqfzGdYc3gIbJ2sPodQUad/ixp8RA6VelFWJX9q9NaaNQEJS7Hdr
         KjhPGzYDnzUNz+p1ZcqHiSp14DMacmMx0YiPDv3RbMd986H3n34d4dh2uZ6slnsHXq/r
         zvHA==
X-Gm-Message-State: AOJu0Yzvbqfbys2dSTNmRNCzNFOC9YK67hXvdNsoyQcz7r4Mji2TqXci
	aEPKUwqmVcmkVEHCip1ZrZ0IX5xzEcjKSNcMefBDbAJXXLSO/JtWMMGB
X-Gm-Gg: ASbGncuSTFf2LlDLn1SfwK9903ZLkP8xXIMZg2ONrmif3PMKYUmy9iuDJcJLgCYN4r3
	+xrIA8gYmAQrGcCz52faQ1mcUtNNTG/fd6fd7iPo3UfJNhQqoEpBhpI89bc7A5wK/VlEo0S/zSF
	RIUUHOVXsX5IIoqsVdnh7DP47OQdTMi+zbVI/Z8S0LiXDd4v+SV6sYLn5GAXdbZJqoc68nPQuJQ
	ilmXPMspU2AOdFoMxkUdJWA/lqmsEvCX26ruoQ+mmUdd/+jOqDEoTadb8Sl5cx3TYYJkU9W91rv
	YrQnGXNOUwYuNZXjW63PRhrVVLff2D3nd87GaWoU9WeI3zp7vuXbAggfeZPo9MNCpUpkYiny4l6
	iRTqbdh8hn8+FR02XaaxcK4xmDej7ohmg4qCRjdQ22+X/NfTDE663HQ6hyKaeSzwCV4hj889Ci7
	I1o3HtPg==
X-Google-Smtp-Source: AGHT+IHZtUWxu6C3/1n0fAV2c9/VFRgP9VtSw4rwL9TRjMSv+Tk0bAkfADJ5CZZPdPXjkRgVgcjvVQ==
X-Received: by 2002:a17:90b:1d06:b0:329:d8d2:3602 with SMTP id 98e67ed59e1d1-339c27a2b9fmr7016159a91.17.1759551927689;
        Fri, 03 Oct 2025 21:25:27 -0700 (PDT)
Received: from [10.0.2.15] ([157.50.90.152])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-339c4a19fe4sm3825555a91.8.2025.10.03.21.25.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Oct 2025 21:25:27 -0700 (PDT)
Message-ID: <1c6cceec-da16-4867-88e0-c629accbb35c@gmail.com>
Date: Sat, 4 Oct 2025 09:55:22 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: Use kmalloc_array to prevent overflow of dynamic
 size calculation
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
 Don Brace <don.brace@microchip.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>, storagedev@microchip.com
Cc: linux-scsi@vger.kernel.org,
 linux-kernel-mentees@lists.linuxfoundation.org, skhan@linuxfoundation.org,
 david.hunter.linux@gmail.com
References: <20251001113935.52596-1-bhanuseshukumar@gmail.com>
 <7761904f64c554821e71e30b205e092fc2f8478e.camel@HansenPartnership.com>
Content-Language: en-US
From: Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>
In-Reply-To: <7761904f64c554821e71e30b205e092fc2f8478e.camel@HansenPartnership.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 03/10/25 20:23, James Bottomley wrote:
> On Wed, 2025-10-01 at 17:09 +0530, Bhanu Seshu Kumar Valluri wrote:
>> Use kmalloc_array to avoid potential overflow during dynamic size
>> calculation inside kmalloc.
> 
> This description isn't correct.
> 
> Given this check
> 
>>  
>> -	host_memory_descriptor->host_chunk_virt_address =
>> kmalloc(sg_count * sizeof(void *), GFP_KERNEL);
> 
> How is it possible that this allocation could ever overflow?
> 
> If you want to change the description to say using kmalloc_array is
> better practice or something (and the maintainer concurs) that's fine,
> but we can't have a false justification in the kernel git log.
> 
> Regards,
> 
> James
> 
Hi,

Thank you for your helpful comment. 
I will await till maintainer confirms if it is ok to push this change as v2 with
subject line similar what you have suggested.

Regards,
Bhanu Seshu Kumar Valluri
