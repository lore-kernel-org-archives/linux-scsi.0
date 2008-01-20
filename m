From: Hans de Goede <j.w.r.degoede-fbo2DhPpy/Q@public.gmane.org>
Subject: Re: PATCH: usb-storage-set-last-sector-bug-flag.patch
Date: Sun, 20 Jan 2008 22:25:38 +0100
Message-ID: <4793BC52.2040902@hhs.nl>
References: <47932211.90105@hhs.nl>  <20080120205625.GB28842@kroah.com> <1200863008.3105.30.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1200863008.3105.30.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Matthew Dharm <mdharm-scsi-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, USB Storage list <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, USB development list <linux-usb-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, David Brown <usb-storage2-GijAUarxTbMdnm+yROfE0A@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Sun, 2008-01-20 at 12:56 -0800, Greg KH wrote:
>> On Sun, Jan 20, 2008 at 11:27:29AM +0100, Hans de Goede wrote:
>>> Hi all,
>>>
>>> This patch sets the last_sector_bug flag to 1 for all USB disks. This is
>>> needed to makes the cardreader on various HP multifunction printers work.
>>>
>>> Since the performance impact is negible we set this flag for all USB disks 
>>> to avoid an unusual_devs.h nightmare.
>> Oh great, now my "working just fine" USB devices, which happen to have
>> data in the last sector, suddenly stop working.
>>
>> That's not acceptable :(
> 
> I don't see how this will happen, might you not be confusing this change
> (which allows access to the last sector, just insists that it be
> accessed by a single sector read) with US_FL_FIX_CAPACITY which is for
> devices that report having one more sectors than they actually have and
> therefore adjusts the access limits down by one?
> 

Let me try to explain some more, the scsi-sd patch, which goes hand in hand 
with this adds a last_sector_bug flag, which is indeed a different flag form 
the fix_capacity flag. Both deal with with what are (in case of the 
last_sector_bug flag probably) off by one bugs.

The fix_capacity flag is for devices which report their last sector is N (with 
sectors numbered from 0 - N) but in reality  / they mean they have N sectors, 
so their last sector really is N - 1.

The last_sector_bug flag is for a bug (sofar only seen in HP multifunction 
printers with cardreader when using an sdcard) where the reader will cease to 
function (returns error codes in response to each and every command) after one 
has attempted to read the last sector in a read larger then 1 sector. To be 
clear an example lets say an example disk has 256 sectors, numbered 0 - 255.

Then the following reads will all cause the reader to go into borked mode:
16 sectors starting at 240
8 sectors starting at 248
2 sectors starting at 254

Yet the last sector can still be read without problems the following read:
1 sector starting at 255

So what the scsi-sd part of these 2 patches does it adds a last_sector_bug 
flag, which when set will cause the layer to split a read like this:
16 sectors starting at 240

Into:
15 sectors starting at 240
1 sector starting at 255


Since reading the last sector is a rare occurence (but one which does happen 
every time when determining the partition table, triggering the bug on every 
card insert). and since there are a lot of different HP printer models ( and 
cheap usb card readers are notoriously buggy so other cardreaders might be 
affected too), Matthew Dharm (the usb-storage maintainer) thought it best to 
enable this for all devices.

Regards,

Hans
