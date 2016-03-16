From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH RFC 0/2] mempool based chained scatterlist alloc/free
 api api
Date: Tue, 15 Mar 2016 22:18:52 -0700
Message-ID: <1458105532.5809.10.camel@kernel.org>
References: <1458081569-30953-1-git-send-email-mlin@kernel.org>
	 <1458083523.2375.120.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1458083523.2375.120.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2016-03-15 at 16:12 -0700, James Bottomley wrote:
> On Tue, 2016-03-15 at 15:39 -0700, Ming Lin wrote:
> > From: Ming Lin <ming.l@ssi.samsung.com>
> >=20
> > Hi list,
> >=20
> > This moves the mempool based chained scatterlist alloc/free code
> > from
> > scsi_lib.c to lib/scatterlist.c.
> >=20
> > So other drivers(for example, the under development NVMe over
> > fabric=C2=A0
> > drivers) can also use it.
> >=20
> > Ming Lin (2):
> > =C2=A0 scatterlist: add mempool based chained SG alloc/free api
> > =C2=A0 scsi: use the new chained SG api
> >=20
> > =C2=A0drivers/scsi/scsi_lib.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| 129 ++=
----------------------------
> > ------
> > =C2=A0include/linux/scatterlist.h |=C2=A0=C2=A012 ++++
> > =C2=A0lib/scatterlist.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0| 156
> > ++++++++++++++++++++++++++++++++++++++++++++
> > =C2=A03 files changed, 175 insertions(+), 122 deletions(-)
>=20
> I'd really rather this were a single patch so git can tell us the
> code
> motion.=C2=A0=C2=A0If you add in one patch and remove in another the =
code
> motion
> trackers don't see it.
>=20
> Secondly, you said "This copied code from scsi_lib.c to scatterlist.c
> and modified it a bit" could you move in one patch and modify in
> another, so we can see exactly what you're changing.

The modification is mostly about structure names and function names
changes.

I can do it in a single patch.

>=20
> Thirdly, are you sure the pool structure for NVMe should be the same
> as
> for SCSI?=C2=A0=C2=A0We don't do buddy pools for 1,2 or 4 entry trans=
actions in
> SCSI just basically because of heuristics, but the packetised io
> characteristics of NVMe make single entry lists more likely for it,
> don't they?

Not sure about this, but the nvme-pci driver may not use this api,
because it also has a PRP lists except for the SG lists.

But nvme-over-rdma/nvme-over-fiber-channel driver is good to use this
api.

>=20
> James
>=20
>=20
