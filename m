From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 4/4] SCSI: bidi support
Date: Fri, 09 Nov 2007 16:15:58 -0500 (EST)
Message-ID: <20071109.161558.39152463.k-ueda@ct.jp.nec.com>
References: <4730ACAA.2060007@panasas.com>
	<47333E2A.7020307@panasas.com>
	<47334156.8050105@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbXKIVQz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Nov 2007 16:16:55 -0500
In-Reply-To: <47334156.8050105@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, pw@osc.edu, bhalevy@panasas.com, akpm@osdl.org, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com

Hi Boaz,

On Thu, 08 Nov 2007 19:03:18 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
>   At the block level bidi request uses req->next_rq pointer for a second
>   bidi_read request.
>   At Scsi-midlayer a second scsi_data_buffer structure is used for the
>   bidi_read part. This bidi scsi_data_buffer is put on
>   request->next_rq->special. Struct scsi_cmnd is not changed.
> 
>   - Define scsi_bidi_cmnd() to return true if it is a bidi request and a
>     second sgtable was allocated.
> 
>   - Define scsi_in()/scsi_out() to return the in or out scsi_data_buffer
>     from this command This API is to isolate users from the mechanics of
>     bidi.
> 
>   - Define scsi_end_bidi_request() to do what scsi_end_request() does but
>     for a bidi request. This is necessary because bidi commands are a bit
>     tricky here. (See comments in body)
<snip>
>  /*
> + * Bidi commands Must be complete as a whole, both sides at once.
> + * If part of the bytes were written and lld returned
> + * scsi_in()->resid and/or scsi_out()->resid this information will be left
> + * in req->data_len and req->next_rq->data_len. The upper-layer driver can
> + * decide what to do with this information.
> + */
> +void scsi_end_bidi_request(struct scsi_cmnd *cmd)
> +{
> +	struct request *req = cmd->request;
> +
> +	end_that_request_chunk(req, 1, req->data_len);
> +	req->data_len = scsi_out(cmd)->resid;
> +
> +	end_that_request_chunk(req->next_rq, 1, req->next_rq->data_len);
> +	req->next_rq->data_len = scsi_in(cmd)->resid;
> +
> +	scsi_release_buffers(cmd);
> +
> +	/*
> +	 *FIXME: If ll_rw_blk.c is changed to also put_request(req->next_rq)
> +	 *       in end_that_request_last() then this WARN_ON must be removed.
> +	 *       for now, upper-driver must have registered an end_io.
> +	 */
> +	WARN_ON(!req->end_io);
> +
> +	scsi_finalize_request(cmd, 1);
> +}

I'm trying to refine the request completion interface between
device drivers and the block-layer.
(http://marc.info/?l=linux-kernel&m=118953696504819&w=2)

For that work, I wish to keep the space between
end_that_request_chunk() and end_that_request_last() simpler
as much as possible so that they can be converted to the interface
easily.
So I'd like to ask you whether 3 reorderings below cause problem
for you.
  1. reorder end_that_request_chunk() calls for req and req->next_rq
  2. set data_len before end_that_request_chunk() calls
  3. call scsi_release_buffer() after scsi_finalize_request()

void scsi_end_bidi_request(struct scsi_cmnd *cmd)
{
	struct request *req = cmd->request;
	unsigned int dlen = req->data_len;
	unsigned int next_dlen = req->next_rq->data_len;

	req->data_len = scsi_out(cmd)->resid;
	req->next_rq->data_len = scsi_in(cmd)->resid;

	end_that_request_chunk(req->next_rq, 1, next_dlen);
	end_that_request_chunk(req, 1, dlen);

	scsi_finalize_request(cmd, 1);
	scsi_release_buffers(cmd);
}

If they are no problem, I could easily convert it to the new interface.

Thanks,
Kiyoshi Ueda
