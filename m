From: Norman Diamond <n0diamond@yahoo.co.jp>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was: ehci_hcd fails to read a single good block)
Date: Mon, 30 Apr 2012 11:25:14 +0900 (JST)
Message-ID: <518968.75200.qm@web100005.mail.kks.yahoo.co.jp>
References: <Pine.LNX.4.44L0.1204291052310.16623-100000@netrider.rowland.org>
Reply-To: n0diamond@yahoo.co.jp
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web100005.mail.kks.yahoo.co.jp ([114.111.98.179]:38887 "HELO
	web100005.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754787Ab2D3CZR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Apr 2012 22:25:17 -0400
In-Reply-To: <Pine.LNX.4.44L0.1204291052310.16623-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

Alan Stern wrote:
> On Sat, 28 Apr 2012, Norman Diamond wrote:
>> That is not a fix for what really is my immediate problem, which is
>> that my users can have any kind of bridge and any kind of disk, and
>> in an emergency I can tell them to add a kernel boot parameter, or
>> see if they can use a different bridge, etc., but it's really better
>> if we can avoid such emergencies.
>=20
> I have told you several times during this conversation: What you're=20
> asking for is not completely feasible.=A0 But maybe we can do better =
than=20
> we are doing now.

Right, but in your statement where you quoted my rebuttal you started w=
ith "Look..." and claimed that you were fixing my immediate problem.  I=
 trust that you usually do try to make better general solutions and it =
was probably a lapse that you went off on that tangent, but it looked l=
ike a reminder might be useful.

>> A preference for taking the device's word (in cases where we don't
>> have a more reliable heuristic) is different from always taking the
>> device's word (in all cases even when we have a more reliable
>> heuristic).=A0 CAPACITY_HEURISTICS will remain meaningful and will
>> become more meaningful.
>=20
> How could you tell whether the heuristic is more reliable than the
> device?=A0 The idea behind CAPACITY_HEURSTICS is that someone has alr=
eady
> considered the problem, and decided that the heuristic is more
> reliable.=A0 Otherwise the quirk entry would simply have no
> capacity-related flag at all.

The intended meaning behind CAPACITY_HEURISTICS is that someone already=
 saw some degree of ambiguity in one device.  In our discussion we have=
 learned that more devices have ambiguities and we've been trying (at l=
east sometimes) to improve the heuristic.

The existing heuristic, as invented for one device, prefers to believe =
the device when the device reports an even number and to disbelieve the=
 device when the device reports on odd number.

My proposal, a modification for one other device which might also help =
some other incompletely known devices, prefers to believe the device wh=
en the device reports either an even number (as at present) or a multip=
le of 63 (for a reason which I think is obvious) and to disbelieve the =
device when the device reports a number which is neither.

Your proposed patch implied a proposal different from mine.

My proposed modification to your proposed patch would implement my prop=
osal.  (But I made a typo in one version, and later corrected it.)

You asked why.  I answered.  Now we're going around in circles.

> The impression I get is that you want two different heuristics: one
> that aims for an even number of blocks, and one that aims for a numbe=
r
> divisible by 63.=A0 All devices known to be USB-(S)ATA bridges could =
use=20
> the second heuristic.=A0 Maybe that's what you meant.

Here you are modifying my proposal.  It is no problem to discuss your i=
dea.  At first I thought your idea was better than mine, but on second =
thought, sorry, here's a problem.  Again it is because the broken and u=
nbroken Prolific bridges are indistinguishable.  A Prolific bridge coul=
d be connected to a drive whose actual usable capacity is a multiple of=
 63, or it could be connected to a modern drive with emulated capacity =
that is even (in fact a multiple of 8) and not usually a multiple of 63=
=2E

Therefore I still favour my version.  If the bridge reports an even num=
ber then I want to believe it, if the bridge reports a multiple of 63 t=
hen I want to believe it, and if neither then I want to fall back on th=
e existing heuristic which performs a decrement.

> As for whether we need TEST_CAPACITY...=A0 That is still highly
> debatable.=A0 If we did have it, which quirk entries would use it?=A0=
 So
> far the only candidate we have is your Prolific bridge, and even ther=
e
> it seems that the divisible-by-63 heuristic would work just as well.

I wish I could get a broken Prolific bridge to test together with mine.=
  Anyway the divisible-by-63 heuristic would work better than the exist=
ing heuristic but it would not work as well as TEST_CAPACITY.  My propo=
sed modified heursitic would usually work better than the existing heur=
istic but not as well as TEST_CAPACITY.

By the way, a while back you asked what happens if I use sg_dd to try r=
eading multiple blocks including the last existing block and some non-e=
xisting ones.  The answer seems to depend on the drive as well as the m=
ethod of connection (USB-to-PATA vs. eSATA plus SATA-to-PATA).  With th=
e drive that I've usually been using I think the drive hangs so we can'=
t really figure out whether to blame the bridge.  With a different driv=
e the drive reports the error but sg_dd and Linux drivers do something =
to retry so many times that after 30 minutes I lost patience waiting fo=
r sg_dd to finish and report its error.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
