From: "Karen Xie" <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: RE: [PATCH 1/1] cxgb3i: Fix a login over vlan issue
Date: Wed, 9 Dec 2009 21:26:49 -0800
Message-ID: <8A71B368A89016469F72CD08050AD33403F4B0DF@maui.asicdesigners.com>
References: <1259924665-2301-1-git-send-email-rakesh@chelsio.com> <4B1D2E79.4000405@cs.wisc.edu>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <3GoYgSwQLCgww9uqotqx4u0.o0y01qz-u4o4us00sxqs30614.o0y-JX7+OpRa80S8N/ZHIG5xj07CuiCeIGUxQQ4Iyu8u01E@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=>,
	<mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=>,
	<mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rakesh Ranjan <rakesh-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


Hi, thanks, Mike.

It looks like the original patch somehow did not make into the linux-scsi list at all for some reason: tried to search for it but could not find it.

We are re-submitting it just to make sure.

Best regards,
Karen

-----Original Message-----
From: Mike Christie [mailto:michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org]
Sent: Mon 12/7/2009 8:34 AM
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org; davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org; Steve Wise; Karen Xie; linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Rakesh Ranjan
Subject: Re: [PATCH 1/1] cxgb3i: Fix a login over vlan issue
 
Rakesh Ranjan wrote:
> Fix a login over vlan issue, when parent interface is vlan and we are using cxgb3i sepecific
> private ip address in '/etc/iscsi/ifaces/' iface file.
> 
> Acked-by: Karen Xie <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Rakesh Ranjan <rakesh-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> ---
>  drivers/scsi/cxgb3i/cxgb3i_offload.c |   34 +++++++++++++++++++++++++++++++++-
>  1 files changed, 33 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.c b/drivers/scsi/cxgb3i/cxgb3i_offload.c
> index c1d5be4..66d52e4 100644
> --- a/drivers/scsi/cxgb3i/cxgb3i_offload.c
> +++ b/drivers/scsi/cxgb3i/cxgb3i_offload.c
> @@ -1440,6 +1440,10 @@ void cxgb3i_c3cn_release(struct s3_conn *c3cn)
>  static int is_cxgb3_dev(struct net_device *dev)
>  {
>  	struct cxgb3i_sdev_data *cdata;
> +	struct net_device *ndev = dev;
> +
> +	if (dev->priv_flags & IFF_802_1Q_VLAN)
> +		ndev = vlan_dev_real_dev(dev);
>  
>  	write_lock(&cdata_rwlock);
>  	list_for_each_entry(cdata, &cdata_list, list) {
> @@ -1447,7 +1451,7 @@ static int is_cxgb3_dev(struct net_device *dev)
>  		int i;
>  
>  		for (i = 0; i < ports->nports; i++)
> -			if (dev == ports->lldevs[i]) {
> +			if (ndev == ports->lldevs[i]) {
>  				write_unlock(&cdata_rwlock);
>  				return 1;
>  			}
> @@ -1566,6 +1570,26 @@ out_err:
>  	return -1;
>  }
>  
> +/**
> + * cxgb3i_find_dev - find the interface associated with the given address
> + * @ipaddr: ip address
> + */
> +static struct net_device *
> +cxgb3i_find_dev(__be32 ipaddr)
> +{
> +	struct flowi fl;
> +	int err;
> +	struct rtable *rt;
> +
> +	memset(&fl, 0, sizeof(fl));
> +	fl.nl_u.ip4_u.daddr = ipaddr;
> +
> +	err = ip_route_output_key(&init_net, &rt, &fl);
> +	if (!err)
> +		return (&rt->u.dst)->dev;
> +
> +	return NULL;
> +}
>  
>  /**
>   * cxgb3i_c3cn_connect - initiates an iscsi tcp connection to a given address
> @@ -1581,6 +1605,7 @@ int cxgb3i_c3cn_connect(struct net_device *dev, struct s3_conn *c3cn,
>  	struct cxgb3i_sdev_data *cdata;
>  	struct t3cdev *cdev;
>  	__be32 sipv4;
> +	struct net_device *dstdev;
>  	int err;
>  
>  	c3cn_conn_debug("c3cn 0x%p, dev 0x%p.\n", c3cn, dev);
> @@ -1591,6 +1616,13 @@ int cxgb3i_c3cn_connect(struct net_device *dev, struct s3_conn *c3cn,
>  	c3cn->daddr.sin_port = usin->sin_port;
>  	c3cn->daddr.sin_addr.s_addr = usin->sin_addr.s_addr;
>  
> +	dstdev = cxgb3i_find_dev(usin->sin_addr.s_addr);
> +	if (!dstdev || !is_cxgb3_dev(dstdev))
> +		return -ENETUNREACH;
> +
> +	if (dstdev->priv_flags & IFF_802_1Q_VLAN)
> +		dev = dstdev;
> +
>  	rt = find_route(dev, c3cn->saddr.sin_addr.s_addr,
>  			c3cn->daddr.sin_addr.s_addr,
>  			c3cn->saddr.sin_port,


Looks sane. I am not a expert on the networks apis being used though.


--

You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
