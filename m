From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 1/2] scsi: Handle Unit Attention when issuing SCSI
 command
Date: Fri, 14 Oct 2016 13:19:20 +0800
Message-ID: <1476422360.22309.29.camel@linux.vnet.ibm.com>
References: <1476384477-3060-1-git-send-email-krisman@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54719 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751540AbcJNFUP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Oct 2016 01:20:15 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9E5JwOU015185
        for <linux-scsi@vger.kernel.org>; Fri, 14 Oct 2016 01:20:00 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 262rb0hvkm-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 14 Oct 2016 01:19:59 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Thu, 13 Oct 2016 23:19:29 -0600
In-Reply-To: <1476384477-3060-1-git-send-email-krisman@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

On Thu, 2016-10-13 at 15:47 -0300, Gabriel Krisman Bertazi wrote:
> Hi James,
> 
> Thanks for your review.  Please see the v2 below.
> 
> > OK, so really this isn't what you want, because blk_execute_req may
> > have used several of your retries, so you now get a maximum 
> > possible set of retries at UNIT_ATTENTION_RETRIES*retries.  You 
> > need to start from the returned req->retries, which probably means 
> > this loop needs to be inside __scsi_execute.
> 
> Hmm, I was aware of that, but I saw there were other places that may
> have run retries^2 times, like scsi_test_unit_ready and 
> scsi_mode_sense, if I read the code correctly.

There's a lot of this type of retry multiplication, but we really do
need to reduce it, not increase it.

>   But, I see your point and I fixed it on v2.  I also updated the
> second patch to rework these cases.
> 
> Another thing that got me confused is where the blk layer updates
> req->retries.
> 
> What do you think about the v2 below?
> 
> Thanks,
> 
> -- >8 --
> 
> Usually, re-sending the SCSI command is enough to recover from a Unit
> Attention (UA).  This adds a generic retry code to the SCSI command 
> path in case of an UA, before giving up and returning the error 
> condition to the caller.
> 
> I added the UA verification into scsi_execute instead of
> scsi_execute_req because there are at least a few callers that invoke
> scsi_execute directly and would benefit from the internal UA retry.
> Also, I didn't use scsi_normalize_sense to not duplicate 
> functionality with scsi_execute_req_flags.  Instead, scsi_execute 
> uses a small helper function that verifies only the UA condition 
> directly from the raw sense buffer.  If this design is not OK, I can 
> refactor to use scsi_normalize_sense.
> 
> This prevents us from duplicating the retry code in at least a few
> places.  In particular, it fixes an issue found in some IBM 
> enclosures, in which the device may return an Unit Attention during 
> probe, breaking the bind with the ses module:
> 
> scsi 1:0:7:0: Failed to get diagnostic page 0x8000002
> scsi 1:0:7:0: Failed to bind enclosure -19
> 
> Link: https://patchwork.kernel.org/patch/9336763/
> Suggested-by: Brian King <brking@linux.vnet.ibm.com>
> Suggested-by: James Bottomley <jejb@linux.vnet.ibm.com>
> Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
> ---
>  drivers/scsi/scsi_lib.c    | 27 ++++++++++++++++++++++++---
>  include/scsi/scsi_common.h |  9 +++++++++
>  2 files changed, 33 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index c71344aebdbb..9c6623abf120 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -187,15 +187,24 @@ int scsi_execute(struct scsi_device *sdev,
> const unsigned char *cmd,
>  	struct request *req;
>  	int write = (data_direction == DMA_TO_DEVICE);
>  	int ret = DRIVER_ERROR << 24;
> +	bool priv_sense = false;
>  
> +	if (!sense) {
> +		sense = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_NOIO);
> +		if (!sense)
> +			return ret;
> +		priv_sense = true;
> +	}

I think here we might be able to stack allocate this and avoid a
potential error return under memory pressure.  The annoying thing is
that blk_execute_rq does exactly this, so now we have an additional
useless allocation bloating the stack, but I think it's worth it to get
rid of priv_sense and all the error legs.

> + retry:
>  	req = blk_get_request(sdev->request_queue, write,
> __GFP_RECLAIM);
>  	if (IS_ERR(req))
> -		return ret;
> +		goto free_sense;
>  	blk_rq_set_block_pc(req);
>  
>  	if (bufflen &&	blk_rq_map_kern(sdev->request_queue,
> req,
>  					buffer, bufflen,
> __GFP_RECLAIM))
> -		goto out;
> +		goto put_req;
>  
>  	req->cmd_len = COMMAND_SIZE(cmd[0]);
>  	memcpy(req->cmd, cmd, req->cmd_len);
> @@ -210,6 +219,13 @@ int scsi_execute(struct scsi_device *sdev, const
> unsigned char *cmd,
>  	 */
>  	blk_execute_rq(req->q, NULL, req, 1);
>  
> +	if (scsi_sense_unit_attention(sense) && req->retries > 0) {
> +		memset(sense, 0, SCSI_SENSE_BUFFERSIZE);
> +		retries = req->retries - 1;
> +		blk_put_request(req);
> +		goto retry;
> +	}

OK, so this is more theory, but I think you can actually reuse the same
request to go around this loop without doing a get/put.  I've cc'd Jens
to confirm, since no other driver I can find does this, but if it's
legal, it saves freeing and reallocating the request.  You can then
replace the goto with a do { } while (...) which makes the loop obvious
to the next person looking at this.

>  	/*
>  	 * Some devices (USB mass-storage in particular) may
> transfer
>  	 * garbage data together with a residue indicating that the
> data
> @@ -222,9 +238,14 @@ int scsi_execute(struct scsi_device *sdev, const
> unsigned char *cmd,
>  	if (resid)
>  		*resid = req->resid_len;
>  	ret = req->errors;
> - out:
> +
> + put_req:
>  	blk_put_request(req);
>  
> + free_sense:
> +	if (priv_sense)
> +		kfree(sense);
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL(scsi_execute);
> diff --git a/include/scsi/scsi_common.h b/include/scsi/scsi_common.h
> index 20bf7eaef05a..747b632d5b57 100644
> --- a/include/scsi/scsi_common.h
> +++ b/include/scsi/scsi_common.h
> @@ -58,6 +58,15 @@ static inline bool scsi_sense_valid(const struct
> scsi_sense_hdr *sshdr)
>  	return (sshdr->response_code & 0x70) == 0x70;
>  }
>  
> +static inline bool scsi_sense_unit_attention(const char *sense)
> +{
> +	int resp = sense[0] & 0x7f;
> +
> +	return ((resp & 0x70) &&
> +		((resp >= 0x72 && (sense[1] & 0xf) ==
> UNIT_ATTENTION) ||
> +		 (resp < 0x72 && (sense[2] & 0xf) ==
> UNIT_ATTENTION)));
> +}

I think also, to emphasise the locality of this function, just put it
above scsi_execute inside scsi_lib.c ... that way no-one can
proliferate its use.

Other than the above, this looks much better.

Thanks,

James

>  extern bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
>  				 struct scsi_sense_hdr *sshdr);
>  

