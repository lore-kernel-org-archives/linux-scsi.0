From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/4] scsi: explicitly release bidi buffers
Date: Mon, 31 Mar 2014 00:58:01 -0500
Message-ID: <533903E9.3020300@cs.wisc.edu>
References: <1395936862-6938-1-git-send-email-hch@lst.de> <1395936862-6938-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:56319 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbaCaF6Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Mar 2014 01:58:16 -0400
In-Reply-To: <1395936862-6938-2-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org

On 03/27/2014 11:14 AM, Christoph Hellwig wrote:
> +static void scsi_release_bidi_buffers(struct scsi_cmnd *cmd)
> +{
> +	struct scsi_data_buffer *bidi_sdb = cmd->request->next_rq->special;
> +
> +	scsi_free_sgtable(bidi_sdb);
> +	kmem_cache_free(scsi_sdb_cache, bidi_sdb);
> +	cmd->request->next_rq->special = NULL;
> +}
> +
>  /**
>   * __scsi_error_from_host_byte - translate SCSI error code into errno
>   * @cmd:	SCSI command (unused)
> @@ -800,6 +792,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  			req->next_rq->resid_len = scsi_in(cmd)->resid;
>  
>  			scsi_release_buffers(cmd);
> +			scsi_release_bidi_buffers(cmd);
>  			blk_end_request_all(req, 0);
>  
>  			scsi_next_command(cmd);
> 

Hey,

I just wanted to double check that the only time we do bidi requests is
when they come through as REQ_TYPE_BLOCK_PC requests. I saw some of the
code comments on the init side that indicated that, but there was that
scsi_end_request() -> scsi_release_buffers() -> __scsi_release_buffers()
 call which then did not make sense because we were passing in 1 for the
bidi check argument.
