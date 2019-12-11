Return-Path: <SRS0=S2y6=2B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F239CC43603
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 05:57:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD9B32077B
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 05:57:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oMpWaVYh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfLKF52 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Dec 2019 00:57:28 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:33679 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbfLKF52 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Dec 2019 00:57:28 -0500
Received: by mail-pj1-f67.google.com with SMTP id r67so8492596pjb.0;
        Tue, 10 Dec 2019 21:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=V1z4CnyL3vaFU5di2fW8JaESd5vrN6gXo8REKlU0IHE=;
        b=oMpWaVYhbS6/S2DwY4jMKB/K77Bxlv7L5muzU6qOD17UaI96otfmXj30fJMHI9F1AM
         bGkhaW7Cza6EclGAR4CQhRASPCpegLrjD/lTTCBiq840f6Gi3ryj3b9UxyGv/897Vnqm
         8BD/4EpT4zWqX+fT5lDJTXqn/mOyxWOI1VjZno2O75V7qk9rFyhE6bdxWaszpj0Iwd1v
         cZZ2LmlirJfqSRrHUe39tqhJi713+oK/2WxOHsdwWEmqPo8Dxiwb3n0tuYFrcq0OwJjw
         BHV3Kkhs6zM8PMcurIOjDdMsFX8dtwHhUA7j7BRBAxVn6hi5APZHpMCRO6miTbNWUGIP
         ajxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V1z4CnyL3vaFU5di2fW8JaESd5vrN6gXo8REKlU0IHE=;
        b=rZ0eAP4O5hJ2ELb02/Xjet1vO+tz1yD/hSXwMoT2nAxe+0xfew9zIMwTVL58NhVDdF
         jtITtMCMfvC8A1DQX2RV2H8cyRNvjHAIbAbFPIFYa+xKUev5saZAp7+QsSJJm9KlnV01
         1F9kERuBhJjqTixeOrs9L7kffYot+/bP+YFwqtxPd8EdADLe2jPNS+y4K/DA2HOi2aG+
         2v0eoZMM9nA/nKtG2Iid0CUkReLM4kn1Uzoi8prZ0m0hU7zNoMYIRkOFnWUhxIyQDbf7
         vC03Z6D7HdJ+UiSVfrJhPshJG7cLYE8GZncJ/xczWm/TPbLVg7Ujla0hFkHK2UK0aRdX
         hLzg==
X-Gm-Message-State: APjAAAVIgqVxHSlgFfO/q2/FkgaEB34B/Nujt3htd62DT0I3obJ0GryL
        qQFam7J327JLqhY7jJcwvj0DhmSN
X-Google-Smtp-Source: APXvYqy0xa3OZvG6JsEDVhji1MGlsG5ZsNmSjOva8TPWeHXDmIGQKnHq3z+biQHL71vKoS3YHBEYFg==
X-Received: by 2002:a17:902:a404:: with SMTP id p4mr1463174plq.266.1576043846703;
        Tue, 10 Dec 2019 21:57:26 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s7sm912914pjk.22.2019.12.10.21.57.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 21:57:25 -0800 (PST)
Subject: Re: [PATCH 0/1] Summary: hwmon driver for temperature sensors on SATA
 drives
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <20191209052119.32072-1-linux@roeck-us.net>
 <yq15zinmrmj.fsf@oracle.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <67b75394-801d-ce91-55f2-f0c0db9cfffc@roeck-us.net>
Date:   Tue, 10 Dec 2019 21:57:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <yq15zinmrmj.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

On 12/10/19 8:08 PM, Martin K. Petersen wrote:
> 
> Hi Guenter,
> 
>> The most recent attempt was [1] by Linus Walleij. It went through a total
>> of seven iterations. At the end, it was rejected for a number of reasons;
>> see the provided link for details. This implementation resides in the
>> SCSI core. It originally resided in libata but was moved to SCSI per
>> maintainer request, where it was ultimately rejected.
> 
> While I am sure I come across as a curmudgeon, regressions is a major
> concern for me. That, and making sure we pick the right architecture. I
> thought we were making good progress in that department when Linus
> abandoned the effort.
> 

If anything, I am surprised that he did not give up earlier. Personally
I did not see a path to success after v7 of the patch set was rejected.

I also no longer believe that temperature monitoring of SATA drives
should be implemented within the ATA or SCSI subsystem. I came to the
conclusion that it is much better suited as separate hardware monitoring
driver. As separate driver, its instantiation is in full control of
the user. If it causes trouble (or, as mentioned separately, if it adds
too much instantiation time, or if it is considered to be too large),
it can simply be disabled in a given system by blacklisting it (or,
rather, by not explicitly loading it in the first place). With that,
there is no real compatibility concern. If and when drives are detected
which report bad information, such drives can be added to a blacklist
without impact on the core SCSI or ATA code. Until that happens, not
loading the driver solves the problem on any affected system.

