Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D22CC7619A
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Apr 2023 21:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjDBVuk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Apr 2023 17:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDBVuj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Apr 2023 17:50:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126EB7299
        for <linux-scsi@vger.kernel.org>; Sun,  2 Apr 2023 14:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680472190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I57Cy8VgSd+8+9mPivP7ZtH1YY46ErBBKh+KfgMyZ4o=;
        b=DEIWAjtEsQFl7YS9OUzPXYMaoB223fQNCD8gmXaN3FGdMbUb5kLRkHWYrQHDdGp3FptQaf
        hCaCb0h1fJyMX/kozUjvCI5VnWPNUQrEsaHvPgs5Y120oD03LMu/VjNpZVuBG0odArNfR+
        lhVn6phQJQfoQDVRm63r6ZTuZ30mNk4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-GSPJa-y1MtaIxkrfh9KW4Q-1; Sun, 02 Apr 2023 17:49:49 -0400
X-MC-Unique: GSPJa-y1MtaIxkrfh9KW4Q-1
Received: by mail-ed1-f69.google.com with SMTP id f15-20020a50a6cf000000b0050050d2326aso37904169edc.18
        for <linux-scsi@vger.kernel.org>; Sun, 02 Apr 2023 14:49:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680472188;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I57Cy8VgSd+8+9mPivP7ZtH1YY46ErBBKh+KfgMyZ4o=;
        b=lCemNIbDXEYTjdS4Qkkc2pzjObl0XpLrs3LwKtzTfE2akJ0sOC9006Wfoj15Uo4gIh
         u9YshFg9fg81JaHxitSj3BJweT11pVrMzjME/Xypzy3iRG5DkDP5B9KXfPHkEndVJ8FE
         EXbcnavE4LF7ywJIrZeeTTYuRCSJQvjxiqEelspMGqPzDZLM+v/GzzIqVXQeYYsxRf4k
         /pekVsYjm7WS/oZVWoWP96yidVDRlI6ncZKA99/BbcH+qtBXNzMNTyEcshalYHtRjjxl
         igu+oGTyXo53w6eqLfM9sYfbr/DvAIn4aRCTZhCChNMAI118Rak0qGJHCQanGms7p8Ri
         sqpA==
X-Gm-Message-State: AAQBX9enPtZXOgEhNviEREggQev74E6yxqcl6XsX+IvihzBJITgh1wY6
        0sp5UdRnLDqaVTU4bfTWfhjUu9osbTT9temFZ5h0lVkjBDKwB4c8vf4CxVhU9J9NS/Uza/OiY9k
        ZH+zjDKUurHjucFt5ZprA7w==
X-Received: by 2002:a17:906:32d5:b0:926:c9e4:f843 with SMTP id k21-20020a17090632d500b00926c9e4f843mr35572602ejk.59.1680472188569;
        Sun, 02 Apr 2023 14:49:48 -0700 (PDT)
X-Google-Smtp-Source: AKy350YXh582dneT8oBRNHW5k/lhVjWUxA2donGHJq/7XNo6skEICaUYEVVv5scFAymizVrFYHTi8A==
X-Received: by 2002:a17:906:32d5:b0:926:c9e4:f843 with SMTP id k21-20020a17090632d500b00926c9e4f843mr35572595ejk.59.1680472188267;
        Sun, 02 Apr 2023 14:49:48 -0700 (PDT)
Received: from [192.168.0.108] (ip4-83-240-118-160.cust.nbox.cz. [83.240.118.160])
        by smtp.gmail.com with ESMTPSA id t12-20020a170906608c00b0093d0867a65csm3685997ejj.175.2023.04.02.14.49.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 14:49:47 -0700 (PDT)
Message-ID: <3b5cf6e6-9dec-880f-7807-6d0461cbf514@redhat.com>
Date:   Sun, 2 Apr 2023 23:49:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] scsi: sd: mark the scsi device in shutdown as deleted
To:     Bart Van Assche <bvanassche@acm.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20230330164943.11607-1-thenzl@redhat.com>
 <af17886b-5b18-f71f-9fe7-ea929f30b5a6@oracle.com>
 <e4dd3ea37807166820e3b3b7e5102e23ab6b3898.camel@HansenPartnership.com>
 <457808a0-1ec2-d846-075c-7f8812a7a416@redhat.com>
 <488bb066654104bc6b84fdc45595232305519597.camel@HansenPartnership.com>
 <33501374-2cc7-ba1c-9d42-0da2aeed4341@redhat.com>
 <0afc900c-2717-6751-de54-9f65bf127484@acm.org>
Content-Language: en-US
From:   Tomas Henzl <thenzl@redhat.com>
In-Reply-To: <0afc900c-2717-6751-de54-9f65bf127484@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/31/23 20:48, Bart Van Assche wrote:
> On 3/31/23 11:32, Tomas Henzl wrote:
>> The patch doesn't fix a real bug so it isn't urgent nor important,
>> seeing the congestion it creates please just drop it.
> 
> Hi Tomas,
> 
> I'm interested in failing future I/O from inside sd_shutdown() because 
> it would allow me to remove the I/O quiescing code from the UFS driver 
> shutdown callback.
I'm aware of this, other drivers do have similar code and so it would
help elsewhere as well. The patch as it is doesn't however ensure that
there isn't for example an I/O started before sd.shutdown which may
arrive in a driver after his shutdown has been called. Because of that I
haven't used this as an argument in the discussion here.

Regards,
Tomas

> 
> Thanks,
> 
> Bart.
> 

