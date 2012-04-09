From: Norman Diamond <n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was: ehci_hcd fails to read a single good block)
Date: Tue, 10 Apr 2012 07:00:35 +0900 (JST)
Message-ID: <595777.3176.qm@web100001.mail.kks.yahoo.co.jp>
References: <Pine.LNX.4.44L0.1204091014220.1429-100000@iolanthe.rowland.org>
Reply-To: n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1204091014220.1429-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Alan Stern wrote:
> On Mon, 9 Apr 2012, Norman Diamond wrote:
>> I suggest that quirk processing should only try to read 1 block, the=
 last block which is asserted to exist, and decrement if the read fails=
 due to non-existence.=A0 If the read fails for a different reason then=
 the block exists and the count should not be decremented.
>=20
> I have tried to explain before that this is a very bad idea.=A0 Bridg=
es that crash when attempting to read beyond the end of the device woul=
d become totally unusable.

In cases where a bridge has been observed to crash when trying to read =
a SINGLE block which the bridge asserted to exist but which didn't actu=
ally exist, I agree that an aggressive quirk is needed.

In cases where a bridge has been observed to crash when trying to read =
MULTIPLE blocks among which one block had a problem, there is no eviden=
ce yet to judge that my idea is very bad.  Those bridges need to be tes=
ted again with single block reads, and need to be tested on reading the=
 last block number which the bridge asserts to exist rather than attemp=
ting to read an existing bad block (by coincidence the two might be the=
 same block, but not usually).

>>> By the way, Linux's SCSI disk driver no longer does this.  It is mo=
re cautious; accesses near the end of a USB device are broken up into s=
ingle-block reads or writes.  However at the time the quirk entry was a=
dded, the driver wasn't so careful.
>>=20
>> Which means that someone's bridge might have crashed due to a bad bl=
ock at or near the end of the drive.
>=20
> More likely the bridge crashed because it was unable to handle a mult=
iple-block read whereas it could have handled a single-block read.

My intuition agrees with your comparison of the probabilities.

Now I think we agree that the existing handling of quirks is too aggres=
sive for some bridges.

> Regardless, we are now stuck.=A0 We don't dare remove the existing qu=
irk entries because of the potential for breaking systems that currentl=
y work.=A0 If you can suggest a way of detecting whether or not the cap=
acity value is correct that will not break any existing systems, I woul=
d be extremely glad to hear it.

We do know that the existing handling is broken because Linux did trunc=
ate my NTFS partition yesterday.  Linux reported that it was truncating=
, and although each driver didn't know what the reason was, you and I k=
now the reason:  one driver truncated the drive and the next driver saw=
 a partition structure extending past the truncated drive so it truncat=
ed the partition.

I suggest further testing to see which quirks can be handled less aggre=
ssively.  For example with newer instances of firmware 1.00 of the Prol=
ific chip, we know that we can try to do a single block read of the las=
t block that the chip asserts to exist, so we can test whether that blo=
ck really exists (and remember not to count it out if it exists but has=
 media errors).  With older instances of firmware 1.00 of the same Prol=
ific chip, we don't know for sure, but we do know that previous testing=
 wasn't adequate.  In cases where chips and volunteers are available, s=
g_dd provides pretty quick testing.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
