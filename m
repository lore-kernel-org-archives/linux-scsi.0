From: Hu Tao <hutao@cn.fujitsu.com>
Subject: Re: [PATCH v5 2/3] virtio-scsi: add error handling
Date: Mon, 19 Mar 2012 17:55:29 +0800
Message-ID: <20120319095529.GA25623@localhost.localdomain>
References: <1328440562-19425-1-git-send-email-pbonzini@redhat.com>
 <1328440562-19425-3-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="pWyiEgJYm5f9v55/"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1328440562-19425-3-git-send-email-pbonzini@redhat.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Mike Christie <michaelc@cs.wisc.edu>, Pekka Enberg <penberg@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Sun, Feb 05, 2012 at 12:16:01PM +0100, Paolo Bonzini wrote:
> This commit adds basic error handling to the virtio-scsi
> HBA device.  Task management functions are sent synchronously
> via the control virtqueue.
> 
> Cc: linux-scsi <linux-scsi@vger.kernel.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: kvm@vger.kernel.org
> Acked-by: Pekka Enberg <penberg@kernel.org> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> 	v3->v4: fixed 32-bit compilation; adjusted call to virtscsi_kick_cmd
> 
> 	v2->v3: added mempool, used GFP_NOIO instead of GFP_ATOMIC,
> 	formatting fixes
> 
> 	v1->v2: use scmd_printk
> 
>  drivers/scsi/virtio_scsi.c |   73 +++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 72 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 3f87ae0..68104cd 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -29,6 +29,7 @@
>  /* Command queue element */
>  struct virtio_scsi_cmd {
>  	struct scsi_cmnd *sc;
> +	struct completion *comp;
>  	union {
>  		struct virtio_scsi_cmd_req       cmd;
>  		struct virtio_scsi_ctrl_tmf_req  tmf;
> @@ -168,11 +169,12 @@ static void virtscsi_req_done(struct virtqueue *vq)
>  	virtscsi_vq_done(vq, virtscsi_complete_cmd);
>  };
>  
> -/* These are still stubs.  */
>  static void virtscsi_complete_free(void *buf)
>  {
>  	struct virtio_scsi_cmd *cmd = buf;
>  
> +	if (cmd->comp)
> +		complete_all(cmd->comp);
>  	mempool_free(cmd, virtscsi_cmd_pool);
>  }
>  
> @@ -306,12 +308,81 @@ out:
>  	return ret;
>  }
>  
> +static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
> +{
> +	DECLARE_COMPLETION_ONSTACK(comp);
> +	int ret;
> +
> +	cmd->comp = &comp;
> +	ret = virtscsi_kick_cmd(vscsi, vscsi->ctrl_vq, cmd,
> +			       sizeof cmd->req.tmf, sizeof cmd->resp.tmf,
> +			       GFP_NOIO);
> +	if (ret < 0)
> +		return FAILED;
> +
> +	wait_for_completion(&comp);
> +	if (cmd->resp.tmf.response != VIRTIO_SCSI_S_OK &&
> +	    cmd->resp.tmf.response != VIRTIO_SCSI_S_FUNCTION_SUCCEEDED)
> +		return FAILED;
> +
> +	return SUCCESS;
> +}

Hi Paolo,

This is against v5.


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="0001-fix-race-in-tmf.patch"

>From 34ef5e64fc205044e4326fcc5dcf2aa6b219763a Mon Sep 17 00:00:00 2001
From: Hu Tao <hutao@cn.fujitsu.com>
Date: Mon, 19 Mar 2012 15:58:22 +0800
Subject: [PATCH] fix two problems in tmf

This patch fix two problems in tmf:

  1. race in virtscsi_tmf that the cmd may have been already freed
     when waking up from the completion

  2. cmd leak if virtscsi_kick_cmd fails.


Signed-off-by: Hu Tao <hutao@cn.fujitsu.com>
---
 drivers/scsi/virtio_scsi.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index efccd72..3b8a6e6 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -175,7 +175,8 @@ static void virtscsi_complete_free(void *buf)
 
 	if (cmd->comp)
 		complete_all(cmd->comp);
-	mempool_free(cmd, virtscsi_cmd_pool);
+	else
+		mempool_free(cmd, virtscsi_cmd_pool);
 }
 
 static void virtscsi_ctrl_done(struct virtqueue *vq)
@@ -311,21 +312,23 @@ out:
 static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
 {
 	DECLARE_COMPLETION_ONSTACK(comp);
-	int ret;
+	int ret = FAILED;
 
 	cmd->comp = &comp;
 	ret = virtscsi_kick_cmd(vscsi, vscsi->ctrl_vq, cmd,
 			       sizeof cmd->req.tmf, sizeof cmd->resp.tmf,
 			       GFP_NOIO);
 	if (ret < 0)
-		return FAILED;
+		goto failed;
 
 	wait_for_completion(&comp);
-	if (cmd->resp.tmf.response != VIRTIO_SCSI_S_OK &&
-	    cmd->resp.tmf.response != VIRTIO_SCSI_S_FUNCTION_SUCCEEDED)
-		return FAILED;
+	if (cmd->resp.tmf.response == VIRTIO_SCSI_S_OK ||
+	    cmd->resp.tmf.response == VIRTIO_SCSI_S_FUNCTION_SUCCEEDED)
+		ret = SUCCESS;
 
-	return SUCCESS;
+failed:
+	mempool_free(cmd, virtscsi_cmd_pool);
+	return ret;
 }
 
 static int virtscsi_device_reset(struct scsi_cmnd *sc)
-- 
1.7.1


--pWyiEgJYm5f9v55/--
