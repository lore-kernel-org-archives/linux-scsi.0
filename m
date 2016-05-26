From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v3 13/13] cxgbit: add files for cxgbit.ko
Date: Wed, 25 May 2016 21:55:04 -0700
Message-ID: <1464238504.22249.168.camel@haakon3.risingtidesystems.com>
References: <cover.1461088672.git.varun@chelsio.com>
	 <62c9d9c1e609c39f714ef15c10ba62b1cbbddecd.1461088673.git.varun@chelsio.com>
	 <CAJ3xEMiyQaWwsgVd_J9eVXqPwPk6=VYN_iMoEJQGz=1wHFrHqQ@mail.gmail.com>
	 <CAJ3xEMgtsPiatZ-Cy2ENsGVyKVDQSSHi4jr0Ushg21JiuqdLcw@mail.gmail.com>
	 <1464072025.22249.87.camel@haakon3.risingtidesystems.com>
	 <CAJ3xEMjE3pfz7+QKMUheH9P+xyvj81qbCtbod0mBi7pUspMRXg@mail.gmail.com>
	 <011401d1b6ac$917ea000$b47be000$@opengridcomputing.com>
	 <CAJ3xEMhm4eemgvgbpCEKc86LbKSi3WKUX7d+57KwwtZbJB52Wg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:39828 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbcEZEzH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 May 2016 00:55:07 -0400
In-Reply-To: <CAJ3xEMhm4eemgvgbpCEKc86LbKSi3WKUX7d+57KwwtZbJB52Wg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Or Gerlitz <gerlitz.or@gmail.com>
Cc: Steve Wise <swise@opengridcomputing.com>, target-devel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, kxie@chelsio.com, indranil@chelsio.com, Varun Prakash <varun@chelsio.com>

On Wed, 2016-05-25 at 23:41 +0300, Or Gerlitz wrote:
> On Wed, May 25, 2016 at 8:40 PM, Steve Wise <swise@opengridcomputing.=
com> wrote:
> >> From: Or Gerlitz [mailto:gerlitz.or@gmail.com]
> >>

<SNIP>

> .
> >
> > Hey Or and Nicholas,
> >
> > I've been staying out of this directly due to my workload.  But I w=
ill now
> > take a look at where and how we can refactor to reduce the code dup=
lication.
> > Here are some thoughts with a quick glance:
> >
> > DDP is not used by iWARP.  DDP is for direct placement attempt on a=
 TCP
> > streaming mode connection.  RDMA has its own way of doing this that=
 doesn=E2=80=99t
> > utilize the same HW resources.  So I would say that the DDP usage c=
ould be
> > refactored such that there is a set of helper functions to do the c=
ommon
> > logic, like managing page pod adapter resources.  An example would =
be
> > cxgb4i.c:ddp_ppod_write_idata(), and cxgbit_ppod_write_idata() from=
 patch
> > 13.
>=20
> sounds good
>=20
> > Connection Management (CM) can definitely be refactored to share he=
lper
> > functions for setting up/tearing down TCP connections.  But the iWA=
RP logic
> > is very different from iscsi once the TCP connection is setup and t=
he
> > connection moved into RDMA mode.  So the sharing of logic would be =
in
> > sending various CPL messages to the adapter to connect/accept/close=
/abort
> > connections.
>=20
> Ditto
>=20
> > Having said that, the initiator and target wouldn't share a
> > lot by virtue of the initiator only doing active side connection se=
tup, and
> > the target only doing passive side connection setup.
>=20
> Well, I am not sure. It's like saying that if you break the IB/RoCE C=
M
> to active side and passive side they will not share lots of code. If
> you look on the existing CM (drivers/infiniband/core/cm.c) and think
> how to break it to two, you'll see that you end up with two code base=
s
> to maintain with likelihood of same bugs and similar state machines t=
o
> implement/maintain and debug. So in that sense, it's much (much)
> better to have one CM code which does both iscsi sides.
>=20
> > So refactor would be
> > common services that iw_cxgb4, cxgbi4, and cxgbit all use.    An ex=
ample
> > would be: iw_cxgb4/cm.c:send_connect(), and cxgb4i.c/send_act_open_=
req().
>=20
> good and one code base which treats both sides.
>=20
> > I didn't look at LRO at this point.
> >
> > Anyway, none of these are particularly difficult, but will require
> > significant effort and time.  The current cxgbit series has had a l=
ot of
> > internal review and testing by the Chelsio iscsi team, and it would=
 be great
> > if this refactoring can be deferred with the promise that we will g=
et it
> > done for the 4.8 merge window.  Thoughts?
>=20
> We've been there, e.g Intel recently sent iWARP driver and throughout
> the review we realized that lots of the iwarp netlink code is shared
> between existing drivers and the new driver, so the driver didn't get
> in kernel X but rather X+1 after doing that fix, it's only off by
> one...
>=20
> I don't think we should be letting duplication of that extent to get
> in, for Chelsio ppl that know the materials well better vs anyone els=
e
> it should have been clear that they create that dup without any real
> justification and till  that moment they didn't come here to even
> comment on that. Lets have them fix that for the next merge window,
> that's my thinking, Nic?
>=20

Varun + Co have made common improvements between existing software
iscsi-target RX + TX PDU handling and their new driver, and no further
comments for these prerequisites have been made.

The additional improvements discussed here so far are cxgb* specific,
and will not effect other drivers, and will not change configfs user AB=
I
layout compatibility within /sys/kernel/config/target/iscsi/.

That being the case, I think it's a reasonable starting point for
mainline users to consume target ISO on cxgb hardware, and for Chelsio
to make further common code improvements across their existing host
drivers.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
