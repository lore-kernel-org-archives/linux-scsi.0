From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 03/11] block: add rq->resid_len
Date: Sun, 10 May 2009 17:07:39 +0300
Message-ID: <4A06DFAB.40205@panasas.com>
References: <1241423927-11871-1-git-send-email-tj@kernel.org> <1241423927-11871-4-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1241423927-11871-4-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, Doug Gilbert <dgilbert@interlog.com>, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 05/04/2009 10:58 AM, Tejun Heo wrote:
> rq->data_len served two purposes - the length of data buffer on issue
> and the residual count on completion.  This duality creates some
> headaches.
> 
> First of all, block layer and low level drivers can't really determine
> what rq->data_len contains while a request is executing.  It could be
> the total request length or it coulde be anything else one of the
> lower layers is using to keep track of residual count.  This
> complicates things because blk_rq_bytes() and thus
> [__]blk_end_request_all() relies on rq->data_len for PC commands.
> Drivers which want to report residual count should first cache the
> total request length, update rq->data_len and then complete the
> request with the cached data length.
> 
> Secondly, it makes requests default to reporting full residual count,
> ie. reporting that no data transfer occurred.  The residual count is
> an exception not the norm; however, the driver should clear
> rq->data_len to zero to signify the normal cases while leaving it
> alone means no data transfer occurred at all.  This reverse default
> behavior complicates code unnecessarily and renders block PC on some
> drivers (ide-tape/floppy) unuseable.
> 
> This patch adds rq->resid_len which is used only for residual count.
> 
> While at it, remove now unnecessasry blk_rq_bytes() caching in
> ide_pc_intr() as rq->data_len is not changed anymore.
> 
> Boaz: spotted missing conversion in osd.
> 
> [ Impact: cleanup residual count handling, report 0 resid by default ]
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Cc: Borislav Petkov <petkovbb@googlemail.com>
> Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> Cc: Mike Miller <mike.miller@hp.com>
> Cc: Eric Moore <Eric.Moore@lsi.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Doug Gilbert <dgilbert@interlog.com>
> Cc: Mike Miller <mike.miller@hp.com>
> Cc: Eric Moore <Eric.Moore@lsi.com>
> Cc: Darrick J. Wong <djwong@us.ibm.com>
> Cc: Pete Zaitcev <zaitcev@redhat.com>
> Cc: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  block/bsg.c                              |    8 +++---
>  block/scsi_ioctl.c                       |    2 +-
<snip>
>  drivers/message/fusion/mptsas.c          |    3 +-
>  drivers/scsi/libsas/sas_expander.c       |    6 +----
>  drivers/scsi/libsas/sas_host_smp.c       |   38 +++++++++++++++--------------
>  drivers/scsi/mpt2sas/mpt2sas_transport.c |    4 +--
>  drivers/scsi/scsi_lib.c                  |   24 +++++++++---------
>  drivers/scsi/sg.c                        |    2 +-
>  drivers/scsi/st.c                        |    2 +-
>  fs/exofs/osd.c                           |    4 +-
>  include/linux/blkdev.h                   |    1 +
>  16 files changed, 59 insertions(+), 80 deletions(-)
> 

Hi Tejun, I've carefully reviewed these files which I know more about.
The drivers/block files I've skipped, since I'm not familiar with this code.

Except a small fallout, it looks very good. See some comments plus Ack/review below

Thank you for doing this.

