Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CABDC4724C
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 15:18:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F30B9208CA
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 15:18:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WF4M9VBw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgD3PSR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 11:18:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46108 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726419AbgD3PSR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2020 11:18:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588259896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gT1RiBxRO1MeINtxb4Edq656Z+GZYmFg7eLqaOJyLD0=;
        b=WF4M9VBwFo3rWZDggYnJhxYTeilIS7IXw/0aBDFro7A+m5ZiKn1grPXrXUQ23BNyrEU6aq
        r3TKTN8qTS4JexxydeVqAZPbBP8gkn0oA3u8aCHuVWq/pHaKXooslGQYYEoW0wnYb1w6Yh
        b/DV86N9f86Opqj8sk7PNiIw+FEH1g0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-2NhTOm7rMRm_GoHlJXdfXg-1; Thu, 30 Apr 2020 11:18:11 -0400
X-MC-Unique: 2NhTOm7rMRm_GoHlJXdfXg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF1BA462;
        Thu, 30 Apr 2020 15:18:09 +0000 (UTC)
Received: from T590 (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 19A3E610B0;
        Thu, 30 Apr 2020 15:17:58 +0000 (UTC)
Date:   Thu, 30 Apr 2020 23:17:53 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH RFC v3 06/41] virtio_scsi: use reserved commands for TMF
Message-ID: <20200430151753.GC1005453@T590>
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-7-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430131904.5847-7-hare@suse.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 30, 2020 at 03:18:29PM +0200, Hannes Reinecke wrote:
> From: Hannes Reinecke <hare@suse.com>
> 
> Set two commands aside for TMF, and use reserved commands to issue
> TMFs. With that we can drop the TMF memory pool.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/virtio_scsi.c | 105 ++++++++++++++++++---------------------------
>  1 file changed, 41 insertions(+), 64 deletions(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 0e0910c5b942..26054c29d897 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -35,10 +35,10 @@
>  #define VIRTIO_SCSI_MEMPOOL_SZ 64
>  #define VIRTIO_SCSI_EVENT_LEN 8
>  #define VIRTIO_SCSI_VQ_BASE 2
> +#define VIRTIO_SCSI_RESERVED_CMDS 2
>  
>  /* Command queue element */
>  struct virtio_scsi_cmd {
> -	struct scsi_cmnd *sc;
>  	struct completion *comp;
>  	union {
>  		struct virtio_scsi_cmd_req       cmd;
> @@ -86,9 +86,6 @@ struct virtio_scsi {
>  	struct virtio_scsi_vq req_vqs[];
>  };
>  
> -static struct kmem_cache *virtscsi_cmd_cache;
> -static mempool_t *virtscsi_cmd_pool;
> -
>  static inline struct Scsi_Host *virtio_scsi_host(struct virtio_device *vdev)
>  {
>  	return vdev->priv;
> @@ -108,7 +105,7 @@ static void virtscsi_compute_resid(struct scsi_cmnd *sc, u32 resid)
>  static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
>  {
>  	struct virtio_scsi_cmd *cmd = buf;
> -	struct scsi_cmnd *sc = cmd->sc;
> +	struct scsi_cmnd *sc = scsi_cmd_from_priv(cmd);
>  	struct virtio_scsi_cmd_resp *resp = &cmd->resp.cmd;
>  
>  	dev_dbg(&sc->device->sdev_gendev,
> @@ -406,7 +403,7 @@ static int __virtscsi_add_cmd(struct virtqueue *vq,
>  			    struct virtio_scsi_cmd *cmd,
>  			    size_t req_size, size_t resp_size)
>  {
> -	struct scsi_cmnd *sc = cmd->sc;
> +	struct scsi_cmnd *sc = scsi_cmd_from_priv(cmd);
>  	struct scatterlist *sgs[6], req, resp;
>  	struct sg_table *out, *in;
>  	unsigned out_num = 0, in_num = 0;
> @@ -557,8 +554,6 @@ static int virtscsi_queuecommand(struct Scsi_Host *shost,
>  	dev_dbg(&sc->device->sdev_gendev,
>  		"cmd %p CDB: %#02x\n", sc, sc->cmnd[0]);
>  
> -	cmd->sc = sc;
> -
>  	BUG_ON(sc->cmd_len > VIRTIO_SCSI_CDB_SIZE);
>  
>  #ifdef CONFIG_BLK_DEV_INTEGRITY
> @@ -590,17 +585,17 @@ static int virtscsi_queuecommand(struct Scsi_Host *shost,
>  static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
>  {
>  	DECLARE_COMPLETION_ONSTACK(comp);
> -	int ret = FAILED;
>  
>  	cmd->comp = &comp;
> +
>  	if (virtscsi_add_cmd(&vscsi->ctrl_vq, cmd,
>  			      sizeof cmd->req.tmf, sizeof cmd->resp.tmf, true) < 0)
> -		goto out;
> +		return FAILED;
>  
>  	wait_for_completion(&comp);
>  	if (cmd->resp.tmf.response == VIRTIO_SCSI_S_OK ||
>  	    cmd->resp.tmf.response == VIRTIO_SCSI_S_FUNCTION_SUCCEEDED)
> -		ret = SUCCESS;
> +		return SUCCESS;
>  
>  	/*
>  	 * The spec guarantees that all requests related to the TMF have
> @@ -613,33 +608,36 @@ static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
>  	 * REQ_ATOM_COMPLETE has been set.
>  	 */
>  	virtscsi_poll_requests(vscsi);
> -
> -out:
> -	mempool_free(cmd, virtscsi_cmd_pool);
> -	return ret;
> +	return FAILED;
>  }
>  
>  static int virtscsi_device_reset(struct scsi_cmnd *sc)
>  {
> +	struct scsi_device *sdev = sc->device;
> +	struct scsi_cmnd *reset_sc;
>  	struct virtio_scsi *vscsi = shost_priv(sc->device->host);
>  	struct virtio_scsi_cmd *cmd;
> +	int rc;
>  
> -	sdev_printk(KERN_INFO, sc->device, "device reset\n");
> -	cmd = mempool_alloc(virtscsi_cmd_pool, GFP_NOIO);
> -	if (!cmd)
> +	sdev_printk(KERN_INFO, sdev, "device reset\n");
> +	reset_sc = scsi_get_reserved_cmd(sdev, DMA_NONE);
> +	if (!reset_sc)
>  		return FAILED;
> -
> +	cmd = scsi_cmd_priv(reset_sc);
>  	memset(cmd, 0, sizeof(*cmd));
>  	cmd->req.tmf = (struct virtio_scsi_ctrl_tmf_req){
>  		.type = VIRTIO_SCSI_T_TMF,
>  		.subtype = cpu_to_virtio32(vscsi->vdev,
>  					     VIRTIO_SCSI_T_TMF_LOGICAL_UNIT_RESET),
>  		.lun[0] = 1,
> -		.lun[1] = sc->device->id,
> -		.lun[2] = (sc->device->lun >> 8) | 0x40,
> -		.lun[3] = sc->device->lun & 0xff,
> +		.lun[1] = sdev->id,
> +		.lun[2] = (sdev->lun >> 8) | 0x40,
> +		.lun[3] = sdev->lun & 0xff,
>  	};
> -	return virtscsi_tmf(vscsi, cmd);
> +	rc = virtscsi_tmf(vscsi, cmd);
> +	scsi_put_reserved_cmd(reset_sc);
> +
> +	return rc;
>  }
>  
>  static int virtscsi_device_alloc(struct scsi_device *sdevice)
> @@ -679,25 +677,31 @@ static int virtscsi_change_queue_depth(struct scsi_device *sdev, int qdepth)
>  
>  static int virtscsi_abort(struct scsi_cmnd *sc)
>  {
> -	struct virtio_scsi *vscsi = shost_priv(sc->device->host);
> +	struct scsi_device *sdev = sc->device;
> +	struct scsi_cmnd *reset_sc;
> +	struct virtio_scsi *vscsi = shost_priv(sdev->host);
>  	struct virtio_scsi_cmd *cmd;
> +	int rc;
>  
>  	scmd_printk(KERN_INFO, sc, "abort\n");
> -	cmd = mempool_alloc(virtscsi_cmd_pool, GFP_NOIO);
> -	if (!cmd)
> +	reset_sc = scsi_get_reserved_cmd(sdev, DMA_NONE);
> +	if (!reset_sc)
>  		return FAILED;
> +	cmd = scsi_cmd_priv(reset_sc);
>  
>  	memset(cmd, 0, sizeof(*cmd));
>  	cmd->req.tmf = (struct virtio_scsi_ctrl_tmf_req){
>  		.type = VIRTIO_SCSI_T_TMF,
>  		.subtype = VIRTIO_SCSI_T_TMF_ABORT_TASK,
>  		.lun[0] = 1,
> -		.lun[1] = sc->device->id,
> -		.lun[2] = (sc->device->lun >> 8) | 0x40,
> -		.lun[3] = sc->device->lun & 0xff,
> +		.lun[1] = sdev->id,
> +		.lun[2] = (sdev->lun >> 8) | 0x40,
> +		.lun[3] = sdev->lun & 0xff,
>  		.tag = cpu_to_virtio64(vscsi->vdev, (unsigned long)sc),
>  	};
> -	return virtscsi_tmf(vscsi, cmd);
> +	rc = virtscsi_tmf(vscsi, cmd);
> +	scsi_put_reserved_cmd(reset_sc);
> +	return rc;
>  }
>  
>  static int virtscsi_map_queues(struct Scsi_Host *shost)
> @@ -865,6 +869,11 @@ static int virtscsi_probe(struct virtio_device *vdev)
>  		goto virtscsi_init_failed;
>  
>  	shost->can_queue = virtqueue_get_vring_size(vscsi->req_vqs[0].vq);
> +	shost->can_queue -= VIRTIO_SCSI_RESERVED_CMDS;

I guess it should have been '+=', right?

Thanks,
Ming

