From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] USB: uas: Fix slave queue_depth not being set
Date: Tue, 24 May 2016 08:53:33 +0200
Message-ID: <1e1c9f07-8190-8400-0fee-455ba7ddf517@redhat.com>
References: <1464004158-3062-1-git-send-email-hdegoede@redhat.com>
 <1464025007.2331.17.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1464025007.2331.17.camel@HansenPartnership.com>
Sender: stable-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gerd Hoffmann <kraxel@redhat.com>, Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On 23-05-16 19:36, James Bottomley wrote:
> On Mon, 2016-05-23 at 13:49 +0200, Hans de Goede wrote:
>> Commit 198de51dbc34 ("USB: uas: Limit qdepth at the scsi-host level")
>> removed the scsi_change_queue_depth() call from uas_slave_configure()
>> assuming that the slave would inherit the host's queue_depth, which
>> that commit sets to the same value.
>>
>> This is incorrect, without the scsi_change_queue_depth() call the
>> slave's queue_depth defaults to 1, introducing a performance
>> regression.
>>
>> This commit restores the call, fixing the performance regression.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 198de51dbc34 ("USB: uas: Limit qdepth at the scsi-host level")
>> Reported-by: Tom Yan <tom.ty89@gmail.com>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>>  drivers/usb/storage/uas.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
>> index 16bc679..ecc7d4b 100644
>> --- a/drivers/usb/storage/uas.c
>> +++ b/drivers/usb/storage/uas.c
>> @@ -835,6 +835,7 @@ static int uas_slave_configure(struct scsi_device
>> *sdev)
>>  	if (devinfo->flags & US_FL_BROKEN_FUA)
>>  		sdev->broken_fua = 1;
>>
>> +	scsi_change_queue_depth(sdev, devinfo->qdepth - 2);
>
> Are you sure about this?  For spinning rust, experiments imply that the
> optimal queue depth per device is somewhere between 2 and 4.  Obviously
> that's not true for SSDs, so it depends on your use case.  Plus, for
> ATA NCQ devices (which I believe most UAS is bridged to) you have a
> maximum NCQ depth of 31.

So this value is the same as host.can_queue, and is what uas has always
used, basically this says it is ok to queue as much as the bridge can
handle. We've seen a few rare multi-lun devices, but typically almost
all uas devices have one lun, what I really want to do here is give a
maximum and let say the sd driver lower that if it is sub-optimal.

Also notice that uas is used a lot with ssd-s, that is mostly what
I want to optimize for, but it is definitely also used with
spinning rust.

And yes almost all uas devices are bridged sata devices (this may
change in the near future though, with ssd-s specifically designed
for usb-3 attachment, although sofar these all seem to use an
embbeded sata bridge), so from this pov an upper limit of 31 makes sense,
I guess, but I've not seen any bridges which actually do more then 32
streams anyways.

Still this is a bug-fix patch, essentially a partial revert, to address
performance regressions, so lets get this out as is and take our time to
come up with some tweaks (if necessary) for the say 4.8.

> There's a good reason why you don't want a queue deeper than you can
> handle: it tends to interfere with writeback because you build up a lot
> of pending I/O in the queue which can't be issued (it's very similar to
> why bufferbloat is a problem in networks).  In theory, as long as your
> devices return the correct indicator (QUEUE_FULL status), we'll handle
> most of this in the mid-layer by plugging the block queue, but given
> what I've seen from UAS devices, that's less than probable.

So any smart ideas how to be nicer to spinning rust, without negatively
impacting ssd-s? As said if I've to choice I think we should chose
optimizing ssd-s, as that is where uas is used a lot (although usb-attached
harddisks are switching over to it too).

Note I just checked the 1TB sata/ahci harddisk in my workstation and it is using
a queue_depth of 31 too, so this really does seem like a mid-layer problem
to me.

Regards,

Hans
