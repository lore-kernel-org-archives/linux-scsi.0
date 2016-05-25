From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH v3 13/13] cxgbit: add files for cxgbit.ko
Date: Wed, 25 May 2016 23:41:38 +0300
Message-ID: <CAJ3xEMhm4eemgvgbpCEKc86LbKSi3WKUX7d+57KwwtZbJB52Wg@mail.gmail.com>
References: <cover.1461088672.git.varun@chelsio.com>
	<62c9d9c1e609c39f714ef15c10ba62b1cbbddecd.1461088673.git.varun@chelsio.com>
	<CAJ3xEMiyQaWwsgVd_J9eVXqPwPk6=VYN_iMoEJQGz=1wHFrHqQ@mail.gmail.com>
	<CAJ3xEMgtsPiatZ-Cy2ENsGVyKVDQSSHi4jr0Ushg21JiuqdLcw@mail.gmail.com>
	<1464072025.22249.87.camel@haakon3.risingtidesystems.com>
	<CAJ3xEMjE3pfz7+QKMUheH9P+xyvj81qbCtbod0mBi7pUspMRXg@mail.gmail.com>
	<011401d1b6ac$917ea000$b47be000$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:36102 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbcEYUlo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 May 2016 16:41:44 -0400
In-Reply-To: <011401d1b6ac$917ea000$b47be000$@opengridcomputing.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, kxie@chelsio.com, indranil@chelsio.com, Varun Prakash <varun@chelsio.com>

On Wed, May 25, 2016 at 8:40 PM, Steve Wise <swise@opengridcomputing.co=
m> wrote:
>> From: Or Gerlitz [mailto:gerlitz.or@gmail.com]
>>
>> On Tue, May 24, 2016 at 9:40 AM, Nicholas A. Bellinger
>> <nab@linux-iscsi.org> wrote:
>> > Hi Or & Co,
>> > On Wed, 2016-05-18 at 14:45 +0300, Or Gerlitz wrote:
>> >> On Sat, Apr 30, 2016 at 6:54 PM, Or Gerlitz <gerlitz.or@gmail.com=
> wrote:
>> >> > On Tue, Apr 19, 2016 at 9:30 PM, Varun Prakash <varun@chelsio.c=
om> wrote:
>> >> >> cxgbit.h - This file contains data structure
>> >> >> definitions for cxgbit.ko.
>> >> >>
>> >> >> cxgbit_lro.h - This file contains data structure
>> >> >> definitions for LRO support.
>> >> >>
>> >> >> cxgbit_main.c - This file contains code for
>> >> >> registering with iscsi target transport and
>> >> >> cxgb4 driver.
>> >> >>
>> >> >> cxgbit_cm.c - This file contains code for
>> >> >> connection management.
>> >> >>
>> >> >> cxgbit_target.c - This file contains code
>> >> >> for processing iSCSI PDU.
>> >> >>
>> >> >> cxgbit_ddp.c - This file contains code for
>> >> >> Direct Data Placement.
>> >> >
>> >> > Wait,
>> >> >
>> >> > You are adding many K's LOCs to handle things like CM (connecti=
on
>> >> > management), DDP and LRO. But your upstream solution must be us=
ing CM
>> >> > and DDP (and LRO as well) for the HW offloaded initiator side a=
s well,
>> >> > not to mention the iWARP side of things.
>> >> >
>> >> > There must be some way to refactor things instead of repeating =
the
>> >> > same bits over and over, thoughts?
>>
>> >> The author haven't responded... where that this stands from your =
point of view?
>>
>> > For an initial merge, I don't have an objection to this series wrt
>> > drivers/target/iscsi/* improvements + prerequisites, and new stand=
alone
>> > cxgbit iscsit_transport driver.
>> >
>> > That said, there are areas between cxgbi + cxgbit code that can be=
 made
>> > common as you've pointed out.  The Cheliso folks have mentioned of=
f-list
>> > that cxgbi as-is in mainline does not support LRO, and that the ma=
jority
>> > of DDP logic is shared between initiator + target.
>> >
>> > Are there specific pieces of logic in DDP or iWARP for cxgb* that =
you'd
>> > like to see Varun + Co pursue as common code in v4.8+..?
>>
>> Hi Nic,
>>
>> As I wrote above, I have good reasons to believe that there are few =
K
>> LOCs of duplication
>> between this series to the chelsio hw iscsi initiator or the chelsio
>> iwarp driver or both (triple).
>>
>> Ys, I'd like to see a public response from Varun and Co on this vali=
d
>> reviewer comment
>> before you proceed with this series, makes sense? There's no point t=
o
>> duplicate the same
>> code in the kernel again and again. **Even** if there's one
>> duplication now, we don't want
>> another one.
>>
>> Or.
>
> Hey Or and Nicholas,
>
> I've been staying out of this directly due to my workload.  But I wil=
l now
> take a look at where and how we can refactor to reduce the code dupli=
cation.
> Here are some thoughts with a quick glance:
>
> DDP is not used by iWARP.  DDP is for direct placement attempt on a T=
CP
> streaming mode connection.  RDMA has its own way of doing this that d=
oesn=E2=80=99t
> utilize the same HW resources.  So I would say that the DDP usage cou=
ld be
> refactored such that there is a set of helper functions to do the com=
mon
> logic, like managing page pod adapter resources.  An example would be
> cxgb4i.c:ddp_ppod_write_idata(), and cxgbit_ppod_write_idata() from p=
atch
> 13.

sounds good

> Connection Management (CM) can definitely be refactored to share help=
er
> functions for setting up/tearing down TCP connections.  But the iWARP=
 logic
> is very different from iscsi once the TCP connection is setup and the
> connection moved into RDMA mode.  So the sharing of logic would be in
> sending various CPL messages to the adapter to connect/accept/close/a=
bort
> connections.

Ditto

> Having said that, the initiator and target wouldn't share a
> lot by virtue of the initiator only doing active side connection setu=
p, and
> the target only doing passive side connection setup.

Well, I am not sure. It's like saying that if you break the IB/RoCE CM
to active side and passive side they will not share lots of code. If
you look on the existing CM (drivers/infiniband/core/cm.c) and think
how to break it to two, you'll see that you end up with two code bases
to maintain with likelihood of same bugs and similar state machines to
implement/maintain and debug. So in that sense, it's much (much)
better to have one CM code which does both iscsi sides.

> So refactor would be
> common services that iw_cxgb4, cxgbi4, and cxgbit all use.    An exam=
ple
> would be: iw_cxgb4/cm.c:send_connect(), and cxgb4i.c/send_act_open_re=
q().

good and one code base which treats both sides.

> I didn't look at LRO at this point.
>
> Anyway, none of these are particularly difficult, but will require
> significant effort and time.  The current cxgbit series has had a lot=
 of
> internal review and testing by the Chelsio iscsi team, and it would b=
e great
> if this refactoring can be deferred with the promise that we will get=
 it
> done for the 4.8 merge window.  Thoughts?

We've been there, e.g Intel recently sent iWARP driver and throughout
the review we realized that lots of the iwarp netlink code is shared
between existing drivers and the new driver, so the driver didn't get
in kernel X but rather X+1 after doing that fix, it's only off by
one...

I don't think we should be letting duplication of that extent to get
in, for Chelsio ppl that know the materials well better vs anyone else
it should have been clear that they create that dup without any real
justification and till  that moment they didn't come here to even
comment on that. Lets have them fix that for the next merge window,
that's my thinking, Nic?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
