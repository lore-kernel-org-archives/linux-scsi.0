From: Norman Diamond <n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was: ehci_hcd fails to read a single good block)
Date: Tue, 27 Mar 2012 17:48:39 +0900 (JST)
Message-ID: <245059.32791.qm@web100011.mail.kks.yahoo.co.jp>
References: <1332834045.2883.13.camel@dabdike>
Reply-To: n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332834045.2883.13.camel@dabdike>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

James Bottomley corrected one of the experts who corrected me yesterday=
:
>>> So, the problem is that sd_mod is turning your request for a single=
 block into a request for several blocks.
>=20
> No, it won't be this.=A0 Everything below block does exactly what blo=
ck says.=A0 If readahead is the problem, then you need to turn it off i=
n block:
> echo 0 > /sys/block/<dev>/queue/read_ahead_kb

Thank you.  But...

James Bottomley corrected me too.
>> I originally wrote (blaming the wrong component):
>>>> dd if=3D/dev/sdb of=3D/dev/zero bs=3D512 count=3D1 skip=3D551563
>>>> should succeed because block 551563 has no problem.=A0 But it fail=
s because ehci_hcd insists on reading blocks 551560 through 551567, and=
 block 551562 does have a problem.  (Of course I should have been outpu=
tting to /dev/null instead of /dev/zero but that should not matter.)
>
> this is not fixable using dd which goes through the page cache (and t=
hus had a minimum read of a page at a time). If you want exact 512 byte=
 sector reads, use sg_dd instead.

Then writing a 0 to /sys/block/sdb/queue/read_ahead_kb is useless in th=
is particular case, right?  But it might be useful in further testing, =
because of more oddities.

The USB-to-IDE bridge is vendor 067b, product 2507, Prolific Technology=
 Inc., and usb-storage matches it for quirk 110.

Digression:  Someone adjusts the number of blocks from the reported 390=
70080 (which I think is correct) to 39070079 (which I think is wrong). =
 I'll have to install the drive in an old notebook to check if the repo=
rted number of blocks is really correct.

Today I created a FAT12 partition in approximately 8 megabytes surround=
ing known bad block number 551562.

Windows XP could write a bunch of files to fill the partition (0 blocks=
 free).  Windows XP could copy all the files from the partition to a di=
rectory on an internal SATA drive.  I guess there is some amount of luc=
k that the bad block is not in use in any of the files, despite there b=
eing 0 blocks free.

Linux (cp -pr) could not copy all the files from the partition to a dir=
ectory on an internal SATA drive.  Even when it should only copy blocks=
 near the bad block, it stubbornly tried to readahead the bad block and=
 it bombed out.  I had to unplug and replug the USB cable to read the d=
rive again.

Back to Windows XP.  When I told it to run CHKDSK and try to verify eve=
ry block, then it bombed out.  I had to unplug and replug the USB cable=
=2E  Again, just copying the files, they all copied.

So the need to unplug and replug seems to be the bridge's fault.

I think readahead is not a bad thing to do, and I can see why it is too=
 late for Linux to recover after getting the error from trying to read =
ahead.  But I'm sure I've seen Windows XP do readahead too.  How come W=
indows XP survived where Linux didn't?
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
