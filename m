From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] megaraid_sas: move command counter to correct place
Date: Wed, 9 Aug 2017 16:09:05 +0200
Message-ID: <a677fd3b-0730-1213-2791-41cf8b32c08c@redhat.com>
References: <20170728140359.15424-1-thenzl@redhat.com>
 <yq1lgmv9t51.fsf@oracle.com>
 <730abe70a796241670b9443bd72e395b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42118 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752790AbdHIOJH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Aug 2017 10:09:07 -0400
In-Reply-To: <730abe70a796241670b9443bd72e395b@mail.gmail.com>
Content-Language: en-MW
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Kashyap Desai <kashyap.desai@broadcom.com>

On 8.8.2017 09:37, Sumit Saxena wrote:
>> -----Original Message-----
>> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
>> Sent: Monday, August 07, 2017 11:07 PM
>> To: Tomas Henzl
>> Cc: linux-scsi@vger.kernel.org; sumit.saxena@broadcom.com;
>> kashyap.desai@broadcom.com
>> Subject: Re: [PATCH] megaraid_sas: move command counter to correct place
>>
>>
>> Tomas,
>>
>>> the eh reset function returns success when fw_outstanding equals zero,
>>> that means that the counter shouldn't be decremented when the driver
>>> still owns the command
>> Applied to 4.13/scsi-fixes. Thank you!
> Just realized that this patch may cause performance regression.
> With this patch below scenario may occur-
>
> -Consider outstanding IOs reaches to controller's Queue depth.
> -Driver frees up command and complete it back to SML.
> -Since host_busy is decremented, SML can issue one new  IO to driver.
> -By the time, if "fw_outstanding" is not decremented by driver, then
> driver will return newly submitted IO back to SML with return status
> SCSI_MLQUEUE_HOST_BUSY because of below code
>   in megaraid_sas driver's IO submission path-
>
>     if (atomic_inc_return(&instance->fw_outstanding) >
>             instance->host->can_queue) {
>         atomic_dec(&instance->fw_outstanding);
>         return SCSI_MLQUEUE_HOST_BUSY;
>     }
>
> This situation will be more evident when RAID1 fastpath IOs are running as
> in that case driver will be issuing two IOs to firmware for single IO
> issued from SML.
> Above situation can be avoided, if this patch is removed.
>
> Regarding Tomas' concern, there should not be any problem as driver calls
> "synchronize_irq" before checking "fw_outstanding". Once fw_outstanding is
> decremented and
> driver frees up command, then only driver will be checking
> "fw_outstanding" equals to zero or not so all this will always fall in a
> sequence and will not
> cause the problem stated by Tomas.

I haven't expected this to fix a real issue in latest upstream code,
just wanted to follow the correct ordering.
If it creates a performance issue, reverting the patch is fine for me.

>
> I am sorry for confusion and would request to revert this patch.
>
> Thanks,
> Sumit
>
>> --
>> Martin K. Petersen	Oracle Linux Engineering
