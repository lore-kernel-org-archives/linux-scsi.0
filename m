From: Christian Franke <Christian.Franke@t-online.de>
Subject: Re: XHCI issues: WD MyBook 1230 - reset SuperSpeed USB device
Date: Sat, 18 Jan 2014 15:12:31 +0100
Message-ID: <52DA8BCF.6070201@t-online.de>
References: <Pine.LNX.4.44L0.1401161532560.1109-100000@iolanthe.rowland.org> <52D8DD45.9010602@suse.de> <52D991BA.40903@interlog.com> <52D99D51.1030100@fri.uniza.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout08.t-online.de ([194.25.134.20]:56375 "EHLO
	mailout08.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbaARO2E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jan 2014 09:28:04 -0500
In-Reply-To: <52D99D51.1030100@fri.uniza.sk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?UGV0ZXIgUGFsw7pjaA==?= <Peter.Paluch@fri.uniza.sk>, dgilbert@interlog.com
Cc: Hannes Reinecke <hare@suse.de>, Alan Stern <stern@rowland.harvard.edu>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

Peter Pal=C3=BAch wrote:
> Gentlemen,
>
> First of all, thank you very much for looking into this issue.
>
> Alan, for the sake of keeping the thread tidy in archives, I am not=20
> going to change the $SUBJECT of this e-mail but I wholeheartedly agre=
e=20
> that this is not an xHCI issue. Mea culpa; I did not know that at the=
=20
> time I first reported it.
>
> Douglas, Hannes: I believe we are definitely on to something. I do=20
> _not_ run smartd but this may be caused by something in my Gnome3 GUI=
=20
> environment. I have noticed that when I am not logged in to Gnome and=
=20
> work just in the text console, plugging in the USB drive and accessin=
g=20
> it works without any issues. Only when I am logged into my Gnome and=20
> plug the drive in, Gnome obviously tries to do something with the=20
> drive that causes it to stall and recover in 30 seconds. I have not=20
> yet been able to identify what it is.

Gnome disk utility?

AFAIK it relies on libatasmart. The source code of libatasmart is=20
unrelated to smartmontools.


> On 17.01.2014 21:25, Douglas Gilbert wrote:
>> On 14-01-17 02:35 AM, Hannes Reinecke wrote:
>>> On 01/16/2014 09:48 PM, Alan Stern wrote:
>>>> It looks like the reset occurred because the computer sent an
>>>> ATA-passthru command to the disk, and the disk wasn't prepared to
>>>> handle it properly.  The firmware crashed, requiring a reset.
>>>>
>>>> If anyone can explain, the command bytes in question were:
>>>>
>>>>     85082e00 00000000 00000000 0000ec00
>>
>> SCSI ATA PASS-THROUGH(16) command issuing the
>> mandatory ATA command 0xec which is IDENTIFY DEVICE.
>> [See SAT-3 drafts for more information on the pass-through
>> command.]
>>

The above command sets CK_COND bit (CDB[2] |=3D 0x20) to request ATA=20
return descriptor.

Smartmontools never set CK_COND for IDENTIFY DEVICE. It is only set if=20
ATA output reqister values are actually needed:

# smartctl -d sat -r ioctl -i -H /dev/sdd
=2E..
REPORT-IOCTL: Device=3D/dev/sdd Command=3DIDENTIFY DEVICE
Input:   FR=3D...., SC=3D0x01, LL=3D...., LM=3D...., LH=3D...., DEV=3D.=
=2E.., CMD=3D0xec IN
[ata pass-through(16): 85 08 0e 00 00 00 01 00 00 00 00 00 00 00 ec 00 =
]
=2E..
REPORT-IOCTL: Device=3D/dev/sdd Command=3DSMART STATUS CHECK
Input:   FR=3D0xda, SC=3D...., LL=3D...., LM=3D0x4f, LH=3D0xc2, DEV=3D.=
=2E.., CMD=3D0xb0
[ata pass-through(16): 85 06 2c 00 da 00 00 00 00 00 4f 00 c2 00 b0 00 =
]
=2E..


>>>> and the sense data was:
>>>>
>>>>     7201001d 0000000e 090c0000 00005d00 01000000 0050
>>
>> ATA spec says there should not (normally) be an error issued
>> by that command; but there was:
>>
>> $ sg_decode_sense -n 7201001d 0000000e 090c0000 00005d00 01000000 00=
50
>>  Descriptor format, current;  Sense key: Recovered Error
>>  Additional sense: ATA pass through information available
>>   Descriptor type: ATA Status Return
>>     extend=3D0  error=3D0x0  sector_count=3D0x0
>>     lba=3D0x000000
>>     device=3D0x0  status=3D0x50
>>
>> Looks reasonable at the SCSI level, not sure about the
>> ATA level, perhaps others can comment.

Returned ATA register values look reasonable but are not needed for ATA=
=20
IDENTIFY command.


>> Doug Gilbert
>> [a smartmontools maintainer]
>>

Christian Franke
[a smartmontools maintainer :-]

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
