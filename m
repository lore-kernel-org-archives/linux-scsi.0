From: Norman Diamond <n0diamond@yahoo.co.jp>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was: ehci_hcd fails to read a single good block)
Date: Wed, 18 Apr 2012 07:54:47 +0900 (JST)
Message-ID: <545679.82050.qm@web100009.mail.kks.yahoo.co.jp>
References: <Pine.LNX.4.44L0.1204171114460.1364-100000@iolanthe.rowland.org>
Reply-To: n0diamond@yahoo.co.jp
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web100009.mail.kks.yahoo.co.jp ([114.111.98.183]:38226 "HELO
	web100009.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751519Ab2DQWyt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Apr 2012 18:54:49 -0400
In-Reply-To: <Pine.LNX.4.44L0.1204171114460.1364-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

Alan Stern wrote:
> On Tue, 17 Apr 2012, Norman Diamond wrote:
>> Yes it does look like changing this bridge to CAPACITY_HEURISTICS fr=
om FIX_CAPACITY is likely to help a bit.
>=20
> That's easy enough.

Yeah I know, even I could do that one  ^_^

>> I think that heuristics should also accept multiples of 63 even if t=
he total is odd.=A0 This doesn't solve everything but will probably hel=
p more.
>=20
> Okay, if nobody objects.

I'm nobody and I don't object  ^_^
(Of course we have to wait to see if anyone knows a real reason that th=
is would be a problem.)

>> I think that handling of FIX_CAPACITY should check for multiples of =
63 and report the apparent likelihood that FIX_CAPACITY probably wasn't=
 the right setting for the bridge (if it's a bridge).=A0 This doesn't s=
olve everything but will probably help more.
>=20
> The FIX_CAPACITY code runs in a different module.=A0 It has no way to=
 know whether the device is a bridge or not.

The quirks table could be made available, but values stored in the tabl=
e don't say if the device is a bridge.  OK, then I still think this:  I=
 think that handling of FIX_CAPACITY should check for multiples of 63 a=
nd report the apparent likelihood that FIX_CAPACITY probably wasn't the=
 right setting for the device.

In addition, I have a feeling that if a device has FIX_CAPACITY but the=
 number of reported blocks is even then I doubt the accuracy of FIX_CAP=
ACITY.  The reason is that flash memory devices tend to have physical s=
ectors that are even multiples of logical sectors.

I do think the handling of FIX_CAPACITY should report when devices repo=
rt capacities that are either multiples of 63 or 2 (or both), so that f=
urther testing can be done.  The existing code to do the decrement anyw=
ay can remain the same until further testing is done.

>> The addition of TEST_CAPACITY doesn't solve everything but will prob=
ably help more.
>=20
> That will require a certain amount of work, with the possibility of b=
reaking some systems.=A0 I'd rather not do it if there's no clear and p=
ressing need.

Two indistinguishable versions of the Prolific bridge show that there i=
s a need.  One version needs the decrement (probably) and the other ver=
sion doesn't (definitely).
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
