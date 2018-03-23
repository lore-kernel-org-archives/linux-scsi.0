From: Long Li <longli@microsoft.com>
Subject: RE: [PATCH 2/3] Netvsc: Use the vmbus functiton to calculate ring
 buffer percentage
Date: Fri, 23 Mar 2018 17:42:04 +0000
Message-ID: <MWHPR2101MB0729D643AC561D9F9494EAA8CEA80@MWHPR2101MB0729.namprd21.prod.outlook.com>
References: <20180323001538.31876-1-longli@linuxonhyperv.com>
 <20180323001538.31876-2-longli@linuxonhyperv.com>
 <BL0PR2101MB1108CF3AEE2D04D064BA76FACAA80@BL0PR2101MB1108.namprd21.prod.outlook.com>
 <DM5PR2101MB0888F3389A0EB587EE85CC8CA0A80@DM5PR2101MB0888.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <DM5PR2101MB0888F3389A0EB587EE85CC8CA0A80@DM5PR2101MB0888.namprd21.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Long Li <longli@linuxonhyperv.com>, Stephen Hemminger <sthemmin@microsoft.com>, "James E . J . Bottomley" <JBottomley@odin.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> Subject: RE: [PATCH 2/3] Netvsc: Use the vmbus functiton to calculate rin=
g
> buffer percentage
>=20
>=20
>=20
> > -----Original Message-----
> > From: Haiyang Zhang
> > Sent: Friday, March 23, 2018 8:01 AM
> > To: Long Li <longli@linuxonhyperv.com>; KY Srinivasan
> > <kys@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> James
> > E . J . Bottomley <JBottomley@odin.com>; Martin K . Petersen
> > <martin.petersen@oracle.com>; devel@linuxdriverproject.org; linux-
> > scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> > Cc: Long Li <longli@microsoft.com>
> > Subject: RE: [PATCH 2/3] Netvsc: Use the vmbus functiton to calculate
> > ring buffer percentage
> >
> >
> >
> > > -----Original Message-----
> > > From: Long Li <longli@linuxonhyperv.com>
> > > Sent: Thursday, March 22, 2018 8:16 PM
> > > To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> > > <haiyangz@microsoft.com>; Stephen Hemminger
> > <sthemmin@microsoft.com>;
> > > James E . J . Bottomley <JBottomley@odin.com>; Martin K . Petersen
> > > <martin.petersen@oracle.com>; devel@linuxdriverproject.org; linux-
> > > scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> > > Cc: Long Li <longli@microsoft.com>
> > > Subject: [PATCH 2/3] Netvsc: Use the vmbus functiton to calculate
> > > ring
> > buffer
> > > percentage
> > >
> > > From: Long Li <longli@microsoft.com>
> > >
> > > In Vmbus, we have defined a function to calculate available ring
> > > buffer percentage to write.
> > >
> > > Use that function and remove duplicate netvsc code.
> > >
> > > Signed-off-by: Long Li <longli@microsoft.com>
> > > ---
> > >  drivers/net/hyperv/netvsc.c     | 17 +++--------------
> > >  drivers/net/hyperv/netvsc_drv.c |  3 ---
> > >  2 files changed, 3 insertions(+), 17 deletions(-)
>=20
> Why is the patch being sent to the scsi list and not to the network maili=
ng list
> and Dave Miller.

I will re-send the patch.

