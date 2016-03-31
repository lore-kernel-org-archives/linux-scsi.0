From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] uas: Add a new NO_REPORT_LUNS quirk
Date: Thu, 31 Mar 2016 17:23:42 +0200
Message-ID: <56FD40FE.3030302@redhat.com>
References: <1459426971-11927-1-git-send-email-hdegoede@redhat.com>
 <1459435682.2958.19.camel@HansenPartnership.com>
 <56FD3C27.2050708@redhat.com>
 <1459437073.2958.29.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1459437073.2958.29.camel@HansenPartnership.com>
Sender: stable-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Gerd Hoffmann <kraxel@redhat.com>
Cc: David Webb <djw@noc.ac.uk>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On 31-03-16 17:11, James Bottomley wrote:
> On Thu, 2016-03-31 at 17:03 +0200, Hans de Goede wrote:
>> Hi,
>>
>> On 31-03-16 16:48, James Bottomley wrote:
>>> On Thu, 2016-03-31 at 14:22 +0200, Hans de Goede wrote:
>>>> Add a new NO_REPORT_LUNS quirk and set it for Seagate drives with
>>>> an usb-id of: 0bc2:331a, as these will fail to respond to a
>>>> REPORT_LUNS command.
>>>
>>> Actually, if we're sending them a report luns command, they must be
>>> reporting in at SCSI-3 SPC or higher.  Should we be quirking them
>>> down to SCSI-2 instead because it reduces the risk of running into
>>> something else they're not doing from the SPC command set?
>>
>> These are fairly new devices, so they should really be scsi3, but the
>> usb <-> sata bridge (presumably) used does not seem to like
>> report_luns.
>
> That's what I'm questioning: REPORT LUNS is one of the big SCSI-3
> changes, if they don't support that, it really looks like someone
> picked up an old engine and just fuzzed the inquiry data to return SCSI
> -3.  In which case we should put it back to SCSI-2 where it belongs.

Actually it does support REPORT LUNS, some of the time. When you first
boot the computer with uas blacklisted for this device, so initialize
it once with usb-storage, and then reboot with out the blacklist
(and without removing power to the drive) uas will work with REPORT LUNS
bit cold-booting directly into uas mode and then doing a REPORT LUNS
upsets the drive / disk enclosure (this has all been observed by
David Webb, I do not own such a drive).

> Also, if it's USB<->SCSI bridge, that isn't really UAS, is it?

I assume you mean that a USB<->sata bridge is not really a SCSI device
but more of a scsi emulating device. I'm not going to argue that, but
all devices talking the uas protocol I've seen sofar are USB<->sata
bridges.

>> Note that usb-storage simple sets no_report_luns conditionally for
>> all usb-storage devices. The scsi people have repeatedly asked me to
>> not do this kinda blanket blacklisting for uas devices, because they
>> hope that uas will allow them to more or less do proper scsi over
>> usb, so we end up with blacklisting specific commands every now and
>> then to get devices to work.
>
> Well, we were hoping that with UAS the USB device creators would
> actually learn what a standard was when it bit them, yes.  The fact
> that Seagate can release a SCSI-3 UAS device that doesn't do REPORT
> LUNS kind of dashes that hope.

See above it does sortof do REPORT LUNS just not reliable (and thus
not usable). Also for some reason Seagate seems to be particularly
bad in their uas implementation, we have a ton of quirks for Seagate
uas devices in drivers/usb/storage/unusual_uas.h, so far all of them
stop responding until reset after ATA_12 or ATA_16 CDBs so we filter
those out. This REPORT LUNS issue is new.

Regards,

Hans
