From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v2.5 3/6] scsi_debug: add multiple queue support
Date: Wed, 4 May 2016 15:09:13 -0700
Message-ID: <572A7309.9000703@sandisk.com>
References: <1462070687-12689-1-git-send-email-dgilbert@interlog.com>
 <1462070687-12689-4-git-send-email-dgilbert@interlog.com>
 <57271169.8020204@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0064.outbound.protection.outlook.com ([157.56.110.64]:33894
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751132AbcEDWJU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 May 2016 18:09:20 -0400
In-Reply-To: <57271169.8020204@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com, bart.vanassche@sandisk.com

On 05/02/2016 01:35 AM, Hannes Reinecke wrote:
> On 05/01/2016 04:44 AM, Douglas Gilbert wrote:
>> Add submit_queue parameter (minimum and default: 1; maximum:
>> nr_cpu_ids) that controls how many queues are built, each with
>> their own lock and in_use bit vector. Add statistics parameter
>> which is default on.
>>
>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>> ---
>>   drivers/scsi/scsi_debug.c | 680 +++++++++++++++++++++++++++++-----------------
>>   1 file changed, 426 insertions(+), 254 deletions(-)
>>
> Two general questions for this:
>
> - Why do you get rid of the embedded command payload?
>    Where's the benefit of allocating the commands yourself?
> - Wouldn't it be better to move to a per-cpu structure per queue?
>    Each queue will be tacked to a CPU anyway, so you could be using
>    per-cpu structures. Otherwise you'll run into synchronization
>    issues, and any performance gain you might get from scsi-mq is
>    lost as you to synchronize on the lower level.

With submit_queues == nr_cpu_ids the block layer will ensure that the 
each submit queue is always run on the same CPU core. This means that 
there is a high chance that sdebug_queue.qc_lock will be present in the 
L1 cache and hence that the locking overhead will be minimal.

Bart.
