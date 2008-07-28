From: =?ISO-8859-1?Q?C=E9dric_Godin?= <cedric@belbone.be>
Subject: Re: [SCSI] can't plug Nokia 5300 anymore (bisected)
Date: Mon, 28 Jul 2008 22:19:41 +0200
Message-ID: <488E29DD.4050303@belbone.be>
References: <Pine.LNX.4.44L0.0807281054060.2296-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:26541 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751635AbYG1UTy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jul 2008 16:19:54 -0400
In-Reply-To: <Pine.LNX.4.44L0.0807281054060.2296-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Kernel <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> On Mon, 28 Jul 2008, C=E9dric Godin wrote:
>
>  =20
>>>>>> Hello,
>>>>>>
>>>>>> since 2 or 3 -git kernels (Linus tree)  I have a problem with my=
 laptop=20
>>>>>> and its connection through USB to a nokia 5300 gsm.
>>>>>>
>>>>>> The logs show me a endless loop (until i unplug my USB cable) of=
=20
>>>>>> following messages :
>>>>>>
>>>>>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>>>>>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
>>>>>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>>>>>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
>>>>>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>>>>>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
>>>>>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>>>>>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
>>>>>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>>>>>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
>>>>>>
>>>>>> I bisected the kernel and found the following commit as result :
>>>>>>
>>>>>> 427e59f09fdba387547106de7bab980b7fff77be is first bad commit
>>>>>> commit 427e59f09fdba387547106de7bab980b7fff77be
>>>>>> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
>>>>>> Date:   Sat Mar 8 18:24:17 2008 -0600
>>>>>>
>>>>>>    [SCSI] make use of the residue value
>>>>>>
>>>>>>    USB sometimes doesn't return an error but instead returns a r=
esidue
>>>>>>    value indicating part (or all) of the command wasn't complete=
d.  So if
>>>>>>    the driver _done() error processing indicates the command was=
 fully
>>>>>>    processed, subtract off the residue so that this USB error ge=
ts
>>>>>>    propagated.
>>>>>>            =20
>
>  =20
>> That's me sending the wrong dmesg, sorry :-$
>>
>> Attached is the "good" one.
>>
>>    =20
>>> see only one error, and the commit you found wouldn't have affected=
=20
>>> that error.  More accurately, if the commit magnified the error int=
o an=20
>>> endless loop, then without the commit the error would still have be=
en=20
>>> present and would have caused data corruption.
>>>
>>> Anyway, it would be interesting to see what happens with the commit=
 in=20
>>> place and the following patch applied.  (The first part of the patc=
h=20
>>> has already been accepted by James.)
>>>  =20
>>>      =20
>> Same problem.
>>    =20
>
> Okay.  The problem is one we've seen many times in the past: The devi=
ce
> reports that it contains one sector more than it really does contain.=
 =20
> When the system tries to access the non-existent "last" sector, all
> sorts of problems occur.  In your case the device returned no data,
> together with an indication that a problem existed (Check Condition
> status) and no indication of what the problem actually was (no Sense
> data).
>
> The patch below should fix the problem.
>
> Alan Stern
>
>
>
> Index: usb-2.6/drivers/usb/storage/unusual_devs.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- usb-2.6.orig/drivers/usb/storage/unusual_devs.h
> +++ usb-2.6/drivers/usb/storage/unusual_devs.h
> @@ -225,6 +225,13 @@ UNUSUAL_DEV(  0x0421, 0x0495, 0x0370, 0x
>  		US_SC_DEVICE, US_PR_DEVICE, NULL,
>  		US_FL_MAX_SECTORS_64 ),
> =20
> +/* Reported by Cedric Godin <cedric@belbone.be> */
> +UNUSUAL_DEV(  0x0421, 0x04b9, 0x0551, 0x0551,
> +		"Nokia",
> +		"5300",
> +		US_SC_DEVICE, US_PR_DEVICE, NULL,
> +		US_FL_FIX_CAPACITY ),
> +
>  /* Reported by Olaf Hering <olh@suse.de> from novell bug #105878 */
>  UNUSUAL_DEV(  0x0424, 0x0fdc, 0x0210, 0x0210,
>  		"SMSC",
>
>  =20
it works, thanks !

Tested-by: Cedric Godin <cedric@belbone.be>


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
