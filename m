From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/3] osd_initiator: support bio chains
Date: Mon, 27 Apr 2009 19:02:44 +0300
Message-ID: <49F5D724.8030802@panasas.com>
References: <20090402015455.GA14087@havoc.gtf.org> <20090407225302.GA14248@havoc.gtf.org> <20090410114821.GA10602@havoc.gtf.org> <20090410114908.GB10602@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090410114908.GB10602@havoc.gtf.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, Andrew Morton <akpm@linux-foundation.org>, James.Bottomley@HansenPartnership.com, osd-dev@open-osd.org, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 04/10/2009 02:49 PM, Jeff Garzik wrote:
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> ---
>  drivers/scsi/osd/osd_initiator.c |   83 +++++++++++++++++++++++++++++++--------
>  1 file changed, 67 insertions(+), 16 deletions(-)
> 

Some of my comments below will be more clear after reading the 
comments to the next patch

> diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
> index 2a5f077..2d35d65 100644
> --- a/drivers/scsi/osd/osd_initiator.c
> +++ b/drivers/scsi/osd/osd_initiator.c
> @@ -709,14 +709,36 @@ EXPORT_SYMBOL(osd_req_remove_object);
>  	struct osd_obj_id *first, struct osd_obj_id_list *list, unsigned nelem);
>  */
>  
> +static unsigned int bio_chain_size(struct bio *bio)
> +{
> +	unsigned int chain_size = 0;
> +
> +	while (bio) {
> +		chain_size += bio->bi_size;
> +		bio = bio->bi_next;
> +	}
> +
> +	return chain_size;
> +}
> +

This will not be needed see below.

>  void osd_req_write(struct osd_request *or,
>  	const struct osd_obj_id *obj, struct bio *bio, u64 offset)

-	const struct osd_obj_id *obj, struct bio *bio, u64 offset)
+	const struct osd_obj_id *obj, struct bio *bio, u64 total_bytes, u64 offset)

>  {
> -	_osd_req_encode_common(or, OSD_ACT_WRITE, obj, offset, bio->bi_size);
> +	unsigned int chain_size = 0;
> +	struct bio *tmp_bio = bio;
> +
> +	while (tmp_bio) {
> +		chain_size += tmp_bio->bi_size;
> +		tmp_bio->bi_rw |= (1 << BIO_RW);
> +
> +		tmp_bio = tmp_bio->bi_next;
> +	}
> +

Is not needed bio->bi_rw should be taken care of, in bio_clone()
and chain_size is total_bytes received.

> +	_osd_req_encode_common(or, OSD_ACT_WRITE, obj, offset, chain_size);
>  	WARN_ON(or->out.bio || or->out.total_bytes);
> -	bio->bi_rw |= (1 << BIO_RW);
> +
>  	or->out.bio = bio;
> -	or->out.total_bytes = bio->bi_size;
> +	or->out.total_bytes = chain_size;
>  }
>  EXPORT_SYMBOL(osd_req_write);
>  
> @@ -747,11 +769,21 @@ EXPORT_SYMBOL(osd_req_flush_object);
>  void osd_req_read(struct osd_request *or,
>  	const struct osd_obj_id *obj, struct bio *bio, u64 offset)

same here

>  {
> -	_osd_req_encode_common(or, OSD_ACT_READ, obj, offset, bio->bi_size);
> +	unsigned int chain_size = 0;
> +	struct bio *tmp_bio = bio;
> +
> +	while (tmp_bio) {
> +		chain_size += tmp_bio->bi_size;
> +		tmp_bio->bi_rw &= ~(1 << BIO_RW);
> +
> +		tmp_bio = tmp_bio->bi_next;
> +	}
> +

and here

> +	_osd_req_encode_common(or, OSD_ACT_READ, obj, offset, chain_size);
>  	WARN_ON(or->in.bio || or->in.total_bytes);
> -	bio->bi_rw &= ~(1 << BIO_RW);
> +
>  	or->in.bio = bio;
> -	or->in.total_bytes = bio->bi_size;
> +	or->in.total_bytes = chain_size;
>  }
>  EXPORT_SYMBOL(osd_req_read);
>  
> @@ -1176,7 +1208,7 @@ static int _osd_req_finalize_data_integrity(struct osd_request *or,
>  		unsigned pad;
>  
>  		or->out_data_integ.data_bytes = cpu_to_be64(
> -			or->out.bio ? or->out.bio->bi_size : 0);
> +			or->out.bio ? bio_chain_size(or->out.bio) : 0);