> diff --git a/block/bsg.c b/block/bsg.c
> index 206060e..2d746e3 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -445,14 +445,14 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
>  	}
>  
>  	if (rq->next_rq) {
> -		hdr->dout_resid = rq->data_len;
> -		hdr->din_resid = rq->next_rq->data_len;
> +		hdr->dout_resid = rq->resid_len;
> +		hdr->din_resid = rq->next_rq->resid_len;
>  		blk_rq_unmap_user(bidi_bio);
>  		blk_put_request(rq->next_rq);
>  	} else if (rq_data_dir(rq) == READ)
> -		hdr->din_resid = rq->data_len;
> +		hdr->din_resid = rq->resid_len;
>  	else
> -		hdr->dout_resid = rq->data_len;
> +		hdr->dout_resid = rq->resid_len;
>  
>  	/*
>  	 * If the request generated a negative error number, return it

Reviewed-by: Boaz Harrosh <bharrosh@panasas.com>

> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
> index 58cf456..a9670dd 100644
> --- a/block/scsi_ioctl.c
> +++ b/block/scsi_ioctl.c
> @@ -230,7 +230,7 @@ static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
>  	hdr->info = 0;
>  	if (hdr->masked_status || hdr->host_status || hdr->driver_status)
>  		hdr->info |= SG_INFO_CHECK;
> -	hdr->resid = rq->data_len;
> +	hdr->resid = rq->resid_len;
>  	hdr->sb_len_wr = 0;
>  
>  	if (rq->sense_len && hdr->sbp) {

Reviewed-by: Boaz Harrosh <bharrosh@panasas.com>

<snip>
> diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
> index a9019f0..5d5f347 100644
> --- a/drivers/message/fusion/mptsas.c
> +++ b/drivers/message/fusion/mptsas.c
> @@ -1357,8 +1357,7 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
>  		smprep = (SmpPassthroughReply_t *)ioc->sas_mgmt.reply;
>  		memcpy(req->sense, smprep, sizeof(*smprep));
>  		req->sense_len = sizeof(*smprep);
> -		req->data_len = 0;
> -		rsp->data_len -= smprep->ResponseDataLength;
> +		rsp->resid_len = rsp->data_len - smprep->ResponseDataLength;
>  	} else {
>  		printk(MYIOC_s_ERR_FMT "%s: smp passthru reply failed to be returned\n",
>  		    ioc->name, __func__);

I think original code was assuming full residual count on the else side
(not MPT_IOCTL_STATUS_RF_VALID). So maybe add:

+		rsp->resid_len = rsp->data_len;

> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index 3da02e4..6605ec9 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -1936,12 +1936,8 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
>  			       bio_data(rsp->bio), rsp->data_len);
>  	if (ret > 0) {
>  		/* positive number is the untransferred residual */
> -		rsp->data_len = ret;
> -		req->data_len = 0;
> +		rsp->resid_len = ret;
>  		ret = 0;
> -	} else if (ret == 0) {
> -		rsp->data_len = 0;
> -		req->data_len = 0;
>  	}
>  
>  	return ret;

This is actually a bug fix, as well as a strait conversion

Reviewed-by: Boaz Harrosh <bharrosh@panasas.com>