>=20
> K. Y
> > >
> > > diff --git a/drivers/net/hyperv/netvsc.c
> > > b/drivers/net/hyperv/netvsc.c
> > index
> > > 0265d703eb03..8af0069e4d8c 100644
> > > --- a/drivers/net/hyperv/netvsc.c
> > > +++ b/drivers/net/hyperv/netvsc.c
> > > @@ -31,7 +31,6 @@
> > >  #include <linux/vmalloc.h>
> > >  #include <linux/rtnetlink.h>
> > >  #include <linux/prefetch.h>
> > > -#include <linux/reciprocal_div.h>
> > >
> > >  #include <asm/sync_bitops.h>
> > >
> > > @@ -590,17 +589,6 @@ void netvsc_device_remove(struct hv_device
> > *device)
> > > #define RING_AVAIL_PERCENT_HIWATER 20  #define
> > > RING_AVAIL_PERCENT_LOWATER 10
> > >
> > > -/*
> > > - * Get the percentage of available bytes to write in the ring.
> > > - * The return value is in range from 0 to 100.
> > > - */
> > > -static u32 hv_ringbuf_avail_percent(const struct
> > > hv_ring_buffer_info
> > > *ring_info) -{
> > > -	u32 avail_write =3D hv_get_bytes_to_write(ring_info);
> > > -
> > > -	return reciprocal_divide(avail_write  * 100, netvsc_ring_reciprocal=
);
> > > -}
> > > -
> > >  static inline void netvsc_free_send_slot(struct netvsc_device
> > *net_device,
> > >  					 u32 index)
> > >  {
> > > @@ -649,7 +637,8 @@ static void netvsc_send_tx_complete(struct
> > > netvsc_device *net_device,
> > >  		wake_up(&net_device->wait_drain);
> > >
> > >  	if (netif_tx_queue_stopped(netdev_get_tx_queue(ndev, q_idx))
> > &&
> > > -	    (hv_ringbuf_avail_percent(&channel->outbound) >
> > > RING_AVAIL_PERCENT_HIWATER ||
> > > +	    (hv_get_avail_to_write_percent(&channel->outbound) >
> > > +	     RING_AVAIL_PERCENT_HIWATER ||
> > >  	     queue_sends < 1)) {
> > >  		netif_tx_wake_queue(netdev_get_tx_queue(ndev, q_idx));
> > >  		ndev_ctx->eth_stats.wake_queue++;  @@ -757,7 +746,7 @@
> static
> > >inline int netvsc_send_pkt(
> > >  	struct netdev_queue *txq =3D netdev_get_tx_queue(ndev, packet-
> > >q_idx);
> > >  	u64 req_id;
> > >  	int ret;
> > > -	u32 ring_avail =3D hv_ringbuf_avail_percent(&out_channel-
> > >outbound);
> > > +	u32 ring_avail =3D
> > > +hv_get_avail_to_write_percent(&out_channel->outbound);
> > >
> > >  	nvmsg.hdr.msg_type =3D NVSP_MSG1_TYPE_SEND_RNDIS_PKT;
> > >  	if (skb)
> > > diff --git a/drivers/net/hyperv/netvsc_drv.c
> > b/drivers/net/hyperv/netvsc_drv.c
> > > index faea0be18924..b0b1c2fd2b7b 100644
> > > --- a/drivers/net/hyperv/netvsc_drv.c
> > > +++ b/drivers/net/hyperv/netvsc_drv.c
> > > @@ -35,7 +35,6 @@
> > >  #include <linux/slab.h>
> > >  #include <linux/rtnetlink.h>
> > >  #include <linux/netpoll.h>
> > > -#include <linux/reciprocal_div.h>
> > >
> > >  #include <net/arp.h>
> > >  #include <net/route.h>
> > > @@ -55,7 +54,6 @@ static unsigned int ring_size __ro_after_init =3D
> > > 128; module_param(ring_size, uint, S_IRUGO);
> > MODULE_PARM_DESC(ring_size,
> > > "Ring buffer size (# of pages)");  unsigned int netvsc_ring_bytes
> > __ro_after_init;
> > > -struct reciprocal_value netvsc_ring_reciprocal __ro_after_init;
> > >
> > >  static const u32 default_msg =3D NETIF_MSG_DRV | NETIF_MSG_PROBE |
> > >  				NETIF_MSG_LINK | NETIF_MSG_IFUP | @@ -
> 2186,7 +2184,6 @@ static
> > > int __init netvsc_drv_init(void)
> > >  			ring_size);
> > >  	}
> > >  	netvsc_ring_bytes =3D ring_size * PAGE_SIZE;
> > > -	netvsc_ring_reciprocal =3D reciprocal_value(netvsc_ring_bytes);
> > >
> > >  	ret =3D vmbus_driver_register(&netvsc_drv);
> > >  	if (ret)
> > > --
> >
> >
> > Please also remove netvsc_ring_reciprocal from hyperv_net.h Thanks.

I will fix it and re-send the patch.

> >
> > Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
