From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was:
 ehci_hcd fails to read a single good block)
Date: Sun, 29 Apr 2012 11:15:42 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1204291052310.16623-100000@netrider.rowland.org>
References: <760201.32872.qm@web100018.mail.kks.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:34939 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752891Ab2D2PPn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Apr 2012 11:15:43 -0400
In-Reply-To: <760201.32872.qm@web100018.mail.kks.yahoo.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Norman Diamond <n0diamond@yahoo.co.jp>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, 28 Apr 2012, Norman Diamond wrote:

> That is not a fix for what really is my immediate problem, which is
> that my users can have any kind of bridge and any kind of disk, and
> in an emergency I can tell them to add a kernel boot parameter, or
> see if they can use a different bridge, etc., but it's really better
> if we can avoid such emergencies.

I have told you several times during this conversation: What you're=20
asking for is not completely feasible.  But maybe we can do better than=
=20
we are doing now.

> A preference for taking the device's word (in cases where we don't
> have a more reliable heuristic) is different from always taking the
> device's word (in all cases even when we have a more reliable
> heuristic).  CAPACITY_HEURISTICS will remain meaningful and will
> become more meaningful.

How could you tell whether the heuristic is more reliable than the
device?  The idea behind CAPACITY_HEURSTICS is that someone has already
considered the problem, and decided that the heuristic is more
reliable.  Otherwise the quirk entry would simply have no
capacity-related flag at all.

> > For example, consider all those cameras sold by Nikon, Pentax, and =
so
> > on.=A0 They probably all used Symbian's firmware, which some years =
ago=A0=20
> > had the capacity bug.=A0 Maybe the firmware has been fixed since th=
en; I
> > don't know.=A0 But under the reasonable assumption that the
> > SD/CF/whatever memories used in these cameras will always have an e=
ven=20
> > number of blocks, the existing CAPACITY_HEURISTICS solution is=20
> > appropriate.
>=20
> If you think that a revised CAPACITY_HEURISTICS incorporating my
> suggestion will become less appropriate than the existing
> CAPACITY_HEURISTICS then we need two separate heuristics, one for
> Symbian and similar, one for Prolific and similar.  And we even more
> surely do need TEST_CAPACITY.

The impression I get is that you want two different heuristics: one
that aims for an even number of blocks, and one that aims for a number
divisible by 63.  All devices known to be USB-(S)ATA bridges could use=20
the second heuristic.  Maybe that's what you meant.

As for whether we need TEST_CAPACITY...  That is still highly
debatable.  If we did have it, which quirk entries would use it?  So
far the only candidate we have is your Prolific bridge, and even there
it seems that the divisible-by-63 heuristic would work just as well.

> > You know that for decades, ATA disks have reported capacities that =
were
> > multiples of 63.=A0 So if a drive reports a capacity that is 5 larg=
er
> > than a multiple of 63, why would you want to decrement the value?
>=20
> Where a report is 5 larger than a multiple of 63, I left the existing
> heuristic intact.  I suggested only modifying the heuristic to avoid
> decrementing from exact multiples of 63.

Okay, now I understand.  This still has the problem that it is likely
to be wrong for flash drives, again suggesting that a separate
heuristic is appropriate.

> > Also, the amount of effort required to write the TEST_CAPACITY code=
 and=20
> > get it accepted into the kernel would be non-trivial.=A0 I prefer n=
ot to=20
> > do it unless it turns out to be clearly necessary.
>=20
> I think it is clearly necessary.  In the meantime a revised heuristic
> will help a lot.
>=20
> By the way, I will not be the primary beneficiary of these revisions.=
 =20
> The primary beneficiaries will be owners of bridges and devices that
> you and I have learned to dislike, but we have to live with them.

I have no objection to that, provided it doesn't cause increased
problems for other people.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
