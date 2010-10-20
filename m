From: John Chandy <john.chandy@uconn.edu>
Subject: Re: [PATCH 4/4] libosd: write/read_sg_kern API
Date: Wed, 20 Oct 2010 10:28:37 -0400
Message-ID: <CEBBEE5F-61C6-4803-A25A-75E8A58984A2@uconn.edu>
References: <4CBD8CAB.2030207@panasas.com> <1287490962-24013-1-git-send-email-bharrosh@panasas.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ecs-ex10-cas2.engr.uconn.edu ([137.99.15.237]:31441 "EHLO
	mail.engr.uconn.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752866Ab0JTOeF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2010 10:34:05 -0400
In-Reply-To: <1287490962-24013-1-git-send-email-bharrosh@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@suse.de>, open-osd <osd-dev@open-osd.org>, linux-scsi <linux-scsi@vger.kernel.org>

I don't need these, but I thought that they might be helpful routines.  With the normal write_sg/read_sg routines if the data on the caller side is scattered, the caller has to copy the scattered data into/from a single bio buffer.  With the _kern API the caller could instead let these routines set up the bios from a pointer list without a copy.

John.

On Oct 19, 2010, at 8:22 AM, Boaz Harrosh wrote:

> From: John A. Chandy <john.chandy@uconn.edu>
> 
> This is a trivial addition to the SG API that can receive kernel
> pointers. It is only used by the out-of-tree test module. So
> it's immediate need is questionable. For maintenance ease it might
> just get in, as it's very small.
> 
> John.
> do you need this in the Kernel, or is it only for osd_ktest.ko?
> 
> Signed-off-by: John A. Chandy <john.chandy@uconn.edu>
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
> drivers/scsi/osd/osd_initiator.c |   71 ++++++++++++++++++++++++++++++++++++++
> 1 files changed, 71 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
> index f5b5735..0433ea6 100644
> --- a/drivers/scsi/osd/osd_initiator.c
> +++ b/drivers/scsi/osd/osd_initiator.c
> @@ -1015,6 +1015,77 @@ int osd_req_read_sg(struct osd_request *or,
> }
> EXPORT_SYMBOL(osd_req_read_sg);
> 
> +/* SG-list write/read Kern API
> + *
> + * osd_req_{write,read}_sg_kern takes an array of @buff pointers and an array
> + * of sg_entries. @numentries indicates how many pointers and sg_entries there
> + * are.  By requiring an array of buff pointers. This allows a caller to do a
> + * single write/read and scatter into multiple buffers.
> + * NOTE: Each buffer + len should not cross a page boundary.
> + */
> +static struct bio *_create_sg_bios(struct osd_request *or,
> +	void **buff, const struct osd_sg_entry *sglist, unsigned numentries)
> +{
> +	struct request_queue *q = osd_request_queue(or->osd_dev);
> +	struct bio *bio;
> +	unsigned i;
> +
> +	bio = bio_kmalloc(GFP_KERNEL, numentries);
> +	if (unlikely(!bio)) {
> +		OSD_DEBUG("Faild to allocate BIO size=%u\n", numentries);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	for (i = 0; i < numentries; i++) {
> +		unsigned offset = offset_in_page(buff[i]);
> +		struct page *page = virt_to_page(buff[i]);
> +		unsigned len = sglist[i].len;
> +		unsigned added_len;
> +
> +		BUG_ON(offset + len > PAGE_SIZE);
> +		added_len = bio_add_pc_page(q, bio, page, len, offset);
> +		if (unlikely(len != added_len)) {
> +			OSD_DEBUG("bio_add_pc_page len(%d) != added_len(%d)\n",
> +				  len, added_len);
> +			bio_put(bio);
> +			return ERR_PTR(-ENOMEM);
> +		}
> +	}
> +
> +	return bio;
> +}
> +
> +int osd_req_write_sg_kern(struct osd_request *or,
> +	const struct osd_obj_id *obj, void **buff,
> +	const struct osd_sg_entry *sglist, unsigned numentries)
> +{
> +	struct bio *bio = _create_sg_bios(or, buff, sglist, numentries);
> +	if (IS_ERR(bio))
> +		return PTR_ERR(bio);
> +
> +	bio->bi_rw |= REQ_WRITE;
> +	osd_req_write_sg(or, obj, bio, sglist, numentries);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(osd_req_write_sg_kern);
> +
> +int osd_req_read_sg_kern(struct osd_request *or,
> +	const struct osd_obj_id *obj, void **buff,
> +	const struct osd_sg_entry *sglist, unsigned numentries)
> +{
> +	struct bio *bio = _create_sg_bios(or, buff, sglist, numentries);
> +	if (IS_ERR(bio))
> +		return PTR_ERR(bio);
> +
> +	osd_req_read_sg(or, obj, bio, sglist, numentries);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(osd_req_read_sg_kern);
> +
> +
> +
> void osd_req_get_attributes(struct osd_request *or,
> 	const struct osd_obj_id *obj)
> {
> -- 
> 1.7.2.3
> 

