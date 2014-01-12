From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 5/6] scsi_debug: prepare to enable clustering
Date: Sun, 12 Jan 2014 10:28:52 +0900
Message-ID: <CAC5umyhUnzVfcAqzFTpNWD1JqgGSB5rYN92cgtQc5nsUDS=vew@mail.gmail.com>
References: <1388964792-3546-1-git-send-email-akinobu.mita@gmail.com>
	<1388964792-3546-6-git-send-email-akinobu.mita@gmail.com>
	<yq1bnzjpl9g.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:52047 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaALB2x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jan 2014 20:28:53 -0500
Received: by mail-oa0-f43.google.com with SMTP id m1so6659835oag.2
        for <linux-scsi@vger.kernel.org>; Sat, 11 Jan 2014 17:28:52 -0800 (PST)
In-Reply-To: <yq1bnzjpl9g.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>

2014/1/11 Martin K. Petersen <martin.petersen@oracle.com>:
>>>>>> "Akinobu" == Akinobu Mita <akinobu.mita@gmail.com> writes:
>
> Akinobu> This replaces these for_each_sg() loops with sg mapping
> Akinobu> iterator which is capable of handling each sg list element is
> Akinobu> consisted with multiple pages.
>
> Looks good in general but what's with disabling interrupts? Would it be

Disabling interrupts look unnecessary and removing these simplies the
change.  I was blindly borrowing the code from sg_copy_{from,to}_buffer().
I'll fix it in the next version.

> better to move the PI verification in under atomic_rw?

It also looks right.  Besides that, I realized that resp_unmap() calls
unmap_region() which also needs atomic_rw write lock, but it doesn't
lock.  I'll do it in another patch.
