From: "Ouyangzhaowei (Charles)" <ouyangzhaowei@huawei.com>
Subject: Re: [PATCH] scsi: shost->async_scan should be protected by mutex_lock
Date: Wed, 13 Sep 2017 11:59:59 +0800
Message-ID: <4ec18ead-f6d0-c10c-71ad-d6e7e6fb47d5@huawei.com>
References: <f99d1494-af46-4f0f-5a24-bb88a860d0fe@huawei.com>
 <8e8d0a1b-f053-6eab-a85a-ec83201b50be@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:6041 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750728AbdIMEAp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2017 00:00:45 -0400
In-Reply-To: <8e8d0a1b-f053-6eab-a85a-ec83201b50be@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tyrel Datwyler <turtle.in.the.kernel@gmail.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Suoben <suoben@huawei.com>, "Wulizhen (Pss)" <pss.wulizhen@huawei.com>

shost->async_scan should be protected by mutex_lock, otherwise the check
of "called twice" won't work.

Signed-off-by: Ouyang Zhaowei <ouyangzhaowei@huawei.com>
---
 drivers/scsi/scsi_scan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index fd88dab..20d539b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1722,9 +1722,10 @@ static struct async_scan_data
*scsi_prep_async_scan(struct Scsi_Host *shost)
        if (strncmp(scsi_scan_type, "sync", 4) == 0)
                return NULL;

+       mutex_lock(&shost->scan_mutex);
        if (shost->async_scan) {
                shost_printk(KERN_DEBUG, shost, "%s called twice\n",
__func__);
-               return NULL;
+               goto unlock;
        }

        data = kmalloc(sizeof(*data), GFP_KERNEL);
@@ -1735,7 +1736,6 @@ static struct async_scan_data
*scsi_prep_async_scan(struct Scsi_Host *shost)
                goto err;
        init_completion(&data->prev_finished);

-       mutex_lock(&shost->scan_mutex);
        spin_lock_irqsave(shost->host_lock, flags);
        shost->async_scan = 1;
        spin_unlock_irqrestore(shost->host_lock, flags);
@@ -1751,6 +1751,8 @@ static struct async_scan_data
*scsi_prep_async_scan(struct Scsi_Host *shost)

  err:
        kfree(data);
+ unlock:
+       mutex_unlock(&shost->scan_mutex);
        return NULL;
 }


On 2017.9.11 9:44, Tyrel Datwyler wrote:
> On 09/07/2017 11:54 PM, Ouyangzhaowei (Charles) wrote:
>> shost->async_scan should be protected by mutex_lock, otherwise the check
>> of "called twice" won't work.
>>
>> Signed-off-by: Ouyang Zhaowei <ouyangzhaowei@huawei.com>
>> ---
>>  drivers/scsi/scsi_scan.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>> index fd88dab..1d1df51 100644
>> --- a/drivers/scsi/scsi_scan.c
>> +++ b/drivers/scsi/scsi_scan.c
>> @@ -1722,6 +1722,7 @@ static struct async_scan_data
>> *scsi_prep_async_scan(struct Scsi_Host *shost)
>>         if (strncmp(scsi_scan_type, "sync", 4) == 0)
>>                 return NULL;
>>
>> +       mutex_lock(&shost->scan_mutex);
> 
> The mutex will not be unlocked in the event that either the host has called
> scsi_prep_async_scan() twice, or a condition is meet the branches to the "err" label prior
> to where the original mutex_lock() was located below.

Thanks for the review, I modified the patch, please check it out again.

> 
> -Tyrel
> 
>>         if (shost->async_scan) {
>>                 shost_printk(KERN_DEBUG, shost, "%s called twice\n",
>> __func__);
>>                 return NULL;
>> @@ -1735,7 +1736,6 @@ static struct async_scan_data
>> *scsi_prep_async_scan(struct Scsi_Host *shost)
>>                 goto err;
>>         init_completion(&data->prev_finished);
>>
>> -       mutex_lock(&shost->scan_mutex);
>>         spin_lock_irqsave(shost->host_lock, flags);
>>         shost->async_scan = 1;
>>         spin_unlock_irqrestore(shost->host_lock, flags);
>>
> 
> 
> .
> 
