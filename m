From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH 0/5] block/target queue/LUN reset support
Date: Tue, 31 May 2016 14:56:07 -0500
Message-ID: <574DEC57.7090701@redhat.com>
References: <1464162903-14735-1-git-send-email-mchristi@redhat.com>
 <574BDFB7.5000407@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbcEaT4K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 May 2016 15:56:10 -0400
In-Reply-To: <574BDFB7.5000407@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, target-devel@vger.kernel.org

On 05/30/2016 01:37 AM, Hannes Reinecke wrote:
> On 05/25/2016 09:54 AM, mchristi@redhat.com wrote:
>> Currently, for SCSI LUN_RESETs the target layer can only wait on
>> bio/requests it has sent. This normally results in the LUN_RESET
>> timing out on the initiator side and that SCSI error handler
>> escalating to something more disruptive.
>>
>> To fix this, the following patches add a block layer helper and
>> callout to reset a request queue which the target layer can use
>> to force drivers to complete/fail executing requests.
>>
>> Patches were made over Jens's block tree's for-next branch.
>>
> In general I like the approach, it just looks as if the main aim (ie
> running a LUN RESET concurrent with normal I/O on other devices) is
> not quite reached.
> 
> The general concept of eh_async_device_reset() is quite nice, and
> renaming existing functions for doing so is okay, too.
> 
> It's just the integration with SCSI EH which is somewhat deficient
> (as outlined in the comment on patch 3).
> For the async device reset to work we'd need to call it _before_
> SCSI EH is started, ie after the asynchronous command abort failed.

Yes that is my plan.

However, these first patches are only to allow LIO to be able to do
resets. I need the same infrastructure for both though.

> 
> The easiest way would be to add per-device reset workqueue item,
> which wold be called whenever command abort failed.

If you want to do this without stopping the entire host, you need the
patches like in this set where we stop and flush a queue.


> As it's being per device we'd be getting an implicit serialisation,
> and we could skip the lun reset from EH.

To build on my patches for a new async based scsi eh what we want to do is:

0. Add eh_async_target_reset callout which works like async device reset
one. For iscsi this maps to iscsi_eh_session_reset. FC drivers have
something similar in the code paths that call rc_remote_port_delete and
the terminate_rport_io paths. We just need wrappers.

1. scsi_times_out would kick off abort if needed and return
BLK_EH_RESET_TIMEOUT.
2. If abort fails, cancel queued aborts and call new async device reset
callout in these patches.
3. If device reset fails call new async target reset callout.
4. if target reset fails, let fail the block timeout timer and do the
old style scsi eh host reset.

It is really simple for newer drivers/classes like FC and iSCSI because
they handle the device and target/port level reset clean up already. The
difficult (not really difficult but messy) part is trying to support old
and new style EHs in a functions like scsi_times_out and scsi_abort_command.
