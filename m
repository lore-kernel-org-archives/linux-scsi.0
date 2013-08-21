From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 2/4] scsi_debug: fix logical block provisioning support
 when unmap_alignment != 0
Date: Wed, 21 Aug 2013 22:58:38 +0900
Message-ID: <CAC5umyhBGaYDrO6wEZnEeyBEE1obe=ynTFqJKOHZNBQDTkj=1g@mail.gmail.com>
References: <1373889127-17083-1-git-send-email-akinobu.mita@gmail.com>
	<1373889127-17083-3-git-send-email-akinobu.mita@gmail.com>
	<CAC5umyh8+zBtKrpoFXdO+1D_5vOQS-P82LkocmaVY+FXb5YHRA@mail.gmail.com>
	<5213D808.1080806@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:43748 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab3HUN6j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Aug 2013 09:58:39 -0400
Received: by mail-ob0-f175.google.com with SMTP id xn12so773496obc.34
        for <linux-scsi@vger.kernel.org>; Wed, 21 Aug 2013 06:58:38 -0700 (PDT)
In-Reply-To: <5213D808.1080806@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

2013/8/21 Douglas Gilbert <dgilbert@interlog.com>:
> On 13-08-19 10:16 AM, Akinobu Mita wrote:
>>
>> Hi Douglas, Martin,
>>
>> Could you review this patch when you have a time?  I would like to
>> submit at least this patch 2/4, and 1/4 which has already been acked
>> by Douglas for the next merge window.
>>
>> Although the patches 2/4 ~ 4/4 are all related to the logical block
>> provisioning support, the problems that fixed by 3/4 and 4/4 only
>> happen with virtual_gb option enabled, too.  On the other hand, the
>> problem that fixed by 2/4 is easily reproduced by, for example,
>> 'modprobe scsi_debug lbpu=1 unmap_alignment=1 unmap_granularity=4'.
>> So the patch 2/4 has rather higher severity than others.
>
>
> This is Martin's area of expertise so I hope he also
> acks it.
>
> Acked-by: Douglas Gilbert <dgilbert@interlog.com>

Thanks.

BTW, I realized that the commit log for this change didn't fully
describe the problem.  So I'll update it so that it includes a
concrete example like below.

How to reproduce this problem:
        # modprobe scsi_debug lbpu=1 unmap_alignment=1 unmap_granularity=4
        # dd if=/dev/zero of=/dev/sdb
        # sg_unmap --lba=1 --num=4 /dev/sdb

GET LBA STATUS command for lba=1 shows that the last UNMAP command didn't work:
        # sg_get_lba_status --lba=1 /dev/sdb
        descriptor LBA: 0x0000000000000001  blocks: 16383  mapped
