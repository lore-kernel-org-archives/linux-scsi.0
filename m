From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [EXT] Re: [PATCH net-next 07/10] qed*: Add iWARP 100g support
Date: Thu, 2 May 2019 15:31:18 +0300
Message-ID: <20190502123118.GR7676@mtr-leonro.mtl.com>
References: <20190501095722.6902-1-michal.kalderon@marvell.com>
 <20190501095722.6902-8-michal.kalderon@marvell.com>
 <20190501.203522.1577716429222042609.davem@davemloft.net>
 <20190502051320.GF7676@mtr-leonro.mtl.com>
 <BLUPR18MB0130AF99D6AB674A85E075D9A1340@BLUPR18MB0130.namprd18.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BLUPR18MB0130AF99D6AB674A85E075D9A1340@BLUPR18MB0130.namprd18.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Michal Kalderon <mkalderon@marvell.com>
Cc: David Miller <davem@davemloft.net>, Ariel Elior <aelior@marvell.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "dledford@redhat.com" <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, May 02, 2019 at 12:10:39PM +0000, Michal Kalderon wrote:
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Thursday, May 2, 2019 8:13 AM
> > On Wed, May 01, 2019 at 08:35:22PM -0400, David Miller wrote:
> > > From: Michal Kalderon <michal.kalderon@marvell.com>
> > > Date: Wed, 1 May 2019 12:57:19 +0300
> > >
> > > > diff --git a/drivers/infiniband/hw/qedr/main.c
> > > > b/drivers/infiniband/hw/qedr/main.c
> > > > index d93c8a893a89..8bc6775abb79 100644
> > > > --- a/drivers/infiniband/hw/qedr/main.c
> > > > +++ b/drivers/infiniband/hw/qedr/main.c
> > > > @@ -52,6 +52,10 @@ MODULE_DESCRIPTION("QLogic 40G/100G ROCE
> > > > Driver");  MODULE_AUTHOR("QLogic Corporation");
> > > > MODULE_LICENSE("Dual BSD/GPL");
> > > >
> > > > +static uint iwarp_cmt;
> > > > +module_param(iwarp_cmt, uint, 0444);
> > MODULE_PARM_DESC(iwarp_cmt, "
> > > > +iWARP: Support CMT mode. 0 - Disabled, 1 - Enabled. Default:
> > > > +Disabled");
> > > > +
> > >
> > > Sorry no, this is totally beneath us.
> >
> > It is not acceptable for RDMA too.
>
> Dave and Leon,
>
> This is a bit of a special case related specifically to our hardware.
> Enabling iWARP on this kind of configuration impacts L2 performance.
> We don't want this to happen implicitly once the rdma driver is loaded since
> that can happen automatically and could lead to unexpected behavior from user perspective.
> Therefore we need a way of giving the user control to decide whether they want iWARP at the cost
> of L2 performance degradation.
> We also need this information as soon as the iWARP device registers, so using the rdma-tool would be too late.
>
> If module parameter is not an option, could you please advise what would be ok ?
> ethtool private flags ?
> devlink ?

Yes, devlink params are modern way to have same functionality as module
parameters.

This patch can help you in order to get a sense of how to do it.
https://lore.kernel.org/patchwork/patch/959195/

Thanks

>
> thanks,
> Michal
>
> >
> > Also please don't use comments inside function calls, it complicates various
> > checkers without real need.
> > dev->ops->iwarp_set_engine_affin(dev->cdev, true /* reset */);
> >                                                 ^^^^^^^^^^^^^^ Thanks
