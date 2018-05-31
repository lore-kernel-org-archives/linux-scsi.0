From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 2/8] scsi: libsas: check the lldd callback correctly
Date: Thu, 31 May 2018 15:09:41 +0100
Message-ID: <a8427e3b-baaf-3044-6fb3-c9c9a4253417@huawei.com>
References: <20180529022309.21071-1-yanaijie@huawei.com>
 <20180529022309.21071-3-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529022309.21071-3-yanaijie@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, xiexiuqi@huawei.com, tj@kernel.org, miaoxie@huawei.com, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 29/05/2018 03:23, Jason Yan wrote:
> We are using lldd_port_deformed so we'd better check if lldd_port_deformed
> is NULL.
>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> CC: John Garry <john.garry@huawei.com>
> CC: Johannes Thumshirn <jthumshirn@suse.de>
> CC: Ewan Milne <emilne@redhat.com>
> CC: Christoph Hellwig <hch@lst.de>
> CC: Tomas Henzl <thenzl@redhat.com>
> CC: Dan Williams <dan.j.williams@intel.com>
> CC: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/libsas/sas_discover.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
> index a0fa7ef3a071..354f6db5bb66 100644
> --- a/drivers/scsi/libsas/sas_discover.c
> +++ b/drivers/scsi/libsas/sas_discover.c
> @@ -260,7 +260,7 @@ static void sas_suspend_devices(struct work_struct *work)
>  	 * phy_list is not being mutated
>  	 */
>  	list_for_each_entry(phy, &port->phy_list, port_phy_el) {
> -		if (si->dft->lldd_port_formed)
> +		if (si->dft->lldd_port_deformed)

If you do make this change, then you can remove 
hisi_sas_port_deformed(), as it is just a stub to avoid a jump to NULL 
from above.

>  			si->dft->lldd_port_deformed(phy);
>  		phy->suspended = 1;
>  		port->suspended = 1;
>
