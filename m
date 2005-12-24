From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [SCSI] Add support for braindead Cypress USB ATA	passthrough
 CDBs
Date: Sat, 24 Dec 2005 13:28:20 +1000
Message-ID: <43ACC054.6080305@torque.net>
References: <20051221122442.GA16571@porkrind.org>	 <1135353160.3728.10.camel@mulgrave>	 <FEB7BF7CC02839AFCC0CF35D@dev.porkrind.org> <1135370071.3728.43.camel@mulgrave> <0C1803A3682E0D951A5A631C@dev.porkrind.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:19854 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1161161AbVLXD1A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Dec 2005 22:27:00 -0500
In-Reply-To: <0C1803A3682E0D951A5A631C@dev.porkrind.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Caldwell <david@porkrind.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

David Caldwell wrote:
> On 12/23/05 14:34:30 -0600 James Bottomley wrote:
> 
>> On Fri, 2005-12-23 at 11:12 -0800, David Caldwell wrote:
>>
>>> > I think this approach is too invasive to the stack.  When this was
>>> > discussed in november, there wasn't much enthusiasm for resurrecting
>>> > the long dead LUN_INHIBIT flag.  The two suggested mechanisms are
>>>
>>> Invasive because of the extra flag in the request structure?
>>
>>
>> Yes. But also having users determine this is wrong when it's a device
>> feature.
> 
> 
> I see. I can agree with that. It certainly would be better if it was
> somehow automatic.
> 
>>> > 2) If 1) doesn't work, then use a blacklist entry which the subsystems
>>> > would also have access to.
>>>
>>> I think this might not be optimal. The problem is that it's impossible
>>> to  tell that it's a Cypress part from the USB side of things (or the
>>> SCSI side  for that matter), so there would have to be an entry for each
>>> of the 50,000  vendors of USB bridges.
>>
>>
>> I meant use it in the way usb uses other blacklist flags: set them from
>> slave_configure.
> 
> 
> Hmm. I don't understand this yet, I'll have to read more, but a cursory
> glance looks like this is a kernel interface. I'd really like things to
> flexible enough to be able to do this sort of one off random device
> stuff from user space. Or is the idea that the [generic] usb_storage
> driver would set a flag that says "I don't do LUNs"?
> 
>>> What about the patch's cdb length additions in sg and scsi_lib.c? It
>>> seems  like half the code guesses CDB length and the other half passes
>>> it around.  Clearly, given devices like this, guessing isn't going to
>>> work 100% of the  time. So either eveyone needs to pass around lengths,
>>> or there needs to be  another flag somewhere. The code should at least
>>> be consistent though.
>>
>>
>> I don't think they're necessary, are they?  Zero in cmnd_len means
>> mid-layer determines size.
> 
> 
> I think it's fine for zero length to mean mid_layer figures out the
> size,

David,
I don't think it is a good idea to ever pass zero command
length through a scsi pass through. I'm not even sure the
SCSI-2 (1992) standard asserts that the first command byte
can be used to determine command length. Definitely nothing
since then.

 but
> right now SG is throwing away the user passed in length (since
> scsi_execute_async() doesn't have a cdb_length parameter) and then
> guessing at it later regardless of whether it's zero or non-zero.

I can find no such code. Which kernel version are you
describing? There was a bug in the block layer SG_IO
ioctl code in the early lk 2.6 series that caused
the user supplied length to be ignored. That has now
been fixed. The sg driver from about 1998 has had
mechanisms to explicitly supply the command length.

> blkdev/scsi_ioctl.c doesn't do this, but sg.c does which is at least
> inconsistent.

do what ??

>> What it prevents is the issuing of vendor specific commands via the API,
>> which is arguably a good thing.
> 
> 
> Hmmm, isn't this the point of the ioctl API? How else do you get vendor
> unique things to a device?

I supplied a patch to allow the user to write to scsi_level
in sysfs, thus overriding any assumptions that scsi_lib
made about the device supplied scsi_level:
http://marc.theaimsgroup.com/?l=linux-scsi&m=113343693013725&w=2
That would solve your command overwrite problem in a less
invasive way than the patch you are proposing.

Doug Gilbert

