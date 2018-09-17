From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 3/5] scsi: libsas: always unregister the old device if
 going to discover new
Date: Mon, 17 Sep 2018 15:55:26 +0200
Message-ID: <c64532c9-9497-29c5-9d96-efef453ee050@suse.com>
References: <20180912082946.34814-1-yanaijie@huawei.com>
 <20180912082946.34814-4-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180912082946.34814-4-yanaijie@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, zhaohongjiang@huawei.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, miaoxie@huawei.com, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 09/12/2018 10:29 AM, Jason Yan wrote:
> If we went into sas_rediscover_dev() the attached_sas_addr was already
> insured not to be zero. So it's unnecessary to check if the
> attached_sas_addr is zero.
> 
> And although if the sas address is not changed, we always have to
> unregister the old device when we are going to register a new one. We
> cannot just leave the device there and bring up the new.
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
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/libsas/sas_expander.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index fadc99cb60df..52222940d398 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -2054,14 +2054,11 @@ static int sas_rediscover_dev(struct domain_device *dev, int phy_id, bool last)
>  		return res;
>  	}
>  
> -	/* delete the old link */
> -	if (SAS_ADDR(phy->attached_sas_addr) &&
> -	    SAS_ADDR(sas_addr) != SAS_ADDR(phy->attached_sas_addr)) {
> -		SAS_DPRINTK("ex %016llx phy 0x%x replace %016llx\n",
> -			    SAS_ADDR(dev->sas_addr), phy_id,
> -			    SAS_ADDR(phy->attached_sas_addr));
> -		sas_unregister_devs_sas_addr(dev, phy_id, last);
> -	}
> +	/* we always have to delete the old device when we went here */
> +	SAS_DPRINTK("ex %016llx phy 0x%x replace %016llx\n",
> +		    SAS_ADDR(dev->sas_addr), phy_id,
> +		    SAS_ADDR(phy->attached_sas_addr));
> +	sas_unregister_devs_sas_addr(dev, phy_id, last);
>  
>  	return sas_discover_new(dev, phy_id);
>  }
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
