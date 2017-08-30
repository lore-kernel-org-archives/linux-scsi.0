From: Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH] scsi: qla2xxx: Fix an integer overflow in sysfs code
Date: Wed, 30 Aug 2017 06:20:54 -0700
Message-ID: <CANn89iJBtAFJjz7wY2=2pO5SdNGhJx8M8_V-dEq81NhsFHeAUA@mail.gmail.com>
References: <CAER+mfKPOt03DmPB4FTCjVvQ=2uRSMVbBHP-3CdoG+mQnSiYFw@mail.gmail.com>
 <20170830122106.dmdfril4kwi4p5e5@mwanda> <20170830131235.GC12924@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:36247 "EHLO
        mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751302AbdH3NU4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2017 09:20:56 -0400
Received: by mail-yw0-f172.google.com with SMTP id h127so31017160ywf.3
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2017 06:20:56 -0700 (PDT)
In-Reply-To: <20170830131235.GC12924@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, qla2xxx-upstream@qlogic.com, shqking <shqking@gmail.com>, Joe Carnuccio <joe.carnuccio@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, "security@kernel.org" <security@kernel.org>

On Wed, Aug 30, 2017 at 6:12 AM, Greg KH <greg@kroah.com> wrote:
> On Wed, Aug 30, 2017 at 03:21:07PM +0300, Dan Carpenter wrote:
>> The value of "size" comes from the user.  When we add "start + size"
>> it could lead to an integer overflow bug.
>>
>> It means we vmalloc() a lot more memory than we had intended.  I believe
>> that on 64 bit systems vmalloc() can succeed even if we ask it to
>> allocate huge 4GB buffers.  So we would get memory corruption and likely
>> a crash when we call ha->isp_ops->write_optrom() and ->read_optrom().
>>
>> Only root can trigger this bug.
>>
>> Fixes: b7cc176c9eb3 ("[SCSI] qla2xxx: Allow region-based flash-part accesses.")
>> Reported-by: shqking <shqking@gmail.com>
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
>
> Cc: stable <stable@vger.kernel.org>
>
> perhaps?
>
> thanks,
>
> greg k-h

Also a link to https://bugzilla.kernel.org/show_bug.cgi?id=194061
since shqking did a fair bit of analysis, not only report the bug.

Thanks.
