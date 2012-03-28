From: Norman Diamond <n0diamond@yahoo.co.jp>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was: ehci_hcd fails to read a single good block)
Date: Wed, 28 Mar 2012 13:14:45 +0900 (JST)
Message-ID: <102582.72180.qm@web100001.mail.kks.yahoo.co.jp>
Reply-To: n0diamond@yahoo.co.jp
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web100001.mail.kks.yahoo.co.jp ([114.111.98.175]:30372 "HELO
	web100001.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750761Ab2C1EOr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Mar 2012 00:14:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

I wrote:
> James Bottomley corrected one of the experts who corrected me yesterd=
ay:
>>>> So, the problem is that sd_mod is turning your request for a singl=
e block into a request for several blocks.
>>=20
>> No, it won't be this.=A0 Everything below block does exactly what bl=
ock says.=A0 If readahead is the problem, then you need to turn it off =
in block:
>> echo 0 > /sys/block/<dev>/queue/read_ahead_kb
>=20
> Thank you.=A0 But...

But it didn't help.  Today I put the disk internally in an old notebook=
, and libata made it /dev/sda.
echo 0 >/sys/block/sda/queue/read_ahead_kb
but sg_dd still insisted on reading an entire page, so it refused to re=
ad a good block that was too close to the bad block.

> James Bottomley corrected me too.
>>> I originally wrote (blaming the wrong component):
>>>>> dd if=3D/dev/sdb of=3D/dev/zero bs=3D512 count=3D1 skip=3D551563
>>>>> should succeed because block 551563 has no problem.=A0 But it fai=
ls because ehci_hcd insists on reading blocks 551560 through 551567, an=
d block 551562 does have a problem.=A0 (Of course I should have been ou=
tputting to /dev/null instead of /dev/zero but that should not matter.)
>>
>> this is not fixable using dd which goes through the page cache (and =
thus had a minimum read of a page at a time). If you want exact 512 byt=
e sector reads, use sg_dd instead.
>=20
> Then writing a 0 to /sys/block/sdb/queue/read_ahead_kb is useless in =
this particular case, right?=A0 But it might be useful in further testi=
ng, because of more oddities.

It was even more useless than expected because sg_dd failed the same wa=
y as dd.

It is really really bad that sg_dd could not overcome this.  Some years=
 ago linux-ide and libata were fixed.  When readahead failed, they knew=
 that data were not available for the nearby bad block, but the good bl=
ock could be read.  I don't know when the fix got unfixed.  This is a s=
how stopper for forensics.  I don't get to do forensics myself, but I h=
ave to be aware of it, and the inability to read a good block just beca=
use a bad block is next door is not acceptable.

It is really really bad when Windows XP can read it but Linux can't.  (=
Details below.)

> The USB-to-IDE bridge is vendor 067b, product 2507, Prolific Technolo=
gy Inc., and usb-storage matches it for quirk 110.

It does appear to be the bridge's fault that the USB cable needed unplu=
gging and replugging.  When the drive is internal and connected to an o=
ld Intel ATA controller, the drive did not need unplugging and repluggi=
ng.

> Digression:=A0 Someone adjusts the number of blocks from the reported=
 39070080 (which I think is correct) to 39070079 (which I think is wron=
g).=A0 I'll have to install the drive in an old notebook to check if th=
e reported number of blocks is really correct.

=46urther on this digression:  The number of blocks really is 39070080.=
  Today libata made no adjustment and the number of blocks was correct.=
  So some USB component makes a misadjustment to screw up the number of=
 blocks.


(Quoting details from yesterday, because of the importance to forensics=
 and mentioned above.)
>
> Today I created a FAT12 partition in approximately 8 megabytes surrou=
nding known bad block number 551562.
>=20
> Windows XP could write a bunch of files to fill the partition (0 bloc=
ks free).=A0 Windows XP could copy all the files from the partition to =
a directory on an internal SATA drive.=A0 I guess there is some amount =
of luck that the bad block is not in use in any of the files, despite t=
here being 0 blocks free.
>=20
> Linux (cp -pr) could not copy all the files from the partition to a d=
irectory on an internal SATA drive.=A0 Even when it should only copy bl=
ocks near the bad block, it stubbornly tried to readahead the bad block=
 and it bombed out.=A0 I had to unplug and replug the USB cable to read=
 the drive again.
>=20
> Back to Windows XP.=A0 When I told it to run CHKDSK and try to verify=
 every block, then it bombed out.=A0 I had to unplug and replug the USB=
 cable.=A0 Again, just copying the files, they all copied.
>=20
> So the need to unplug and replug seems to be the bridge's fault.
>=20
> I think readahead is not a bad thing to do, and I can see why it is t=
oo late for Linux to recover after getting the error from trying to rea=
d ahead.=A0 But I'm sure I've seen Windows XP do readahead too.=A0 How =
come Windows XP survived where Linux didn't?=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
