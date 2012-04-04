From: Norman Diamond <n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was: ehci_hcd fails to read a single good block)
Date: Wed, 4 Apr 2012 13:13:40 +0900 (JST)
Message-ID: <388819.38189.qm@web100008.mail.kks.yahoo.co.jp>
References: <Pine.LNX.4.44L0.1204031017110.1537-100000@iolanthe.rowland.org>
Reply-To: n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1204031017110.1537-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Alan Stern wrote:
> On Tue, 3 Apr 2012, Norman Diamond wrote:
>>>> Wrong.  We CAN try to read the last block that the bridge says exi=
sts, to see if it really exists or not.  (Well, only partly wrong.  May=
be there really are some bridges that crash in that situation, but mine=
 doesn't, and a broken driver still needs fixing.)
>>>=20
>>> Yes, there really are such bridges.  You can find reports from peop=
le complaining about them in the email archives.
>>=20
>> Wait.=A0 Is there a bridge which overreports the last sector number =
by 1, and which ALSO crashes when the host PC tries to read that suppos=
ed last sector number?
>=20
> Yes.=A0 Like I said before, you can find complaints about these thing=
s in the mailing list archives.=A0 However it's not clear whether the c=
rashing is the fault of the bridge itself or the drive it is attached t=
o.

Or the driver.

I think it is not the fault of the drive.  If a drive crashed when a dr=
iver tried to access a nonexistent sector, then the drive would crash w=
hen mounted internally on an ATA or SATA cable not only when connected =
to a USB cable.

It might be the fault of the bridge, BUT, does a single bridge really s=
uffer from BOTH faults as I asked?  You seem to be saying yes, but then=
 you cloud it up by saying it's unclear if it might be the drive instea=
d of the bridge.  I still wonder if it's the driver instead of the brid=
ge, but surely not the drive.

>>=A0 If so then we need a quirk for that doubly broken bridge.
>=20
> That's what the existing quirk entries are there for.

Surely that's not what the quirk is for on my bridge.

>> But otherwise, we can try to read the supposedly last sector number =
and figure out whether we have to subtract 1.
>=20
> True enough, but we don't have any way to know which bridges do crash=
 and which don't other than trying it.=A0 And you'll probably agree tha=
t trial and error is not such a good idea in the cases where the bridge=
 does crash.

This still makes me wonder why Windows is able to handle the same bridg=
es.

Now, as far as I can tell, I have found a WTF of a standard.  I only ha=
ve drafts of old T10 documents but it sure looks like a WTF unless some=
thing was fixed later.

In SCSI Block Commands, it seems to me that the READ CAPACITY (10) comm=
and (opcode 0x25) returns the number of blocks.

In Reduced Block Commands, it says explicitly that the READ CAPACITY co=
mmand (opcode 0x25) returns the LBA of the last logical block of the me=
dia contained in the device.  So a USB-to-ATA bridge is required to sub=
tract 1 from the number of blocks reported by ATA IDENTIFY, and a USB-t=
o-SCSI bridge has to subtract 1 from the result of READ CAPACITY (10). =
 (Our present discussion involves the fact that a defective bridge migh=
t not subtract that 1, whereupon the next step gets spindled and mutila=
ted.)

If a driver wants the last block number then it has to subtract 1 in th=
e case of SCSI, and it wants the number of blocks then it has to add 1 =
in the case of USB.  Did I really read this right?
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
