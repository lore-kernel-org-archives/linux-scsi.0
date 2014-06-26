From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: SCSI eats error from flush failure during hot plug
Date: Thu, 26 Jun 2014 14:52:14 -0400
Message-ID: <1403808734.6440.12.camel@dabdike>
References: <CAPK7rjcrBuQgoiAxZ9ZASAGugtyHTsHB3ssZegKtuzRdo9TMNQ@mail.gmail.com>
	 <20140626150208.GA14887@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51111 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750797AbaFZSwh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jun 2014 14:52:37 -0400
In-Reply-To: <20140626150208.GA14887@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Steven Haber <steven@qumulo.com>, linux-scsi@vger.kernel.org

On Thu, 2014-06-26 at 08:02 -0700, Christoph Hellwig wrote:
> Hi Steven,
> 
> can you test the patch below?
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index f7e3163..9b56e48 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -733,6 +733,14 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  			scsi_next_command(cmd);
>  			return;
>  		}
> +	} else if (req->cmd_flags & REQ_FLUSH) {
> +		/*
> +		 * Flush request don't transfer data, so we can't try
> +		 * to complete the good bytes first before checking
> +		 * the error.
> +		 */
> +		if (result && !sense_deferred)
> +			error = __scsi_error_from_host_byte(cmd, result);

Well, no, that's wrong.  To catch all of the corner cases that slip
through here, the check is for a zero length command with and error
otherwise we get the same problem for failed discards.

This is what the check should be.

James

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f7e3163..83e447e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -733,6 +733,14 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			scsi_next_command(cmd);
 			return;
 		}
+	} else if (blk_rq_bytes(req) == 0 && result && !sense_deferred) {
+		/*
+		 * Certain non BLOCK_PC requests are commands that don't
+		 * actually transfer anything (FLUSH, DISCARD), so cannot use
+		 * good_bytes == 0 as the signal for an error.  This sets the
+		 * error explicitly for the problem case
+		 */
+		error = __scsi_error_from_host_byte(cmd, result);
 	}
 
 	/* no bidi support for !REQ_TYPE_BLOCK_PC yet */


