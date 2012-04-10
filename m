From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was:
 ehci_hcd fails to read a single good block)
Date: Tue, 10 Apr 2012 10:31:32 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1204101024420.1605-100000@iolanthe.rowland.org>
References: <595777.3176.qm@web100001.mail.kks.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:35545 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755311Ab2DJObe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Apr 2012 10:31:34 -0400
In-Reply-To: <595777.3176.qm@web100001.mail.kks.yahoo.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Norman Diamond <n0diamond@yahoo.co.jp>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 10 Apr 2012, Norman Diamond wrote:

> Alan Stern wrote:
> > On Mon, 9 Apr 2012, Norman Diamond wrote:
> >> I suggest that quirk processing should only try to read 1 block, t=
he last block which is asserted to exist, and decrement if the read fai=
ls due to non-existence.=A0 If the read fails for a different reason th=
en the block exists and the count should not be decremented.
> >=20
> > I have tried to explain before that this is a very bad idea.=A0 Bri=
dges that crash when attempting to read beyond the end of the device wo=
uld become totally unusable.
>=20
> In cases where a bridge has been observed to crash when trying to rea=
d a SINGLE block which the bridge asserted to exist but which didn't ac=
tually exist, I agree that an aggressive quirk is needed.
>=20
> In cases where a bridge has been observed to crash when trying to rea=
d MULTIPLE blocks among which one block had a problem, there is no evid=
ence yet to judge that my idea is very bad.  Those bridges need to be t=
ested again with single block reads, and need to be tested on reading t=
he last block number which the bridge asserts to exist rather than atte=
mpting to read an existing bad block (by coincidence the two might be t=
he same block, but not usually).

It sounds like you are suggesting that we have a new quirk, something=20
like TEST_CAPACITY.  When this quirk is present, we could attempt to=20
read the last block when the drive (or media) is first detected,=20
thereby determining whether the reported capacity needs to be adjusted.

The existing FIX_CAPACITY and CAPACITY_HEURISTICS quirk entries could
be changed to TEST_CAPACITY as people report the results of their
testing.  However this would be a very slow process.

Is that what you want?

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
