Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86BCEC2D0C8
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 03:57:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C62D2176D
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 03:57:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uHcqm7W3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbfLQD5g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Dec 2019 22:57:36 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46097 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbfLQD5g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2019 22:57:36 -0500
Received: by mail-pf1-f193.google.com with SMTP id y14so6756206pfm.13;
        Mon, 16 Dec 2019 19:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iCxYfSe4wfh5Oa268U6X7/B5eWsDv/JbGRRyvV87dDA=;
        b=uHcqm7W3PzpQu2wXLlo4vlInUiEOW1NW0HRrtfokI3T2/O6wtgcmbRjOQG3F0ks8J2
         UU1yGhmsq1uf6vX6kyu/Cg/X2dJSAjVi+3WBQAPjE2LsohRsR80Yx6O9RKAhmnchdmRd
         58/JYZS1v3AGwzP0V6ez8ryQ0A+cjh/+KzkEzFJ5nlOH+fA1ZxoCkw45BXj4b1wZT9BI
         6OuKZHqMh3uheN+xo/dL8tSU8DytbAUt709MyVg+JfTgaGkjKWgpFeViQenhRgENiz53
         kyjR1e5ivK0EHyYNTY1z+48hBh2auVjWcmNNTxjuLlw52nJ6ih49uHt+xnoy1dnSwQAF
         n6xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iCxYfSe4wfh5Oa268U6X7/B5eWsDv/JbGRRyvV87dDA=;
        b=liPz62p4MMYBQJ1bFzfHOyooYGHvo/+bvIPDyk1vvWxnc5jSJpzEn+z1J82aplHTrz
         EAoLzI6NQdRRn7wKi3avlNYi9JcodHW3GCkk7+9aXULTAERVs1/ipk8GJOOCiOCzd6JA
         QCXyPqmRBzejWcksbZ9GKb3XwSpf7XCT2xK3D76DP2POlcf5kz/PPW0F7vkJbQ1In8x1
         AFQh6knYUknEfo5ZpHC1W8uHOCjGbkprywVDqTXcZ853O0h0hKsHn05EZGaeaEYm2As4
         0XZoMC5H2BnH0sGzDVa5NpYLsphqFFDa1H6hsgD9kEnTgYnv7bgPaQsDsqAVOS6HZFfF
         d8tQ==
X-Gm-Message-State: APjAAAVRY22/ufvfbUg0l5JTeYBY1Aor8HwZHd/mPqr0WT+XT6oyf6Va
        ayxR733Xacejthx9/Rcv6crroozI
X-Google-Smtp-Source: APXvYqxWfrO+VkUtpr7Mu+1RYEbPbCCigVRj4dF8yKxw2ueMgAOyXi/Y+7TLPLC6K+Y43BudQixSuQ==
X-Received: by 2002:a63:5407:: with SMTP id i7mr22917017pgb.330.1576555055209;
        Mon, 16 Dec 2019 19:57:35 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d85sm24508645pfd.146.2019.12.16.19.57.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 19:57:32 -0800 (PST)
Subject: Re: [PATCH 0/1] Summary: hwmon driver for temperature sensors on SATA
 drives
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <20191209052119.32072-1-linux@roeck-us.net>
 <yq15zinmrmj.fsf@oracle.com>
 <67b75394-801d-ce91-55f2-f0c0db9cfffc@roeck-us.net>
 <yq1y2vbhe6i.fsf@oracle.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <83d528fc-42b7-aa3f-5dd9-a000268da38e@roeck-us.net>
Date:   Mon, 16 Dec 2019 19:57:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <yq1y2vbhe6i.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/16/19 6:35 PM, Martin K. Petersen wrote:
> 
> Guenter,
> 
>> If and when drives are detected which report bad information, such
>> drives can be added to a blacklist without impact on the core SCSI or
>> ATA code. Until that happens, not loading the driver solves the
>> problem on any affected system.
> 
> My only concern with that is that we'll have blacklisting several
> places. We already have ATA and SCSI blacklists. If we now add a third
> place, that's going to be a maintenance nightmare.
> 
> More on that below.
> 
>>> My concerns are wrt. identifying whether SMART data is available for
>>> USB/UAS. I am not too worried about ATA and "real" SCSI (ignoring RAID
>>> controllers that hide the real drives in various ways).
> 
> OK, so I spent my weekend tinkering with 15+ years of accumulated USB
> devices. And my conclusion is that no, we can't in any sensible manner,
> support USB storage monitoring in the kernel. There is no heuristic that
> I can find that identifies that "this is a hard drive or an SSD and
> attempting one of the various SMART methods may be safe". As opposed to
> "this is a USB key that's likely to lock up if you try". And that's
> ignoring the drives with USB-ATA bridges that I managed to wedge in my
> attempt at sending down commands.
> 
> Even smartmontools is failing to work on a huge part of my vintage
> collection.  Thanks to a wide variety of bridges with random, custom
> interfaces.
> 
> So my stance on all this is that I'm fine with your general approach for
> ATA. I will post a patch adding the required bits for SCSI. And if a
> device does not implement either of the two standard methods, people
> should use smartmontools.
> 
> Wrt. name, since I've added SCSI support, satatemp is a bit of a
> misnomer. drivetemp, maybe? No particular preference.
> 
Agreed, if we extend this to SCSI, satatemp is less than perfect.
drivetemp ? disktemp ? I am open to suggestions, with maybe a small
personal preference for disktemp out of those two.

>> The one USB/UAS connected SATA drive I have (a WD passport) reports
>> itself as "WD      ", not as "ATA     ". I would expect other drives
>> to do the same.
> 
> Yes. Most vendors are too fond of their brand names to put "ATA" in
> there. So my suggestion is to relax the heuristic to trigger on the ATA
> Information VPD page only and ignore the name.
> 

Fine with me. I wanted to be as restrictive as possible.

> Also, there are some devices that will lock up the way you access that
> VPD page. So a tweak is also required there.
> 
Do you have details ? Do I need to add a call to scsi_device_supports_vpd(),
maybe ?

> To avoid the multiple blacklists and heuristic collections my suggestion
> is that I introduce a helper function in SCSI (based on what I did in
> the disk driver) that can be called to identify whether something is an
> ATA device. And then the hwmon driver can call that and we can keep the
> heuristics in one place.
> 
> If a device turns out to be problematic wrt. getting the ATA VPD for the
> purpose of SMART, for instance, it will also need to be blacklisted for
> other reasons in SCSI. So I would really like to keep the heuristics in
> one place.
> 
Fine with me. My only concern is that I don't want the driver to disappear
into nowhere-land (again).

Thanks,
Guenter
