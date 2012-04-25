From: Norman Diamond <n0diamond@yahoo.co.jp>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was: ehci_hcd fails to read a single good block)
Date: Thu, 26 Apr 2012 08:44:23 +0900 (JST)
Message-ID: <83362.45763.qm@web100010.mail.kks.yahoo.co.jp>
References: <Pine.LNX.4.44L0.1204251126320.1471-100000@iolanthe.rowland.org>
Reply-To: n0diamond@yahoo.co.jp
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web100010.mail.kks.yahoo.co.jp ([114.111.98.184]:45504 "HELO
	web100010.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932482Ab2DYXo0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Apr 2012 19:44:26 -0400
In-Reply-To: <Pine.LNX.4.44L0.1204251126320.1471-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

Alan Stern wrote:
> On Wed, 18 Apr 2012, Norman Diamond wrote:
>> Alan Stern wrote:
>>> On Tue, 17 Apr 2012, Norman Diamond wrote:
>>>> Yes it does look like changing this bridge to CAPACITY_HEURISTICS =
from FIX_CAPACITY is likely to help a bit.
>>>=20
>>> That's easy enough.
>>=20
>> Yeah I know, even I could do that one=A0 ^_^
>>=20
>>>> I think that heuristics should also accept multiples of 63 even if=
 the total is odd.  This doesn't solve everything but will probably hel=
p more.
>>>=20
>>> Okay, if nobody objects.
>>=20
>> I'm nobody and I don't object=A0 ^_^
>> (Of course we have to wait to see if anyone knows a real reason that=
 this would be a problem.)
>>=20
>>>> I think that handling of FIX_CAPACITY should check for multiples o=
f 63 and report the apparent likelihood that FIX_CAPACITY probably wasn=
't the right setting for the bridge (if it's a bridge).  This doesn't s=
olve everything but will probably help more.
>>>=20
>>> The FIX_CAPACITY code runs in a different module.  It has no way to=
 know whether the device is a bridge or not.
>>=20
>> The quirks table could be made available, but values stored in the t=
able don't say if the device is a bridge.=A0 OK, then I still think thi=
s:=A0 I think that handling of FIX_CAPACITY should check for multiples =
of 63 and report the apparent likelihood that FIX_CAPACITY probably was=
n't the right setting for the device.
>>=20
>> In addition, I have a feeling that if a device has FIX_CAPACITY but =
the number of reported blocks is even then I doubt the accuracy of FIX_=
CAPACITY.=A0 The reason is that flash memory devices tend to have physi=
cal sectors that are even multiples of logical sectors.
>=20
> FIX_CAPACITY applies to all kinds of devices, not just those using fl=
ash memory.=A0 There have been examples posted in the archives of devic=
es which really do have an odd number of blocks.=A0 (I don't remember w=
hether any of these devices needs the FIX_CAPACITY flag, though.)

Actually I now recall jumpering a hard drive in or around 1998.  When t=
he drive reported its full capacity, the PC's BIOS hanged and would not=
 boot.  I jumpered the drive to report 15 heads instead of 16, reducing=
 the capacity of the drive so that the PC's BIOS would boot.  I don't r=
ecall the number of reported cylinders, but if that was also odd then t=
he total number of reported blocks would be odd.

If the drive were connected to a USB cable then jumpering would not be =
necessary.  However, if the drive already contained data and we wanted =
to use a USB cable to retrieve the data, then the jumper would have to =
remain in place.

I no longer have that drive, but I'm going to report a bug later in thi=
s message.

>> I do think the handling of FIX_CAPACITY should report when devices r=
eport capacities that are either multiples of 63 or 2 (or both), so tha=
t further testing can be done.=A0 The existing code to do the decrement=
 anyway can remain the same until further testing is done.
>>=20
>>>> The addition of TEST_CAPACITY doesn't solve everything but will pr=
obably help more.
>>>=20
>>> That will require a certain amount of work, with the possibility of=
 breaking some systems.  I'd rather not do it if there's no clear and p=
ressing need.
>>=20
>> Two indistinguishable versions of the Prolific bridge show that ther=
e is a need.=A0 One version needs the decrement (probably) and the othe=
r version doesn't (definitely).
>=20
> No, the two indistinguishable versions show there is a need to change=
 the existing FIX_CAPACITY flag to CAPACITY_HEURISTICS.

OK, the new code for heuristics makes it PROBABLY good enough to change=
 the Prolific bridge from FIX_CAPACITY to CAPACITY_HEURISTICS.

> Below are two patches that do pretty much what you are asking for.  P=
lease test just the first and then both together.

Ouch.  Yeah I should expect it to be my responsibility to test, but reb=
uilding the live Linux system that I use is particularly painful.  (Of =
course I have to be grateful that it is even possible in the first plac=
e, regardless of being painful.)

Would it be acceptable for me to donate my USB-to-ATA cable to you?

> +        (sdp->guess_capacity && (n % 2 =3D=3D 1 || n % 63 =3D=3D 1))=
) {

Imagine a device with 63 blocks.  guess_capacity is true and n % 2 =3D=3D=
 1 so this is going to truncate when we don't want to.

How is one of these, either in my style:
(sdp->guess_capacity && (n % 2 !=3D 0) && (n % 63 !=3D 0))) {

or a popular coding style:
(sdp->guess_capacity && n % 2 n % 63)) {

> +            sd_printk(KERN_INFO, sdkp, "(This adjustment may be inco=
rrect)\n");

I'd like to suggest:
"(This adjustment may be incorrect.  If this adjustment truncates your =
drive when it should not, please report the error and your device's det=
ails to linux-usb@vger.kernel.org)"
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
