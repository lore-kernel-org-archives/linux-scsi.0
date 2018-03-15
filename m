From: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] scsi: iscsi_tcp: set BDI_CAP_STABLE_WRITES when data
 digest enabled
Date: Thu, 15 Mar 2018 11:05:27 -0700
Message-ID: <20180315180527.GC32176@straylight.hirudinean.org>
References: <1520425743-1923-1-git-send-email-jianchao.w.wang@oracle.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBCYMVIPVXQMBB27LVLKQKGQER57GB5Y-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Content-Disposition: inline
In-Reply-To: <1520425743-1923-1-git-send-email-jianchao.w.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: Jianchao Wang <jianchao.w.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: lduncan-IBi9RG/b67k@public.gmane.org, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 07, 2018 at 08:29:03PM +0800, Jianchao Wang wrote:
> iscsi tcp will first send out data, then calculate and send data
> digest. If we don't have BDI_CAP_STABLE_WRITES, the page cache will
> be written in spite of the on going writeback. Consequently, wrong
> digest will be got and sent to target.
> 
> To fix this, set BDI_CAP_STABLE_WRITES when data digest is enabled
> in iscsi_tcp .slave_configure callback.
> 
> Signed-off-by: Jianchao Wang <jianchao.w.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/scsi/iscsi_tcp.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 6198559..261c686 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -37,6 +37,7 @@
>  #include <linux/kfifo.h>
>  #include <linux/scatterlist.h>
>  #include <linux/module.h>
> +#include <linux/backing-dev.h>
>  #include <net/tcp.h>
>  #include <scsi/scsi_cmnd.h>
>  #include <scsi/scsi_device.h>
> @@ -954,6 +955,12 @@ static int iscsi_sw_tcp_slave_alloc(struct scsi_device *sdev)
>  
>  static int iscsi_sw_tcp_slave_configure(struct scsi_device *sdev)
>  {
> +	struct iscsi_sw_tcp_host *tcp_sw_host = iscsi_host_priv(sdev->host);
> +	struct iscsi_session *session = tcp_sw_host->session;
> +	struct iscsi_conn *conn = session->leadconn;
> +
> +	if (conn->datadgst_en)
> +		sdev->request_queue->backing_dev_info->capabilities |= BDI_CAP_STABLE_WRITES;
>  	blk_queue_bounce_limit(sdev->request_queue, BLK_BOUNCE_ANY);
>  	blk_queue_dma_alignment(sdev->request_queue, 0);
>  	return 0;
> -- 

Thanks for fixing this issue with data digests!

Signed-off-by: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
