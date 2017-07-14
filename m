From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 7/7] libsas: release disco mutex during waiting in
 sas_ex_discover_end_dev
Date: Fri, 14 Jul 2017 08:55:52 +0200
Message-ID: <fbaafcf1-9be8-4db6-728a-f6432b4c8e76@suse.de>
References: <1499670369-44143-1-git-send-email-wangyijing@huawei.com>
 <1499670369-44143-8-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1499670369-44143-8-git-send-email-wangyijing@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yijing Wang <wangyijing@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, emilne@redhat.com, thenzl@redhat.com, wefu@redhat.com, charles.chenxin@huawei.com, chenweilong@huawei.com, john.garry@huawei.com, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 07/10/2017 09:06 AM, Yijing Wang wrote:
> Disco mutex was introudced to prevent domain rediscovery competing
> with ata error handling(87c8331). If we have already hold the lock
> in sas_revalidate_domain and sync executing probe, deadlock caused,
> because, sas_probe_sata() also need hold disco_mutex. Since disco mutex
> use to prevent revalidata domain happen during ata error handler,
> it should be safe to release disco mutex when sync probe, because
> no new revalidate domain event would be process until the sync return,
> and the current sas revalidate domain finish.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> CC: John Garry <john.garry@huawei.com>
> CC: Johannes Thumshirn <jthumshirn@suse.de>
> CC: Ewan Milne <emilne@redhat.com>
> CC: Christoph Hellwig <hch@lst.de>
> CC: Tomas Henzl <thenzl@redhat.com>
> CC: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/scsi/libsas/sas_expander.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index 9d26c28..077024e 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -776,6 +776,7 @@ static struct domain_device *sas_ex_discover_end_dev(
>  	struct ex_phy *phy = &parent_ex->ex_phy[phy_id];
>  	struct domain_device *child = NULL;
>  	struct sas_rphy *rphy;
> +	bool prev_lock;
>  	int res;
>  
>  	if (phy->attached_sata_host || phy->attached_sata_ps)
> @@ -803,6 +804,7 @@ static struct domain_device *sas_ex_discover_end_dev(
>  	sas_ex_get_linkrate(parent, child, phy);
>  	sas_device_set_phy(child, phy->port);
>  
> +	prev_lock = mutex_is_locked(&child->port->ha->disco_mutex);
>  #ifdef CONFIG_SCSI_SAS_ATA
>  	if ((phy->attached_tproto & SAS_PROTOCOL_STP) || phy->attached_sata_dev) {
>  		res = sas_get_ata_info(child, phy);
> @@ -832,7 +834,11 @@ static struct domain_device *sas_ex_discover_end_dev(
>  				    SAS_ADDR(parent->sas_addr), phy_id, res);
>  			goto out_list_del;
>  		}
> +		if (prev_lock)
> +			mutex_unlock(&child->port->ha->disco_mutex);
>  		sas_disc_wait_completion(child->port, DISCE_PROBE);
> +		if (prev_lock)
> +			mutex_lock(&child->port->ha->disco_mutex);
>  
>  	} else
>  #endif
> @@ -861,7 +867,11 @@ static struct domain_device *sas_ex_discover_end_dev(
>  				    SAS_ADDR(parent->sas_addr), phy_id, res);
>  			goto out_list_del;
>  		}
> +		if (prev_lock)
> +			mutex_unlock(&child->port->ha->disco_mutex);
>  		sas_disc_wait_completion(child->port, DISCE_PROBE);
> +		if (prev_lock)
> +			mutex_lock(&child->port->ha->disco_mutex);
>  	} else {
>  		SAS_DPRINTK("target proto 0x%x at %016llx:0x%x not handled\n",
>  			    phy->attached_tproto, SAS_ADDR(parent->sas_addr),
> 
I would rather have an analysis if this really cannot happen; 'should
not' is rather vague. But seeing that it _is_ quite complex:

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
