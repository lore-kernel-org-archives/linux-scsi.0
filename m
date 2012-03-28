From: Norman Diamond <n0diamond@yahoo.co.jp>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was: ehci_hcd fails to read a single good block)
Date: Wed, 28 Mar 2012 16:48:54 +0900 (JST)
Message-ID: <798989.59139.qm@web100013.mail.kks.yahoo.co.jp>
References: <1332919095.2869.2.camel@dabdike>
Reply-To: n0diamond@yahoo.co.jp
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web100013.mail.kks.yahoo.co.jp ([114.111.98.187]:35920 "HELO
	web100013.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755419Ab2C1Hs4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Mar 2012 03:48:56 -0400
In-Reply-To: <1332919095.2869.2.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Wed, 2012-03-28 at 13:14 +0900, Norman Diamond wrote:
>> I wrote:
>>> James Bottomley corrected one of the experts who corrected me yeste=
rday:
>>>>>> So, the problem is that sd_mod is turning your request for a sin=
gle block into a request for several blocks.
>>>>=20
>>>> No, it won't be this.=A0 Everything below block does exactly what =
block says.=A0 If readahead is the problem, then you need to turn it of=
f in block:
>>>> echo 0 > /sys/block/<dev>/queue/read_ahead_kb
>>>=20
>>> Thank you.=A0 But...
>>=20
>> But it didn't help.=A0 Today I put the disk internally in an old not=
ebook, and libata made it /dev/sda.
>> echo 0 >/sys/block/sda/queue/read_ahead_kb
>> but sg_dd still insisted on reading an entire page, so it refused to=
 read a good block that was too close to the bad block.
>=20
> This tells me you didn't read the man page on sg_dd.

Guilty as charged.  Sorry, for some reason I didn't imagine that its pa=
rameters would differ from dd.

> To get it to read a block at a time using SCSI commands, you need
> sg_dd blk_sgio=3D1 bs=3D512 bpt=3D1 <rest of the arguments>
> That says use SG_IO and read exactly one block per SCSI command

Thank you.

I don't want to manhandle that old notebook's fragile vendor proprietar=
y IDE cable again, but I'll try to find another way to test that drive =
again without going though USB.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
