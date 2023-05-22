Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 630E2C7EE2A
	for <linux-scsi@archiver.kernel.org>; Mon, 22 May 2023 20:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbjEVUvz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 May 2023 16:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjEVUvz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 May 2023 16:51:55 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFFC92;
        Mon, 22 May 2023 13:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1684788705; i=deller@gmx.de;
        bh=PlwiIjbt31eASWGjhy+grQ3UHqKEgPfDTNdFcM3wHws=;
        h=X-UI-Sender-Class:Date:Subject:To:References:From:In-Reply-To;
        b=K1nPPummJSI7JYFm698wuU7sJnI2n88QjQUGQQFafh4GPbY/tGRfk6UZaRqDds0+9
         lRYunmX3LVguH9+ZUdBbLXwCxiNyYNanP0RVwwws+GTt/70/DgfarEUs0zj4FOdqYR
         IYVHcelzhecBk3N7I6d32+0XX9BuMYyOFpkVm8NlynjpD6ytAUX60QpKL20Ny8eYNm
         YA2hz76eO5iEOEQYSSGhAq2psD0pKVw5cY5T0MFM04gFNT1+LnjJY6Onn+m8yT1Ra9
         XdBFKC2HyBI6uk12pCC1WnJQV5h43XNSj9P9Iyw/bgWEI4++XtrGO4eRDNDDlIYxH0
         hyB6u/a9k1O7g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([94.134.144.112]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mxm3Q-1qLKd520vW-00zEA6; Mon, 22
 May 2023 22:51:45 +0200
Message-ID: <8bd7faad-abf4-f7b3-03c9-e06f9b5d2148@gmx.de>
Date:   Mon, 22 May 2023 22:51:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: spinlock recursion in aio_complete()
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        linux-aio@kvack.org, linux-parisc <linux-parisc@vger.kernel.org>
References: <5057d550-c3f4-be34-d3e6-390790051232@gmx.de>
 <89053bf1-6bc3-3778-7662-14d15bd778a3@acm.org>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <89053bf1-6bc3-3778-7662-14d15bd778a3@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:b4PH3HvBV4wZ7jefTyqXdSuXHKGxrGZFZOLEaNETAjmjdcbdgUG
 RPL+bpFkCh4Sxdhdrm7k9c0PvqUpkJx9F0GBZAXutdYKAoy8k3a5GHWwDOZEmz4kPci13sG
 UAvnLp6jvJ92mloPTBqT6ruydbjuyNkAWHa2c+g6rCyWFfuPFVk9Dil/mzuHz9SafR935hw
 yX9n6in/hjYr/9iCKVMNQ==
UI-OutboundReport: notjunk:1;M01:P0:WPRbdojmkes=;i2ZnPMdoqwtiOk0LjluAg/Y53OP
 t5WSN7xaPblH0knq0JFHD4aa3rB91gYl0q/uSDzmzDb0RXd3gcFidCzN4gloSjiQoWB5byohS
 1SZvZxxK+yKOYij26ixu2nqEXaOYMSjLoR8xgNikDVO5NMSAAOg1mVOPC+joC+F3ebc84z6D5
 zlaifXiewPvCkEqIZng/SPRGo+zcUOxs6MBxCKDZQ+5GBjGyGRfBREibNDIWBA1mXTpB12LZ0
 bk3nMUA4iRWpLBn4AZS3iLKb6Rs29a6nvKgLN9e5gqV3Jifa+If09BHvirpAylUFKATixLm8F
 ut1K+dji9oeloM4zZzgnLEc5KVTG1gwhxuingVm1oHCyNe71hbvUxCzYXYPLdm7uXzlZsuzaN
 dTV4oYuX/LGzCSr9lC3JYuaGXSFwOBXaXM8z6z5F1oEbEOBIoDt54C8KZitfOuqec0x7WdR4w
 1NH69iCKadYDkM6VttxKQGtD3O90V2ecO671AcCMrc/P7oHCNzbc23kYSyCvgh3+/ejLXytlp
 W8Cn+Ni/SOF2YQfm2JQStqWA+g29nKcR64xlaLOArKVf+1hN+DI7eD1t3GgVXdMYtgaDidEUJ
 3q7kJdkK/6w4RQYMiXmV85XfH5DsAASNy9rU5cEgVZgEuHKur4d/w25NXYBu1oMYnysnzy4y8
 GalYw8sudY0+Onm3x4P6xKMgy423Dr4Hy0kwTvWjRAgJjQ7/HgkLR0rseZbNkIqQxWZKzn+0b
 nI/LHsZXd6MfeVTs8K93PQbgNRMRxRqnSo28o/e6rSu6hVg7Rd5jpKA8sZ25qOr0VMBBMhdF8
 ha2BXBEDPIWj1e0cPsWVq/cv4Q6oSEm51Ih6a+oNc0N04xrRD1U/CGJmveTJ6CRZwNbI0pE+T
 JQpTiAeWReAbhRpG7pQZeaFapmeZj64pIt0N2pB5zoqkIsuzOW00hfECpc+UVu7Cskql2j1Qi
 xHYf+g==
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/22/23 21:28, Bart Van Assche wrote:
> On 5/20/23 22:43, Helge Deller wrote:
>> On a single-CPU parisc64 machine I face the spinlock recursion below.
>> Happens reproduceably directly at bootup since kernel 6.2 (and ~ 6.1.5)=
.
>> Kernel is built for SMP. Same kernel binary works nicely on machines wi=
th more than
>> one CPU, but stops on UP machines.
>> Any idea or patch I could try?
>
> How about performing one or more of the following actions?
> * Translating aio_complete+0x68 into a line number.

It hangs in fs/aio.c:1128, function aio_complete(), in this call:
	spin_lock_irqsave(&ctx->completion_lock, flags);

> * Repeating the test with lockdep enabled.

Hmm... We don't have LOCKDEP yet on parisc :-(

> * Bisecting this issue.

Will try, but this process is *very* slow as it happens on one machine onl=
y,
it's only accessible remotely, uses endless time to reboot and I have no
easy way to netboot kernels...

Helge
