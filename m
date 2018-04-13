From: "Michael Kelley (EOSG)" <Michael.H.Kelley@microsoft.com>
Subject: RE: [Resend Patch 2/3] Netvsc: Use the vmbus functiton to calculate
 ring buffer percentage
Date: Fri, 13 Apr 2018 23:39:58 +0000
Message-ID: <DM5PR2101MB103001D09986D57D8E0EF124DCB30@DM5PR2101MB1030.namprd21.prod.outlook.com>
References: <20180328004840.22787-1-longli@linuxonhyperv.com>
 <20180328004840.22787-2-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180328004840.22787-2-longli@linuxonhyperv.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, "James E . J . Bottomley" <JBottomley@odin.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org <linux-kernel-owner@vger.kernel.=
org> On Behalf
> Of Long Li
> Sent: Tuesday, March 27, 2018 5:49 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.=
com>; Stephen
> Hemminger <sthemmin@microsoft.com>; James E . J . Bottomley <JBottomley@o=
din.com>;
> Martin K . Petersen <martin.petersen@oracle.com>; devel@linuxdriverprojec=
t.org; linux-
> scsi@vger.kernel.org; linux-kernel@vger.kernel.org; netdev@vger.kernel.or=
g
> Cc: Long Li <longli@microsoft.com>
> Subject: [Resend Patch 2/3] Netvsc: Use the vmbus functiton to calculate =
ring buffer
> percentage
>=20
> From: Long Li <longli@microsoft.com>
>=20
> In Vmbus, we have defined a function to calculate available ring buffer
> percentage to write.
>=20
> Use that function and remove netvsc's private version.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>

Reviewed-by:  Michael Kelley <mikelley@microsoft.com>

> ---
>  drivers/net/hyperv/hyperv_net.h |  1 -
>  drivers/net/hyperv/netvsc.c     | 17 +++--------------
>  drivers/net/hyperv/netvsc_drv.c |  3 ---
>  3 files changed, 3 insertions(+), 18 deletions(-)
>=20
> diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_=
net.h
> index cd538d5a7986..a0199ab13d67 100644
> --- a/drivers/net/hyperv/hyperv_net.h
> +++ b/drivers/net/hyperv/hyperv_net.h
> @@ -189,7 +189,6 @@ struct netvsc_device;
>  struct net_device_context;
>=20
>  extern u32 netvsc_ring_bytes;
> -extern struct reciprocal_value netvsc_ring_reciprocal;
>=20
>  struct netvsc_device *netvsc_device_add(struct hv_device *device,
>  					const struct netvsc_device_info *info);
> diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
> index 0265d703eb03..8af0069e4d8c 100644
> --- a/drivers/net/hyperv/netvsc.c
> +++ b/drivers/net/hyperv/netvsc.c
> @@ -31,7 +31,6 @@
>  #include <linux/vmalloc.h>
>  #include <linux/rtnetlink.h>
>  #include <linux/prefetch.h>
> -#include <linux/reciprocal_div.h>
>=20
>  #include <asm/sync_bitops.h>
>=20
> @@ -590,17 +589,6 @@ void netvsc_device_remove(struct hv_device *device)
>  #define RING_AVAIL_PERCENT_HIWATER 20
>  #define RING_AVAIL_PERCENT_LOWATER 10
>=20
> -/*
> - * Get the percentage of available bytes to write in the ring.
> - * The return value is in range from 0 to 100.
> - */
> -static u32 hv_ringbuf_avail_percent(const struct hv_ring_buffer_info *ri=
ng_info)
> -{
> -	u32 avail_write =3D hv_get_bytes_to_write(ring_info);
> -
> -	return reciprocal_divide(avail_write  * 100, netvsc_ring_reciprocal);
> -}
> -
>  static inline void netvsc_free_send_slot(struct netvsc_device *net_devic=
e,
>  					 u32 index)
>  {
> @@ -649,7 +637,8 @@ static void netvsc_send_tx_complete(struct netvsc_dev=
ice
> *net_device,
>  		wake_up(&net_device->wait_drain);
>=20
>  	if (netif_tx_queue_stopped(netdev_get_tx_queue(ndev, q_idx)) &&
> -	    (hv_ringbuf_avail_percent(&channel->outbound) >
> RING_AVAIL_PERCENT_HIWATER ||
> +	    (hv_get_avail_to_write_percent(&channel->outbound) >
> +	     RING_AVAIL_PERCENT_HIWATER ||
>  	     queue_sends < 1)) {
>  		netif_tx_wake_queue(netdev_get_tx_queue(ndev, q_idx));
>  		ndev_ctx->eth_stats.wake_queue++;
> @@ -757,7 +746,7 @@ static inline int netvsc_send_pkt(
>  	struct netdev_queue *txq =3D netdev_get_tx_queue(ndev, packet->q_idx);
>  	u64 req_id;
>  	int ret;
> -	u32 ring_avail =3D hv_ringbuf_avail_percent(&out_channel->outbound);
> +	u32 ring_avail =3D hv_get_avail_to_write_percent(&out_channel->outbound=
);
>=20
>  	nvmsg.hdr.msg_type =3D NVSP_MSG1_TYPE_SEND_RNDIS_PKT;
>  	if (skb)
> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_=
drv.c
> index faea0be18924..b0b1c2fd2b7b 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -35,7 +35,6 @@
>  #include <linux/slab.h>
>  #include <linux/rtnetlink.h>
>  #include <linux/netpoll.h>
> -#include <linux/reciprocal_div.h>
>=20
>  #include <net/arp.h>
>  #include <net/route.h>
> @@ -55,7 +54,6 @@ static unsigned int ring_size __ro_after_init =3D 128;
>  module_param(ring_size, uint, S_IRUGO);
>  MODULE_PARM_DESC(ring_size, "Ring buffer size (# of pages)");
>  unsigned int netvsc_ring_bytes __ro_after_init;
> -struct reciprocal_value netvsc_ring_reciprocal __ro_after_init;
>=20
>  static const u32 default_msg =3D NETIF_MSG_DRV | NETIF_MSG_PROBE |
>  				NETIF_MSG_LINK | NETIF_MSG_IFUP |
> @@ -2186,7 +2184,6 @@ static int __init netvsc_drv_init(void)
>  			ring_size);
>  	}
>  	netvsc_ring_bytes =3D ring_size * PAGE_SIZE;
> -	netvsc_ring_reciprocal =3D reciprocal_value(netvsc_ring_bytes);
>=20
>  	ret =3D vmbus_driver_register(&netvsc_drv);
>  	if (ret)
> --
> 2.14.1
