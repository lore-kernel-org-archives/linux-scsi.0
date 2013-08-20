From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 2/4] scsi_debug: fix logical block provisioning support
 when unmap_alignment != 0
Date: Tue, 20 Aug 2013 16:56:40 -0400
Message-ID: <5213D808.1080806@interlog.com>
References: <1373889127-17083-1-git-send-email-akinobu.mita@gmail.com> <1373889127-17083-3-git-send-email-akinobu.mita@gmail.com> <CAC5umyh8+zBtKrpoFXdO+1D_5vOQS-P82LkocmaVY+FXb5YHRA@mail.gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:59617 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab3HTU5n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Aug 2013 16:57:43 -0400
In-Reply-To: <CAC5umyh8+zBtKrpoFXdO+1D_5vOQS-P82LkocmaVY+FXb5YHRA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 13-08-19 10:16 AM, Akinobu Mita wrote:
> Hi Douglas, Martin,
>
> Could you review this patch when you have a time?  I would like to
> submit at least this patch 2/4, and 1/4 which has already been acked
> by Douglas for the next merge window.
>
> Although the patches 2/4 ~ 4/4 are all related to the logical block
> provisioning support, the problems that fixed by 3/4 and 4/4 only
> happen with virtual_gb option enabled, too.  On the other hand, the
> problem that fixed by 2/4 is easily reproduced by, for example,
> 'modprobe scsi_debug lbpu=1 unmap_alignment=1 unmap_granularity=4'.
> So the patch 2/4 has rather higher severity than others.

This is Martin's area of expertise so I hope he also
acks it.

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> 2013/7/15 Akinobu Mita <akinobu.mita@gmail.com>:
>> Commit b90ebc3d5c41c9164ae04efd2e4f8204c2a186f1 ("[SCSI] scsi_debug:
>> fix logical block provisioning support") fixed several issues with
>> logical block provisioning support, but it still doesn't properly fix
>> the cases when unmap_alignment > 0.  (for example, unmap_alignment=1
>> and unmap_granularity=3)
>>
>> The problem is in map_index_to_lba(), which should return the first
>> LBA which is corresponding to a given index of provisioning map
>> (map_storep).
>>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
>> Cc: Douglas Gilbert <dgilbert@interlog.com>
>> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
>> Cc: linux-scsi@vger.kernel.org
>> ---
>>   drivers/scsi/scsi_debug.c | 10 ++++++++--
>>   1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
>> index 2f39b13..01c0ffa 100644
>> --- a/drivers/scsi/scsi_debug.c
>> +++ b/drivers/scsi/scsi_debug.c
>> @@ -1997,8 +1997,14 @@ static unsigned long lba_to_map_index(sector_t lba)
>>
>>   static sector_t map_index_to_lba(unsigned long index)
>>   {
>> -       return index * scsi_debug_unmap_granularity -
>> -               scsi_debug_unmap_alignment;
>> +       sector_t lba = index * scsi_debug_unmap_granularity;
>> +
>> +       if (scsi_debug_unmap_alignment) {
>> +               lba -= scsi_debug_unmap_granularity -
>> +                       scsi_debug_unmap_alignment;
>> +       }
>> +
>> +       return lba;
>>   }
>>
>>   static unsigned int map_state(sector_t lba, unsigned int *num)
>> --
>> 1.8.3.1
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

