Return-Path: <SRS0=WdRn=3Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F21BBC3524D
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Feb 2020 23:24:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D418D217BA
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Feb 2020 23:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbgBDXY3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Feb 2020 18:24:29 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:50970 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727412AbgBDXY3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Feb 2020 18:24:29 -0500
Received: by mail-pj1-f67.google.com with SMTP id r67so114845pjb.0
        for <linux-scsi@vger.kernel.org>; Tue, 04 Feb 2020 15:24:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nfUF0paBEl+JBOlCafgFfiZOacl0X2suq9kKdRtIx3o=;
        b=OcRj8fq27qUZ/MNI/q8GFyUYwDf29Zm/A4VI7YfQ3rX8nfOUC0WkYYlO9QlZVA8S0F
         57hZNss8azmqCIdEGxybW4kQlleVVxM4KGu1NjRLliBsRfm+cKsU3Q7DzihjP1TTCDL/
         aLxlRrgZpKiAnIYYcTwAZseDmFV2QEvyjZERLxcbVc5IFWrYMa/mHZCN4/H0ALMpvDL+
         Id3YMVHQtpMsfPUwkPL605xErOhoY89CxuFGEN/ieiEYMdUsTZ3FE7lhJtQVcQnmJeJI
         G/OFwy1oFKNkVlNSoPl9YNqBlk3Gt+r59qksBVPPwL5KWAncl1PPQxiicGaC6WjUI3ef
         zarw==
X-Gm-Message-State: APjAAAUyEJQgNDqU+243B/0pYtMNMtast8N/xL+bGii/qr2cQN/x0nMF
        GNyba9T6P+deF/7dXyko7ju5Xkdz
X-Google-Smtp-Source: APXvYqwZQ4acKbr0ES20dFivar/V8HC126/WJ/Ncu3VtIWUmBR6WyUVRrHjAhedLDeW5x+dHd4tjBQ==
X-Received: by 2002:a17:90a:5d85:: with SMTP id t5mr1993258pji.126.1580858668189;
        Tue, 04 Feb 2020 15:24:28 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id l8sm4678374pjy.24.2020.02.04.15.24.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2020 15:24:27 -0800 (PST)
Subject: Re: [PATCH] scsi: return correct status in
 scsi_host_eh_past_deadline()
To:     "Ewan D. Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20200204102316.39000-1-hare@suse.de>
 <688f38379efc25fb8adde2d5834b150e8db89c38.camel@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <0c9baacd-badf-e26c-77e2-b1fb1af9eff2@acm.org>
Date:   Tue, 4 Feb 2020 15:24:26 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <688f38379efc25fb8adde2d5834b150e8db89c38.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/4/20 1:54 PM, Ewan D. Milne wrote:
> On Tue, 2020-02-04 at 11:23 +0100, Hannes Reinecke wrote:
>> If the user changed the 'eh_deadline' setting to 'off' while evaluating
>> the time_before() call we will return 'true', which is inconsistent
>> with the first conditional, where we return 'false' if 'eh_deadline'
>> is set to 'off'.
>>
>> Reported-by: Martin Wilck <martin.wilck@suse.com>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/scsi/scsi_error.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index ae2fa170f6ad..ae29a9b4af56 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -113,7 +113,7 @@ static int scsi_host_eh_past_deadline(struct Scsi_Host *shost)
>>   	    shost->eh_deadline > -1)
>>   		return 0;
>>   
>> -	return 1;
>> +	return shost->eh_deadline == -1 ? 0 : 1;
>>   }
>>   
>>   /**
> 
> Hmm.  4 accesses to shost->eh_deadline in the function?
> Why don't we just copy it to a local variable and use that.

That sounds like a better solution to me and that would also fix the 
problem described by Hannes.

Bart.
