From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] cmdfilter: extend default read filter
Date: Thu, 26 Jun 2008 19:43:31 +0200
Message-ID: <20080626174331.GF20851@kernel.dk>
References: <6cf6b73e0806260853v2c8fb475u2a53bcdf20b8ae70@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:18492 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbYFZRne (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jun 2008 13:43:34 -0400
Content-Disposition: inline
In-Reply-To: <6cf6b73e0806260853v2c8fb475u2a53bcdf20b8ae70@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adel Gadllah <adel.gadllah@gmail.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, pjones@redhat.com, dgilbert@interlog.com, matthew@wil.cx, linux-scsi@vger.kernel.org

On Thu, Jun 26 2008, Adel Gadllah wrote:
> 2008/6/26 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>:
> > On Fri, 27 Jun 2008 00:08:46 +0900
> > FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> >
> >> On Thu, 26 Jun 2008 17:05:50 +0200
> >> "Adel Gadllah" <adel.gadllah@gmail.com> wrote:
> >>
> >> > 2008/6/26 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>:
> >> > > On Thu, 26 Jun 2008 12:10:25 +0200
> >> > > "Adel Gadllah" <adel.gadllah@gmail.com> wrote:
> >> > >
> >> > >> 2008/6/18 Peter Jones <pjones@redhat.com>:
> >> > >> > Douglas Gilbert wrote:
> >> > >> >>
> >> > >> >> Peter Jones wrote:
> >> > >> >>>
> >> > >> >>> FUJITA Tomonori wrote:
> >> > >> >>>
> >> > >> >>>> Well, this changes sg behaviour since sg's allow_ops filter has a
> >> > >> >>>> access permission different from blk_verify_command filter's.
> >> > >> >>>
> >> > >> >>>  >
> >> > >> >>>>
> >> > >> >>>> I guess that the first thing you need to do is that figuring out a
> >> > >> >>>> proper access permission for each command, which sg maintainer, etc
> >> > >> >>>> can agree. It's pretty hard and that's the reason why this patch has
> >> > >> >>>> not been merged for years, I think.
> >> > >> >>>
> >> > >> >>> I don't think this logic is sound.
> >> > >> >>
> >> > >> >> That depends on your viewpoint.
> >> > >> >
> >> > >> > My viewpoint is this:
> >> > >> >
> >> > >> > 1) Whether you agree with his reasons or not, Linus made it pretty clear
> >> > >> > that he's against removing the command filter (see
> >> > >> > http://marc.info/?l=linux-scsi&m=115419945212450&w=2 )
> >> > >> > 2) Having different code paths use different filtering code just adds more
> >> > >> > confusion.
> >> > >> > 3) If we're going to have filtering, it should be configurable on a
> >> > >> > per-device basis from userland.
> >> > >> >
> >> > >> > Which of these do you disagree with?
> >> > >> >
> >> > >> > [...]
> >> > >> >>
> >> > >> >> Are per device command filters being proposed?
> >> > >> >
> >> > >> > Yes, that's what the patch implements.  And it allows the userland to
> >> > >> > configure them according to the needs of the hardware.
> >> > >>
> >> > >> Jens can we add merge this for .27 or does anyone still has objections?
> >> > >
> >> > > I think that this patch makes sg's permission stricter. So this could
> >> > > break the existing user-space applications.
> >> > >
> >> >
> >> > any particular app in mind?
> >>
> >> No, but there would be some.
> >>
> >>
> >> > for write access it still allows all commands (because there are some
> >> > userspace apps tha rely on this).
> >>
> >> Yeah, I know. But for read access, some commands will be blocked.
> >
> > I think that it's not a good idea to say "this patch could break
> > something but we have no idea about them. So we can merge this."
> >
> > It's better to loosen scsi_ioctl's permissions to match with sg's
> > permission.
> 
> agreed.
> 
> Jens please apply the attached patch on top of the old one.

Thanks, I thought this had already been worked out when I saw the
previous discussion. Please verify that this patch then no longer causes
ANY different behaviour than what we already have, that's a prerequisite
for merging it.

I've applied this patch.

-- 
Jens Axboe