here we have or->out.total_bytes set properly at this stage
(This will also work well when in the future we will support
 CDB-CONTINUATION which is yet another segment in out buffer)

>  		or->out_data_integ.set_attributes_bytes = cpu_to_be64(
>  			or->set_attr.total_bytes);
>  		or->out_data_integ.get_attributes_bytes = cpu_to_be64(
> @@ -1269,6 +1301,7 @@ int osd_finalize_request(struct osd_request *or,
>  	struct osd_cdb_head *cdbh = osd_cdb_head(&or->cdb);
>  	bool has_in, has_out;
>  	int ret;
> +	struct bio *bio, *tmp;
>  
>  	if (options & OSD_REQ_FUA)
>  		cdbh->options |= OSD_CDB_FUA;
> @@ -1292,23 +1325,40 @@ int osd_finalize_request(struct osd_request *or,
>  	}
>  
>  	if (or->out.bio) {
> -		ret = blk_rq_append_bio(or->request->q, or->out.req,
> -					or->out.bio);
> -		if (ret) {
> -			OSD_DEBUG("blk_rq_append_bio out failed\n");
> -			return ret;
> +		bio = or->out.bio;
> +		while (bio) {
> +			tmp = bio;
> +			bio = bio->bi_next;
> +
> +			ret = blk_rq_append_bio(or->request->q, or->out.req,
> +						tmp);
> +			if (ret) {
> +				OSD_DEBUG("blk_rq_append_bio out failed\n");
> +				return ret;
> +			}
>  		}
>  		OSD_DEBUG("out bytes=%llu (bytes_req=%u)\n",
>  			_LLU(or->out.total_bytes), or->out.req->data_len);
> +
> +		or->out.bio = NULL;
>  	}
>  	if (or->in.bio) {
> -		ret = blk_rq_append_bio(or->request->q, or->in.req, or->in.bio);
> -		if (ret) {
> -			OSD_DEBUG("blk_rq_append_bio in failed\n");
> -			return ret;
> +		bio = or->in.bio;
> +		while (bio) {
> +			tmp = bio;
> +			bio = bio->bi_next;
> +
> +			ret = blk_rq_append_bio(or->request->q, or->in.req,
> +						tmp);
> +			if (ret) {
> +				OSD_DEBUG("blk_rq_append_bio in failed\n");
> +				return ret;
> +			}

OK a loop here is plain hack, but two loops is a blasphemy. Specially over
"wants to die" API. If at all, then it needs an helper that will be later
pushed to block-layer.

I have an RFC in place that makes use of a new blk_make_request(bio, total_bytes, ...)
It should be enhanced to properly support chained-bios.

I will send this patch rebased on top of that RFC so it will be ready for
the osdblk patch.

>  		}
>  		OSD_DEBUG("in bytes=%llu (bytes_req=%u)\n",
>  			_LLU(or->in.total_bytes), or->in.req->data_len);
> +
> +		or->in.bio = NULL;
>  	}
>  
>  	or->out.pad_buff = sg_out_pad_buffer;
> @@ -1618,6 +1668,7 @@ void osd_sec_sign_cdb(struct osd_cdb *ocdb __unused, const u8 *cap_key __unused)
>  void osd_sec_sign_data(void *data_integ __unused,
>  		       struct bio *bio __unused, const u8 *cap_key __unused)
>  {
> +	/* NOTE: bio is a linked list */

Yep, that was the original idea. Please note that even with a single bio submitted at osd_req_read/write
today, at this point they are already chained with up to 4 additional segments.

>  }
>  
>  /*


Thanks Jeff. I now understand what is needed to support chained-bios
Please let me refresh my RFC to block-layer and add this patch to the patchset.

Then your osdblk patch can apply on top of that. That will also create some
needed pressure for this work to be done.

Sincerely yours
Boaz
