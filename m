From: Mark Lord <lkml@rtr.ca>
Subject: Re: Problems with USB disk [solved]
Date: Wed, 12 Sep 2007 18:10:50 -0400
Message-ID: <46E863EA.4060806@rtr.ca>
References: <f9akh8$ori$1@sea.gmane.org> <20070807211847.GA25391@kroah.com> <f9c71t$r60$1@sea.gmane.org> <200708081357.03238.ismail@pardus.org.tr> <f9hmia$dol$1@sea.gmane.org> <f9mlcc$njk$1@sea.gmane.org> <f9pr31$rdq$1@sea.gmane.org> <46C1C560.80801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759419AbXILWLF@vger.kernel.org>
In-Reply-To: <46C1C560.80801@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Niels <zorglub_olsen@hotmail.com>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

Chuck Ebbert wrote:
> On 08/13/2007 10:50 AM, Niels wrote:
>> On Sunday 12 August 2007 11:54, Niels wrote:
>>
>>> On Friday 10 August 2007 14:43, Niels wrote:
>>>
>>>> On Wednesday 08 August 2007 12:57, Ismail D=C3=B6nmez wrote:
>>>>
>>>>> On Wednesday 08 August 2007 13:48:29 you wrote:
>>>>>> On Tuesday 07 August 2007 23:18, Greg KH wrote:
>>>>>>> On Tue, Aug 07, 2007 at 10:26:15PM +0200, Niels wrote:
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> I'm having problems with a new 500 GB USB disk. It works, but
>>>>>>>> sometimes I get these in dmesg:
>>>>>>>>
>>>>>>>>
>>>>>>>> usb 1-3: reset high speed USB device using ehci_hcd and addres=
s 2
>>>>>>>> usb 5-1: USB disconnect, address 2
>>>>>>>> drivers/usb/class/usblp.c: usblp0: removed
>>>>>>>> sd 0:0:0:0: Device not ready: <6>: Sense Key : 0x2 [current]
>>>>>>>>
>>>>>>>> : ASC=3D0x4 ASCQ=3D0x2
>>>>>>>>
>>>>>>>> end_request: I/O error, dev sda, sector 254148215
>>>>>>>> sd 0:0:0:0: Device not ready: <6>: Sense Key : 0x2 [current]
>>>>>>>>
>>>>>>>> : ASC=3D0x4 ASCQ=3D0x2
>>>>>>>>
>>>>>>>> end_request: I/O error, dev sda, sector 252434023
>>>>>>>> EXT3-fs error (device sda1): ext3_find_entry: reading director=
y
>>>>>>>> #15761836 offset 0
>>>>>>>>
>>>>>>>>
>>>>>>>> There's also a printer connected. This is on a pci/usb2 card. =
When
>>>>>>>> the above happens, I get I/O errors. When I mount the drive ne=
xt,
>>>>>>>> there are errors and often missing files. Quite annoying!
>>>>>>>>
>>>>>>>> Kernel is 2.6.21
>>>>>>>>
>>>>>>>> What's going on?
>>>>>>> You have a low voltage issue, or a bad cable.  The device is
>>>>>>> electronically disconnecting itself.  Try using a externally-po=
wered
>>>>>>> hub, or a new cable.
>>>>> I am seeing a similar problem with 2.6.22 and 2.6.23-* kernels wi=
th my
>>>>> 60G iPod Video, works fine with 2.6.18 kernel though.
>>>>>
>>>> So far I'm seeing this:
>>>>
>>>> - On 2.6.21 I mount the drive. After a while it spins down, and wh=
en I
>>>> then unmount it, an error pops up in dmesg.
>>>>
>>>> - On 2.6.18 I can't provoke the same error. The drive doesn't appe=
ar to
>>>> spin down. I don't know if the data corruption from 2.6.21 occurs =
with
>>>> regular use.
>>>>
>>>> There are a number of other factor I need to eliminate on my syste=
m, but
>>>> that's it so far. CONFIG_USB_SUSPEND is not set on either kernel.
>>> OK, on a vanilla 2.6.18.8 I also have this problem, with both the p=
ci/usb2
>>> card, and the usb1 on the board. I listen to music from the drive, =
and
>>> after some time (10-20 minutes or so), it freaks out:
>>>
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D
>>> sd 1:0:0:0: Device not ready: <6>: Current: sense key=3D0x2
>>>     ASC=3D0x4 ASCQ=3D0x2
>>> end_request: I/O error, dev sda, sector 126693711
>>> sd 1:0:0:0: Device not ready: <6>: Current: sense key=3D0x2
>>>     ASC=3D0x4 ASCQ=3D0x2
>>> end_request: I/O error, dev sda, sector 126693711
>>> sd 1:0:0:0: Device not ready: <6>: Current: sense key=3D0x2
>>>     ASC=3D0x4 ASCQ=3D0x2
>>> end_request: I/O error, dev sda, sector 126693711
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>
>> Using a new PSU and a powered hub made no difference. But I found a =
solution
>> here:
>>
>> http://alienghic.livejournal.com/382903.html
>>
>> Basically, the problem is, as suspected, that the drive spins down /=
 goes to
>> suspend. This can be disabled with "sdparm --clear STANDBY -6 /dev/s=
da".
>>
>> It seems to me to be an error that the kernel reports this as someth=
ing like
>> a hardware failure. Or at least very misleading.
>>
>=20
> Oh, nice. The usb-storage (SCSI) disk spins itself down and we can't =
handle that.
> Should we be disabling auto-spindown when we connect the device, or b=
e able to
> handle this by sending the start command when needed?

There's more to this.

My Sandisk Cruzer Micro 1GB USB sticks suffer from this regression.
Plug one in, it works for about 5 seconds, then the light goes off (bad=
).
Next access requires a 30s timeout + reset.  Etc..

This is with 2.6.23-rc6.
Works without any problems in 2.6.22.  REGRESSION.

-ml
