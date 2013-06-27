From: Asias He <asias@redhat.com>
Subject: Re: [PATCH 8/9] vhost/scsi: Drop unnecessary wait_for_tasks=true
 usage with transport_generic_free_cmd
Date: Thu, 27 Jun 2013 09:59:12 +0800
Message-ID: <20130627015912.GA4133@hj.localdomain>
References: <1370640864-15568-1-git-send-email-nab@linux-iscsi.org>
 <1370640864-15568-9-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1370640864-15568-9-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, Kent Overstreet <koverstreet@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, Or Gerlitz <ogerlitz@mellanox.com>, Moussa Ba <moussaba@micron.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 07, 2013 at 09:34:23PM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch changes vhost_scsi_free_cmd() to call transport_generic_free_cmd()
> with wait_for_tasks=false in order to avoid the extra se_cmd->t_state_lock
> access for the wait_for_tasks=true case.
> 
> This is unnecessary because vhost_scsi_free_cmd() is only ever called by
> vhost_scsi_complete_cmd_work() after TCM completion handoff, and by
> vhost_scsi_handle_vq() exception code before TCM submission handoff, so
> there is never a case where se_cmd is still active from TCM's perspective
> when transport_generic_free_cmd() is called.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Roland Dreier <roland@kernel.org>
> Cc: Kent Overstreet <koverstreet@google.com>
> Cc: Asias He <asias@redhat.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Or Gerlitz <ogerlitz@mellanox.com>
> Cc: Moussa Ba <moussaba@micron.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

Acked-by: Asias He <asias@redhat.com>

> ---
>  drivers/vhost/scsi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index 7014202..aacf71e 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -557,7 +557,7 @@ static void vhost_scsi_free_cmd(struct tcm_vhost_cmd *tv_cmd)
>  	struct se_cmd *se_cmd = &tv_cmd->tvc_se_cmd;
>  
>  	/* TODO locking against target/backend threads? */
> -	transport_generic_free_cmd(se_cmd, 1);
> +	transport_generic_free_cmd(se_cmd, 0);
>  
>  	if (tv_cmd->tvc_sgl_count) {
>  		u32 i;
> -- 
> 1.7.2.5
> 

-- 
Asias
