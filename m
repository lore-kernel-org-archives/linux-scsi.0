Return-Path: <SRS0=Z6Af=26=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49951C33CA2
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 01:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C4942067D
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 01:04:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K4rKxVe3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbgAIBES (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jan 2020 20:04:18 -0500
Received: from mail-pj1-f44.google.com ([209.85.216.44]:53775 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbgAIBES (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jan 2020 20:04:18 -0500
Received: by mail-pj1-f44.google.com with SMTP id n96so371404pjc.3
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jan 2020 17:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RoBZPYJ2ZGHXkJ0X6/lMhjhbUJnpmZcpJUN34I/umOI=;
        b=K4rKxVe3osyi0eNTB5IYkJGNjYxWHflUhmDo7nlYU56emydmO4SF6qSh9uJW6+0PZC
         FujcJPiDWCoT5OuZstg2rYg0+IwKe8yxHswxxaaVKrg0p8CNeD201TzdAr4hD8ALGdSE
         vWyHi4D3VYrEQBnjnx5qFqUuvsV+CPTgwSOo472MLD5rygjbxnxi4zuGZqv7jrggcis2
         e5Y8aMzDNIu00CeYOhDkqohcOULPoMS8qDhOPDTzrHA93TeJbDiAVWyKwIsP1oXb5GgQ
         IhPcL19HH2NeRj4NBfapGDz4G17fmsUCZoPdc7rwtson9Fu7HoVMjYVAcPJkNBVmneZc
         kaAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RoBZPYJ2ZGHXkJ0X6/lMhjhbUJnpmZcpJUN34I/umOI=;
        b=uCHd7tAZMACFTNuhCdwU8ztVruz4p+dDzfYTm5q1HaW/V9S4wjTCug2sNyfpfS6oM0
         jyYfI3LGxaABeTNyhEPTOQ1JBqw7kfoDxB/KkIPjckLX0ui9hJ4GgKJ7v2otlb975Skd
         yebubg8Za/DaPN2EBh8WIhObGxiD0EQ10LqzPBJwJOPd8qD53C3onsUZVkqFibRvgqnv
         s6riWHEoymB4W2cVFZca66Ukmq911/vmfv24+2AWlalT5//AffDbxB1jeLyqxHJ9MV2V
         nQn/6fcvSIa7sfECKzDzx+aNyREOZCr5rbiF7mazexqDtH+TaELjO/ItARTwXZmWO+N/
         2e6w==
X-Gm-Message-State: APjAAAXD2IEg0/1aKb791T6Sg2gcenSOVrfdaNwdOchnd5mM3vAtjIv9
        7EfZ484/EDR3l6oDbLsqmm0=
X-Google-Smtp-Source: APXvYqzmu3vaigCwppjYS4muPDUAldM5iKbaElApIsRBx6TPqEU1z95pn4psgHoLDBtlj4BQNT+F/Q==
X-Received: by 2002:a17:90a:36af:: with SMTP id t44mr1894983pjb.25.1578531857724;
        Wed, 08 Jan 2020 17:04:17 -0800 (PST)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 12sm5219127pfn.177.2020.01.08.17.04.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 17:04:17 -0800 (PST)
Subject: Re: [PATCH v2 04/32] elx: libefc_sli: queue create/destroy/parse
 routines
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
 <20191220223723.26563-5-jsmart2021@gmail.com>
 <07c171f7-3d2c-a3ce-37ed-2b02f00fa6b2@suse.de>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <1b9bf0ea-3667-6109-152b-65af80459d43@gmail.com>
Date:   Wed, 8 Jan 2020 17:04:15 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <07c171f7-3d2c-a3ce-37ed-2b02f00fa6b2@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/7/2020 11:45 PM, Hannes Reinecke wrote:
> Hmm. Why do you return -EFC_FAIL here, and EFC_FAIL in the two cases above?
> Do you differentiate between EFC_FAIL and -EFC_FAIL?
> If so you should probably use different #defines ...
> 
...
> 
> '0'? Why not EFC_FAIL/EFC_SUCCESS?
> 
...
> EFC_FAIL?
> 
> Cheers,
> 
> Hannes
> 

We will remove all -1, -EFC_FAIL and return only EFC_SUCCESS/EFC_FAIL.

Thanks

-- james
