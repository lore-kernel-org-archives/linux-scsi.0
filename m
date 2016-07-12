From: Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH v2] xen_pvscsi: reclaim the ring request when the
 prepairing failed
Date: Tue, 12 Jul 2016 10:02:23 +0200
Message-ID: <5784A40F.9000908@suse.com>
References: <1468283787-18260-1-git-send-email-wu.wubin@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1468283787-18260-1-git-send-email-wu.wubin@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bin Wu <wu.wubin@huawei.com>, boris.ostrovsky@oracle.com, david.vrabel@citrix.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/07/16 02:36, Bin Wu wrote:
> During scsi command queueing or exception handling, if prepairing
> fails, we need to reclaim the failed request. Otherwise, the garbage
> request will be pushed into the ring for the backend to work.
> 
> Signed-off-by: Bin Wu <wu.wubin@huawei.com>

Reviewed-by: Juergen Gross <jgross@suse.com>

> ---
>  drivers/scsi/xen-scsifront.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
> index 9dc8687..8646db1 100644
> --- a/drivers/scsi/xen-scsifront.c
> +++ b/drivers/scsi/xen-scsifront.c
> @@ -184,8 +184,6 @@ static struct vscsiif_request *scsifront_pre_req(struct vscsifrnt_info *info)
>  
>  	ring_req = RING_GET_REQUEST(&(info->ring), ring->req_prod_pvt);
>  
> -	ring->req_prod_pvt++;
> -
>  	ring_req->rqid = (uint16_t)id;
>  
>  	return ring_req;
> @@ -196,6 +194,8 @@ static void scsifront_do_request(struct vscsifrnt_info *info)
>  	struct vscsiif_front_ring *ring = &(info->ring);
>  	int notify;
>  
> +	ring->req_prod_pvt++;
> +
>  	RING_PUSH_REQUESTS_AND_CHECK_NOTIFY(ring, notify);
>  	if (notify)
>  		notify_remote_via_irq(info->irq);
> 
