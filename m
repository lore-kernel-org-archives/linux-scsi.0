From: Norman Diamond <n0diamond@yahoo.co.jp>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was: ehci_hcd fails to read a single good block)
Date: Thu, 29 Mar 2012 08:43:52 +0900 (JST)
Message-ID: <886259.81235.qm@web100012.mail.kks.yahoo.co.jp>
References: <Pine.LNX.4.44L0.1203281033520.1599-100000@iolanthe.rowland.org>
Reply-To: n0diamond@yahoo.co.jp
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web100012.mail.kks.yahoo.co.jp ([114.111.98.186]:41501 "HELO
	web100012.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758501Ab2C1Xnz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Mar 2012 19:43:55 -0400
In-Reply-To: <Pine.LNX.4.44L0.1203281033520.1599-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

Alan Stern wrote:
> On Wed, 28 Mar 2012, Norman Diamond wrote:
>=20
>> I don't want to manhandle that old notebook's fragile vendor proprie=
tary IDE cable again, but I'll try to find another way to test that dri=
ve again without going though USB.
>=20
> You don't have to worry about that.=A0 sg_dd works fine over USB.
>=20
>>> The USB-to-IDE bridge is vendor 067b, product 2507, Prolific Techno=
logy Inc., and usb-storage matches it for quirk 110.
>=20
> What is the bcdDevice value?

Is that different from 2507?

Now, if a combination of zeroing the readahead and proper user input of=
 an sg_dd command will succeed in reading a single valid block next doo=
r to the bad block, then it won't even be necessary to unplug and replu=
g the USB bridge.  That will be good news.

>>> Digression:  Someone adjusts the number of blocks from the reported=
 39070080 (which I think is correct) to 39070079 (which I think is wron=
g).  I'll have to install the drive in an old notebook to check if the =
reported number of blocks is really correct.
>>=20
>> Further on this digression:=A0 The number of blocks really is 390700=
80.=A0 Today libata made no adjustment and the number of blocks was cor=
rect.=A0 So some USB component makes a misadjustment to screw up the nu=
mber of blocks.
>=20
> usb-storage does this, because in the past Prolific's bridges have re=
ported the wrong number of blocks.=A0 In fact, I'm surprised that it se=
ems to work correctly with your drive.

It is hard to imagine a USB bridge adding 1 to the number of blocks.  D=
id that really happen?

Of course there are some USB bridges that f**k up the number of blocks =
differently, mapping each range of the drive's eight 512-byte sectors o=
nto one 4096-byte sector that the bridge presents to the host (coincide=
ntally the exact opposite of the mapping that modern SATA drives do int=
ernally in their firmware), and then proceeding further to conk out at =
the 2TB limit anyway so their f**king of the sector size and count acco=
mplishes no benefit while still causing their damage.  I can imagine a =
theoretical partial benefit to a Linux driver adjusting those sector si=
zes and counts by a factor of 8 in order to partly overcome some braind=
ead bridges.  But it's really hard to imagine a bridge adding 1 to a nu=
mber of blocks and benefiting by a driver subtracting 1.  (Maybe I'm ju=
st not imaginative enough.)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
