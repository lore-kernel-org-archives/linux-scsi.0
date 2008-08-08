From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v2] cmdfilter: clean up sysfs interface
Date: Fri, 8 Aug 2008 17:20:47 +0900
Message-ID: <20080808172100V.fujita.tomonori@lab.ntt.co.jp>
References: <6cf6b73e0808020819x4501aa1cud4e6c3c9ae77558b@mail.gmail.com>
	<20080808160629H.fujita.tomonori@lab.ntt.co.jp>
	<6cf6b73e0808080047i550f2e6bt71d4e213f81fea87@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:59044 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355AbYHHIVn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Aug 2008 04:21:43 -0400
In-Reply-To: <6cf6b73e0808080047i550f2e6bt71d4e213f81fea87@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adel.gadllah@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, viro@zeniv.linux.org.uk, matthew@wil.cx, pjones@redhat.com, dougg@torque.net, James.Bottomley@hansenpartnership.com, dan.j.williams@intel.com

On Fri, 8 Aug 2008 09:47:44 +0200
"Adel Gadllah" <adel.gadllah@gmail.com> wrote:

> >> +     while ((p = strsep((char **)&page, " ")) != NULL) {
> >> +             set = 1;
> >> +
> >> +             if (p[0] == '-') {
> >> +                     set = 0;
> >> +                     p++;
> >> +             }
> >>
> >> -     for (len = strlen(page); len > 0; len -= 3) {
> >> -             if (len < 2)
> >> -                     break;
> >> -             ss.from = (char *) page + ret;
> >> -             ss.to = (char *) page + ret + 2;
> >> -             ret += 3;
> >> +             if (p[0] == '+')
> >> +                     p++;
> >> +             ss.from = (char *) p;
> >> +             ss.to = (char *) p + 4;
> >>               status = match_hex(&ss, &cmd);
> >
> > how about using simple_strtol here? It can handle an value too.
> 
> by value you mean a non hex input?

Oops, "it can handle a sign" But I found that simple_strtol can't
handle '+' though glibc strtol can. Please ignore this comment.

After looking at the string helper functions, here are some new
comments:

o match_hex just uses simple_strtol internally. So I don't think that
we need it here. we can simply use simple_strtol.

o simple_strtol can handle '-' sign. So we don't need:


> >> +             if (p[0] == '-') {
> >> +                     set = 0;
> >> +                     p++;
> >> +             }
