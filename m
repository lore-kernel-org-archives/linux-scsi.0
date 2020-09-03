Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B78B8C433E2
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 16:48:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 909D820716
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 16:48:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="HycvFvKU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgICQsc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Sep 2020 12:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728343AbgICQsb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2020 12:48:31 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC8FC061244
        for <linux-scsi@vger.kernel.org>; Thu,  3 Sep 2020 09:48:31 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id p13so3341283ils.3
        for <linux-scsi@vger.kernel.org>; Thu, 03 Sep 2020 09:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dWbs2D7ANzSNApgDV75SxtXK8mm+ExUgsgrb2445HUo=;
        b=HycvFvKUxCWUdASfsCipUhClebD9ngU1VMnQ7xdq3oWqMPU9+TOe7cWK+61u9oGtIJ
         nwwSdivZtXqw3KSHCd5A7gKaPCzbOaK1dBUYmW4HcOdhl12pzhAize86ZmzuodnVnSOQ
         gSr9uBtn7ki36B8d0TsmDNwqmuBVdEbL2NSUmg0YO8cRuWIT78Y9/f44S7AAyfkmCVfI
         Y2WpDiykKxu8aoqO45qCTP6dX5oJSd1hvD6jWRoRBHA6rNSxhwPrl2oPl7LPkZ84zUYJ
         Oofuehcyd4kO4oceQyU3cCiRldldjxlVB0fFgpfCc+xHIzG/HKtaeG5sGbMzK803lfQz
         oPvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dWbs2D7ANzSNApgDV75SxtXK8mm+ExUgsgrb2445HUo=;
        b=L/3zLlSMWtmHXgvLfw2QdtsE54025Uq4Xshk/CjJ44xe2oQJ9q3aHLkuV2DwpYDWWI
         2/IHY2cHJgvPQuzt26p03NGhBip/WpSnEvxatM1DDP+/aJZBYNTbuMK/pY1pvF8cnXhw
         NI7BeC4BsA1gVckaGgg+hQJdOICr4sThM/34tyyVpn9TegMap+G0oxDj78vJY5gplilQ
         HoDsjN8ut7i/DOZi2DG6399qo+wDqYNshjJIsPNf37rf4SabvCD1WKckZW37zl0svdl0
         5kUI2/9/E8Lr519gcn/CqylX8OO7U66JFxE5r8SZ5aSh4334mh2lMWGnOuYNYNY0RUSq
         FVpg==
X-Gm-Message-State: AOAM531rIlTi8+eIRpftgUb9bOnnU9xrxYn8EJlIiH4k1T6gzlerSK5l
        QzD+X/Nmd5kWdG29BXWBtEmxmqAeCyHWOq00
X-Google-Smtp-Source: ABdhPJyN1OI6ne0Y65my3iOrtprtW+OAySj75BHVQ7V2McRNIW2DTYUkmTVNv8/NDGjtrNN03ZCJZw==
X-Received: by 2002:a92:d70a:: with SMTP id m10mr4054074iln.258.1599151711089;
        Thu, 03 Sep 2020 09:48:31 -0700 (PDT)
Received: from [192.168.1.117] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id i73sm1685754ild.61.2020.09.03.09.48.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 09:48:30 -0700 (PDT)
Subject: Re: [RFC] add io_uring support in scsi layer
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Philip Wong <philip.wong@broadcom.com>
References: <CAHsXFKFy+ZVvaCr=H224VGA755k45fAJhz5TaMz+tOP6hNpj1g@mail.gmail.com>
 <d8d14575-30e4-5d1f-cd97-266f8ba36493@kernel.dk>
 <497f13db2048a0c20cda72863acbce60@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fd77cbd6-c887-ec2c-6c5f-8344a410a645@kernel.dk>
Date:   Thu, 3 Sep 2020 10:48:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <497f13db2048a0c20cda72863acbce60@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/3/20 10:44 AM, Kashyap Desai wrote:
>> On 9/3/20 10:14 AM, Kashyap Desai wrote:
>>> Currently io_uring support is only available in the block layer.
>>> This RFC is to extend support of mq_poll in the scsi layer.
>>
>> I think this needs to clarify that io_uring with IOPOLL is not currently
>> supported, outside of that everything else should work and no extra
>> support
>> in the driver is needed.
>>
>> The summary and title makes it sound like it currently doesn't work at
>> all,
>> which obviously isn't true!
> 
> I actually mean io_uring with IOPOLL support. I will fix this.

Great, thanks.

>>> megaraid_sas and mpt3sas driver will be immediate users of this
>>> interface.
>>> Both the drivers can use mq_poll only if it has exposed more than one
>>> nr_hw_queues.
>>> Waiting for below changes to enable shared host tag support.
>>
>> Just a quick question, do these low level drivers support non-irq mode for
>> requests? That's a requirement for IOPOLL support to work well, and I
>> don't
>> think it'd be worthwhile to plumb anything up that _doesn't_ support pure
>> non-IRQ mode. That's identical to the NVMe support, we will not allow
>> IOPOLL if you don't have explicit non-IRQ support.
> 
> I guess you mean non-IRQ mode = There will not be any msix vector associated
> for poll_queues and h/w can still work in this mode.
> If above is correct, yes both the controller can support non-IRQ mode, but
> we need support of shared host tag as well for completeness of this feature
> in driver.
> Both the h/w are single submission queue and multiple reply queue, but using
> shared host tagset support we will enable simulated multiple hw queue.
> 
> I have megaraid_sas driver patch available and it does identical to what
> NVME driver does.  Driver allocates some extra  reply queues and it will be
> marked as poll_queue.
> This poll_queue will not have associated msix vectors. All the IO completion
> on this queue will be done from IOPOLL interface.
> 
> I tested megaraid_sas driver having 8 poll_queues and using io_uring
> hiprio=1 settings. It can reach 3.2M IOPs and there is *zero* interrupt.
> This is what NVME does so I assume this is what you wanted to confirm here.

This is exactly what I meant, just wanted to ensure it wasn't the poor mans
edition that we've seen before, we're IRQs are still triggered and you end
up getting completions from both manual finding via the poll hook, and from
the "normal" side. Because that kind of sucks.

What you have sounds exactly how it should be, both in terms of functionality
and implementation. Thanks for confirming!

Guess I need to take another look at the shared host tag set support, see if
we an get that in for 5.10.

-- 
Jens Axboe

