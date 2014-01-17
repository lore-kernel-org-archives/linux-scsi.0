From: =?UTF-8?B?UGV0ZXIgUGFsw7pjaA==?= <Peter.Paluch-7KFcp/riIjesQNkk2E3g2Q@public.gmane.org>
Subject: Re: XHCI issues: WD MyBook 1230 - reset SuperSpeed USB device
Date: Fri, 17 Jan 2014 22:14:57 +0100
Message-ID: <52D99D51.1030100@fri.uniza.sk>
References: <Pine.LNX.4.44L0.1401161532560.1109-100000@iolanthe.rowland.org> <52D8DD45.9010602@suse.de> <52D991BA.40903@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52D991BA.40903-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christian Franke <Christian.Franke-zqRNUXuvxA0b1SvskN2V4Q@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Gentlemen,

=46irst of all, thank you very much for looking into this issue.

Alan, for the sake of keeping the thread tidy in archives, I am not=20
going to change the $SUBJECT of this e-mail but I wholeheartedly agree=20
that this is not an xHCI issue. Mea culpa; I did not know that at the=20
time I first reported it.

Douglas, Hannes: I believe we are definitely on to something. I do _not=
_=20
run smartd but this may be caused by something in my Gnome3 GUI=20
environment. I have noticed that when I am not logged in to Gnome and=20
work just in the text console, plugging in the USB drive and accessing=20
it works without any issues. Only when I am logged into my Gnome and=20
plug the drive in, Gnome obviously tries to do something with the drive=
=20
that causes it to stall and recover in 30 seconds. I have not yet been=20
able to identify what it is.

I am not subscribed to linux-scsi mailing list so if you believe=20
anything of this is relevant please forward that mail there.

Thank you!

Best regards,
Peter