> diff --git a/drivers/scsi/libsas/sas_host_smp.c b/drivers/scsi/libsas/sas_host_smp.c
> index d110a36..89952ed 100644
> --- a/drivers/scsi/libsas/sas_host_smp.c
> +++ b/drivers/scsi/libsas/sas_host_smp.c
> @@ -134,7 +134,7 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
>  {
>  	u8 *req_data = NULL, *resp_data = NULL, *buf;
>  	struct sas_ha_struct *sas_ha = SHOST_TO_SAS_HA(shost);
> -	int error = -EINVAL, resp_data_len = rsp->data_len;
> +	int error = -EINVAL;
>  
>  	/* eight is the minimum size for request and response frames */
>  	if (req->data_len < 8 || rsp->data_len < 8)
> @@ -176,17 +176,20 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
>  	resp_data[1] = req_data[1];
>  	resp_data[2] = SMP_RESP_FUNC_UNK;
>  
> +	req->resid_len = req->data_len;
> +	rsp->resid_len = rsp->data_len;
> +
>  	switch (req_data[1]) {
>  	case SMP_REPORT_GENERAL:
> -		req->data_len -= 8;
> -		resp_data_len -= 32;
> +		req->resid_len -= 8;
> +		rsp->resid_len -= 32;
>  		resp_data[2] = SMP_RESP_FUNC_ACC;
>  		resp_data[9] = sas_ha->num_phys;
>  		break;
>  
>  	case SMP_REPORT_MANUF_INFO:
> -		req->data_len -= 8;
> -		resp_data_len -= 64;
> +		req->resid_len -= 8;
> +		rsp->resid_len -= 64;
>  		resp_data[2] = SMP_RESP_FUNC_ACC;
>  		memcpy(resp_data + 12, shost->hostt->name,
>  		       SAS_EXPANDER_VENDOR_ID_LEN);
> @@ -199,13 +202,13 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
>  		break;
>  
>  	case SMP_DISCOVER:
> -		req->data_len -= 16;
> -		if ((int)req->data_len < 0) {
> -			req->data_len = 0;
> +		req->resid_len -= 16;
> +		if ((int)req->resid_len < 0) {
> +			req->resid_len = 0;
>  			error = -EINVAL;
>  			goto out;
>  		}
> -		resp_data_len -= 56;
> +		rsp->resid_len -= 56;
>  		sas_host_smp_discover(sas_ha, resp_data, req_data[9]);
>  		break;
>  
> @@ -215,13 +218,13 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
>  		break;
>  
>  	case SMP_REPORT_PHY_SATA:
> -		req->data_len -= 16;
> -		if ((int)req->data_len < 0) {
> -			req->data_len = 0;
> +		req->resid_len -= 16;
> +		if ((int)req->resid_len < 0) {
> +			req->resid_len = 0;
>  			error = -EINVAL;
>  			goto out;
>  		}
> -		resp_data_len -= 60;
> +		rsp->resid_len -= 60;
>  		sas_report_phy_sata(sas_ha, resp_data, req_data[9]);
>  		break;
>  
> @@ -238,13 +241,13 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
>  		break;
>  
>  	case SMP_PHY_CONTROL:
> -		req->data_len -= 44;
> -		if ((int)req->data_len < 0) {
> -			req->data_len = 0;
> +		req->resid_len -= 44;
> +		if ((int)req->resid_len < 0) {
> +			req->resid_len = 0;
>  			error = -EINVAL;
>  			goto out;
>  		}
> -		resp_data_len -= 8;
> +		rsp->resid_len -= 8;
>  		sas_phy_control(sas_ha, req_data[9], req_data[10],
>  				req_data[32] >> 4, req_data[33] >> 4,
>  				resp_data);
> @@ -265,7 +268,6 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
>  	flush_kernel_dcache_page(bio_page(rsp->bio));
>  	kunmap_atomic(buf - bio_offset(rsp->bio), KM_USER0);
>  	local_irq_enable();
> -	rsp->data_len = resp_data_len;
>  
>   out:
>  	kfree(req_data);

Reviewed-by: Boaz Harrosh <bharrosh@panasas.com>

> diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
> index e03dc0b..53759c5 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
> @@ -1170,9 +1170,7 @@ transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
>  
>  		memcpy(req->sense, mpi_reply, sizeof(*mpi_reply));
>  		req->sense_len = sizeof(*mpi_reply);
> -		req->data_len = 0;
> -		rsp->data_len -= mpi_reply->ResponseDataLength;
> -
> +		rsp->resid_len = rsp->data_len - mpi_reply->ResponseDataLength;
>  	} else {
>  		dtransportprintk(ioc, printk(MPT2SAS_DEBUG_FMT
>  		    "%s - no reply\n", ioc->name, __func__));

Here it's the same as in mptsas_smp_handler. The else case was returning full
residual count on error, maybe an:
+		rsp->resid_len = rsp->data_len;

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index aa9fc57..7d49ef5 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -240,11 +240,11 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
>  	 * is invalid.  Prevent the garbage from being misinterpreted
>  	 * and prevent security leaks by zeroing out the excess data.
>  	 */
> -	if (unlikely(req->data_len > 0 && req->data_len <= bufflen))
> -		memset(buffer + (bufflen - req->data_len), 0, req->data_len);
> +	if (unlikely(req->resid_len > 0 && req->resid_len <= bufflen))
> +		memset(buffer + (bufflen - req->resid_len), 0, req->resid_len);
>  
>  	if (resid)
> -		*resid = req->data_len;
> +		*resid = req->resid_len;
>  	ret = req->errors;
>   out:
>  	blk_put_request(req);
> @@ -549,7 +549,7 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
>  		int leftover = (req->hard_nr_sectors << 9);
>  
>  		if (blk_pc_request(req))
> -			leftover = req->data_len;
> +			leftover = req->resid_len;

This is the fallout:

The above is just a case of:

-		int leftover = (req->hard_nr_sectors << 9);
-
-		if (blk_pc_request(req))
-			leftover = req->data_len;
+		int leftover = blk_rq_bytes();

Which you separated into to stages, much later right?

>  
>  		/* kill remainder if no retrys */
>  		if (error && scsi_noretry_cmd(cmd))
> @@ -673,11 +673,11 @@ void scsi_release_buffers(struct scsi_cmnd *cmd)
>  EXPORT_SYMBOL(scsi_release_buffers);
>  
>  /*
> - * Bidi commands Must be complete as a whole, both sides at once.
> - * If part of the bytes were written and lld returned
> - * scsi_in()->resid and/or scsi_out()->resid this information will be left
> - * in req->data_len and req->next_rq->data_len. The upper-layer driver can
> - * decide what to do with this information.
> + * Bidi commands Must be complete as a whole, both sides at once.  If
> + * part of the bytes were written and lld returned scsi_in()->resid
> + * and/or scsi_out()->resid this information will be left in
> + * req->resid_len and req->next_rq->resid_len. The upper-layer driver
> + * can decide what to do with this information.
>   */
>  static void scsi_end_bidi_request(struct scsi_cmnd *cmd)
>  {
> @@ -685,8 +685,8 @@ static void scsi_end_bidi_request(struct scsi_cmnd *cmd)
>  	unsigned int dlen = req->data_len;
>  	unsigned int next_dlen = req->next_rq->data_len;
>  
> -	req->data_len = scsi_out(cmd)->resid;
> -	req->next_rq->data_len = scsi_in(cmd)->resid;
> +	req->resid_len = scsi_out(cmd)->resid;
> +	req->next_rq->resid_len = scsi_in(cmd)->resid;
>  
>  	/* The req and req->next_rq have not been completed */
>  	BUG_ON(blk_end_bidi_request(req, 0, dlen, next_dlen));
> @@ -778,7 +778,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  			scsi_end_bidi_request(cmd);
>  			return;
>  		}
> -		req->data_len = scsi_get_resid(cmd);
> +		req->resid_len = scsi_get_resid(cmd);
>  	}
>  
>  	BUG_ON(blk_bidi_rq(req)); /* bidi not support for !blk_pc_request yet */

Except the fallout the rest of scsi_lib looks good, specifically the bidi_parts.

I'll send a farther cleanup to scsi_lib based on this patchset later.

> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 82312df..dec4c70 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -1260,7 +1260,7 @@ static void sg_rq_end_io(struct request *rq, int uptodate)
>  
>  	sense = rq->sense;
>  	result = rq->errors;
> -	resid = rq->data_len;
> +	resid = rq->resid_len;
>  
>  	SCSI_LOG_TIMEOUT(4, printk("sg_cmd_done: %s, pack_id=%d, res=0x%x\n",
>  		sdp->disk->disk_name, srp->header.pack_id, result));

Reviewed-by: Boaz Harrosh <bharrosh@panasas.com>

> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index eb24efe..8681b70 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -463,7 +463,7 @@ static void st_scsi_execute_end(struct request *req, int uptodate)
>  	struct scsi_tape *STp = SRpnt->stp;
>  
>  	STp->buffer->cmdstat.midlevel_result = SRpnt->result = req->errors;
> -	STp->buffer->cmdstat.residual = req->data_len;
> +	STp->buffer->cmdstat.residual = req->resid_len;
>  
>  	if (SRpnt->waiting)
>  		complete(SRpnt->waiting);

Reviewed-by: Boaz Harrosh <bharrosh@panasas.com>

> diff --git a/fs/exofs/osd.c b/fs/exofs/osd.c
> index b249ae9..06ca926 100644
> --- a/fs/exofs/osd.c
> +++ b/fs/exofs/osd.c
> @@ -50,10 +50,10 @@ int exofs_check_ok_resid(struct osd_request *or, u64 *in_resid, u64 *out_resid)
>  
>  	/* FIXME: should be include in osd_sense_info */
>  	if (in_resid)
> -		*in_resid = or->in.req ? or->in.req->data_len : 0;
> +		*in_resid = or->in.req ? or->in.req->resid_len : 0;
>  
>  	if (out_resid)
> -		*out_resid = or->out.req ? or->out.req->data_len : 0;
> +		*out_resid = or->out.req ? or->out.req->resid_len : 0;
>  
>  	return ret;
>  }

Ack-by: Boaz Harrosh <bharrosh@panasas.com>

<snip>

Dear Tejun.
I've started farther cleanup based on your patchset. However I had a merge conflict
when merging your branch with Linus-2.6.30-rc5, around the block areas, do you know
what that might be? I've continued to work based on your branch alone, but will wait and
post it later once things settle.

Thanks
Boaz
