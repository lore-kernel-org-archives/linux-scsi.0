From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Re: [PATCH 7/9] bsg-lib: remove bsg_job.req
Date: Mon, 16 Oct 2017 18:36:48 +0200
Message-ID: <20171016163647.GC26185@bblock-ThinkPad-W530>
References: <20171003104845.10417-1-hch@lst.de>
 <20171003104845.10417-8-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53228 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753122AbdJPQgx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Oct 2017 12:36:53 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v9GGY7rZ023134
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2017 12:36:53 -0400
Received: from e06smtp10.uk.ibm.com (e06smtp10.uk.ibm.com [195.75.94.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2dn0808mgj-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2017 12:36:52 -0400
Received: from localhost
        by e06smtp10.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
        Mon, 16 Oct 2017 17:36:51 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v9GGamEY26738786
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2017 16:36:48 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A197452041
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2017 16:31:10 +0100 (BST)
Received: from bblock-ThinkPad-W530 (unknown [9.152.212.38])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 877EC5203F
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2017 16:31:10 +0100 (BST)
Content-Disposition: inline
In-Reply-To: <20171003104845.10417-8-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>

On Tue, Oct 03, 2017 at 12:48:43PM +0200, Christoph Hellwig wrote:
> Users of the bsg-lib interface should only use the bsg_job data structure
> and not know about implementation details of it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/bsg-lib.c         | 14 ++++++--------
>  include/linux/bsg-lib.h |  1 -
>  2 files changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/block/bsg-lib.c b/block/bsg-lib.c
> index 0d5bbf6a2ddd..6299526bd2c3 100644
> --- a/block/bsg-lib.c
> +++ b/block/bsg-lib.c
> @@ -35,7 +35,7 @@
>  static void bsg_teardown_job(struct kref *kref)
>  {
>  	struct bsg_job *job = container_of(kref, struct bsg_job, kref);
> -	struct request *rq = job->req;
> +	struct request *rq = blk_mq_rq_from_pdu(job);
> 
>  	put_device(job->dev);	/* release reference for the request */
> 
> @@ -68,19 +68,18 @@ EXPORT_SYMBOL_GPL(bsg_job_get);
>  void bsg_job_done(struct bsg_job *job, int result,
>  		  unsigned int reply_payload_rcv_len)
>  {
> -	struct request *req = job->req;
> +	struct request *req = blk_mq_rq_from_pdu(job);
>  	struct request *rsp = req->next_rq;
> -	struct scsi_request *rq = scsi_req(req);
>  	int err;
> 
> -	err = scsi_req(job->req)->result = result;
> +	err = job->sreq.result = result;
>  	if (err < 0)
>  		/* we're only returning the result field in the reply */
> -		rq->sense_len = sizeof(u32);
> +		job->sreq.sense_len = sizeof(u32);
>  	else
> -		rq->sense_len = job->reply_len;
> +		job->sreq.sense_len = job->reply_len;
>  	/* we assume all request payload was transferred, residual == 0 */
> -	rq->resid_len = 0;
> +	job->sreq.resid_len = 0;
> 
>  	if (rsp) {
>  		WARN_ON(reply_payload_rcv_len > scsi_req(rsp)->resid_len);
> @@ -232,7 +231,6 @@ static void bsg_initialize_rq(struct request *req)
>  	sreq->sense = sense;
>  	sreq->sense_len = SCSI_SENSE_BUFFERSIZE;
> 
> -	job->req = req;
>  	job->reply = sense;
>  	job->reply_len = sreq->sense_len;
>  	job->dd_data = job + 1;
> diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
> index 402223c95ce1..08762d297cbd 100644
> --- a/include/linux/bsg-lib.h
> +++ b/include/linux/bsg-lib.h
> @@ -40,7 +40,6 @@ struct bsg_buffer {
>  struct bsg_job {
>  	struct scsi_request sreq;
>  	struct device *dev;
> -	struct request *req;
> 
>  	struct kref kref;
> 
> -- 
> 2.14.1
> 

Reviewed-by: Benjamin Block <bblock@linux.vnet.ibm.com>


                                                    Beste Grüße / Best regards,
                                                      - Benjamin Block
-- 
Linux on z Systems Development         /         IBM Systems & Technology Group
		  IBM Deutschland Research & Development GmbH 
Vorsitz. AufsR.: Martina Koederitz     /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
