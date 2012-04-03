From: Norman Diamond <n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was: ehci_hcd fails to read a single good block)
Date: Tue, 3 Apr 2012 16:54:34 +0900 (JST)
Message-ID: <664580.50344.qm@web100011.mail.kks.yahoo.co.jp>
References: <Pine.LNX.4.44L0.1204021430130.12349-100000@netrider.rowland.org>
Reply-To: n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1204021430130.12349-100000-pYrvlCTfrz9XsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Alan Stern wrote:
> On Mon, 2 Apr 2012, Norman Diamond wrote:
>> My USB-to-IDE bridge DOES NOT CRASH when reading a bad block.=A0 Whe=
n a Linux driver tries to reassign a new USB address and crashes the br=
idge, the fault is a Linux driver.=A0 (And when Windows forgets about t=
he existence of the drive, the fault is Windows.)
>=20
> You really should capture a usbmon trace while running the dd test. T=
hat will show exactly what is happening.=A0 See Documentation/usb/usbmo=
n.txt.

Documentation/usb/usbmon.txt says:
"Mount debugfs (it has to be enabled in your kernel configuration), and=
"

I recommend:
"Mount debugfs (CONFIG_DEBUG_FS has to be enabled in your kernel config=
uration), and"

The help for CONFIG_DEBUG_FS says (or said; this might be outdated):
"debugfs is a virtual file system that kernel developers use to put deb=
ugging files into. Enable this option to be able to read and write to t=
hese files.
If unsure, say N."

I recommend:
"debugfs is a virtual file system that kernel developers use to put deb=
ugging files into. Enable this option to get reports that you can send =
to kernel developers if you ever have to report a bug.
If unsure, say Y."

Do you know a live Linux system whose kernel already has it built in?


>>>> There's still something wrong here.  When the bridge is connected =
to Windows XP, Windows accesses the correct number of blocks.  We need =
to find someone who has a non-working but indistinguishable bridge, ask=
 them to connect it to Windows XP, and see if Windows XP gets a number =
of blocks that is too large by 1.
>>>=20
>>> How would you tell?
>>=20
>> http://hdparm-win32.dyndns.org/hdparm/
>>=20
>> D:\hdparm for Windows\binary\hdparm-6.9-20070516.win32\bin>hdparm /d=
ev/sdg
>>=20
>> /dev/sdg:
>>=A0 geometry=A0 =A0=A0=A0=3D 2432/255/63, sectors =3D 39070080, start=
 =3D 0
>>=20
>> Windows did not get a number of blocks that was too large by 1.=A0 T=
he bridge provided the correct answer for READ CAPACITY, Windows accept=
ed it, and Linux improperly subtracted 1.
>=20
> How do you know?=A0 That is, how do you know that the number printed =
by hdparm above is the value used by Windows and not a value obtained d=
irectly from the bridge by the hdparm program itself?

Linux said that it was adjusting 39070080 to 39070079.  So surely the b=
ridge reported the maximum block number as 39070079 (for 39070080 block=
s).  And I think we can be pretty sure, practically speaking, that this=
 bridge doesn't detect if the PC host is running Windows instead of Lin=
ux, so the bridge surely reported the same maximum block number as 3907=
0079 (for 39070080 blocks) to Windows.

I'm pretty sure that the Windows version of hdparm uses IOCTL_DISK_GET_=
DRIVE_GEOMETRY, IOCTL_DISK_GET_LENGTH_INFO, and SMART_RCV_DRIVE_DATA to=
 get device information.  IOCTL_IDE_PASS_THROUGH and IOCTL_ATA_PASS_THR=
OUGH surely fail (hdparm -I and hdparm -i fail). =20

> Not that I have any reason to doubt this result -- I have no way of k=
nowing whether or not Windows subtracts 1 from the value reported by an=
y USB-(S)ATA bridge.

We should try Windows with a known actually broken bridge  ^_^

> By the way, just out of curiosity, why does it matter so much for you=
r program to know the exact number of blocks a drive contains?

The number of blocks is a multiple of 63 * 255, which was convenient fo=
r Windows XP and earlier, and convenient for BIOSes, and convenient for=
 Linux users who needed to interact with Windows or BIOSes.

Here is not my reason, but a fact that deserves to be a reason:
When the drive is mounted internally, Linux can create a partition endi=
ng at the end of the entire drive.  When the drive is attached to a USB=
 cable, Linux should be expected to be able to access the existing part=
ition.

Here is another fact that deserves to be a reason:
Windows XP can create a partition ending at the end of the entire drive=
, even if the drive is attached to a USB cable.  Linux should be expect=
ed to be able to access it.

Here is a hint at my reason:
Earlier in this thread I mentioned that I don't get to do forensics mys=
elf, but I have to be aware of it.

>>>>> There is no good solution to this problem.
>>>>=20
>>>> Agreed.
>>=20
>> Wrong.=A0 We CAN try to read the last block that the bridge says exi=
sts, to see if it really exists or not.=A0 (Well, only partly wrong.=A0=
 Maybe there really are some bridges that crash in that situation, but =
mine doesn't, and a broken driver still needs fixing.)
>=20
> Yes, there really are such bridges.=A0 You can find reports from peop=
le complaining about them in the email archives.

Wait.  Is there a bridge which overreports the last sector number by 1,=
 and which ALSO crashes when the host PC tries to read that supposed la=
st sector number?  If so then we need a quirk for that doubly broken br=
idge.  But otherwise, we can try to read the supposedly last sector num=
ber and figure out whether we have to subtract 1.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
