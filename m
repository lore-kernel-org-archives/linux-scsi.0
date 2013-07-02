From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCHv2 0/7] Limit overall SCSI EH runtime
Date: Tue, 2 Jul 2013 06:37:05 +0000
Message-ID: <1372747024.2385.71.camel@dabdike>
References: <1372661455-122384-1-git-send-email-hare@suse.de>
	 <20130701174423.GA10645@logfs.org> <1372706605.2385.37.camel@dabdike>
	 <20130701205546.GB10645@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:36348 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139Ab3GBGhI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jul 2013 02:37:08 -0400
In-Reply-To: <20130701205546.GB10645@logfs.org>
Content-Language: en-US
Content-ID: <C0CD7C146770CC4A8917F3367F2E6EED@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Bart van Assche <bvanassche@acm.org>

On Mon, 2013-07-01 at 16:55 -0400, J=F6rn Engel wrote:
> On Mon, 1 July 2013 19:23:25 +0000, James Bottomley wrote:
> > On Mon, 2013-07-01 at 13:44 -0400, J=F6rn Engel wrote:
> > > If a single device is bad, don't ever do a host
> > > reset.
> >=20
> > This isn't a tenable position.  Sometimes a device looks bad becaus=
e the
> > host state for it has gone insane.  At that point, the only safe ac=
tion
> > is a reset of the host to sane state.
> >=20
> > I could be persuaded that you should never do the transport equival=
ent
> > of a bus reset (on non-SPI transports, at least), which is actually=
 hard
> > to do on some of the modern transports, but I don't think you can g=
et
> > away without having a host reset in the eh arsenal.
>=20
> Fair enough.  Hardware being hardware and hardware bugs being hard to
> fix, I see your point.
>=20
> However, we shouldn't screw the poor user who has paid a premium for =
a
> second HBA to get some redundancy and reset both of them at the same
> time.  That would, you know, defeat the redundancy. ;)

I don't understand what you're getting at.  In a dual HBA situation,
whether the second HBA is implicated or not depends on configuration an=
d
what the first HBA is doing. If it's just passively lost device state,
then the second HBA should continue just fine.  If the insane HBA is
injecting rogue data on the bus then, in a properly isolated
configuration, it shouldn't be able to affect the second HBA, but if
there's some leak and it does, chances are error handling will occur on
both simultaneously.  I don't see any way to avoid this other than
having the user buy better hardware and properly configure it.

James

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