>> The feedback on this approach suggests to use the SCSI Temperature log
>> page [0x0d] as means to access drive temperature information. It is
>> unknown if this is implemented in any real SCSI drive.
> 
> Almost every SCSI drive has it.
> 
Good to hear.

>> The feedback also suggests to obtain temperature from ATA drives,
>> convert it into the SCSI temperature log page in libata-scsi, and to
>> use that information in a hardware monitoring driver. The format and
>> method to do this is documented in [3]. This is not currently
>> implemented in the Linux kernel.
> 
> Correct, but I have no qualms over exporting the SCSI temperature log
> page. The devices that export that page are generally well-behaved.
> 
Also good to hear. However, for my part, I have no means to test such
code since I don't have any SCSI drives.

> My concerns are wrt. identifying whether SMART data is available for
> USB/UAS. I am not too worried about ATA and "real" SCSI (ignoring RAID
> controllers that hide the real drives in various ways).
> 

The one USB/UAS connected SATA drive I have (a WD passport) reports
itself as "WD      ", not as "ATA     ". I would expect other drives
to do the same. That drive reports (via smartctl) that it supports
both SCT and SMART data. It doesn't report temperatures through SCT,
but it does report the drive temperature with SMART attribute 194.
I did not attempt to add support for this and similar drives since
I don't know if I can reliably detect it. The potential benefit
compared to the risk seemed too low (we would be getting into
possible regression space) for me to try. Such code (effectively
it boils down to relaxing SATA drive detection) can always be added
at a later time.

> I am not sure why the SCSI temperature log page parsing would be
> complex. I will have to go check smartmontools to see what that is all

Not as much the parsing, but detection if the information is there.

> about. The spec is as simple as can be.
> 

Possibly. I personally also find it quite vague. It is definitely not
something I would want to try to implement without ability to see how
the data actually looks like as reported by a real drive, and without
ability to test the code.

> Anyway. I think the overall approach wrt. SCT and falling back to
> well-known SMART fields is reasonably sane and fine for libata. But I
> don't understand the pushback wrt. using the SCSI temperature log page
> as a conduit. I think it would be fine if this worked out of the box for

This is not a pushback per se. It is simply a matter of ability (or lack
of it) to test any such code.

Regarding "conduit", I assume you mean converting SATA/SCT information
into SCST temperature pages and reporting temperature purely based
on those. I personally think that this would be the wrong approach:
It would effectively require code in the ATA core which is not really
needed there. This would bloat the ATA code with no real advantage.
In my opinion, available temperature information should be interpreted
where it is needed, and only there, not in several places. I see that
as much less risky and error prone than spreading the code to multiple
places.

> both SCSI and ATA drives.
> 
The elegance of my approach is that adding support for reading temperatures
from SCSI drives (or, for that matter, USB/UAS drives) would be
straightforward. All one would need to do is to implement the necessary
detection code as well as a function to actually read the information
from the drive. This can be done at any time, and, again, it should be
done by someone with the ability to test the code.

> The elephant in the room remains USB. And coming up with a way we can
> reliably detect whether it is safe to start poking at the device to
> discover if SMART is provided. If we eventually want to pursue USB,  > think your heuristic stuff needs to be a library that can be leveraged
> by both libata and USB. But that doesn't have to be part of the initial
> effort.
> 
> And finally, my concerns wrt. reacting to bad sensors remain. Not too
> familiar with hwmon, but I would still like any actions based on
> reported temperatures to be under user control and not the kernel.
> 
All sensors can report bad information, and quite often they do.
This is actually quite normal in any given system. That doesn't mean
that the available (connected) sensors should be ignored.

Also, when it comes to actions, the one subsystem performing any actions
in the kernel based on temperature sensor information is the thermal
subsystem, and that is on purpose implemented in the kernel.
The hardware monitoring subsystem, on its own, is purely passive
and only reports sensor information; it does not act on it. Any action
will either be done by userspace (eg with fancontrol) or by the thermal
subsystem.

Overall, I understand the desire to also support temperature reporting
for SCSI and USB/UAS drives. As hardware monitoring maintainer, I'd
be happy to accept patches implementing that support. However, I don't
see this as immediately necessary, and I would want to have some
reassurance that such code is well tested and doesn't cause any
regressions (especially since concerns about possible regressions were
mentioned several times in the context of the previous submissions).

Thanks,
Guenter
