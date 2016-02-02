From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] Separate target visibility from reaped state information
Date: Mon, 1 Feb 2016 19:43:32 -0800
Message-ID: <56B025E4.9010009@sandisk.com>
References: <568FE922.9090004@sandisk.com>
 <yq1oachqehs.fsf@sermon.lab.mkp.net>
 <1453251809.2320.56.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0055.outbound.protection.outlook.com ([207.46.100.55]:20848
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751936AbcBBDni (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Feb 2016 22:43:38 -0500
In-Reply-To: <1453251809.2320.56.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Dan Williams <dan.j.williams@intel.com>, Sebastian Herbszt <herbszt@gmx.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 01/19/16 17:03, James Bottomley wrote:
> On Tue, 2016-01-19 at 19:30 -0500, Martin K. Petersen wrote:
>>>>>>> "Bart" == Bart Van Assche <bart.vanassche@sandisk.com>
>>>>>>> writes:
>>
>> Bart> Instead of representing the states "visible in sysfs" and "has
>> Bart> been removed from the target list" by a single state variable,
>> use
>> Bart> two variables to represent this information.
>>
>> James: Are you happy with the latest iteration of this? Should I
>> queue
>> it?
>
> Well, I'm OK with the patch: it's a simple transformation of the
> enumerated state to a two bit state.  What I can't see is how it fixes
> any soft lockup.
>
> The only change from the current workflow is that the DEL transition
> (now the reaped flag) is done before the spin lock is dropped which
> would fix a tiny window for two threads both trying to remove the same
> target, but there's nothing that could possibly fix an iterative soft
> lockup caused by restarting the loop, which is what the changelog says.

Hello James,

scsi_remove_target() doesn't lock the scan_mutex which means that 
concurrent SCSI scanning activity is not prohibited. Such scanning 
activity can postpone the transition of the state of a SCSI target into 
STARGET_DEL. I think if the scheduler decides to run the thread that 
executes scsi_remove_target() on the same CPU as the scanning code after 
the scanning code has obtained a reap ref and before the scanning code 
has released the reap ref again that the soft lockup can be triggered 
that has been reported by Sebastian Herbszt.

Bart.