On 17.01.2014 21:25, Douglas Gilbert wrote:
> On 14-01-17 02:35 AM, Hannes Reinecke wrote:
>> On 01/16/2014 09:48 PM, Alan Stern wrote:
>>> It's now clear that this is _not_ an XHCI issue, contrary to what
>>> $SUBJECT says.
>>>
>>> On Thu, 16 Jan 2014, Peter Pal=C3=BAch wrote:
>>>
>>>> Alan,
>>>>
>>>> I am attaching the usbmon trace after the drive has been plugged i=
nto
>>>> the USB-2 port. Record of the drive in stall should occur around t=
he
>>>> file offset 87808 (decimal). The log was done on the 3.12.7 kernel
>>>> without CONFIG_PM. Should I do a usbmon trace on my regular kernel=
=20
>>>> with
>>>> CONFIG_PM as well?
>>>
>>> No need.
>>>
>>>> dmesg transcript:
>>>>
>>>> root@bach:/tmp# dmesg
>>>> usb 4-1.2: new high-speed USB device number 5 using ehci-pci
>>>> usb 4-1.2: New USB device found, idVendor=3D1058, idProduct=3D1230
>>>> usb 4-1.2: New USB device strings: Mfr=3D2, Product=3D3, SerialNum=
ber=3D1
>>>> usb 4-1.2: Product: My Book 1230
>>>> usb 4-1.2: Manufacturer: Western Digital
>>>> usb 4-1.2: SerialNumber: 574D43344E30323438393836
>>>> usb-storage 4-1.2:1.0: USB Mass Storage device detected
>>>> scsi6 : usb-storage 4-1.2:1.0
>>>> usbcore: registered new interface driver usb-storage
>>>> scsi 6:0:0:0: Direct-Access     WD       My Book 1230 1050 PQ: 0=20
>>>> ANSI: 6
>>>> scsi 6:0:0:1: Enclosure         WD       SES Device 1050 PQ: 0 ANS=
I: 6
>>>> sd 6:0:0:0: Attached scsi generic sg2 type 0
>>>> scsi 6:0:0:1: Attached scsi generic sg3 type 13
>>>> sd 6:0:0:0: [sdb] Spinning up disk...
>>>> .........ready
>>>> sd 6:0:0:0: [sdb] 732558336 4096-byte logical blocks: (3.00 TB/2.7=
2=20
>>>> TiB)
>>>> sd 6:0:0:0: [sdb] Write Protect is off
>>>> sd 6:0:0:0: [sdb] Mode Sense: 53 00 10 08
>>>> sd 6:0:0:0: [sdb] No Caching mode page found
>>>> sd 6:0:0:0: [sdb] Assuming drive cache: write through
>>>> sd 6:0:0:0: [sdb] 732558336 4096-byte logical blocks: (3.00 TB/2.7=
2=20
>>>> TiB)
>>>> sd 6:0:0:0: [sdb] No Caching mode page found
>>>> sd 6:0:0:0: [sdb] Assuming drive cache: write through
>>>>    sdb: sdb1
>>>> sd 6:0:0:0: [sdb] 732558336 4096-byte logical blocks: (3.00 TB/2.7=
2=20
>>>> TiB)
>>>> sd 6:0:0:0: [sdb] No Caching mode page found
>>>> sd 6:0:0:0: [sdb] Assuming drive cache: write through
>>>> sd 6:0:0:0: [sdb] Attached SCSI disk
>>>> usb 4-1.2: reset high-speed USB device number 5 using ehci-pci
>>>
>>> It looks like the reset occurred because the computer sent an
>>> ATA-passthru command to the disk, and the disk wasn't prepared to
>>> handle it properly.  The firmware crashed, requiring a reset.
>>>
>>> If anyone can explain, the command bytes in question were:
>>>
>>>     85082e00 00000000 00000000 0000ec00
>
> SCSI ATA PASS-THROUGH(16) command issuing the
> mandatory ATA command 0xec which is IDENTIFY DEVICE.
> [See SAT-3 drafts for more information on the pass-through
> command.]
>
>>> and the sense data was:
>>>
>>>     7201001d 0000000e 090c0000 00005d00 01000000 0050
>
> ATA spec says there should not (normally) be an error issued
> by that command; but there was:
>
> $ sg_decode_sense -n 7201001d 0000000e 090c0000 00005d00 01000000 005=
0
>  Descriptor format, current;  Sense key: Recovered Error
>  Additional sense: ATA pass through information available
>   Descriptor type: ATA Status Return
>     extend=3D0  error=3D0x0  sector_count=3D0x0
>     lba=3D0x000000
>     device=3D0x0  status=3D0x50
>
> Looks reasonable at the SCSI level, not sure about the
> ATA level, perhaps others can comment.
>
>>> I don't know what either of these means, or even what software was
>>> responsible for sending this command.  It appears to have come from
>>> some user program, though, not the kernel.  Possibly something run =
by
>>> udev.
>>>
>> Probably smartd.
>> The logic there is _less_ than perfect.
>
> Guilty as charged. Silly us, fancy smartmontools issuing
> mandatory ATA commands over a USB transport (MSC ?) and
> expecting the device to be well-behaved :-)
>
>> Try to disable smartd and check if the issue remains.
>
> Probably will help. Throwing away all your USB storage
> devices (apart from those that do UAS(P)) would be even
> more helpful (to us).
>
> Perhaps smartmontools could do a better job of identifying
> USB connected storage devices and avoid them.
>
> Doug Gilbert
> [a smartmontools maintainer]
>

--=20
Ing. Peter Pal=C3=BAch, Ph.D.
CCIE R&S #23527, CCIP, CCAI, Cisco Designated VIP 2011-2014 LAN & WAN

Department of InfoCom Networks
=46aculty of Management Science and Informatics, University of Zilina
Univerzitn=C3=A1 8215/1, 010 26 =C5=BDilina, Slovakia

WWW:  http://www.kis.fri.uniza.sk
Tel.: +421-41-513-4325, +421-905-164432

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
