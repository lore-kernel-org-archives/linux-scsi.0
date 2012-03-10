From: Hu Tao <hutao@cn.fujitsu.com>
Subject: Re: [PATCH v3 2/2] virtio-scsi: add error handling
Date: Sat, 10 Mar 2012 16:48:07 +0800
Message-ID: <20120310084806.GB24958@localhost.localdomain>
References: <1324296188-3426-1-git-send-email-pbonzini@redhat.com>
 <1324296188-3426-3-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:50816 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab2CKEBE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Mar 2012 23:01:04 -0500
In-Reply-To: <1324296188-3426-3-git-send-email-pbonzini@redhat.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Mike Christie <michaelc@cs.wisc.edu>

On Mon, Dec 19, 2011 at 01:03:08PM +0100, Paolo Bonzini wrote:

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
> @@ -306,12 +308,79 @@ out:
>  	return ret;
>  }
>  
> +static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
> +{
> +	DECLARE_COMPLETION_ONSTACK(comp);
> +	int ret;
> +
> +	cmd->comp = &comp;
> +	ret = virtscsi_kick_cmd(vscsi, vscsi->ctrl_vq, cmd);
> +	if (ret < 0)
> +		return FAILED;
> +
> +	wait_for_completion(&comp);
> +	if (cmd->resp.tmf.response != VIRTIO_SCSI_S_OK &&
> +	    cmd->resp.tmf.response != VIRTIO_SCSI_S_FUNCTION_SUCCEEDED)
> +		return FAILED;

Is there a race here that the cmd may have been already freed (by
virtscsi_complete_free) after waking up from the completion?

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 3f20678..7cba05d 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -175,7 +175,8 @@ static void virtscsi_complete_free(void *buf)
 
        if (cmd->comp)
                complete_all(cmd->comp);
-       mempool_free(cmd, virtscsi_cmd_pool);
+       else
+               mempool_free(cmd, virtscsi_cmd_pool);
 }
 
 static void virtscsi_ctrl_done(struct virtqueue *vq)
@@ -305,7 +306,7 @@ out:
 static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
 {
        DECLARE_COMPLETION_ONSTACK(comp);
-       int ret;
+       int ret = SUCCESS;
 
        cmd->comp = &comp;
        ret = virtscsi_kick_cmd(vscsi, vscsi->ctrl_vq, cmd);
@@ -315,9 +316,10 @@ static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
        wait_for_completion(&comp);
        if (cmd->resp.tmf.response != VIRTIO_SCSI_S_OK &&
            cmd->resp.tmf.response != VIRTIO_SCSI_S_FUNCTION_SUCCEEDED)
-               return FAILED;
+               ret = FAILED;
 
-       return SUCCESS;
+       mempool_free(cmd, virtscsi_cmd_pool);
+       return ret;
 }
 
 static int virtscsi_device_reset(struct scsi_cmnd *sc)


> +
> +	return SUCCESS;
> +}

-- 
Thanks,
Hu Tao
