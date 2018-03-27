From: "Kalderon, Michal" <Michal.Kalderon@cavium.com>
Subject: RE: [PATCH net-next] qed*: Utilize FW 8.33.11.0
Date: Tue, 27 Mar 2018 17:41:51 +0000
Message-ID: <CY1PR0701MB201259F4DC154EFA6AE90E6F88AC0@CY1PR0701MB2012.namprd07.prod.outlook.com>
References: <1522083732-26560-1-git-send-email-Michal.Kalderon@cavium.com>
 <20180326211827.GG15554@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180326211827.GG15554@ziepe.ca>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "davem@davemloft.net" <davem@davemloft.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Tayar, Tomer" <Tomer.Tayar@cavium.com>, "Rangankar, Manish" <Manish.Rangankar@cavium.com>, "Elior, Ariel" <Ariel.Elior@cavium.com>
List-Id: linux-scsi@vger.kernel.org

> From: Jason Gunthorpe [mailto:jgg@ziepe.ca]
> Sent: Tuesday, March 27, 2018 12:18 AM
> > diff --git a/drivers/infiniband/hw/qedr/main.c
> > b/drivers/infiniband/hw/qedr/main.c
> > index db4bf97..7dbbe6d 100644
> > +++ b/drivers/infiniband/hw/qedr/main.c
> > @@ -51,6 +51,7 @@
> >  MODULE_DESCRIPTION("QLogic 40G/100G ROCE Driver");
> > MODULE_AUTHOR("QLogic Corporation");  MODULE_LICENSE("Dual
> BSD/GPL");
> > +MODULE_VERSION(QEDR_MODULE_VERSION);
> >
> >  #define QEDR_WQ_MULTIPLIER_DFT	(3)
> >
> > diff --git a/drivers/infiniband/hw/qedr/qedr.h
> > b/drivers/infiniband/hw/qedr/qedr.h
> > index 86d4511..ab0d411 100644
> > +++ b/drivers/infiniband/hw/qedr/qedr.h
> > @@ -43,6 +43,8 @@
> >  #include "qedr_hsi_rdma.h"
> >
> >  #define QEDR_NODE_DESC "QLogic 579xx RoCE HCA"
> > +#define QEDR_MODULE_VERSION "8.33.11.20"
> > +
>=20
> I thought we had a general prohibition against versions like this in main=
line
> drivers? And what does this hunk have to do with supporting new firmware?
>=20
> Jason
I'm assuming you refer only to rdma in regards to version prohibition right=
 ? as looking at all other vendors
(including Mellanox) all have module versions under net/ why is rdma differ=
ent in this way ?
I now searched back mails on the topic and found an email from Leon where h=
e stated:=20
" I am strongly against module versions. You should rely on official kernel=
 version."
But it's not always the inbox driver that is installed or probed, the kerne=
l version is not enough.=20
Given different distros, vanilla kernels, out of box drivers, etc... it is =
essential for  us that based on
logs And modinfo we can determine the qed* drivers that are running.=20

We have received complaints that our qedr module doesn't have a version whe=
reas all of our other
components do (qed, qede, qedi, qedf). We decided to add the qedr version w=
ith the next version
update to align with the rest of the components.=20

We can move the driver version bump into a different commit for all compone=
nts, just made
sense to Add it to this one as it is the root of the version update.=20
Let me know if you think it is essential and I'll make the change for v2

Thanks,
Michal
