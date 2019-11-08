Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84059FC6195
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 14:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5815821D7F
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 14:33:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="Uc+0XKXh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfKHOdw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 09:33:52 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:37100 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbfKHOdv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 09:33:51 -0500
Received: by mail-il1-f193.google.com with SMTP id s5so5312354iln.4
        for <linux-scsi@vger.kernel.org>; Fri, 08 Nov 2019 06:33:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vjFrtw/BFflYelHD8o98Hq690NNXJ7cJs1titEez/pc=;
        b=Uc+0XKXhH2reTQzfsdxC5OYZZJp4hWzSccHyFmJI7DDzk7v3gjlNR3eF/0VSskkxIP
         ojav5IUWz5RjyQ8qtY66iOtKU5hC3q4xVHRIKwKhj56Q8bTWS1AgPQT4RkXea8OHT5oP
         7vaHluDTMa1pyv+LyC92ZjWHp5Web55G/lHle/LBSJf8KPLx6Q8LA5xwNFs+IQkqkWbT
         D+cksZX1ery1wFdfcWBA3bN02uh2G2r7yXszcUx172QxTGOEEXDEiGzi2rwtT936e4q9
         Xsc6WQcyGkgXXPFPtunNfQe8G0RW29QJT+fNFvRFZpuRozyTopfnJ72T16EbpCJzsQL3
         g6/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vjFrtw/BFflYelHD8o98Hq690NNXJ7cJs1titEez/pc=;
        b=bTIL/Dbs+K4eV8ryVTwNBFukLtrMmLpsyG/zzPkWMRdTM2SPxCWlPaY5XjrNL20HEZ
         FwvskQU5SLuLhCAQfKj0kCD9WkPIa50RiHT+RR/pKDyGgvCyyvXh9VOeR0ym6wk+YglL
         DJAKCorRtuQvnx8WeoG1BgVluJS6YCZkgTqC6cuzgalohkicCN2dIr9hQtoLlhVnh0sE
         z91c2RjyyUpS+62JHQVXpL48ccSZJtH8zUFjWqnEPowSnWHokxJgQXZkcjlhgrI3p3Km
         x3mq867/SX91fUoHMEZ/eikx0Y1dXsZxSj6vgRTVqVDawMZjXoK+bibD8cXiU0IOWLBd
         CGSQ==
X-Gm-Message-State: APjAAAX6tt4ZtKSIGJCny5m3wd5PKwhzRYhWP0hsEmBdMfhj28+bn0bk
        P725B8Gd/axzV2Wv159TX8ccKfElwXg=
X-Google-Smtp-Source: APXvYqzzo8tZh5qGUiRxpACPRILKqdIaMAMNe1+mjb9Boab7B6GRuyqZ5VZjLbkvu6RjAf6QsrNOsQ==
X-Received: by 2002:a92:8c0a:: with SMTP id o10mr11008361ild.249.1573223629218;
        Fri, 08 Nov 2019 06:33:49 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id d21sm488497ioe.86.2019.11.08.06.33.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Nov 2019 06:33:48 -0800 (PST)
Subject: Re: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Andrea Vai <andrea.vai@unipv.it>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1911061044070.1694-100000@iolanthe.rowland.org>
 <BYAPR04MB5816640CEF40CB52430BBD3AE7790@BYAPR04MB5816.namprd04.prod.outlook.com>
 <b22c1dd95e6a262cf2667bee3913b412c1436746.camel@unipv.it>
 <BYAPR04MB58167B95AF6B7CDB39D24C52E7780@BYAPR04MB5816.namprd04.prod.outlook.com>
 <CAOsYWL3NkDw6iK3q81=5L-02w=VgPF_+tYvfgnTihgCcwKgA+g@mail.gmail.com>
 <BYAPR04MB5816ECD4302AD94338CB9072E77B0@BYAPR04MB5816.namprd04.prod.outlook.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <72fc7fd1-cf86-969c-d1ed-36201cf9510a@kernel.dk>
Date:   Fri, 8 Nov 2019 07:33:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <BYAPR04MB5816ECD4302AD94338CB9072E77B0@BYAPR04MB5816.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/8/19 1:42 AM, Damien Le Moal wrote:
> On 2019/11/08 4:00, Andrea Vai wrote:
>> [Sorry for the duplicate message, it didn't reach the lists due to
>> html formatting]
>> Il giorno gio 7 nov 2019 alle ore 08:54 Damien Le Moal
>> <Damien.LeMoal@wdc.com> ha scritto:
>>>
>>> On 2019/11/07 16:04, Andrea Vai wrote:
>>>> Il giorno mer, 06/11/2019 alle 22.13 +0000, Damien Le Moal ha scritto:
>>>>>
>>>>>
>>>>> Please simply try your write tests after doing this:
>>>>>
>>>>> echo mq-deadline > /sys/block/<name of your USB
>>>>> disk>/queue/scheduler
>>>>>
>>>>> And confirm that mq-deadline is selected with:
>>>>>
>>>>> cat /sys/block/<name of your USB disk>/queue/scheduler
>>>>> [mq-deadline] kyber bfq none
>>>>
>>>> ok, which kernel should I test with this: the fresh git cloned, or the
>>>> one just patched with Alan's patch, or doesn't matter which one?
>>>
>>> Probably all of them to see if there are any differences.
>>
>> with both kernels, the output of
>> cat /sys/block/sdh/queue/schedule
>>
>> already contains [mq-deadline]: is it correct to assume that the echo
>> command and the subsequent testing is useless? What to do now?
> 
> Probably, yes. Have you obtained a blktrace of the workload during these
> tests ? Any significant difference in the IO pattern (IO size and
> randomness) and IO timing (any device idle time where the device has no
> command to process) ? Asking because the problem may be above the block
> layer, with the file system for instance.

blktrace would indeed be super useful, especially if you can do that
with a kernel that's fast for you, and one with the current kernel
where it's slow.

Given that your device is sdh, you simply do:

# blktrace /dev/sdh

and then run the test, then ctrl-c the blktrace. Then do:

# blkparse sdh > output

and save that output file. Do both runs, and bzip2 them up. The shorter
the run you can reproduce with the better, to cut down on the size of
the traces.

-- 
Jens Axboe

