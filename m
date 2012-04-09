From: Norman Diamond <n0diamond@yahoo.co.jp>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was: ehci_hcd fails to read a single good block)
Date: Mon, 9 Apr 2012 11:07:56 +0900 (JST)
Message-ID: <137070.95048.qm@web100013.mail.kks.yahoo.co.jp>
References: <Pine.LNX.4.44L0.1204061213010.1392-100000@iolanthe.rowland.org>
Reply-To: n0diamond@yahoo.co.jp
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web100013.mail.kks.yahoo.co.jp ([114.111.98.187]:27872 "HELO
	web100013.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752845Ab2DICH7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 8 Apr 2012 22:07:59 -0400
In-Reply-To: <Pine.LNX.4.44L0.1204061213010.1392-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

Alan Stern wrote:
> On Fri, 6 Apr 2012, Norman Diamond wrote:
>> When sg_dd tries to read the bad block, it fails, but the bridge doe=
s not crash.
>>=20
>> When ordinary dd tries to read a Linux-length page of 8 blocks, the =
bridge crashes.
>>=20
>> I'm pretty sure Windows is reading a cluster of 4 blocks in the file=
 and the bridge crashes at that time.=A0 (The partition is a little und=
er 8MB, formatted FAT12, with clusters of 4 sectors.)
>=20
> What happens if you use sg_dd to try reading four or eight blocks inc=
luding the bad block?

If bpt=3D1 count=3D4 then sg_dd reads 2 good blocks, aborts on the bad =
block, and doesn't try the subsequent good block.  The bridge does not =
crash.

If bpt=3D4 count=3D4 then sg_dd aborts and reports that it didn't read =
anything.  The bridge crashes.  OK, this is good to know.

>> Nonetheless, trying to read a nonexistent sector after the last exis=
ting sector does not crash my bridge.=A0 sg_dd reports the error correc=
tly.=A0 Ordinary dd doesn't try to do the read because the sector addre=
ss is 2 past where Linux thinks the drive ends (which is 1 past where t=
he drive really ends).=A0 Existing non-defective blocks on the drive ca=
n still be accessed.=A0 The USB cable does not beed to be unplugged and=
 replugged.
>=20
> What happens if you use sg_dd to try reading four or eight blocks inc=
luding the first nonexistent block?

With bpt=3D4 count=3D4, sg_dd aborts and reports that it didn't read an=
ything (which is true this time).  The bridge DOES NOT CRASH.  However,=
 the good news kind of seems irrelevant.  I suggest that quirk processi=
ng should only try to read 1 block, the last block which is asserted to=
 exist, and decrement if the read fails due to non-existence.  If the r=
ead fails for a different reason then the block exists and the count sh=
ould not be decremented.

> By the way, Linux's SCSI disk driver no longer does this.=A0 It is mo=
re cautious; accesses near the end of a USB device are broken up into s=
ingle-block reads or writes.=A0 However at the time the quirk entry was=
 added, the driver wasn't so careful.

Which means that someone's bridge might have crashed due to a bad block=
 at or near the end of the drive.  Around a week ago I partitioned the =
first 95% of someone's hard drive for exactly that reason (I could have=
 continued and tried 99%, etc., but he said not to bother).

> If you want to see the discussion that led to the quirk being added, =
look here:
> =A0=A0=A0 http://marc.info/?l=3Dlinux-usb-users&m=3D110219110306073&w=
=3D2
> Unfortunately the critical message that had the logs attached never g=
ot into the mailing list archive.

He couldn't send the log because it was too big for Hotmail.  Microsoft=
 missed their chance  ^_^  After so much discussion of Windows losing d=
ata on hard drives, Microsoft should have gladly assisted a discussion =
of this Linux problem  ^_^

>> With a different bridge, a Linux driver hangs for a few minutes afte=
r trying to read the bad block.=A0 Then it resets the bridge, the reset=
 succeeds, and good blocks on the drive can still be accessed.=A0 Also =
with that different bridge, Linux knows the real size of the drive.
>=20
> The firmware on a lot of these bridges is pretty buggy.

OK.  However, the reset succeeded (after a delay).  More importantly, t=
he number of blocks was used accurately by Linux drivers.  You will hea=
r about this bridge again in a few minutes, in response to your other m=
essage.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
