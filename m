From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: Re: [PATCH 1/2] scsi: smartpqi: Replace semaphore sync_request_sem
 with mutex
Date: Mon, 24 Oct 2016 15:39:27 +0530
Message-ID: <CAHv-k_-FE6acJ2U=Ps675ea6wK_W=jUamjdNtWpvH__OP=H-AA@mail.gmail.com>
References: <1476953642-2160-1-git-send-email-binoy.jayan@linaro.org>
 <1476953642-2160-2-git-send-email-binoy.jayan@linaro.org> <3118730.6uvAdDZXCF@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:35585 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754934AbcJXKJ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Oct 2016 06:09:28 -0400
Received: by mail-ua0-f174.google.com with SMTP id 90so6210999uan.2
        for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2016 03:09:28 -0700 (PDT)
In-Reply-To: <3118730.6uvAdDZXCF@wuerfel>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, kevin Barnett <kevin.barnett@microsemi.com>, Don Brace <don.brace@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, Linux kernel mailing list <linux-kernel@vger.kernel.org>

On 20 October 2016 at 14:40, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday, October 20, 2016 2:24:01 PM CEST Binoy Jayan wrote:
>> -       sema_init(&ctrl_info->sync_request_sem,
>> -               PQI_RESERVED_IO_SLOTS_SYNCHRONOUS_REQUESTS);
>> +       mutex_init(&ctrl_info->sync_request_mutex);
>>
>
> Looking at this again, I see that PQI_RESERVED_IO_SLOTS_SYNCHRONOUS_REQUESTS
> is '3', so this is in fact a counting semaphore rather than a mutex,
> and the conversion is changing the behavior.
>
> The patch can't go in unless you either show that it should be
> a normal mutex rather than a counting semaphore, or you find a way
> to keep the behavior the same.

This still holds true, will try changing this accordingly.

-Binoy
