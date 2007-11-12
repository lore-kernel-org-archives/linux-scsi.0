From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 4/4] SCSI: bidi support
Date: Mon, 12 Nov 2007 14:52:40 -0500 (EST)
Message-ID: <20071112.145240.48534067.k-ueda@ct.jp.nec.com>
References: <47334156.8050105@panasas.com>
	<20071109.161558.39152463.k-ueda@ct.jp.nec.com>
	<47383020.8010108@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbXKLUZY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Nov 2007 15:25:24 -0500
In-Reply-To: <47383020.8010108@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, pw@osc.edu, bhalevy@panasas.com, akpm@osdl.org, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com

Hi Boaz,

On Mon, 12 Nov 2007 12:51:12 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
> > I'm trying to refine the request completion interface between
> > device drivers and the block-layer.
> > (http://marc.info/?l=linux-kernel&m=118953696504819&w=2)
> > 
> > For that work, I wish to keep the space between
> > end_that_request_chunk() and end_that_request_last() simpler
> > as much as possible so that they can be converted to the interface
> > easily.
> > So I'd like to ask you whether 3 reorderings below cause problem
> > for you.
> >   1. reorder end_that_request_chunk() calls for req and req->next_rq
> >   2. set data_len before end_that_request_chunk() calls
> >   3. call scsi_release_buffer() after scsi_finalize_request()
> > 
> > void scsi_end_bidi_request(struct scsi_cmnd *cmd)
> > {
> > 	struct request *req = cmd->request;
> > 	unsigned int dlen = req->data_len;
> > 	unsigned int next_dlen = req->next_rq->data_len;
> > 
> > 	req->data_len = scsi_out(cmd)->resid;
> > 	req->next_rq->data_len = scsi_in(cmd)->resid;
> > 
> > 	end_that_request_chunk(req->next_rq, 1, next_dlen);
> > 	end_that_request_chunk(req, 1, dlen);
> > 
> > 	scsi_finalize_request(cmd, 1);
> > 	scsi_release_buffers(cmd);
> > }
> > 
> > If they are no problem, I could easily convert it to the new interface.
>
> 1. If req->data_len is not affected by end_that_request_chunk() than sure.
> 2. Please note that "end_that_request_chunk(req->next_rq, 1, next_dlen);"
>    *must* not be paired with a call to end_that_request_last().
>    It is not a "Queued" request and will break the system. This is
>    the "bidi trick". So end_that_request_chunk() must be exported still.
> 3. scsi_release_buffers(cmd) must stay where it is, and certainly before 
>    scsi_finalize_request() which does a put_command.
> 4. If you are already touching block-layer. I would be happy if you add a
>    blk_end_request_bidi(struct request *, int write_resid, int read_resid,
>    error ...) ;
>    That will release both request and request->next_rq, completely and set
>    resid for ULDs. Then scsi_end_bidi_request() can be removed.
> 
> I would prefer to leave the code as it is for now and change it to what ever
> it needs to be in your patchset.
> But if you insist What I would suggest is below: (Minus the comments)

Thank you for detailed answer and looking the blk_end_request().
I'll consider how to convert based on your answer.

Leaving the code for now is OK to me.

Thanks,
Kiyoshi Ueda
