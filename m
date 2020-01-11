Return-Path: <SRS0=vbb9=3A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA66FC33CA4
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jan 2020 20:23:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F54E20880
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jan 2020 20:23:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vZ2ZQzhb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731170AbgAKUXB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Jan 2020 15:23:01 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36061 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731119AbgAKUXA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jan 2020 15:23:00 -0500
Received: by mail-pf1-f195.google.com with SMTP id x184so2861699pfb.3;
        Sat, 11 Jan 2020 12:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=41KWMk1pZePqF7DfgTawJC7PFNFV1UU7PbNC+WCjwvw=;
        b=vZ2ZQzhbAdvQJc6i1VGPzo9PLxV1GRAtcj4FNeKlizCfjGVoIi1N+h4A+/941KxN+K
         Or5V7F/FqqwYcoY/I0IELwJMc1OB4/SeieFXzIQXNzzWHAJFiHE95uQYNxUWFE79oRqR
         SQZlM1xt9m+6DjAGHIR4JN+Ky8GXwFR83vc0513L656LSwct6Lf0m77fXi2k6tw2isKF
         f9+8Wpaeji9ri//KUKpJRXjfdo9GjKJLE9pdawsG4HeaW/e6Es0PrxCMCAUuHSAMyQAV
         lzMa/3Qlagy1ZW2ZrRKzsVFyQxoF43PQsooNsstDlyuGruyMrX2F+ZA4x8xxLL01cRwj
         63sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:from:to:cc:references:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=41KWMk1pZePqF7DfgTawJC7PFNFV1UU7PbNC+WCjwvw=;
        b=tbkucNVnTzmfcaSDn2PpG0mduXkGdk+XO+O392RSiGY0KOYUlAe4vPan3+x6DGIgKO
         kGeuHrIeI3M8LCQXiZXFcvTV6C4iYOKLA13mfa4AGPBcWI/Cy3TT9RdjbuE0pmePfgBm
         0LbUGpWXgKpMqlEeJ+UptuGvqfyuT/b90XvlyyBtllIhsDuR5EgfvIdhZG3Xvk1oGhDu
         36TSUmNMi2ccyPVb9KMwoFTn4roWH9GU6a0+LqM9O+PbE1x5OxYYBDGIbXQdstBchEzo
         iuqMGGoGJcFpmT8GkjrJ6kIm6pO6V6q3PfzXGkcNEdDnz1py4qp3VHpVlR6jodMVNPZW
         hOdw==
X-Gm-Message-State: APjAAAXNdIMhAASR74GnhuNMUhlDNTPDDUSkZ9IpD5K9p92OY+FOCYHN
        aL55M6qMFRYX2eY6NxRoOiw=
X-Google-Smtp-Source: APXvYqyzTVgDIcY913y1z652I02ZglZtHagv5esZ0OSA1Rm/rl7v3G+QeLDwAGkHey9qCR8Hz8yWjg==
X-Received: by 2002:a63:d306:: with SMTP id b6mr12428585pgg.195.1578774179696;
        Sat, 11 Jan 2020 12:22:59 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b193sm7962800pfb.57.2020.01.11.12.22.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jan 2020 12:22:59 -0800 (PST)
Subject: Re: [PATCH v2] hwmon: Driver for temperature sensors on SATA drives
From:   Guenter Roeck <linux@roeck-us.net>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        Chris Healy <cphealy@gmail.com>
References: <20191215174509.1847-1-linux@roeck-us.net>
 <20191215174509.1847-2-linux@roeck-us.net> <yq1r211dvck.fsf@oracle.com>
 <b22a519c-8f26-e731-345f-9deca1b2150e@roeck-us.net>
 <yq1sgkq21ll.fsf@oracle.com> <20200108153341.GB28530@roeck-us.net>
Message-ID: <38af9fda-9edf-1b54-bd8d-92f712ae4cda@roeck-us.net>
Date:   Sat, 11 Jan 2020 12:22:57 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200108153341.GB28530@roeck-us.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/8/20 7:33 AM, Guenter Roeck wrote:
> On Tue, Jan 07, 2020 at 08:12:06PM -0500, Martin K. Petersen wrote:
>>
>> Guenter,
>>
>>> Any idea how I might be able to reproduce this ? So far I have been
>>> unsuccessful.
>>>
>>> Building drivetemp into the kernel, with ahci and everything SCSI
>>> built as module, doesn't trigger the crash for me. This is with the
>>> drivetemp patch (v3) as well as commit d188b0675b ("scsi: core: Add
>>> sysfs attributes for VPD pages 0h and 89h") applied on top of v5.4.7.
>>
>> This is with 5.5-rc1. I'll try another kernel.
>>
>> My repro is:
>>
>> # modprobe drivetemp
>> # modprobe <any SCSI driver, including ahci>
>>
> No luck on my side. Can you provide a traceback ? Maybe we can use it
> to find out what is happening.
> 

I tried again, this time with v5.5-rc5. Loading and unloading ahci and
drivetemp in any order does not cause any problems for me.

At this point I don't know what else I could test. I went ahead and
applied the drivetemp patch to hwmon-next. Maybe we'll get some additional
test feedback this way.

Guenter
