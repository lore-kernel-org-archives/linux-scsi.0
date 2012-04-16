From: Norman Diamond <n0diamond@yahoo.co.jp>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was: ehci_hcd fails to read a single good block)
Date: Tue, 17 Apr 2012 07:41:42 +0900 (JST)
Message-ID: <385068.36090.qm@web100007.mail.kks.yahoo.co.jp>
References: <Pine.LNX.4.44L0.1204161103080.1408-100000@iolanthe.rowland.org>
Reply-To: n0diamond@yahoo.co.jp
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web100007.mail.kks.yahoo.co.jp ([114.111.98.181]:29705 "HELO
	web100007.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753336Ab2DPWlo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Apr 2012 18:41:44 -0400
In-Reply-To: <Pine.LNX.4.44L0.1204161103080.1408-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

Alan Stern wrote:
> On Mon, 16 Apr 2012, Norman Diamond wrote:
>> Alan Stern wrote:
>>> On Fri, 13 Apr 2012, Norman Diamond wrote:
>>>> You THOUGHT you knew in advance that a particular bridge is known =
to have the overreporting but, where in fact in some secret revisions i=
t doesn't and in some secret revisions we're not quite sure, missing a =
log and missing a test sample for further testing.  How can we be sure =
that other bridge manufacturers don't also make secret revisions?
>>>=20
>>> In fact we don't know.  But that's not a good enough reason to risk=
 breaking existing systems.  When we encounter bridges whose behavior h=
as changed, we can update the quirk entries.
>>=20
>> That's not a good enough reason to cause known breakage in newer exi=
sting systems, but I agree that updating the quirk entries helps solve =
it.
>>=20
>>> (Even that isn't as cautious as I'd like.  If the device behavior h=
as changed then maybe the old devices won't handle reading beyond the e=
nd of the drive.  But I can't think of anything safer.)
>>=20
>> Well, if the reported capacity isn't a multiple of 63 and if no exis=
ting partition includes the last reported block then it seems comparati=
vely safe to decrement the reported size, but as you pointed out, we ca=
n't really be sure what the existing partitions are (non-DOS tables etc=
=2E).=A0 But a multiple of 63 still seems like a relatively safe heuris=
tic, comparatively speaking.=A0 But not always, as you pointed out, and=
 as I'll detail below.
>=20
> At this point I'm not sure what you want to do.=A0 Would you like the=
 quirks entry for your bridge changed to CAPACITY_HEURISTICS instead of=
 FIX_CAPACITY?=A0 That's the easiest thing to do quickly.

Come on, the purpose of our discussion should be to figure out what is =
best to do, not what I want.  I agree that an easy quick change looks l=
ike it will help a bit, but we should still figure out the best change =
too.

Yes it does look like changing this bridge to CAPACITY_HEURISTICS from =
=46IX_CAPACITY is likely to help a bit.

I think that heuristics should also accept multiples of 63 even if the =
total is odd.  This doesn't solve everything but will probably help mor=
e.

I think that handling of FIX_CAPACITY should check for multiples of 63 =
and report the apparent likelihood that FIX_CAPACITY probably wasn't th=
e right setting for the bridge (if it's a bridge).  This doesn't solve =
everything but will probably help more.

The addition of TEST_CAPACITY doesn't solve everything but will probabl=
y help more.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
