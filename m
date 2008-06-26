From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH/RFC v3] allow userspace to modify scsi command filter
 on per device basis
Date: Fri, 27 Jun 2008 00:08:46 +0900
Message-ID: <20080627000846K.fujita.tomonori@lab.ntt.co.jp>
References: <6cf6b73e0806260310n5988b59dycb0aeab3b0f5c930@mail.gmail.com>
	<20080626233633E.fujita.tomonori@lab.ntt.co.jp>
	<6cf6b73e0806260805t10f22898idb7c7276c2a51480@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:43927 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbYFZPLl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jun 2008 11:11:41 -0400
In-Reply-To: <6cf6b73e0806260805t10f22898idb7c7276c2a51480@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adel.gadllah@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, pjones@redhat.com, dgilbert@interlog.com, matthew@wil.cx, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

On Thu, 26 Jun 2008 17:05:50 +0200
"Adel Gadllah" <adel.gadllah@gmail.com> wrote:

> 2008/6/26 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>:
> > On Thu, 26 Jun 2008 12:10:25 +0200
> > "Adel Gadllah" <adel.gadllah@gmail.com> wrote:
> >
> >> 2008/6/18 Peter Jones <pjones@redhat.com>:
> >> > Douglas Gilbert wrote:
> >> >>
> >> >> Peter Jones wrote:
> >> >>>
> >> >>> FUJITA Tomonori wrote:
> >> >>>
> >> >>>> Well, this changes sg behaviour since sg's allow_ops filter has a
> >> >>>> access permission different from blk_verify_command filter's.
> >> >>>
> >> >>>  >
> >> >>>>
> >> >>>> I guess that the first thing you need to do is that figuring out a
> >> >>>> proper access permission for each command, which sg maintainer, etc
> >> >>>> can agree. It's pretty hard and that's the reason why this patch has
> >> >>>> not been merged for years, I think.
> >> >>>
> >> >>> I don't think this logic is sound.
> >> >>
> >> >> That depends on your viewpoint.
> >> >
> >> > My viewpoint is this:
> >> >
> >> > 1) Whether you agree with his reasons or not, Linus made it pretty clear
> >> > that he's against removing the command filter (see
> >> > http://marc.info/?l=linux-scsi&m=115419945212450&w=2 )
> >> > 2) Having different code paths use different filtering code just adds more
> >> > confusion.
> >> > 3) If we're going to have filtering, it should be configurable on a
> >> > per-device basis from userland.
> >> >
> >> > Which of these do you disagree with?
> >> >
> >> > [...]
> >> >>
> >> >> Are per device command filters being proposed?
> >> >
> >> > Yes, that's what the patch implements.  And it allows the userland to
> >> > configure them according to the needs of the hardware.
> >>
> >> Jens can we add merge this for .27 or does anyone still has objections?
> >
> > I think that this patch makes sg's permission stricter. So this could
> > break the existing user-space applications.
> >
> 
> any particular app in mind?

No, but there would be some.


> for write access it still allows all commands (because there are some
> userspace apps tha rely on this).

Yeah, I know. But for read access, some commands will be blocked.
