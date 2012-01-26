From: Greg KH <greg@kroah.com>
Subject: Re: [v2] Re: [091/129] block: fail SCSI passthrough ioctls on
 partition devices
Date: Wed, 25 Jan 2012 16:07:49 -0800
Message-ID: <20120126000749.GC14281@kroah.com>
References: <20120124023932.023409422@clark.kroah.org>
 <1327423431-13965-1-git-send-email-pbonzini@redhat.com>
 <20120125223937.GA12516@kroah.com>
 <alpine.DEB.2.02.1201252348520.22090@aurora.sdinet.de>
 <CA+5PVA601fTyuTc66nvY_9pZPE5i5DkBkKpyL3-i=q9OxkoT+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40046 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750865Ab2AZAI7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jan 2012 19:08:59 -0500
Received: from compute5.internal (compute5.nyi.mail.srv.osa [10.202.2.45])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id F218C20594
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jan 2012 19:08:58 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <CA+5PVA601fTyuTc66nvY_9pZPE5i5DkBkKpyL3-i=q9OxkoT+g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Josh Boyer <jwboyer@gmail.com>
Cc: Sven-Haegar Koch <haegar@sdinet.de>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>

On Wed, Jan 25, 2012 at 06:10:47PM -0500, Josh Boyer wrote:
> On Wed, Jan 25, 2012 at 5:51 PM, Sven-Haegar Koch <haegar@sdinet.de> =
wrote:
> > On Wed, 25 Jan 2012, Greg KH wrote:
> >
> >> On Tue, Jan 24, 2012 at 05:43:50PM +0100, Paolo Bonzini wrote:
> >> > > You need to return -ENOTTY from scsi_verify_blk_ioctl and -ENO=
IOCTLCMD from
> >> > > sd_compat_ioctl, because -ENOIOCTLCMD will not be handled corr=
ectly by
> >> > > block/ioctl.c. =A0This would break BLKROSET and BLKFLSBUF done=
 by non-root
> >> > > but with the appropriate capabilities.
> >> > >
> >> > > Fixed patch follows. =A0If you prefer that I send an interdiff=
, let me know.
> >>
> >> Wait, why do you want the stable trees to diverge from what is in
> >> Linus's tree with regards to the error codes being returned?
> >>
> >> That doesn't seem safe, or sane.
> >>
> >> So for now, I'm going to follow what is in Linus's tree. =A0If you
> >> need/want the error codes to be different, then shouldn't it also =
be
> >> done there as well?
> >
> > May be because the stable trees do not have
> > 07d106d0a33d6063d2061305903deb02489eba20? "vfs: fix up ENOIOCTLCMD =
error
> > handling"?
>=20
> I believe that is the case, yes.  Linus was unhappy about ENOIOCTLCMD=
 vs.
> ENOTTY overall when the patch was first submitted, which lead to that=
 commit.
> The patches Paolo submitted for stable are the original versions that=
 apply
> directly to 3.2 and older.
>=20
> 07d106d0a isn't really stable material as it was put into 3.3 to catc=
h any odd
> fallout from the change.

Ok, thanks both of you, that makes more sense now.  I'll take Paolo's
updated patches and do a release now.

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
