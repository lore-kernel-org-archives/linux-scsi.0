From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH-v2 6/6] virtio-scsi: Enable DIF/DIX modes in SCSI host
 LLD
Date: Thu, 22 May 2014 10:37:31 +0200
Message-ID: <537DB74B.6010208@redhat.com>
References: <1400725582-5521-1-git-send-email-nab@daterainc.com> <1400725582-5521-7-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1400725582-5521-7-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>
List-Id: linux-scsi@vger.kernel.org

Il 22/05/2014 04:26, Nicholas A. Bellinger ha scritto:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch updates virtscsi_probe() to setup necessary Scsi_Host
> level protection resources. (currently hardcoded to 1)
>
> It changes virtscsi_add_cmd() to attach outgoing / incoming
> protection SGLs preceeding the data payload, and is using the
> new virtio_scsi_cmd_req_pi->d[oi],pi_niv field to signal

Wrong field name in the commit message...

> to signal to vhost/scsi how many prot_sgs to expect.

s/prot_sgs to expect/bytes to expect for protection data/

Apart from this, which can be fixed in the pull request,

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

for getting this in via the target tree.

Paolo

> v4 changes:
>   - Convert virtio_scsi_init_hdr_pi to use pi_bytesout + pi_bytesin
>     (mst + paolo + nab)
>   - Use blk_integrity->tuple_size to calculate pi bytes (nab)
>
> v3 changes:
>   - Use VIRTIO_SCSI_F_T10_PI to determine PI or non PI header (Paolo)
>
> v2 changes:
>   - Make protection buffer come before data buffer (Paolo)
>   - Enable virtio_scsi_cmd_req_pi usage (Paolo)
>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/scsi/virtio_scsi.c |   86 ++++++++++++++++++++++++++++++++++----------
>  1 file changed, 68 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 16bfd50..cc634b0 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -37,6 +37,7 @@ struct virtio_scsi_cmd {
>  	struct completion *comp;
>  	union {
>  		struct virtio_scsi_cmd_req       cmd;
> +		struct virtio_scsi_cmd_req_pi    cmd_pi;
>  		struct virtio_scsi_ctrl_tmf_req  tmf;
>  		struct virtio_scsi_ctrl_an_req   an;
>  	} req;
> @@ -440,7 +441,7 @@ static int virtscsi_add_cmd(struct virtqueue *vq,
>  			    size_t req_size, size_t resp_size, gfp_t gfp)
>  {
>  	struct scsi_cmnd *sc = cmd->sc;
> -	struct scatterlist *sgs[4], req, resp;
> +	struct scatterlist *sgs[6], req, resp;
>  	struct sg_table *out, *in;
>  	unsigned out_num = 0, in_num = 0;
>
> @@ -458,16 +459,24 @@ static int virtscsi_add_cmd(struct virtqueue *vq,
>  	sgs[out_num++] = &req;
>
>  	/* Data-out buffer.  */
> -	if (out)
> +	if (out) {
> +		/* Place WRITE protection SGLs before Data OUT payload */
> +		if (scsi_prot_sg_count(sc))
> +			sgs[out_num++] = scsi_prot_sglist(sc);
>  		sgs[out_num++] = out->sgl;
> +	}
>
>  	/* Response header.  */
>  	sg_init_one(&resp, &cmd->resp, resp_size);
>  	sgs[out_num + in_num++] = &resp;
>
>  	/* Data-in buffer */
> -	if (in)
> +	if (in) {
> +		/* Place READ protection SGLs before Data IN payload */
> +		if (scsi_prot_sg_count(sc))
> +			sgs[out_num + in_num++] = scsi_prot_sglist(sc);
>  		sgs[out_num + in_num++] = in->sgl;
> +	}
>
>  	return virtqueue_add_sgs(vq, sgs, out_num, in_num, cmd, gfp);
>  }
> @@ -492,12 +501,44 @@ static int virtscsi_kick_cmd(struct virtio_scsi_vq *vq,
>  	return err;
>  }
>
> +static void virtio_scsi_init_hdr(struct virtio_scsi_cmd_req *cmd,
> +				 struct scsi_cmnd *sc)
> +{
> +	cmd->lun[0] = 1;
> +	cmd->lun[1] = sc->device->id;
> +	cmd->lun[2] = (sc->device->lun >> 8) | 0x40;
> +	cmd->lun[3] = sc->device->lun & 0xff;
> +	cmd->tag = (unsigned long)sc;
> +	cmd->task_attr = VIRTIO_SCSI_S_SIMPLE;
> +	cmd->prio = 0;
> +	cmd->crn = 0;
> +}
> +
> +static void virtio_scsi_init_hdr_pi(struct virtio_scsi_cmd_req_pi *cmd_pi,
> +				    struct scsi_cmnd *sc)
> +{
> +	struct request *rq = sc->request;
> +	struct blk_integrity *bi;
> +
> +	virtio_scsi_init_hdr((struct virtio_scsi_cmd_req *)cmd_pi, sc);
> +
> +	if (!rq || !scsi_prot_sg_count(sc))
> +		return;
> +
> +	bi = blk_get_integrity(rq->rq_disk);
> +
> +	if (sc->sc_data_direction == DMA_TO_DEVICE)
> +		cmd_pi->pi_bytesout = blk_rq_sectors(rq) * bi->tuple_size;
> +	else if (sc->sc_data_direction == DMA_FROM_DEVICE)
> +		cmd_pi->pi_bytesin = blk_rq_sectors(rq) * bi->tuple_size;
> +}
> +
>  static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
>  				 struct virtio_scsi_vq *req_vq,
>  				 struct scsi_cmnd *sc)
>  {
>  	struct virtio_scsi_cmd *cmd;
> -	int ret;
> +	int ret, req_size;
>
>  	struct Scsi_Host *shost = virtio_scsi_host(vscsi->vdev);
>  	BUG_ON(scsi_sg_count(sc) > shost->sg_tablesize);
> @@ -515,22 +556,20 @@ static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
>
>  	memset(cmd, 0, sizeof(*cmd));
>  	cmd->sc = sc;
> -	cmd->req.cmd = (struct virtio_scsi_cmd_req){
> -		.lun[0] = 1,
> -		.lun[1] = sc->device->id,
> -		.lun[2] = (sc->device->lun >> 8) | 0x40,
> -		.lun[3] = sc->device->lun & 0xff,
> -		.tag = (unsigned long)sc,
> -		.task_attr = VIRTIO_SCSI_S_SIMPLE,
> -		.prio = 0,
> -		.crn = 0,
> -	};
>
>  	BUG_ON(sc->cmd_len > VIRTIO_SCSI_CDB_SIZE);
> -	memcpy(cmd->req.cmd.cdb, sc->cmnd, sc->cmd_len);
>
> -	if (virtscsi_kick_cmd(req_vq, cmd,
> -			      sizeof cmd->req.cmd, sizeof cmd->resp.cmd,
> +	if (virtio_has_feature(vscsi->vdev, VIRTIO_SCSI_F_T10_PI)) {
> +		virtio_scsi_init_hdr_pi(&cmd->req.cmd_pi, sc);
> +		memcpy(cmd->req.cmd_pi.cdb, sc->cmnd, sc->cmd_len);
> +		req_size = sizeof(cmd->req.cmd_pi);
> +	} else {
> +		virtio_scsi_init_hdr(&cmd->req.cmd, sc);
> +		memcpy(cmd->req.cmd.cdb, sc->cmnd, sc->cmd_len);
> +		req_size = sizeof(cmd->req.cmd);
> +	}
> +
> +	if (virtscsi_kick_cmd(req_vq, cmd, req_size, sizeof(cmd->resp.cmd),
>  			      GFP_ATOMIC) == 0)
>  		ret = 0;
>  	else
> @@ -871,7 +910,7 @@ static int virtscsi_probe(struct virtio_device *vdev)
>  {
>  	struct Scsi_Host *shost;
>  	struct virtio_scsi *vscsi;
> -	int err;
> +	int err, host_prot;
>  	u32 sg_elems, num_targets;
>  	u32 cmd_per_lun;
>  	u32 num_queues;
> @@ -921,6 +960,16 @@ static int virtscsi_probe(struct virtio_device *vdev)
>  	shost->max_id = num_targets;
>  	shost->max_channel = 0;
>  	shost->max_cmd_len = VIRTIO_SCSI_CDB_SIZE;
> +
> +	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_T10_PI)) {
> +		host_prot = SHOST_DIF_TYPE1_PROTECTION | SHOST_DIF_TYPE2_PROTECTION |
> +			    SHOST_DIF_TYPE3_PROTECTION | SHOST_DIX_TYPE1_PROTECTION |
> +			    SHOST_DIX_TYPE2_PROTECTION | SHOST_DIX_TYPE3_PROTECTION;
> +
> +		scsi_host_set_prot(shost, host_prot);
> +		scsi_host_set_guard(shost, SHOST_DIX_GUARD_CRC);
> +	}
> +
>  	err = scsi_add_host(shost, &vdev->dev);
>  	if (err)
>  		goto scsi_add_host_failed;
> @@ -990,6 +1039,7 @@ static struct virtio_device_id id_table[] = {
>  static unsigned int features[] = {
>  	VIRTIO_SCSI_F_HOTPLUG,
>  	VIRTIO_SCSI_F_CHANGE,
> +	VIRTIO_SCSI_F_T10_PI,
>  };
>
>  static struct virtio_driver virtio_scsi_driver = {
>
