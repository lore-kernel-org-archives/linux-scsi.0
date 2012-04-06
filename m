From: Norman Diamond <n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was: ehci_hcd fails to read a single good block)
Date: Fri, 6 Apr 2012 09:49:31 +0900 (JST)
Message-ID: <124887.42544.qm@web100003.mail.kks.yahoo.co.jp>
References: <Pine.LNX.4.44L0.1204041128160.1543-100000@iolanthe.rowland.org>
Reply-To: n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1204041128160.1543-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Alan Stern wrote:
> On Wed, 4 Apr 2012, Norman Diamond wrote:
>> Alan Stern wrote:
>>> On Tue, 3 Apr 2012, Norman Diamond wrote:
>>>>>> Wrong.=A0 We CAN try to read the last block that the bridge says=
 exists, to see if it really exists or not.=A0 (Well, only partly wrong=
=2E=A0 Maybe there really are some bridges that crash in that situation=
, but mine doesn't, and a broken driver still needs fixing.)
>>>>>=20
>>>>> Yes, there really are such bridges.=A0 You can find reports from =
people complaining about them in the email archives.
>>>>=20
>>>> Wait.  Is there a bridge which overreports the last sector number =
by 1, and which ALSO crashes when the host PC tries to read that suppos=
ed last sector number?
>>>=20
>>> Yes.  Like I said before, you can find complaints about these thing=
s in the mailing list archives.  However it's not clear whether the cra=
shing is the fault of the bridge itself or the drive it is attached to.
>>=20
>> Or the driver.
>=20
> No, it is not the fault of the driver.

I agree now that my bridge's crash sometimes when trying to read bad bl=
ocks is not the driver's fault, but meanwhile my bridge does not crash =
when trying to read a nonexistent block so it still seems possible to d=
etect if the result of READ CAPACITY is wrong.

>> I think it is not the fault of the drive.=A0 If a drive crashed when=
 a driver tried to access a nonexistent sector, then the drive would cr=
ash when mounted internally on an ATA or SATA cable not only when conne=
cted to a USB cable.

[I think we agree on that.]

> However there's no question that other bridges having the same vendor=
, product, and revision ID values as yours _did_ report the drive capac=
ity incorrectly; otherwise the quirk entry would not be there.=A0 What =
I'm not sure of is whether those bridges went on to crash as dramatical=
ly as yours.

Except that mine doesn't crash when trying to read a nonexistent block,=
 so the quirk handling still looks overly aggressive.

>> This still makes me wonder why Windows is able to handle the same br=
idges.
>=20
> Probably because Windows does not try to read the last block, unless =
it is occupied by a file.

I think Windows does.  At least in some cases the last block of a parti=
tion contains structural information and can't be used for files.  At l=
east in some cases Windows reports a file system error if that block ca=
n't be accessed when trying to mount the partition.  Now, Windows won't=
 have this trouble with my bridge because Windows saw the correct drive=
 size through my bridge.  Only Linux will have trouble.  I'll have to s=
ee if I can create a suitable partition in Windows and then get a Linux=
 error when trying to mount the partition without its last sector.

> It would be interesting to know the details of what your Windows syst=
em does when trying to read a file that occupies the faulty sector.

As mentioned in my other message a few minutes ago, now we do know more=
 or less, but I wonder what Windows was doing previously when it obviou=
sly wasn't really reading that file.

>> Now, as far as I can tell, I have found a WTF of a standard.=A0 I on=
ly have drafts of old T10 documents but it sure looks like a WTF unless=
 something was fixed later.
>>=20
>> In SCSI Block Commands, it seems to me that the READ CAPACITY (10) c=
ommand (opcode 0x25) returns the number of blocks.
>=20
> I'm not sure how you reached that conclusion.=A0 In my rather old cop=
y of the SCSI-2 standard, section 9.2.7 (the READ CAPACITY command in t=
he chapter on Direct-access devices) says:
>=20
> =A0=A0=A0 A partial medium indicator (PMI) bit of zero indicates that=
 the=20
> =A0=A0=A0 returned logical block address and the block length in byte=
s
> =A0=A0=A0 are those of the last logical block on the logical unit.

That's the same result that RBC promises, but my draft of SBC-3 doesn't=
 say that.  Oh, now I see it gives a hint and I missed it:

"A partial medium indicator (PMI) bit set to zero specifies that the de=
vice server return information on the last logical block on the direct-=
access block device."

That wording change was a pretty scuzzy thing to do.  Not your fault of=
 course.  (Or is it ... let me check the list of committee members at t=
he top of the document ^_^ )
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
