Return-Path: <SRS0=+W3W=3D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE202C33CA9
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 05:20:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94CFD2187F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 05:20:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eb1inmK6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgANFUz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jan 2020 00:20:55 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:39174 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbgANFUz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jan 2020 00:20:55 -0500
Received: by mail-pj1-f68.google.com with SMTP id e11so3772343pjt.4;
        Mon, 13 Jan 2020 21:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hpg375SG4OcRJmsXIQB4JvlM7mK+PXk3tVmm8/Xog0I=;
        b=Eb1inmK65871bjwXXURvt/KZT59pK0p9MojqskFZAmrJvcqKeyOsqgyh8nbp25X8II
         sQ4K+nd1xfS2arR49DGCUEB/UsSvNDocoNEXDKg9XPulWvmZoWYn8JLsPHNRB1PZ/YFk
         km3df9BKbMWALHC/3zZS84vGAdJHbvahhQBGxTNY6o4VYCQ0lmriUT5D9rRZJo+IiuyH
         uXDpHm3U6xWgPFHk6eULScXecxmdKqK4eHouICv/DNXzflv2eTAXrqjtkwAXvV0DjNof
         d0Z15lEPNJ9LJ2WbdX/GOqTyQDJvyBYVYGA+xKZTdqlkly3ErO2Ur1ooroKx5oDXh1Eq
         uorg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hpg375SG4OcRJmsXIQB4JvlM7mK+PXk3tVmm8/Xog0I=;
        b=STweey4Wr7mpQ8uNl/YGMY5KUMGlmhPpoe+J7u1BMni9pSRtLoVIZ+Ktf1V4zLq588
         cKqg482CufP2mySHeN9e8ULlIpgNBF1nWPfa0tdaDW2oVcGIj9LL0Vi2thBwUcLH7rsn
         wlORsFuPC5v36jLJDfD3F6y00u8IST8xHO0suI2FRIx4Ba5B7VDbQhoKFoSn2UPFPtRp
         XirEoPJvGoJF1VlLbVZGRE2cqKmBbyo23sWb8zjboyAwlrNyXv1kP+74mcS9/A1qWl0G
         atzcGXZmuGm1XYABFxQSOSgh7iQb7sY/xx5IcW1jTcK4ncKv6XTx0h6xLhPJL+SvXKBI
         c1tg==
X-Gm-Message-State: APjAAAW9/3EWMEg33Yuucum9KVFL9tuxBiBT+zTGZz+TzLNsq+sIFhE6
        uDMFr5meJRxXJLgA3KziwBY=
X-Google-Smtp-Source: APXvYqz58gFiJcD5qAaaAUtMBc+NyktKYV30g2WYNX6ECk+RvLjF+XG0PbzQF/2zzl966J49rSN+9A==
X-Received: by 2002:a17:902:724a:: with SMTP id c10mr18279878pll.307.1578979254311;
        Mon, 13 Jan 2020 21:20:54 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m3sm16042186pfh.116.2020.01.13.21.20.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jan 2020 21:20:53 -0800 (PST)
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
 <b22a519c-8f26-e731-345f-9deca1b2150e@roeck-us.net>
 <yq1sgkq21ll.fsf@oracle.com> <20200108153341.GB28530@roeck-us.net>
 <38af9fda-9edf-1b54-bd8d-92f712ae4cda@roeck-us.net>
 <yq1r202spr9.fsf@oracle.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <403cfbf8-79da-94f1-509f-e90d1a165722@roeck-us.net>
Date:   Mon, 13 Jan 2020 21:20:51 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <yq1r202spr9.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

On 1/13/20 7:03 PM, Martin K. Petersen wrote:
> 
> Hi Guenter!
> 
>> I tried again, this time with v5.5-rc5. Loading and unloading ahci and
>> drivetemp in any order does not cause any problems for me.
> 
> I tried your hwmon-next branch and it still happens for me. Both in qemu
> and on real hw. I'm really low on bandwidth the next couple of days.
> Will try to look later this week unless you beat me to it. I get lots of
> these warnings after modprobe drivetemp; modprobe ahci:
> 
> [ 1055.611922] WARNING: CPU: 3 PID: 3233 at drivers/base/dd.c:519 really_probe+0x436/0x4f0
> 
> A quick test forcing synchronous SCSI scanning made no difference.
> 

The hwmon-next branch is based on v5.5-rc1. It might be better to either
merge hwmon-next into mainline, or to apply the drivetemp patch to mainline,
and test the result. I have seen some (unrelated) weird tracebacks
in the driver core with v5.5-rc1, so that may not be the best baseline
for a test.

Thanks,
Guenter
