From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] fixes and cleanups for the new command allocation code
Date: Tue, 04 Feb 2003 12:57:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E3FFEEF.3040506@splentec.com>
References: <20030204162326.A30755@lst.de> <20030204081616.A24105@beaverton.ibm.com> <20030204175146.A31515@lst.de> <20030204091955.A24785@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> On Tue, Feb 04, 2003 at 05:51:46PM +0100, Christoph Hellwig wrote:
> 
>>On Tue, Feb 04, 2003 at 08:16:16AM -0800, Patrick Mansfield wrote:
> 
> 
>>>I was trying to fix/hit this - surprisingly, I did not see performance
>>>problems (i.e. getting tons of QUEUE_FULLs), probably because my request
>>>queue limits are 128, and the disks are not old.
>>
>>I wonder whether we really need it or whether the queue limits shouldn't
>>be enough.  If there's a chance I'd like to avoid having throttewling in
>>too many places.
> 
> 
> We really need to limit to what the scsi_device (thinks it) can handle
> (currently new_queue_depth). Otherwise we could have QUEUE_FULL storms,
> plus we really don't want that many scsi_cmnd's outstanding (i.e. limited
> by the amount of memory we can allocate) when we have many scsi_devices on
> the system. If we lowered the request queue limit that would hurt
> scsi_devices (and maybe adapters) with a low queue limits.

The sole functionality of scsi_get/put_command() is/was(?) to
just give/take back a command structure.  This was my intention,
to abstract it away, with a well defined functionality.

Queue depths, limits and such checks should be provided elsewhere,
i.e. in the enqueuing piece of code of a scsi_cmnd into a LLDD.  Again,
this should be abstracted away with a well defined/sole functionality.

LLDD may call scsi_get/put_command() to piggy-back memory management
to SCSI Core, but this doesn't necessarily mean that they will
enqueue those commands.

BTW, is it the trend to have ether-pointers (as I call them) in SCSI Core
all over the place or to put SCSI Core data in a structure (i.e. to
reflect that it *is* SCSI Core), aka struct scsi_core_data?  I see this is
now gone.

-- 
Luben



