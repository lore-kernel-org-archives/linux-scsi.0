From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: Re: [PATCH] qedf: fixup compilation warning about atomic_t usage
Date: Thu, 23 Feb 2017 09:43:35 -0500 (EST)
Message-ID: <alpine.OSX.2.00.1702230942410.665@n5127mndc1pbs1.qlogic.org>
References: <1487850291-114238-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0043.outbound.protection.outlook.com ([104.47.38.43]:17120
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751107AbdBWOoY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Feb 2017 09:44:24 -0500
In-Reply-To: <1487850291-114238-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Nilesh Javali <nilesh.javali@cavium.com>, Hannes Reinecke <hare@suse.com>



On Thu, 23 Feb 2017, 11:44am -0000, Hannes Reinecke wrote:

> The driver didn't follow the atomic_t vs refcount_t change, and
> anyway one should be using kref_read() instead of accessing the
> counter inside an kref.
> 
> Fixes: 61d8658b4a435e ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.)
> Cc: Chad Dupuis <chad.dupuis@cavium.com>
> Cc: Nilesh Javali <nilesh.javali@cavium.com>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/qedf/qedf_io.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
> index 486c045..ee0dcf9 100644
> --- a/drivers/scsi/qedf/qedf_io.c
> +++ b/drivers/scsi/qedf/qedf_io.c
> @@ -998,7 +998,7 @@ static void qedf_trace_io(struct qedf_rport *fcport, struct qedf_ioreq *io_req,
>  	io_log->sg_count = scsi_sg_count(sc_cmd);
>  	io_log->result = sc_cmd->result;
>  	io_log->jiffies = jiffies;
> -	io_log->refcount = atomic_read(&io_req->refcount.refcount);
> +	io_log->refcount = kref_read(&io_req->refcount);
>  
>  	if (direction == QEDF_IO_TRACE_REQ) {
>  		/* For requests we only care abot the submission CPU */
> @@ -1340,7 +1340,7 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
>  			/* Good I/O completion */
>  			sc_cmd->result = DID_OK << 16;
>  		} else {
> -			refcount = atomic_read(&io_req->refcount.refcount);
> +			refcount = kref_read(&io_req->refcount);
>  			QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_IO,
>  			    "%d:0:%d:%d xid=0x%0x op=0x%02x "
>  			    "lba=%02x%02x%02x%02x cdb_status=%d "
> @@ -1425,7 +1425,7 @@ void qedf_scsi_done(struct qedf_ctx *qedf, struct qedf_ioreq *io_req,
>  	qedf_unmap_sg_list(qedf, io_req);
>  
>  	sc_cmd->result = result << 16;
> -	refcount = atomic_read(&io_req->refcount.refcount);
> +	refcount = kref_read(&io_req->refcount);
>  	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_IO, "%d:0:%d:%d: Completing "
>  	    "sc_cmd=%p result=0x%08x op=0x%02x lba=0x%02x%02x%02x%02x, "
>  	    "allowed=%d retries=%d refcount=%d.\n",
> @@ -1556,7 +1556,7 @@ static void qedf_flush_els_req(struct qedf_ctx *qedf,
>  {
>  	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_IO,
>  	    "Flushing ELS request xid=0x%x refcount=%d.\n", els_req->xid,
> -	    atomic_read(&els_req->refcount.refcount));
> +	    kref_read(&els_req->refcount));
>  
>  	/*
>  	 * Need to distinguish this from a timeout when calling the
>

Thanks for the patch Hannes though it looks like the atomic_read's in 
qedf_els.c need to be converted as well.  Will post a patch shortly. 
