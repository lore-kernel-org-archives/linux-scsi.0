Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA2D1F16B
	for <linux-scsi@vger.kernel.org>; Fri,  1 Mar 2024 23:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709334232; cv=none; b=YYqI115LXwyGtIhSvK6bHDQyy+gF22uvv2j1OJ8tI90vIB76eX/JX2sGHNkssvBnFEQYtDczw/3F+B7hatcnDSfdB6hKWt0kP4fbXrK5jYR1SYqxOvSxB3B4ByyaDQP8038O2rBU9hsMsQyvVHYlxewODkpQlGbYo4MBwgPPdz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709334232; c=relaxed/simple;
	bh=V1Hlfc6dmZRcMp6S6SU8k5QfMkvtwS7Xjk5etHhgvNc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z4AX13GzgwpaNCE/sCeoR5QX7niufKuiXT88PtBFzqjsiIViZqjvsjDIpvvrISmLmCmhh2Gjyqr/++T4C5qAe1MEEWK8FljHQ3DnttYqm+lfONR80y9LZZq9a5l3zqikOyIgcRkVccBi4wiPJe31fQLLbojnMN+XpcPbzbBLKRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-29a7951c6faso1984830a91.1
        for <linux-scsi@vger.kernel.org>; Fri, 01 Mar 2024 15:03:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709334230; x=1709939030;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zDBcm0T6rgKyLoiB1Oi0mYl1EU8mcx68QstEfWk1cG8=;
        b=e03qC1vIlIOx/zCIxGFXdraRc/HJbNC3n6xc0DzNyBJTPoz7oAMaviwv0217LTtTev
         coXkENtPEu4YYw629Dki3SQE5DZuKjfP9YsTAM0e5JhzuqOFRrdHBfmcNeqKsvxUN4Og
         4O47rw9TknIDFDHBOm1z142bjMlP2ffoiAnWJF2isYBWqRQU54KIrbri3ilttAOw95MX
         MDgt9kTvPp7QsFmu8SIch2Ucsng6ImfRi1AeNzq7Th651/zydqbfo7MGgQiY6WvNp5fP
         8+zVYIJfNoKLxRM6YNmEoyeZANPzpbD/VrDaQPc8sOtAtwmQCfgEm9rftl0KMCEb8k45
         cpdg==
X-Gm-Message-State: AOJu0YwnogtUywLwc7/qlXgDOpEJdyVu7f0QO6mOnrWWdi2XmVPBwG0+
	cRzmzGfCLvxcM7+1RXCAgst8f2AwtHtIGxR3M7SDg0ziDPtZNL0Z
X-Google-Smtp-Source: AGHT+IG958G7ECw8IZPnlGPuUfsk5za73ds8qmwRGeq80ecxmT273abIYLKVIcW6qaiprFgnBZDZ5g==
X-Received: by 2002:a17:90a:990b:b0:29a:4b13:786f with SMTP id b11-20020a17090a990b00b0029a4b13786fmr3001841pjp.36.1709334229866;
        Fri, 01 Mar 2024 15:03:49 -0800 (PST)
Received: from ?IPV6:2601:647:4d7e:54f3:667:4981:ffa1:7be1? ([2601:647:4d7e:54f3:667:4981:ffa1:7be1])
        by smtp.gmail.com with ESMTPSA id y6-20020a634b06000000b005ce472f2d0fsm3105554pga.66.2024.03.01.15.03.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Mar 2024 15:03:49 -0800 (PST)
Message-ID: <49b3e7b8-4e34-487a-8789-32f8b765ea1c@acm.org>
Date: Fri, 1 Mar 2024 15:03:48 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi_debug: Make CRC_T10DIF support optional
Content-Language: en-US
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20240229172320.2494100-1-bvanassche@acm.org>
 <d94983a5-9c0c-494d-8fb7-51e3dd2d3460@oracle.com>
 <61b4391a-8613-4ca5-b250-3253f2085712@acm.org>
 <fcad0227-dfd9-4fe4-b977-2eaf6242ea48@oracle.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <fcad0227-dfd9-4fe4-b977-2eaf6242ea48@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/1/24 10:18, John Garry wrote:
> On 29/02/2024 17:23, Bart Van Assche wrote:
>  >   config SCSI_DEBUG
>  >       tristate "SCSI debugging host and device simulator"
>  >       depends on SCSI
>  > -    select CRC_T10DIF
>  > +    select CRC_T10DIF if SCSI_DEBUG = y
> 
> So this means that we select CRC_T10DIF if SCSI_DEBUG is only built-in, 
> right?

Yes, that's correct. Without "select CRC_T10DIF if SCSI_DEBUG = y" the
build fails if CRC_T10DIF=m and SCSI_DEBUG=y.

Thanks,

Bart.

