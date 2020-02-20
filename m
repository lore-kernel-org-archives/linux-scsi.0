Return-Path: <SRS0=qpW3=4I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 451EEC11D0C
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 16:40:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16445207FD
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 16:40:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbgBTQk4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Feb 2020 11:40:56 -0500
Received: from smtp.infotech.no ([82.134.31.41]:46533 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728119AbgBTQk4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Feb 2020 11:40:56 -0500
X-Greylist: delayed 596 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Feb 2020 11:40:55 EST
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 0AD8820424C;
        Thu, 20 Feb 2020 17:30:58 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wkrkYvupg6ch; Thu, 20 Feb 2020 17:30:56 +0100 (CET)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 9661C2040E4;
        Thu, 20 Feb 2020 17:30:55 +0100 (CET)
Reply-To: dgilbert@interlog.com
Subject: Re: ioctl seems to change errno behaviour in 5.6.0rc2
To:     Antonio Larrosa <alarrosa@suse.de>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
References: <68516393-f24a-dbb5-4c81-99fb1b70bb6f@suse.de>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <3b6cf3fb-675e-fdea-590e-31d73ccab4cd@interlog.com>
Date:   Thu, 20 Feb 2020 11:30:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <68516393-f24a-dbb5-4c81-99fb1b70bb6f@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-20 11:02 a.m., Antonio Larrosa wrote:
> Hello,
> 
> I noticed cdparanoia stopped working with kernel 5.6.0rc2 while it worked fine
> with 5.5.2 .
> 
> Running as root `cdparanoia -v -d /dev/sr0 [0]` with 5.6.0rc2, gives the
> following errors:
> 
> Testing /dev/sr0 for SCSI/MMC interface
>          no SG_IO support for device: /dev/sr0
> Error trying to open /dev/sga exclusively (No such file or directory).
> 
> I checked that the sg module is loaded with both kernels and also did a diff of
> the lsmod output with both kernels and didn't find anything suspicious.
> 
> After some tests, I did a small c application using code from cdparanoia where
> it can be seen that the ioctl(fd, SG_IO, &hdr) call returns EINVAL in errno with
> the 5.5.2 kernel but returns EFAULT with 5.6.0rc2 .
> 
> The code is attached and can be built just with `gcc test.c -o test` (note it's
> hardcoded in main to use /dev/sr0, so it doesn't have any parameter).
> 
> Note that I'm not a cdparanoia developer (in fact, it seems to have been
> unmaintained for many years), but I thought it might be interesting to report an
> ioctl that changes the behaviour in different kernels.

Antonio,
A fix is in the works for this, see:
    [PATCH] compat_ioctl, cdrom: Replace .ioctl with .compat_ioctl in four 
appropriate places

by Arnd Bergmann on the linux-scsi list.

Doug Gilbert


