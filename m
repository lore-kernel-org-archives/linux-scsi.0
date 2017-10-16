From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/9] bsg-lib: introduce a timeout field in struct bsg_job
Date: Mon, 16 Oct 2017 18:30:24 +0200
Message-ID: <20171016163024.GB26185@bblock-ThinkPad-W530>
References: <20171003104845.10417-1-hch@lst.de>
 <20171003104845.10417-7-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60568 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755217AbdJPQaa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Oct 2017 12:30:30 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v9GGTfSX068415
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2017 12:30:30 -0400
Received: from e06smtp10.uk.ibm.com (e06smtp10.uk.ibm.com [195.75.94.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2dmy82keg9-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2017 12:30:29 -0400
Received: from localhost
        by e06smtp10.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
        Mon, 16 Oct 2017 17:30:27 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v9GGUPIZ23789576
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2017 16:30:25 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9733CA4051
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2017 17:25:51 +0100 (BST)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D532A4040
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2017 17:25:51 +0100 (BST)
Received: from bblock-ThinkPad-W530 (unknown [9.152.212.38])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2017 17:25:51 +0100 (BST)
Content-Disposition: inline
In-Reply-To: <20171003104845.10417-7-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>

On Tue, Oct 03, 2017 at 12:48:42PM +0200, Christoph Hellwig wrote:
> The zfcp driver wants to know the timeout for a bsg job, so add a field
> to struct bsg_job for it in preparation of not exposing the request
> to the bsg-lib users.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/bsg-lib.c             | 1 +
>  drivers/s390/scsi/zfcp_fc.c | 4 ++--
>  include/linux/bsg-lib.h     | 2 ++
>  3 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/block/bsg-lib.c b/block/bsg-lib.c
> index 15d25ccd51a5..0d5bbf6a2ddd 100644
> --- a/block/bsg-lib.c
> +++ b/block/bsg-lib.c
> @@ -132,6 +132,7 @@ static int bsg_prepare_job(struct device *dev, struct request *req)
>  	struct bsg_job *job = blk_mq_rq_to_pdu(req);
>  	int ret;
> 
> +	job->timeout = req->timeout;
>  	job->request = rq->cmd;
>  	job->request_len = rq->cmd_len;
> 
> diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
> index 8210645c2111..9d6f69b92c81 100644
> --- a/drivers/s390/scsi/zfcp_fc.c
> +++ b/drivers/s390/scsi/zfcp_fc.c
> @@ -960,7 +960,7 @@ static int zfcp_fc_exec_els_job(struct bsg_job *job,
>  		d_id = ntoh24(bsg_request->rqst_data.h_els.port_id);
> 
>  	els->handler = zfcp_fc_ct_els_job_handler;
> -	return zfcp_fsf_send_els(adapter, d_id, els, job->req->timeout / HZ);
> +	return zfcp_fsf_send_els(adapter, d_id, els, job->timeout / HZ);
>  }
> 
>  static int zfcp_fc_exec_ct_job(struct bsg_job *job,
> @@ -979,7 +979,7 @@ static int zfcp_fc_exec_ct_job(struct bsg_job *job,
>  		return ret;
> 
>  	ct->handler = zfcp_fc_ct_job_handler;
> -	ret = zfcp_fsf_send_ct(wka_port, ct, NULL, job->req->timeout / HZ);
> +	ret = zfcp_fsf_send_ct(wka_port, ct, NULL, job->timeout / HZ);
>  	if (ret)
>  		zfcp_fc_wka_port_put(wka_port);
> 
> diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
> index b1be0233ce35..402223c95ce1 100644
> --- a/include/linux/bsg-lib.h
> +++ b/include/linux/bsg-lib.h
> @@ -44,6 +44,8 @@ struct bsg_job {
> 
>  	struct kref kref;
> 
> +	unsigned int timeout;
> +
>  	/* Transport/driver specific request/reply structs */
>  	void *request;
>  	void *reply;
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
