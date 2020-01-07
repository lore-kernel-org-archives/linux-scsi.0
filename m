Return-Path: <SRS0=hsTv=24=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2BF7C33C9B
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jan 2020 13:00:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 752BD2087F
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jan 2020 13:00:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="USaN/sz2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbgAGNAn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jan 2020 08:00:43 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41572 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727722AbgAGNAm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jan 2020 08:00:42 -0500
Received: by mail-pg1-f194.google.com with SMTP id x8so28474583pgk.8;
        Tue, 07 Jan 2020 05:00:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lvbtfIt25K3V9bkjoOOm4QAQQ2RLXWTWl1KKBEvQFkY=;
        b=USaN/sz2xKuxGlMgjZHB/wUWQ/8RghB5BDQntO5KHxNVHiYUNlXljkZOc+xBwlotWi
         iR0vr+2KKITG8AilRUMRJvatthQT/2UFg7eTxjT+LRAErQVgfryuIsKryfhO5LuNbdx/
         wSUFMCEdFIi99eFmxcmYny8U12L3h2jEPieIrMDf2rLBo7G0Nb2Y2jTw5rWt9QlWT4BT
         W/zAB5JN0aalf1nmGYQukNVY1UsCh6sT/VjlGjg0/ixeKb71W/s7Hxwy8RKU9Dx/b2Yo
         bE9f/bqLta8M7ohdj39m1HB4K2lvkAzwuPFkw+WH09pDEATD0mwOWflkmzVF2tsG6tUT
         9ZjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lvbtfIt25K3V9bkjoOOm4QAQQ2RLXWTWl1KKBEvQFkY=;
        b=GaZCja/Vdy6t7deyL9MlQH2w/9DdE52ZazACF0FreDMe0pgrLmiQvYN4ucoiz5Vo3u
         gF2hplvmOlAn8fzD/XXYgP4ZSwaZ306WZHesIQ6IRSMPU+23E8oMktBk/+A1jrnZBjNJ
         BCEnfexur18gxdWRgAafnzpAhTCWdSdgq47yGfU59SH4hJyIWCiVc7Px/HFGHPL5UDVv
         KK6nJH2mJewyHnsLKvZIfnfjQ0lfuFBYrhhBtkIYfLZ2Gow8dEmuak9mHXXhNb59PoPO
         rbE1yH917RSAzGcHooLMztDbB4kTKnNKsug2m9Gqf4CEHB0+WjHeSoyyNQi4hl+UiFn9
         wj/A==
X-Gm-Message-State: APjAAAVO40ydyDahA7IrUZE4sTApXjpcCNGn8k7KrnZRzj7KdtPzNesd
        7QpzVojUtpyoEODtykzZWRs=
X-Google-Smtp-Source: APXvYqz9WKLmVN/nRjjHtNkoSm6v+LC6l/HWdccIHNtmRotZJu3YefPowp/baIagDwVd/ryHNTbl6w==
X-Received: by 2002:a62:ac03:: with SMTP id v3mr113535234pfe.17.1578402041672;
        Tue, 07 Jan 2020 05:00:41 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j10sm28590800pjb.14.2020.01.07.05.00.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2020 05:00:40 -0800 (PST)
Subject: Re: [PATCH v2] hwmon: Driver for temperature sensors on SATA drives
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        Chris Healy <cphealy@gmail.com>
References: <20191215174509.1847-1-linux@roeck-us.net>
 <20191215174509.1847-2-linux@roeck-us.net> <yq1r211dvck.fsf@oracle.com>
 <20191219003256.GA28144@roeck-us.net> <yq17e233o0o.fsf@oracle.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <d42990af-78e4-e6c4-37ae-8043d27e565a@roeck-us.net>
Date:   Tue, 7 Jan 2020 05:00:39 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <yq17e233o0o.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/6/20 8:10 PM, Martin K. Petersen wrote:
> 
> Hi Guenter!
> 
>>>   - I still think sensor naming needs work. How and where are the
>>>     "drivetemp-scsi-8-140" names generated?
>>>
>> Quick one: In libsensors, outside the kernel. The naming is generic,
>> along the line of <driver name>-<bus name>-<bus index>-<slot>.
> 
> I understand that there are sensors that may not have an obvious
> associated topology and therefore necessitate coming up with a suitable
> naming or enumeration scheme. But in this case we already have a
> well-defined SCSI device name. Any particular reason you don't shift the
> chip.addr back and print the H:C:T:L format that you used as input?
> 
> However arcane H:C:T:L may seem, I think that predictable naming would
> make things a lot easier for users that need to identify which device
> matches which sensor...
> 

Not sure I understand. Do you mean to add "H:C:T:L" to "drivetemp" ?
That would make it something like "drivetemp:H:C:T:L-scsi-8-140".
Not sure if that is really useful, and it would at least be partially
redundant.

"scsi-8-140" is created by libsensors, so any change in that would
have to be made there, not in the kernel driver.

Guenter
