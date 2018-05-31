From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 4/8] scsi: libsas: trigger a new revalidation to discover
 the device
Date: Thu, 31 May 2018 16:42:29 +0100
Message-ID: <013c5c91-9792-7951-95ed-22daae2e2dbe@huawei.com>
References: <20180529022309.21071-1-yanaijie@huawei.com>
 <20180529022309.21071-5-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529022309.21071-5-yanaijie@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, xiexiuqi@huawei.com, tj@kernel.org, miaoxie@huawei.com, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 29/05/2018 03:23, Jason Yan wrote:
> Now if a new device replaced a old device, the sas address will change.
> We unregister the old device and discover the new device in one
> revalidation process. But after we deferred the sas_port_delete(), the
> sas port is not deleted when we registering the new port and device.
> This will make the sysfs complain of creating duplicate filename.
>
> Fix this by doing the replacement in two steps. The first revalidation
> only delete the old device and trigger a new revalidation. The second
> revalidation discover the new device.
>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> CC: chenxiang <chenxiang66@hisilicon.com>
> CC: John Garry <john.garry@huawei.com>
> CC: Johannes Thumshirn <jthumshirn@suse.de>
> CC: Ewan Milne <emilne@redhat.com>
> CC: Christoph Hellwig <hch@lst.de>
> CC: Tomas Henzl <thenzl@redhat.com>
> CC: Dan Williams <dan.j.williams@intel.com>
> CC: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/libsas/sas_expander.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index 629c580d906b..25ad9ef54e6c 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -2013,6 +2013,8 @@ static int sas_rediscover_dev(struct domain_device *dev, int phy_id, bool last)
>  {
>  	struct expander_device *ex = &dev->ex_dev;
>  	struct ex_phy *phy = &ex->ex_phy[phy_id];
> +	struct asd_sas_port *port = dev->port;
> +	struct asd_sas_phy *sas_phy;
>  	enum sas_device_type type = SAS_PHY_UNUSED;
>  	u8 sas_addr[8];
>  	int res;
> @@ -2060,7 +2062,14 @@ static int sas_rediscover_dev(struct domain_device *dev, int phy_id, bool last)
>  		    SAS_ADDR(phy->attached_sas_addr));
>  	sas_unregister_devs_sas_addr(dev, phy_id, last);
>
> -	return sas_discover_new(dev, phy_id);
> +	/* force the next revalidation find this phy and bring it up */
> +	phy->phy_change_count = -1;
> +	ex->ex_change_count = -1;
> +	sas_phy = container_of(port->phy_list.next, struct asd_sas_phy,
> +			port_phy_el);
> +	port->ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
> +

This is less than ideal: that is, restarting another discovery with this 
artifical broadcast event. We do something similar when re-enabling 
revalidation.

Can we do all the event processing synchronised to the original event?

> +	return 0;
>  }
>
>  /**
>
