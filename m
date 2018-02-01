From: Weiping Zhang <zwp10758@gmail.com>
Subject: Re: [PATCH v3] scsi: sd: add new match array for cache_type
Date: Thu, 1 Feb 2018 22:15:06 +0800
Message-ID: <CAA70yB6th1UGHyTcpF0aFCP2H=TjXc6-kafQQ4xj1sCRtDt1XQ@mail.gmail.com>
References: <20180123144439.GA15247@localhost.didichuxing.com> <yq1lggeempq.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:40331 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750985AbeBAOPH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Feb 2018 09:15:07 -0500
Received: by mail-wm0-f68.google.com with SMTP id v123so5954865wmd.5
        for <linux-scsi@vger.kernel.org>; Thu, 01 Feb 2018 06:15:07 -0800 (PST)
In-Reply-To: <yq1lggeempq.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: weiping zhang <zhangweiping@didichuxing.com>, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org

2018-01-31 11:22 GMT+08:00 Martin K. Petersen <martin.petersen@oracle.com>:
>
> Weiping,
>
>> add user friendly command strings sd_wr_cache to enable/disable
>> write&read cache. user can enable both write and read cache by one of
>> the following commands:
>
> I remain unconvinced that introducing redundant option strings is a
> benefit.
>
> These shorthand forms may seem obvious to you, but not to everyone
> else. Adding to the murkiness is that fact that write cache must be
> *enabled* and read cache *disabled* in the protocol. The fact that the
> ??rN and RCD columns below contain inverse values just emphasizes that
> point that "0" and "1" are not a particularly good interface either.
>
> It is also confusing that the existing longhand forms will be printed
> when the user subsequently queries the state instead of what they used
> to toggle it.
>
Yes, indeed.
>
> This, however, is pretty much what I was looking for:
>
>> Encoding                          | WCE RCD | Write_cache Read_cache
>> --------------------------------------------------------------------
>> write through              / w0r1 | 0   0   | off         on
>> none                       / w0r0 | 0   1   | off         off
>> write back                 / w1r1 | 1   0   | on          on
>> write back, no read (daft) / w1r0 | 1   1   | on          off
>
> Please drop the w?r? options and submit a patch with this table and a
> note about the "temporary" prefix. Put it in
> Documentation/scsi/sd-parameters.txt or something to that effect.
>
It's ok for me.
> Bonus points for also documenting the remaining sd sysfs attributes and
> their options.
I'll try.

Thanks
>
> Thanks!
>
> --
> Martin K. Petersen      Oracle Linux Engineering
