From: Hans de Goede <j.w.r.degoede-fbo2DhPpy/Q@public.gmane.org>
Subject: Re: PATCH: usb-storage-psc1350-v4.patch (was	Linux	scsi	/	usb-mass-storage
 and HP printer cardreader bug + fix)
Date: Sun, 20 Jan 2008 11:12:16 +0100
Message-ID: <47931E80.6050207@hhs.nl>
References: <47854051.1060307@hhs.nl> <4785F6CD.6050907@panasas.com>	 <4785F908.3080307@hhs.nl> <47860106.3090509@panasas.com>	 <4787CE08.5000304@hhs.nl> <1200303645.11301.15.camel@littletux>	 <478B2F90.7010105@hhs.nl>  <20080114160310.GH14375@one-eyed-alien.net>	 <1200328388.3159.20.camel@localhost.localdomain> <478BABF0.1040403@hhs.nl>	 <1200337759.3159.58.camel@localhost.localdomain> <478BB795.4040305@hhs.nl> <1200342046.3159.64.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1200342046.3159.64.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Matthew Dharm <mdharm-scsi-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, Guillaume Bedot <littletux-QFiJtcdG+fw@public.gmane.org>, Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, USB Storage list <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, fedora-kernel-list-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, USB development list <linux-usb-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, David Brown <usb-storage2-GijAUarxTbMdnm+yROfE0A@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Mon, 2008-01-14 at 20:27 +0100, Hans de Goede wrote:
>> James Bottomley wrote:
>>>>> Plus what is the rq->nr_sectors > sdp->sector_size /
>>>>> 512 test supposed to be doing?  that being true is supposed to be a
>>>>> guarantee of the block layer (and if something goes wrong there's a
>>>>> check for this lower down).
>>>>>
>>>> It first is was just:
>>>> rq->nr_sectors > 1
>>>>
>>>> Then I changed it to also do the right thing for 1024 and larger sector disks. 
>>>> The whole purpose is to not read the last sector in a larger then one sector 
>>>> read, so the amount of sectors gets reduced by one if (block + rq->nr_sectors 
>>>> == get_capacity(disk)) but we do want still want to be able to read the last 
>>>> sector by itself, so we must not reduce the no sectors to be read by one if it 
>>>> is already one.
>>> Yes, I know that.  What I mean is the block subsystem sends reads and
>>> writes down in increments of the sector size.  Checking if the current
>>> number of pending sectors is greater than the current block size is
>>> checking that guarantee.  The current code already has a check in it to
>>> see if this guarantee is observed ... you don't need to check it again.
>>>
>> I'm not checking for the guarantee, I'm checking that the read > 1 
>> realsize_sector, before decrementing the number of _512_bytes_sectors by 
>> realsize_sector, this check must be there, as after reading all but the last 
>> sector, another request will be send with 1 realsize_sector size, for which
>> (block + rq->nr_sectors) == get_capacity(disk) will still hold true, in this 
>> case this_count must not be lowered, otherwise this_count will become 0 in this 
>> case and the last sector will never get read.
>>
>> I hope that clarifies why that code is there, if not can you tell how you would 
>> want the code to look by just giving the full if statement as it should be, I 
>> think we are somehow misunderstanding each other.
> 
> Oh, right; it's > rather than >= ... sorry, yes that's fine.
> 

Ok,

I got swamped @work this week so it took a while, but I've made a new seperate 
(scsi-sd only) patch with the cleanups as discussed.

I'm sending this (to the full recipient list) in a new top level post titled:
PATCH: scsi-sd-last-sector-bug-flag.patch

Regards,

Hans
