From: Norman Diamond <n0diamond@yahoo.co.jp>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was: ehci_hcd fails to read a single good block)
Date: Fri, 30 Mar 2012 16:34:06 +0900 (JST)
Message-ID: <662659.4715.qm@web100001.mail.kks.yahoo.co.jp>
References: <Pine.LNX.4.44L0.1203291029190.1417-100000@iolanthe.rowland.org>
Reply-To: n0diamond@yahoo.co.jp
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web100001.mail.kks.yahoo.co.jp ([114.111.98.175]:31885 "HELO
	web100001.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756230Ab2C3HeI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Mar 2012 03:34:08 -0400
In-Reply-To: <Pine.LNX.4.44L0.1203291029190.1417-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

Alan Stern wrote:
> On Thu, 29 Mar 2012, Norman Diamond wrote:
>> Alan Stern wrote:
>>> On Wed, 28 Mar 2012, Norman Diamond wrote:
>>>> I don't want to manhandle that old notebook's fragile vendor propr=
ietary IDE cable again, but I'll try to find another way to test that d=
rive again without going though USB.
>>>=20
>>> You don't have to worry about that.  sg_dd works fine over USB.
>>>=20
>>>>> The USB-to-IDE bridge is vendor 067b, product 2507, Prolific Tech=
nology Inc., and usb-storage matches it for quirk 110.
>>>=20
>>> What is the bcdDevice value?
>>=20
>> Is that different from 2507?
>=20
> It is a separate value from the product ID.=C2=A0 It appears in the o=
utput from "lsusb -v" or in /sys/kernel/debug/usb/devices (where it is =
labelled "Rev=3D").

bcdDevice is 1.00

sg_dd did work fine with proper parameters.  I apologize for wasting th=
e time of other kind participants in this thread.  Fortunately we have =
one genuine bug here waiting to be fixed.

>>>>> Digression:=C2=A0 Someone adjusts the number of blocks from the r=
eported 39070080 (which I think is correct) to 39070079 (which I think =
is wrong).=C2=A0 I'll have to install the drive in an old notebook to c=
heck if the reported number of blocks is really correct.
>>>>=20
>>>> Further on this digression:  The number of blocks really is 390700=
80.=EF=BF=BD Today libata made no adjustment and the number of blocks w=
as correct.  So some USB component makes a misadjustment to screw up th=
e number of blocks.
>>>=20
>>> usb-storage does this, because in the past Prolific's bridges have =
reported the wrong number of blocks.  In fact, I'm surprised that it se=
ems to work correctly with your drive.
>>=20
>> It is hard to imagine a USB bridge adding 1 to the number of blocks.=
=C2=A0 Did that really happen?
>=20
> No.=C2=A0 What happened was that the bridge reported the number of bl=
ocks, but SCSI's READ CAPACITY command requires the device to report th=
e highest available block number (which is one smaller since blocks are=
 numbered starting from 0).

I guess you mean that some USB bridges screw up the result of the READ =
CAPACITY command, so you have to subtract 1 in those cases.  This parti=
cular bridge isn't one of them, and the subtraction of 1 was wrong in t=
his case.

hdparm reports the bugged capacity after the incorrect subtraction of 1=
=2E  HDIO_GETGEO_BIG also gets the bugged capacity.  I don't see an opt=
ion to sdparm to get the device capacity (real SCSI devices probably ha=
ve it in a VPD page but this USB bridge doesn't provide any VPD pages).

sg_dd with correct parameters successfully read the actual last block! =
 That must be because sg_dd accessed /dev/sgsomething instead of /dev/s=
dmumble.

My program doesn't know if a USB bridge is defective and/or if a driver=
 defectively manipulated a block count.  So I have to open a /dev/sgsom=
ething, try to read 1 sector past the last sector that we think is vali=
d.  If it fails then I have to find out if the error was due to nonexis=
tence or other reason.  If it succeeds then I have to execute more pain=
ful hacks that I have to add.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
