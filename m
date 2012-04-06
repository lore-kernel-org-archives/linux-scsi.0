From: Norman Diamond <n0diamond@yahoo.co.jp>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was: ehci_hcd fails to read a single good block)
Date: Fri, 6 Apr 2012 09:27:37 +0900 (JST)
Message-ID: <578492.36106.qm@web100003.mail.kks.yahoo.co.jp>
References: <Pine.LNX.4.44L0.1204041043580.1543-100000@iolanthe.rowland.org>
Reply-To: n0diamond@yahoo.co.jp
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web100003.mail.kks.yahoo.co.jp ([114.111.98.177]:26726 "HELO
	web100003.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756734Ab2DFA1l convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Apr 2012 20:27:41 -0400
In-Reply-To: <Pine.LNX.4.44L0.1204041043580.1543-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

Sorry for top posting, but I don't want to delete the very helpful anal=
ysis in the excessively long quotation below.

Alan Stern is correct to say I was too quick in blaming the driver, but=
 I did have a reason, which will now lead off topic for a moment, sorry=
 again.

Several days ago I said that Windows XP copied all of the files from th=
e partition onto a different hard drive, the bridge did not crash, the =
drive had no problem, etc.  When Windows XP CHKDSK was told to test eve=
ry sector in the partition then Windows XP forgot about the hard drive'=
s existence and it was necessary to unplug and replug the USB cable, ju=
st like Linux.  But Windows XP could copy all the files and Linux's "cp=
 -pr" could not, it sure did look like a driver problem.

Now I know that Windows XP lied.  I don't know what it was really copyi=
ng when it pretended to copy all of the files from the partition onto a=
 different hard drive.

I tracked down which file contained the bad block.  I deleted every oth=
er file in the partition.  Then, when Windows XP tried to copy the file=
 from the partition onto a different hard drive, Windows XP did fail an=
d it forgot about the hard drive's existence.

Therefore it does look like Linux's drivers are not at fault, and the U=
SB-to-ATA bridge is at fault, though there is still something odd.

When sg_dd tries to read the bad block, it fails, but the bridge does n=
ot crash.

When ordinary dd tries to read a Linux-length page of 8 blocks, the bri=
dge crashes.

I'm pretty sure Windows is reading a cluster of 4 blocks in the file an=
d the bridge crashes at that time.  (The partition is a little under 8M=
B, formatted FAT12, with clusters of 4 sectors.)

I wonder what was Windows reading when the partition was filled with ot=
her files besides the one that contains the bad block, when Windows pre=
tended that it read the file containing the bad block?  I'll have to se=
e if I can reconstruct that situation.  Though obviously that will be o=
ff topic.

Nonetheless, trying to read a nonexistent sector after the last existin=
g sector does not crash my bridge.  sg_dd reports the error correctly. =
 Ordinary dd doesn't try to do the read because the sector address is 2=
 past where Linux thinks the drive ends (which is 1 past where the driv=
e really ends).  Existing non-defective blocks on the drive can still b=
e accessed.  The USB cable does not beed to be unplugged and replugged.

With a different bridge, a Linux driver hangs for a few minutes after t=
rying to read the bad block.  Then it resets the bridge, the reset succ=
eeds, and good blocks on the drive can still be accessed.  Also with th=
at different bridge, Linux knows the real size of the drive.


Alan Stern wrote:
> On Wed, 4 Apr 2012, Norman Diamond wrote:
>=20
> > The usbmon output quoted below comes from the sequence of two comma=
nds:
> > sg_dd blk_sgio=3D1 bpt=3D1 bs=3D512 count=3D1 if=3D/dev/sdb of=3D/d=
ev/null skip=3D551562
> > dd bs=3D512 count=3D1 if=3D/dev/sdb of=3D/dev/null skip=3D551562
> >=20
> > As expected by now, the sg_dd command properly reported an error fo=
r the unreadable block, and the USB-to-ATA bridge did not crash.=A0 The=
 dd command also reported an error, and then a driver caused a crash of=
 the driver's self and/or the bridge.
>=20
> This is good.=A0 It shows just what happened.
>=20
> And by the way, you shouldn't be so quick to assign blame.=A0 Without
> knowing the exact details, you're not in a position to say where the
> fault really lies.
>=20
> > f0da9c00 3237261077 S Bo:2:003:1 -115 31 =3D 55534243 d7000000 2400=
0000 80000612 00000024 00000000 00000000 000000
> > f0da9c00 3237261251 C Bo:2:003:1 0 31 >
> > f2938d80 3237261539 S Bi:2:003:2 -115 36 <
> > f2938d80 3237261706 C Bi:2:003:2 0 36 =3D 00000000 23000000 4849544=
1 4348495f 444b3233 42412d32 30422020 20202020
> > f0da9c00 3237261723 S Bi:2:003:2 -115 13 <
> > f0da9c00 3237261793 C Bi:2:003:2 0 13 =3D 55534253 d7000000 0000000=
0 00
>=20
> The first command issued by sg_dd was an INQUIRY, and it succeeded.
>=20
> > f0da9c00 3237261905 S Bo:2:003:1 -115 31 =3D 55534243 d8000000 0002=
0000 80000a28 0000086a 8a000001 00000000 000000
> > f0da9c00 3237262093 C Bo:2:003:1 0 31 >
> > f2938d80 3237262250 S Bi:2:003:2 -115 512 <
> > f2938d80 3239564885 C Bi:2:003:2 -32 0
> > f0da9c00 3239564972 S Co:2:003:0 s 02 01 0000 0082 0000 0
> > f0da9c00 3239565256 C Co:2:003:0 0 0
> > f0da9c00 3239565287 S Bi:2:003:2 -115 13 <
> > f0da9c00 3239565485 C Bi:2:003:2 0 13 =3D 55534253 d8000000 0002000=
0 01
>=20
> This is the second command, a READ(10) for one block starting at bloc=
k
> 551562 (86a8a in hex).=A0 The bridge transmitted no data and reported=
 a=20
> failure status.
>=20
> > f0da9c00 3239565521 S Bo:2:003:1 -115 31 =3D 55534243 d9000000 1200=
0000 80000603 00000012 00000000 00000000 000000
> > f0da9c00 3239565740 C Bo:2:003:1 0 31 >
> > f2938d80 3239565896 S Bi:2:003:2 -115 18 <
> > f2938d80 3239566129 C Bi:2:003:2 0 18 =3D 70000000 0000000a 0000000=
0 00000000 0000
> > f0da9c00 3239566160 S Bi:2:003:2 -115 13 <
> > f0da9c00 3239566364 C Bi:2:003:2 0 13 =3D 55534253 d9000000 0000000=
0 00
>=20
> When asked for detailed status information (REQUEST SENSE), the bridg=
e
> sent an empty reply (No Sense).=A0 This is a bug in the bridge; it sh=
ould
> have indicated what sort of failure occurred, such as: Hardware Error=
,
> Unrecovered read error.
>=20
> > f0da9c00 3239577155 S Bo:2:003:1 -115 31 =3D 55534243 da000000 0000=
0000 00000600 00000000 00000000 00000000 000000
> > f0da9c00 3239577291 C Bo:2:003:1 0 31 >
> > f0da9c00 3239577492 S Bi:2:003:2 -115 13 <
> > f0da9c00 3239577666 C Bi:2:003:2 0 13 =3D 55534253 da000000 0000000=
0 00
>=20
> This is a TEST UNIT READY command.=A0 It shows that the drive is read=
y
> to be used.=A0 I can't tell if this command was sent by sg_dd or
> something else.
>=20
> > f0da9c00 3239579541 S Bo:2:003:1 -115 31 =3D 55534243 db000000 0010=
0000 80000a28 00025428 80000008 00000000 000000
> > f0da9c00 3239579702 C Bo:2:003:1 0 31 >
> > f2938300 3239579845 S Bi:2:003:2 -115 4096 <
> > f2938300 3239593701 C Bi:2:003:2 0 4096 =3D 00000000 00000000 00000=
000 00000000 00000000 00000000 00000000 00000000
> > f0da9c00 3239593720 S Bi:2:003:2 -115 13 <
> > f0da9c00 3239593791 C Bi:2:003:2 0 13 =3D 55534253 db000000 0000000=
0 00
> ...
>=20
> There follows a rather lengthy series of reads, of which I have cut o=
ut
> all but the first.=A0 They look like the sort of thing udev does when=
 a
> new drive is registered, but I have no idea why udev should have been
> triggered at this point.=A0 Anyway, they all succeeded.
>=20
> > f0da9c00 3239745783 S Bo:2:003:1 -115 31 =3D 55534243 37010000 0000=
0000 00000600 00000000 00000000 00000000 000000
> > f0da9c00 3239746063 C Bo:2:003:1 0 31 >
> > f0da9c00 3239746250 S Bi:2:003:2 -115 13 <
> > f0da9c00 3239746289 C Bi:2:003:2 0 13 =3D 55534253 37010000 0000000=
0 00
>=20
> Another successful TEST UNIT READY.
>=20
> > f0da9c00 3239747439 S Bo:2:003:1 -115 31 =3D 55534243 38010000 0002=
0000 80000ca1 082e0001 00000000 ec000000 000000
> > f0da9c00 3239747584 C Bo:2:003:1 0 31 >
> > f2938c80 3239747747 S Bi:2:003:2 -115 512 <
> > f2938c80 3239747790 C Bi:2:003:2 -32 0
> > f0da9c00 3239747827 S Co:2:003:0 s 02 01 0000 0082 0000 0
> > f0da9c00 3239747935 C Co:2:003:0 0 0
> > f0da9c00 3239747969 S Bi:2:003:2 -115 13 <
> > f0da9c00 3239748065 C Bi:2:003:2 0 13 =3D 55534253 38010000 0002000=
0 01
>=20
> This is a 12-byte ATA pass-through command.=A0 I don't know just what=
 the
> command is, but in any case the bridge rejected it with a failure=20
> status.
>=20
> > f0da9c00 3239748146 S Bo:2:003:1 -115 31 =3D 55534243 39010000 1200=
0000 80000603 00000012 00000000 00000000 000000
> > f0da9c00 3239748307 C Bo:2:003:1 0 31 >
> > f2938c80 3239748462 S Bi:2:003:2 -115 18 <
> > f2938c80 3239748557 C Bi:2:003:2 0 18 =3D 70000500 0000000a 0000000=
0 20000000 0000
> > f0da9c00 3239748591 S Bi:2:003:2 -115 13 <
> > f0da9c00 3239748686 C Bi:2:003:2 0 13 =3D 55534253 39010000 0000000=
0 00
>=20
> The corresponding sense information is: Illegal Request, Invalid
> command operation code, which is appropriate for an unrecognized comm=
and.
>=20
> > f0da9c00 3239748806 S Bo:2:003:1 -115 31 =3D 55534243 3a010000 0000=
0000 00000600 00000000 00000000 00000000 000000
> > f0da9c00 3239748949 C Bo:2:003:1 0 31 >
> > f0da9c00 3239749103 S Bi:2:003:2 -115 13 <
> > f0da9c00 3239749164 C Bi:2:003:2 0 13 =3D 55534253 3a010000 0000000=
0 00
>=20
> Yet another TEST UNIT READY.=A0 Then about 15 seconds later we have:
>=20
> > f0da9c00 3255121946 S Bo:2:003:1 -115 31 =3D 55534243 3b010000 0010=
0000 80000a28 0000086a 88000008 00000000 000000
> > f0da9c00 3255122051 C Bo:2:003:1 0 31 >
> > f2938680 3255122332 S Bi:2:003:2 -115 4096 <
> > f2938680 3257419391 C Bi:2:003:2 -121 1037 =3D 20284143 31290000 53=
4d4152 5420436f 6d6d616e 64205472 616e7370 6f727420
> > f0da9c00 3257419502 S Bi:2:003:2 -115 13 <
> > f0da9c00 3285854403 C Bi:2:003:2 -104 0
>=20
> This is a READ(10) command for 8 blocks starting at block 551560.
> Obviously this originated from the dd program, which goes through the
> block layer and therefore tries to read an entire page at a time.=A0 =
The
> bridge transmitted only 1037 bytes out of the 4096 that were requeste=
d
> and then didn't send a status code.=A0 After 30 seconds of waiting fo=
r
> the status, the command was aborted.
>=20
> Interestingly, 1037 =3D 1024 + 13.=A0 The first two readable blocks a=
mount
> to 1024 bytes, and the status information is 13 bytes long.=A0 Howeve=
r
> the bridge neglected to separate the data from the status (it should
> have sent a zero-length packet in between), so to the computer it
> looked like 1037 bytes of data.=A0 Evidently this is another bug in t=
he
> bridge.
>=20
> > f44c7500 3285854464 S Co:2:002:0 s 23 03 0004 0003 0000 0
> > f44c7500 3285854636 C Co:2:002:0 0 0
> > f44c7500 3285865159 S Ci:2:002:0 s a3 00 0000 0003 0004 4 <
> > f44c7500 3285865408 C Ci:2:002:0 0 4 =3D 11050000
> > f44c7500 3285876152 S Ci:2:002:0 s a3 00 0000 0003 0004 4 <
> > f44c7500 3285876399 C Ci:2:002:0 0 4 =3D 03051000
> > f44c7500 3285927200 S Co:2:002:0 s 23 01 0014 0003 0000 0
> > f44c7500 3285927347 C Co:2:002:0 0 0
> > f44c7500 3285927420 S Ci:2:000:0 s 80 06 0100 0000 0040 64 <
> > f44c7500 3285927734 C Ci:2:000:0 0 18 =3D 12010002 00000040 7b06072=
5 00010102 0301
> > f44c7500 3285927770 S Co:2:002:0 s 23 03 0004 0003 0000 0
> > f44c7500 3285927824 C Co:2:002:0 0 0
> > f29aad00 3285938200 S Ci:2:002:0 s a3 00 0000 0003 0004 4 <
> > f29aad00 3285938354 C Ci:2:002:0 0 4 =3D 11050000
> > f29aad00 3285949217 S Ci:2:002:0 s a3 00 0000 0003 0004 4 <
> > f29aad00 3285949327 C Ci:2:002:0 0 4 =3D 03051000
> > f3c27500 3285971663 C Ii:2:002:1 0:2048 2 =3D 0800
> > f3c27500 3285971669 S Ii:2:002:1 -115:2048 2 <
> > f29aad00 3286000218 S Co:2:002:0 s 23 01 0014 0003 0000 0
> > f29aad00 3286000323 C Co:2:002:0 0 0
> > f29aad00 3286000420 S Co:2:000:0 s 00 05 0003 0000 0000 0
> > f29aad00 3286000642 C Co:2:000:0 0 0
> > f29aad00 3286012218 S Ci:2:003:0 s 80 06 0100 0000 0012 18 <
> > f29aad00 3286012661 C Ci:2:003:0 0 18 =3D 12010002 00000040 7b06072=
5 00010102 0301
> > f29aad00 3286012756 S Ci:2:003:0 s 80 06 0200 0000 0020 32 <
> > f29aad00 3286013239 C Ci:2:003:0 0 32 =3D 09022000 010100c0 3209040=
0 00020806 50000705 01020002 00070582 02000200
> > f29aad00 3286013339 S Ci:2:003:0 s 80 06 0303 0409 00ff 255 <
> > f29aad00 3286013609 C Ci:2:003:0 0 4 =3D 04033000
> > f29aad00 3286013711 S Co:2:003:0 s 00 09 0001 0000 0000 0
> > f29aad00 3286013984 C Co:2:003:0 0 0
>=20
> I'll skip the details; the above sequence shows the device being rese=
t
> (including having its address re-assigned).
>=20
> > f0da9c00 3286014115 S Bo:2:003:1 -115 31 =3D 55534243 3c010000 0000=
0000 00000600 00000000 00000000 00000000 000000
> > f0da9c00 3286014228 C Bo:2:003:1 0 31 >
> > f0da9c00 3286014430 S Bi:2:003:2 -115 13 <
> > f0da9c00 3286014598 C Bi:2:003:2 0 13 =3D 55534253 3c010000 0000000=
0 00
>=20
> This is another TEST UNIT READY command, sent to make sure the drive
> is ready to resume normal operation after being reset.=A0 It succeeds=
=2E
>=20
> > f0da9c00 3286017121 S Bo:2:003:1 -115 31 =3D 55534243 3d010000 0010=
0000 80000a28 0000086a 88000008 00000000 000000
> > f0da9c00 3286017234 C Bo:2:003:1 0 31 >
> > f29aad00 3286017446 S Bi:2:003:2 -115 4096 <
> > f29aad00 3316830429 C Bi:2:003:2 -104 0
>=20
> This is the same READ(10) command as before, retried.=A0 This time th=
e
> bridge didn't send any data at all before it stopped responding. Agai=
n,
> the command was aborted after 30 seconds of silence.
>=20
> > f29aad00 3316830529 S Co:2:002:0 s 23 03 0004 0003 0000 0
> > f29aad00 3316830658 C Co:2:002:0 0 0
> > f29aad00 3316841216 S Ci:2:002:0 s a3 00 0000 0003 0004 4 <
> > f29aad00 3316841405 C Ci:2:002:0 0 4 =3D 11050000
> > f29aad00 3316852213 S Ci:2:002:0 s a3 00 0000 0003 0004 4 <
> > f29aad00 3316852402 C Ci:2:002:0 0 4 =3D 03051000
> > f29aad00 3316903213 S Co:2:002:0 s 23 01 0014 0003 0000 0
> > f29aad00 3316903370 C Co:2:002:0 0 0
> > f29aad00 3316903471 S Ci:2:000:0 s 80 06 0100 0000 0040 64 <
> > f29aad00 3321903434 C Ci:2:000:0 -2 0
> > f29aad00 3321903529 S Ci:2:000:0 s 80 06 0100 0000 0040 64 <
> > f29aad00 3321908758 C Ci:2:000:0 -71 0
> > f29aad00 3321908930 S Ci:2:000:0 s 80 06 0100 0000 0040 64 <
> > f29aad00 3321912970 C Ci:2:000:0 -71 0
>=20
> The remainder of the trace is just like this, repeated over and over.
> It shows the device being reset but not responding at all.=A0 Evident=
ly
> at this point the bridge has crashed completely.
>=20
> Judging by this analysis, you tell me: Which component is at fault?=A0=
=20
> The driver did exactly as it was told, and it reset the device each
> time the bridge stopped responding.=A0 The bridge, on the other hand,
> displayed multiple bugs and eventually crashed completely.
>=20
> Alan Stern
>=20
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
