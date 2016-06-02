From: Wei Fang <fangwei1@huawei.com>
Subject: Re: [PATCH v2 1/2] scsi: fix race between simultaneous decrements of
 ->host_failed
Date: Thu, 2 Jun 2016 09:58:30 +0800
Message-ID: <574F92C6.6050607@huawei.com>
References: <1464683898-9877-1-git-send-email-fangwei1@huawei.com>
 <1464789971.23285.1.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1464789971.23285.1.camel@linux.vnet.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, tj@kernel.org, martin.petersen@oracle.com, corbet@lwn.net
Cc: hch@infradead.org, dan.j.williams@intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi, James,

On 2016/6/1 22:06, James Bottomley wrote:
> On Tue, 2016-05-31 at 16:38 +0800, Wei Fang wrote:
>> sas_ata_strategy_handler() adds the works of the ata error handler
>> to system_unbound_wq. This workqueue asynchronously runs work items,
>> so the ata error handler will be performed concurrently on different
>> CPUs. In this case, ->host_failed will be decreased simultaneously in
>> scsi_eh_finish_cmd() on different CPUs, and become abnormal.
>>
>> It will lead to permanently inequal between ->host_failed and
>>  ->host_busy, and scsi error handler thread won't become running.
>> IO errors after that won't be handled forever.
>>
>> Use atomic type for ->host_failed to fix this race.
> 
> As I said previously, you don't need atomics to do this, could you just
> remove the decrement in scsi_eh_finish_command() and zero the counter
> after the strategy handler completes.
> 

OK, I'll send v3 later.

Thanks,
Wei

