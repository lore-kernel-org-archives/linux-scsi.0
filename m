From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/5] scsi: add new async device reset support
Date: Fri, 27 May 2016 11:16:50 +0200
Message-ID: <57481082.9050700@suse.de>
References: <1464162903-14735-1-git-send-email-mchristi@redhat.com>
 <1464162903-14735-5-git-send-email-mchristi@redhat.com>
 <20160527082325.GB31630@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160527082325.GB31630@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, mchristi@redhat.com
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/27/2016 10:23 AM, Christoph Hellwig wrote:
> Adding Hannes to the Cc list as he's been looking into EH improvement=
s
> in this area.
>
> On Wed, May 25, 2016 at 02:55:02AM -0500, mchristi@redhat.com wrote:
>> From: Mike Christie <mchristi@redhat.com>
>>
>> Currently, if the SCSI eh runs then before we do a LUN_RESET
>> we stop the host. This patch and the block layer one before it
>> begin to add infrastructure to be able to do a LUN_RESET and
>> eventually do a transport level recovery without having to stop the
>> host.
>>
>> For LUn-reset, this patch adds a new callout, eh_async_device_reset_=
handler,
>> which works similar to how LLDs handle SG_SCSI_RESET_DEVICE where th=
e
>> LLD manages the commands that are affected.
>>
>> eh_async_device_reset_handler:
>>
>> The LLD should perform a LUN RESET that affects all commands
>> that have been accepted by its queuecommand callout for the
>> device passed in to the callout. While the reset handler is running,
>> queuecommand will not be running or called for the device.
>>
>> Unlike eh_device_reset_handler, queuecommand may still be
>> called for other devices, and the LLD must call scsi_done for the
>> commands that have been affected by the reset.
>>
>> If SUCCESS or FAST_IO_FAIL is returned, the scsi_cmnds cleaned up
>> must be failed with DID_ABORT.
>>
>> Signed-off-by: Mike Christie <mchristi@redhat.com>
In general I like the approach.
I'll be looking into it more closely next week.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
