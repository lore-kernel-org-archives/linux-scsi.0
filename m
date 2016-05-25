From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH v3 13/13] cxgbit: add files for cxgbit.ko
Date: Wed, 25 May 2016 12:40:46 -0500
Message-ID: <011401d1b6ac$917ea000$b47be000$@opengridcomputing.com>
References: <cover.1461088672.git.varun@chelsio.com>	<62c9d9c1e609c39f714ef15c10ba62b1cbbddecd.1461088673.git.varun@chelsio.com>	<CAJ3xEMiyQaWwsgVd_J9eVXqPwPk6=VYN_iMoEJQGz=1wHFrHqQ@mail.gmail.com>	<CAJ3xEMgtsPiatZ-Cy2ENsGVyKVDQSSHi4jr0Ushg21JiuqdLcw@mail.gmail.com>	<1464072025.22249.87.camel@haakon3.risingtidesystems.com> <CAJ3xEMjE3pfz7+QKMUheH9P+xyvj81qbCtbod0mBi7pUspMRXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.opengridcomputing.com ([72.48.136.20]:41235 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932536AbcEYRkm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2016 13:40:42 -0400
In-Reply-To: <CAJ3xEMjE3pfz7+QKMUheH9P+xyvj81qbCtbod0mBi7pUspMRXg@mail.gmail.com>
Content-Language: en-us
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Or Gerlitz' <gerlitz.or@gmail.com>, "'Nicholas A. Bellinger'" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, kxie@chelsio.com, indranil@chelsio.com, 'Varun Prakash' <varun@chelsio.com>

> From: Or Gerlitz [mailto:gerlitz.or@gmail.com]
>=20
> On Tue, May 24, 2016 at 9:40 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > Hi Or & Co,
> > On Wed, 2016-05-18 at 14:45 +0300, Or Gerlitz wrote:
> >> On Sat, Apr 30, 2016 at 6:54 PM, Or Gerlitz <gerlitz.or@gmail.com>=
 wrote:
> >> > On Tue, Apr 19, 2016 at 9:30 PM, Varun Prakash <varun@chelsio.co=
m> wrote:
> >> >> cxgbit.h - This file contains data structure
> >> >> definitions for cxgbit.ko.
> >> >>
> >> >> cxgbit_lro.h - This file contains data structure
> >> >> definitions for LRO support.
> >> >>
> >> >> cxgbit_main.c - This file contains code for
> >> >> registering with iscsi target transport and
> >> >> cxgb4 driver.
> >> >>
> >> >> cxgbit_cm.c - This file contains code for
> >> >> connection management.
> >> >>
> >> >> cxgbit_target.c - This file contains code
> >> >> for processing iSCSI PDU.
> >> >>
> >> >> cxgbit_ddp.c - This file contains code for
> >> >> Direct Data Placement.
> >> >
> >> > Wait,
> >> >
> >> > You are adding many K's LOCs to handle things like CM (connectio=
n
> >> > management), DDP and LRO. But your upstream solution must be usi=
ng CM
> >> > and DDP (and LRO as well) for the HW offloaded initiator side as=
 well,
> >> > not to mention the iWARP side of things.
> >> >
> >> > There must be some way to refactor things instead of repeating t=
he
> >> > same bits over and over, thoughts?
>=20
> >> The author haven't responded... where that this stands from your p=
oint of view?
>=20
> > For an initial merge, I don't have an objection to this series wrt
> > drivers/target/iscsi/* improvements + prerequisites, and new standa=
lone
> > cxgbit iscsit_transport driver.
> >
> > That said, there are areas between cxgbi + cxgbit code that can be =
made
> > common as you've pointed out.  The Cheliso folks have mentioned off=
-list
> > that cxgbi as-is in mainline does not support LRO, and that the maj=
ority
> > of DDP logic is shared between initiator + target.
> >
> > Are there specific pieces of logic in DDP or iWARP for cxgb* that y=
ou'd
> > like to see Varun + Co pursue as common code in v4.8+..?
>=20
> Hi Nic,
>=20
> As I wrote above, I have good reasons to believe that there are few K
> LOCs of duplication
> between this series to the chelsio hw iscsi initiator or the chelsio
> iwarp driver or both (triple).
>=20
> Ys, I'd like to see a public response from Varun and Co on this valid
> reviewer comment
> before you proceed with this series, makes sense? There's no point to
> duplicate the same
> code in the kernel again and again. **Even** if there's one
> duplication now, we don't want
> another one.
>=20
> Or.

Hey Or and Nicholas,

I've been staying out of this directly due to my workload.  But I will =
now=20
take a look at where and how we can refactor to reduce the code duplica=
tion.=20
Here are some thoughts with a quick glance:

DDP is not used by iWARP.  DDP is for direct placement attempt on a TCP=
=20
streaming mode connection.  RDMA has its own way of doing this that doe=
sn=E2=80=99t=20
utilize the same HW resources.  So I would say that the DDP usage could=
 be=20
refactored such that there is a set of helper functions to do the commo=
n=20
logic, like managing page pod adapter resources.  An example would be=20
cxgb4i.c:ddp_ppod_write_idata(), and cxgbit_ppod_write_idata() from pat=
ch=20
13.

Connection Management (CM) can definitely be refactored to share helper=
=20
functions for setting up/tearing down TCP connections.  But the iWARP l=
ogic=20
is very different from iscsi once the TCP connection is setup and the=20
connection moved into RDMA mode.  So the sharing of logic would be in=20
sending various CPL messages to the adapter to connect/accept/close/abo=
rt=20
connections.  Having said that, the initiator and target wouldn't share=
 a=20
lot by virtue of the initiator only doing active side connection setup,=
 and=20
the target only doing passive side connection setup.  So refactor would=
 be=20
common services that iw_cxgb4, cxgbi4, and cxgbit all use.    An exampl=
e=20
would be: iw_cxgb4/cm.c:send_connect(), and cxgb4i.c/send_act_open_req(=
).

I didn't look at LRO at this point.

Anyway, none of these are particularly difficult, but will require=20
significant effort and time.  The current cxgbit series has had a lot o=
f=20
internal review and testing by the Chelsio iscsi team, and it would be =
great=20
if this refactoring can be deferred with the promise that we will get i=
t=20
done for the 4.8 merge window.  Thoughts?

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
