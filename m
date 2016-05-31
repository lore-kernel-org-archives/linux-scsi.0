From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH 4/5] scsi: add new async device reset support
Date: Tue, 31 May 2016 15:34:55 -0500
Message-ID: <574DF56F.1050703@redhat.com>
References: <1464162903-14735-1-git-send-email-mchristi@redhat.com>
 <1464162903-14735-5-git-send-email-mchristi@redhat.com>
 <574BDD49.6070205@suse.de> <574DE828.2090604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755696AbcEaUe5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 May 2016 16:34:57 -0400
In-Reply-To: <574DE828.2090604@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, target-devel@vger.kernel.org

On 05/31/2016 02:38 PM, Mike Christie wrote:
> On 05/30/2016 01:27 AM, Hannes Reinecke wrote:
>> On 05/25/2016 09:55 AM, mchristi@redhat.com wrote:
>>> From: Mike Christie <mchristi@redhat.com>
>>>
>>> Currently, if the SCSI eh runs then before we do a LUN_RESET
>>> we stop the host. This patch and the block layer one before it
>>> begin to add infrastructure to be able to do a LUN_RESET and
>>> eventually do a transport level recovery without having to stop the
>>> host.
>>>
>>> For LUn-reset, this patch adds a new callout, eh_async_device_reset_handler,
>>> which works similar to how LLDs handle SG_SCSI_RESET_DEVICE where the
>>> LLD manages the commands that are affected.
>>>
>>> eh_async_device_reset_handler:
>>>
>>> The LLD should perform a LUN RESET that affects all commands
>>> that have been accepted by its queuecommand callout for the
>>> device passed in to the callout. While the reset handler is running,
>>> queuecommand will not be running or called for the device.
>>>
>>> Unlike eh_device_reset_handler, queuecommand may still be
>>> called for other devices, and the LLD must call scsi_done for the
>>> commands that have been affected by the reset.
>>>
>>> If SUCCESS or FAST_IO_FAIL is returned, the scsi_cmnds cleaned up
>>> must be failed with DID_ABORT.
>>>
>> Hmm. With this patch you essentially just replaced the existing
>> eh_device_reset_handler() with eh_async_device_request_handler().
>> So how does this differ from the original behaviour?
> 
> 
> 1. LLD must call scsi_done and set host byte on each command affected by
> the reset. This is what they have to do for the SG ioctl reset, but for
> the scsi eh reset, LLDs do not have to because scsi-ml manages the
> commands for them.
> 
> When doing a SG ioctl based reset or if the reset is called from the
> target like in the last patch it is not possible to have scsi-ml track
> the outstanding commands like we do today based on timeouts.
> 
> 2. LLDs have to support commands to other luns during device resets, so
> they cannot have any sort of host wide device resource lock/resource
> that they can rely on. It has to be per device.
> 
> 3. We can now support being able to do a lun reset without having to
> stop then entire host.
> 

One other difference is that for the SG ioctl reset case, it is a pain
to handle the race where queuecommand and eh_device_reset_handler are
running while also trying to remove locks and atomics from the LLD and
move to mq. Probably when the SG reset code was made we had the
host_lock taken in queuecommand, so it was simple to handle. If we stop
the queue like in the second patch then the LLD at least does not have
to worry about this.
