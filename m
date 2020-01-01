Return-Path: <SRS0=DSfB=2W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF8AC2D0DF
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jan 2020 17:46:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DC4B2073D
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jan 2020 17:46:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UNRFGzzS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgAARq0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jan 2020 12:46:26 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45891 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727234AbgAARqZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jan 2020 12:46:25 -0500
Received: by mail-pl1-f196.google.com with SMTP id b22so16949359pls.12;
        Wed, 01 Jan 2020 09:46:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jgFQTqseU0AOmtbn0bXATUNb8DmaYbEHD/mrJGCMGbQ=;
        b=UNRFGzzS1y/I5c1sv6nxOMRtNrS0HCd6gOFGIT8F4wnx2BxLzNpbEgKDfjeczU2Sq8
         tBK+RKZT+k30Ckh6kPObJXTldb8lu4hb2yUEtJbIRPsNBSwyGNgazVBLlB6Udpwst5bL
         MosjSgK9f8FwGbSNCvAUaS8irkq86BjjJO2SuVZ8EPFSq5+sS8WMcsH067BjfOPNZH3z
         9Ch9WnaIqp60Sn/ACxxtR8Jvcbde7APYD9mxuZ4RsFOx8KqwbwALWcifnPzolYPHPY+U
         sJg/9giUIn+YCHloFsDxmIsxhUJ/Por0Yl6zJrlgyI9XqIUNJnnSIu/TKgeoK69ADiZp
         Za5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jgFQTqseU0AOmtbn0bXATUNb8DmaYbEHD/mrJGCMGbQ=;
        b=soaN8MKUX07aLYKG8ul8Axt2/wW6gFAzzOKxigALHlZX5/aSRqEvzHHg3wPgTQ57Pr
         +hycxPr74KiasUnnRQfvCv+5ST8fJEsp5o6uXj40G6HsaE69MGF5j/QmCNLM8/ErWLtG
         UCoyiqrNsuACbbPAtGnoRN3f+pT9bR/V386698ygSidytAtUCEazK5WMtN6M/aVWWoKv
         XcY9aCI9GfykHWxqdnZFoJaA8RNX+/GbynBGw5XIrXRQV5pGIeRk9Lo4xtymtQ1Odcb+
         oTZuM4r1a5u6qDAgNynrYwMjcigOhatPqMs0h6u2uoNATiK+PyPcwFMXhVyjD+bzwNJV
         aI1Q==
X-Gm-Message-State: APjAAAWEcbg/JYGL+G4QWjqdCdc9SB9JAXOT7+GEwfQ2O16KxNPkLPNQ
        3UcEBNWocvW3ttkL+Ia04Qk=
X-Google-Smtp-Source: APXvYqy1a++YnyCNOnWLIYqvsCOFO/RVcKBMCIhyX+zWGvbzERkJB9E/9pn3Z5EQ8i/HKKGvIQigzQ==
X-Received: by 2002:a17:902:d694:: with SMTP id v20mr41272054ply.127.1577900784990;
        Wed, 01 Jan 2020 09:46:24 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b128sm56470997pga.43.2020.01.01.09.46.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jan 2020 09:46:24 -0800 (PST)
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
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <b22a519c-8f26-e731-345f-9deca1b2150e@roeck-us.net>
Date:   Wed, 1 Jan 2020 09:46:23 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <yq1r211dvck.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

On 12/18/19 4:15 PM, Martin K. Petersen wrote:
> 
> Guenter,
> 
>> This driver solves this problem by adding support for reading the
>> temperature of SATA drives from the kernel using the hwmon API and
>> by adding a temperature zone for each drive.
> 
> My working tree is available here:
> 
>    https://git.kernel.org/pub/scm/linux/kernel/git/mkp/linux.git/log/?h=5.6/drivetemp
> 
> A few notes:
> 
>   - Before applying your patch I did s/satatemp/drivetemp/
> 
>   - I get a crash in the driver core during probe if the drivetemp module
>     is loaded prior to loading ahci or a SCSI HBA driver. This crash is
>     unrelated to my changes. Haven't had time to debug.
> 

Any idea how I might be able to reproduce this ? So far I have been
unsuccessful.

Building drivetemp into the kernel, with ahci and everything SCSI
built as module, doesn't trigger the crash for me. This is with the
drivetemp patch (v3) as well as commit d188b0675b ("scsi: core: Add
sysfs attributes for VPD pages 0h and 89h") applied on top of v5.4.7.

Thanks,
Guenter

>   - I tweaked your ATA detection heuristics and now use the cached VPD
>     page 0x89 instead of fetching one from the device.
> 
>   - I also added support for reading the temperature log page on SCSI
>     drives.
> 
>   - Tested with a mixed bag of about 40 SCSI and SATA drives attached.
> 
>   - I still think sensor naming needs work. How and where are the
>     "drivetemp-scsi-8-140" names generated?
> 
> I'll tinker some more but thought I'd share what I have for now.
> 

