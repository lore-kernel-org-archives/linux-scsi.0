From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCHv2] Update scsi host to use ida for host number
Date: Tue, 1 Sep 2015 16:44:55 -0700
Message-ID: <55E63877.3020002@suse.com>
References: <1441129120-31398-1-git-send-email-lduncan@suse.com>
 <55E5E52D.5090009@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:59132 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751029AbbIAXpF (ORCPT
	<rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
	Tue, 1 Sep 2015 19:45:05 -0400
In-Reply-To: <55E5E52D.5090009@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, linux-scsi@vger.kernel.org
Cc: JBottomley@Parallels.com, hare@suse.com, jthumshirn@suse.de

On 09/01/2015 10:49 AM, Sagi Grimberg wrote:
> On 9/1/2015 8:38 PM, lduncan@suse.com wrote:
>> From: Lee Duncan <lduncan@suse.com>
>>
>> Each Scsi_host instance gets a host number starting
>> at 0, but this is implemented with an atomic integer,
>> and rollover doesn't seem to have been considered.
>> Another side-effect of this design is that scsi host
>> numbers used by iscsi are never reused, thereby  making
>> rollover more likely. This patch converts Scsi_host
>> instances to use ida to manage their instance
>> numbers.
>>
>> This also means that host instance numbers will be
>> reused, when available.
>>
>> Changes from v1:
>> * Added inline host_put_index() and its use
>>
>> Signed-off-by: Lee Duncan <lduncan@suse.com>
>> Reviewed-by: Hannes Reinecke <hare@suse.com>
>> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
>> ---
>>   drivers/scsi/hosts.c | 47
>> +++++++++++++++++++++++++++++++++++++++--------
>>   1 file changed, 39 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
>> index 8bb173e01084..36cb65612821 100644
>> --- a/drivers/scsi/hosts.c
>> +++ b/drivers/scsi/hosts.c
>> @@ -33,7 +33,7 @@
>>   #include <linux/transport_class.h>
>>   #include <linux/platform_device.h>
>>   #include <linux/pm_runtime.h>
>> -
>> +#include <linux/idr.h>
>>   #include <scsi/scsi_device.h>
>>   #include <scsi/scsi_host.h>
>>   #include <scsi/scsi_transport.h>
>> @@ -42,7 +42,8 @@
>>   #include "scsi_logging.h"
>>
>>
>> -static atomic_t scsi_host_next_hn = ATOMIC_INIT(0);    /* host_no for
>> next new host */
>> +static DEFINE_SPINLOCK(host_index_lock);
>> +static DEFINE_IDA(host_index_ida);
>>
>>
>>   static void scsi_host_cls_release(struct device *dev)
>> @@ -337,6 +338,10 @@ static void scsi_host_dev_release(struct device
>> *dev)
>>
>>       kfree(shost->shost_data);
>>
>> +    spin_lock(&host_index_lock);
>> +    ida_remove(&host_index_ida, shost->host_no);
>> +    spin_unlock(&host_index_lock);
> 
> Why not host_put_index(index)?
> 

Doh! I'll fix that in both places.
-- 
Lee Duncan
