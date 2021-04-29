Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E4B1C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 08:39:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BD57613BC
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 08:39:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235399AbhD2Iki (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Apr 2021 04:40:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49361 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233714AbhD2Ikh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Apr 2021 04:40:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619685591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YziHZFF8ZYjt6d2ezm44ghu0dLtw0EhgTLZDtPz5/rc=;
        b=OvqSnqXKJMdQPBmoYa1OUmE2a0IQOJj3aFg0wiw7jz1qmVBKCX+T4RMlaKXUYxof5/OHz5
        wKvwR6+PlBO9K4Mj3/0ldyXDGSfIAARWsrEz8/NhhCvlXUpEYvkEBRdMfi4YobgmLZ85fm
        zQo148awXcLGfunGLVhwEZ86gB12yBA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-EXf_BoFXNAWx9zUXJRjDUw-1; Thu, 29 Apr 2021 04:39:49 -0400
X-MC-Unique: EXf_BoFXNAWx9zUXJRjDUw-1
Received: by mail-ed1-f71.google.com with SMTP id w14-20020aa7da4e0000b02903834aeed684so26607523eds.13
        for <linux-scsi@vger.kernel.org>; Thu, 29 Apr 2021 01:39:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YziHZFF8ZYjt6d2ezm44ghu0dLtw0EhgTLZDtPz5/rc=;
        b=i9/XjYsZsYULJLQnRyd6v3YV2lp7TkOdjsaCSAGHvwuyUKXmCHJO55gek3Q6hm10OW
         S0LyVKJzcM2ruP49UMSWueDidd8j28849Lu+FWONRaNlfd9qUbyiCD2D/7JsI1QrZw2s
         Dkwpo7BqhmXwRg5m8XaWUtfIPdBxRCYOswghDCTmBi13s1qFNwLkkl4pkJFFpnCuob8j
         kwiK13mP6QzssRmSJ70Z7m3l0+BWE03mCyUwqvcnruVd2yFXXcmLN667GHbUWfpY3fGL
         bV7e5azv9eYgLoRpTUb8xLcSFiSSk3KNGrFeVMCYfSHGGtVXfh5bImDXQ3zsYKK+svkI
         Jpkg==
X-Gm-Message-State: AOAM530yhiJDfj1hIknY4wuIcMbS8bT7L7qH6w7WUMN0ew57tQYQNyfO
        8SBQw9Rmznm94ydZ7uQ9rM3xLRpp8uA7qTVY0Oi2H3gFcBcMu+bnbYho00+pIDX7a7WlpJPLwPh
        WYhyeXBL7u5ayOZwFio3PUtIPLOo6vxuMGLsa6IsAL/3IRJSjq0ROPmKLvUVYRWRijhaWp9jTgQ
        ==
X-Received: by 2002:aa7:cc03:: with SMTP id q3mr17091520edt.366.1619685588002;
        Thu, 29 Apr 2021 01:39:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwd2TXhakCnmeWFFLQi2DCo7bfYX6fBe4+mzuRAM9OilcI3eUClhNV3iEkoklK6AA8G03NA3Q==
X-Received: by 2002:aa7:cc03:: with SMTP id q3mr17091498edt.366.1619685587829;
        Thu, 29 Apr 2021 01:39:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id e4sm1388137ejh.98.2021.04.29.01.39.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Apr 2021 01:39:47 -0700 (PDT)
Subject: Re: dm: dm_blk_ioctl(): implement failover for SG_IO on dm-multipath
To:     Martin Wilck <mwilck@suse.com>, Mike Snitzer <snitzer@redhat.com>
Cc:     Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
References: <20210422202130.30906-1-mwilck@suse.com>
 <20210428195457.GA46518@lobo>
 <26ac367a5a09ff5de628717721425fbc03018f44.camel@suse.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <395bdc56-137d-5f1d-ac0a-0ac5b76c02b3@redhat.com>
Date:   Thu, 29 Apr 2021 10:39:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <26ac367a5a09ff5de628717721425fbc03018f44.camel@suse.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 29/04/21 10:33, Martin Wilck wrote:
> On Wed, 2021-04-28 at 15:54 -0400, Mike Snitzer wrote:
>>
>> @@ -626,32 +626,16 @@ static int dm_sg_io_ioctl(struct block_device
>> *bdev, fmode_t mode,
>>                  }
>>   
>>                  if (rhdr.info & SG_INFO_CHECK) {
>> -                       /*
>> -                        * See if this is a target or path error.
>> -                        * Compare blk_path_error(),
>> scsi_result_to_blk_status(),
>> -                        * blk_errors[].
>> -                        */
>> -                       switch (rhdr.host_status) {
>> -                       case DID_OK:
>> -                               if (scsi_status_is_good(rhdr.status))
>> -                                       rc = 0;
>> -                               break;
>> -                       case DID_TARGET_FAILURE:
>> -                               rc = -EREMOTEIO;
>> -                               goto out;
>> -                       case DID_NEXUS_FAILURE:
>> -                               rc = -EBADE;
>> -                               goto out;
>> -                       case DID_ALLOC_FAILURE:
>> -                               rc = -ENOSPC;
>> -                               goto out;
>> -                       case DID_MEDIUM_ERROR:
>> -                               rc = -ENODATA;
>> -                               goto out;
>> -                       default:
>> -                               /* Everything else is a path error */
>> +                       blk_status_t sts =
>> scsi_result_to_blk_status(rhdr.host_status, NULL);
> 
> This change makes dm_mod depend on scsi_mod.
> Would you seriously prefer that over a re-implementation of the logic?

You could just make it an inline function too.

Paolo

