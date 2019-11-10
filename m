Return-Path: <SRS0=5ueY=ZC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3D0EC17443
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Nov 2019 19:26:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5C232085B
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Nov 2019 19:26:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Siv/CpPf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbfKJT0k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Nov 2019 14:26:40 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41715 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbfKJT0j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Nov 2019 14:26:39 -0500
Received: by mail-pg1-f196.google.com with SMTP id h4so7849559pgv.8;
        Sun, 10 Nov 2019 11:26:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=A1UK+CF1nyrj5jaHjk/tJnwBpEDeuyBk/YtvjUZpIv4=;
        b=Siv/CpPf7oQvCb6Z4v7KLya3vyubsYIwCa8aEV4CRhbHy0ZbFWFCraERJ6eJSzSUTW
         wSF2zVxfJ0euDLkXgjK3uIXQo34YQOTWqugsIDNJ5drQSJHFpO2lBwsFQrbxILWHSFCB
         adxn97yP9o8J8bnS9DlvalnJYbvoqCr/vKF7cAjoPLCNdRV6wUA4wVdsONYwzWRR1gHO
         J80xl2sorezvuv0JXByhvBWiMWVC6fK5wmROZL+tWGYkMsmS90kcMDUG44bJ9EPQIoQk
         fzE3fJnW5McM21ZrUNkmTwY0Jm7b+58JZxgWumbbMlO1Qssl6NQY7f7n+XgDX+emtRdS
         pflg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=A1UK+CF1nyrj5jaHjk/tJnwBpEDeuyBk/YtvjUZpIv4=;
        b=luUtUkRTz9z6k1tAAGCmlMDe/ZiRFI/HVEnJNjAzOdkevFSQG7qm/Y7KbT1t/QTLfO
         /0rvaA/A1YZ5rDi1zDP1iJ9YlL03pNcYUKaDFi2nSfebJIGd0fP4Yp46RiKDnYAMKyrT
         UtoIE4cmjvhNYBrziiYuyFGJEq61TZtJpbila9Dibqd7pDZgv9575/slFAUoxdlBbO0x
         zQgLQFqDtWkVdC8CkdmS/12ki7pGNZsiucx0ZWGgr1HQow/oGz9wiFVZUUQ+Q72Gx91E
         aC416Ew65jvPXyD8I4NjCcF6OFgpsXdqKrefFyXyfOkoIsQM1WU09KtZTY9mNbDDW70t
         OvBw==
X-Gm-Message-State: APjAAAVQYam2F+jY3hEtpHjV5KL68aoHVUN5iTLTAhw3Xv03PCP+05g/
        AkzbMLtsOcJgv/TDWTT48bXWzZ5a
X-Google-Smtp-Source: APXvYqxHB+Skst3JzlbqpMVe41GWzKHnbS3TYF5gfotf/8BVo/scwdX1GRzLCGEO5gfnowBJVZWfAw==
X-Received: by 2002:a17:90a:22a6:: with SMTP id s35mr28307287pjc.3.1573413999039;
        Sun, 10 Nov 2019 11:26:39 -0800 (PST)
Received: from ?IPv6:2001:df0:0:200c:c850:272b:f208:39af? ([2001:df0:0:200c:c850:272b:f208:39af])
        by smtp.gmail.com with ESMTPSA id w2sm12311031pgm.18.2019.11.10.11.26.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 10 Nov 2019 11:26:38 -0800 (PST)
Subject: Re: [PATCH] zorro_esp: increase maximum dma length to 65536 bytes
To:     Kars de Jong <jongk@linux-m68k.org>
Cc:     James Bottomley <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
References: <CACz-3rh9ZCyU1825yU8xxty5BGrwFhpbjKNoWnn0mGiv_h2Kag@mail.gmail.com>
 <20191109191400.8999-1-jongk@linux-m68k.org>
 <1573330351.3650.4.camel@linux.ibm.com>
 <6b914b12-cbc7-6fe6-7cba-3e89b2f6f19b@gmail.com>
 <CACz-3rjUh8tcShX5OPi+37JvF8PqG-8AEf5uMQHjMynSaVa1gw@mail.gmail.com>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <8c356175-e490-68c0-6114-5192eedc3a4f@gmail.com>
Date:   Mon, 11 Nov 2019 08:26:32 +1300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CACz-3rjUh8tcShX5OPi+37JvF8PqG-8AEf5uMQHjMynSaVa1gw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Kars,

thanks for your patch!

On 10/11/19 10:01 PM, Kars de Jong wrote:
> Hi Michael,
>
> Op zo 10 nov. 2019 om 03:36 schreef Michael Schmitz <schmitzmic@gmail.com>:
>> All of the old board-specific drivers used a max transfer length of
>> 0x1000000, only the fastlane driver used 0xfffc.
> Yes, I also found this when checking the old drivers.
>
>> That lower limit might
>> be due to a DMA limitation on the fastlane board. We could accommodate
>> the different limit for this board by using a board-specific
>> dma_length_limit() callback...
> Yes, I think that's the best idea for now. Oktagon also used to have a
> different limit but that was never ported to the new ESP core.

I can't remember the details, but as far as I recall it, the Oktagon 
used pseudo-DMA rather than hardware DMA. At the time I started porting 
Zorro ESP drivers to the new core, pseudo-DMA code was available for Mac 
only, and no PIO transfer for data phases at all, so I decided to leave 
that out altogether.

Might be a lot easier now that Finn has moved the PIO support code into 
the core driver. Someone could start with a PIO mode driver and add PDMA 
later.

>>> case for any of the cards the zorro_esp drives, it might be better to
>>> lower the max length to 61440 (64k-4k) so the residual is a page.
>> For the benefit of keeping the code simple, and avoid retesting the
>> fastlane board, that might indeed be the better solution.
> But it's slower... :-P
I wonder what max. transfer size had been used so far, in the majority 
of cases. I hadn't observed this bug in my tests of the ESP driver on 
elgar. So it might not matter so much in practice.
> Also, I may be adding another board-specific version for the Blizzard
> 12x0 IV to enable 24-bit transfers, like the am53c974 driver does, in
> a later patch.

If we can differentiate between the Mark IV board and the Mark II board 
in a reliable way, fine. I can't remember whether I've had a report on 
that ever.

I'd suggest to change the transfer size limit to 60k in the first 
instance, and add board-specific tweaks as needed when you add 24 bit 
DMA support for the Mark IV.

Cheers,

     Michael

>
> Kind regards,
>
> Kars.
