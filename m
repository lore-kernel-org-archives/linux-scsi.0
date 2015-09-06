From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH 1/1] Update scsi hosts to use idr for host number mgmt
Date: Sun, 6 Sep 2015 08:16:40 -0700
Message-ID: <55EC58D8.7010605@suse.com>
References: <cover.1441412268.git.lduncan@suse.com>
 <05a1b95993cbb2b0ce9be8e088203c23f0e49107.1441412269.git.lduncan@suse.com>
 <55EBEC9F.7020600@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:59877 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752396AbbIFPQz (ORCPT
	<rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
	Sun, 6 Sep 2015 11:16:55 -0400
In-Reply-To: <55EBEC9F.7020600@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, hare@suse.com, jthumshirn@suse.de, JBottomley@Parallels.com

On 09/06/2015 12:34 AM, Sagi Grimberg wrote:
> On 9/5/2015 11:44 PM, Lee Duncan wrote:
>> Each Scsi_host instance gets a host number starting
>> at 0, but this was implemented with an atomic integer,
>> and rollover wasn't considered. Another problem with
>> this design is that scsi host numbers used by iscsi
>> are never reused, thereby making rollover more likely.
>> This patch converts Scsi_host instances to use idr
>> to manage their instance numbers and to simplify
>> instance number to pointer lookups.
>>
>> This also means that host instance numbers will be
>> reused, when available.
>>
>> Signed-off-by: Lee Duncan <lduncan@suse.com>
>> ---
>>   drivers/scsi/hosts.c | 59
>> +++++++++++++++++++++++++---------------------------
>>   1 file changed, 28 insertions(+), 31 deletions(-)
>>
>> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
>> index 8bb173e01084..1127a50e5942 100644
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
>> @@ -41,8 +41,8 @@
>>   #include "scsi_priv.h"
>>   #include "scsi_logging.h"
>>
>> -
>> -static atomic_t scsi_host_next_hn = ATOMIC_INIT(0);    /* host_no for
>> next new host */
>> +static DEFINE_SPINLOCK(host_index_lock);
>> +static DEFINE_IDR(host_index_idr);
>>
>>
>>   static void scsi_host_cls_release(struct device *dev)
>> @@ -337,6 +337,10 @@ static void scsi_host_dev_release(struct device
>> *dev)
>>
>>       kfree(shost->shost_data);
>>
>> +    spin_lock(&host_index_lock);
>> +    idr_remove(&host_index_idr, shost->host_no);
>> +    spin_unlock(&host_index_lock);
>> +
> 
> Did you change your mind on having host_[get|put]_idx() helpers?

No. As I said on the description:

> A separate patch sequence follows which will add helper routines
> for the ida index functions.

I'll be sending out that patch series today (I hope).

I *do* believe it would be useful to add some ida helper routines, since
callers of these routines seem mostly to use a uniform calling sequence.
But even so some of the callers do things differently enough so that I
was not comfortable changing them to use the helper routines.

But the "idr" routines, i.e. the ones that manage both an index *and* a
pointer, which are the ones I'm using in hosts.c, are not called so
uniformly, so helper routines did not seem like a good idea.
-- 
Lee Duncan

