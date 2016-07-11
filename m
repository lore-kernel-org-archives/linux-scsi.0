From: Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH] xen_pvscsi: reclaim the ring request when mapping data
 failed
Date: Mon, 11 Jul 2016 11:33:28 +0200
Message-ID: <578367E8.2050601@suse.com>
References: <578309AE.1080704@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <578309AE.1080704@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bin Wu <wu.wubin@huawei.com>, boris.ostrovsky@oracle.com, david.vrabel@citrix.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/07/16 04:51, Bin Wu wrote:
> During scsi command queueing, if mapping data fails, we need to
> reclaim the failed request. Otherwise, the garbage request will
> be pushed into the ring for the backend to work.

Well spotted. There is another instance of this problem in
scsifront_action_handler(). Would you mind correcting this one, too?


Juergen

> 
> Signed-off-by: Bin Wu <wu.wubin@huawei.com>
> ---
>  drivers/scsi/xen-scsifront.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
> index 9dc8687..655163d 100644
> --- a/drivers/scsi/xen-scsifront.c
> +++ b/drivers/scsi/xen-scsifront.c
> @@ -565,6 +565,7 @@ static int scsifront_queuecommand(struct Scsi_Host
> *shost,
>      err = map_data_for_request(info, sc, ring_req, shadow);
>      if (err < 0) {
>          pr_debug("%s: err %d\n", __func__, err);
> +        info->ring.req_prod_pvt--;
>          scsifront_put_rqid(info, rqid);
>          scsifront_return(info);
>          spin_unlock_irqrestore(shost->host_lock, flags);
