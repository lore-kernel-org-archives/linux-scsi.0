From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 6/6] virtio-scsi: Enable DIF/DIX modes in SCSI host LLD
Date: Mon, 07 Apr 2014 01:40:57 -0700
Message-ID: <1396860057.19888.20.camel@haakon3.risingtidesystems.com>
References: <1396819929-29687-1-git-send-email-nab@daterainc.com>
	 <1396819929-29687-7-git-send-email-nab@daterainc.com>
	 <53425BC4.4040707@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <53425BC4.4040707@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2014-04-07 at 11:03 +0300, Sagi Grimberg wrote:
> On 4/7/2014 12:32 AM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> >
> > This patch updates virtscsi_probe() to setup necessary Scsi_Host
> > level protection resources. (currently hardcoded to 1)
> >
> > It changes virtscsi_add_cmd() to attach outgoing / incoming
> > protection SGLs preceeding the data payload, and is using the
> > new virtio_scsi_cmd_req_pi->d[oi],pi_niv field to signal
> > to signal to vhost/scsi how many prot_sgs to expect.
> >
> > v3 changes:
> >    - Use VIRTIO_SCSI_F_T10_PI to determine PI or non PI header (Paolo)
> >
> > v2 changes:
> >    - Make protection buffer come before data buffer (Paolo)
> >    - Enable virtio_scsi_cmd_req_pi usage (Paolo)
> >
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Michael S. Tsirkin <mst@redhat.com>
> > Cc: Martin K. Petersen <martin.petersen@oracle.com>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >   drivers/scsi/virtio_scsi.c |   78 ++++++++++++++++++++++++++++++++++----------
> >   1 file changed, 60 insertions(+), 18 deletions(-)
> >
> > diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> > index 16bfd50..68d8d1b 100644
> > --- a/drivers/scsi/virtio_scsi.c
> > +++ b/drivers/scsi/virtio_scsi.c
> > @@ -37,6 +37,7 @@ struct virtio_scsi_cmd {
> >   	struct completion *comp;
> >   	union {
> >   		struct virtio_scsi_cmd_req       cmd;
> > +		struct virtio_scsi_cmd_req_pi    cmd_pi;
> >   		struct virtio_scsi_ctrl_tmf_req  tmf;
> >   		struct virtio_scsi_ctrl_an_req   an;
> >   	} req;
> > @@ -440,7 +441,7 @@ static int virtscsi_add_cmd(struct virtqueue *vq,
> >   			    size_t req_size, size_t resp_size, gfp_t gfp)
> >   {
> >   	struct scsi_cmnd *sc = cmd->sc;
> > -	struct scatterlist *sgs[4], req, resp;
> > +	struct scatterlist *sgs[6], req, resp;
> >   	struct sg_table *out, *in;
> >   	unsigned out_num = 0, in_num = 0;
> >   
> > @@ -458,16 +459,24 @@ static int virtscsi_add_cmd(struct virtqueue *vq,
> >   	sgs[out_num++] = &req;
> >   
> >   	/* Data-out buffer.  */
> > -	if (out)
> > +	if (out) {
> > +		/* Place WRITE protection SGLs before Data OUT payload */
> > +		if (scsi_prot_sg_count(sc))
> 
> Didn't we agree that the LLD should not discard the scmnd prot_op? Martin?
> 

Without the initiator providing a protection buffer, there is not much
else that can be done here.

So for the special case where the protect CDB is set, but no protection
buffer is provided, the WRITE_INSERT / READ_STRIP emulation should kick
in on the target side.

--nab

> > +			sgs[out_num++] = scsi_prot_sglist(sc);
> >   		sgs[out_num++] = out->sgl;
> > +	}
> >   
> >   	/* Response header.  */
> >   	sg_init_one(&resp, &cmd->resp, resp_size);
> >   	sgs[out_num + in_num++] = &resp;
> >   
> >   	/* Data-in buffer */
> > -	if (in)
> > +	if (in) {
> > +		/* Place READ protection SGLs before Data IN payload */
> > +		if (scsi_prot_sg_count(sc))
> 
> Same here.
> 
> > +			sgs[out_num + in_num++] = scsi_prot_sglist(sc);
> >   		sgs[out_num + in_num++] = in->sgl;
> > +	}
> >   
> >   	return virtqueue_add_sgs(vq, sgs, out_num, in_num, cmd, gfp);
> >   }
> >
