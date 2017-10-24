From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Re: [PATCH 9/9] bsg: split handling of SCSI CDBs vs transport
 requeues
Date: Tue, 24 Oct 2017 18:58:08 +0200
Message-ID: <20171024165808.GB26380@bblock-ThinkPad-W530>
References: <20171003104845.10417-1-hch@lst.de>
 <20171003104845.10417-10-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51572 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751378AbdJXQ6O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Oct 2017 12:58:14 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v9OGsigR067996
        for <linux-scsi@vger.kernel.org>; Tue, 24 Oct 2017 12:58:13 -0400
Received: from e06smtp12.uk.ibm.com (e06smtp12.uk.ibm.com [195.75.94.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2dt7ehh51q-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 24 Oct 2017 12:58:13 -0400
Received: from localhost
        by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
        Tue, 24 Oct 2017 17:58:11 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v9OGw9Kg16253132
        for <linux-scsi@vger.kernel.org>; Tue, 24 Oct 2017 16:58:09 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 925484C046
        for <linux-scsi@vger.kernel.org>; Tue, 24 Oct 2017 17:53:48 +0100 (BST)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B5044C044
        for <linux-scsi@vger.kernel.org>; Tue, 24 Oct 2017 17:53:48 +0100 (BST)
Received: from bblock-ThinkPad-W530 (unknown [9.145.24.194])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP
        for <linux-scsi@vger.kernel.org>; Tue, 24 Oct 2017 17:53:48 +0100 (BST)
Content-Disposition: inline
In-Reply-To: <20171003104845.10417-10-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>

> +static int bsg_transport_complete_rq(struct request *rq, struct sg_io_v4 *hdr)
> +{
> +	struct bsg_job *job = blk_mq_rq_to_pdu(rq);
> +	int ret = 0;
> +
> +	/*
> +	 * The assignments below don't make much sense, but are kept for
> +	 * bug by bug backwards compatibility:
> +	 */
> +	hdr->device_status = job->result & 0xff;
> +	hdr->transport_status = host_byte(job->result);
> +	hdr->driver_status = driver_byte(job->result);
> +	hdr->info = 0;
> +	if (hdr->device_status || hdr->transport_status || hdr->driver_status)
> +		hdr->info |= SG_INFO_CHECK;
> +	hdr->response_len = 0;
> +
> +	if (job->result < 0) {
> +		/* we're only returning the result field in the reply */
> +		job->reply_len = sizeof(u32);
> +		ret = job->result;
> +	}
> +
> +	if (job->reply_len && hdr->response) {
> +		int len = min(hdr->max_response_len, job->reply_len);
> +
> +		if (copy_to_user(ptr64(hdr->response), job->reply, len))
> +			ret = -EFAULT;
> +		else
> +			hdr->response_len = len;
> +	}
> +
> +	/* we assume all request payload was transferred, residual == 0 */
> +	hdr->dout_resid = 0;
> +
> +	if (rq->next_rq) {
> +		unsigned int rsp_len = blk_rq_bytes(rq->next_rq);
> +
> +		if (WARN_ON(job->reply_payload_rcv_len > rsp_len))

This gives my a lot of new Warnings when running my tests on zFCP, non
of which happen when I run on 4.13.

After browsing the source some, I figured this is because in comparison
to the old code, blk_rq_bytes() is now called after we finished the
blk-request already and blk_update_bidi_request()+blk_update_request()
was already called. This will update rq->__data_len, and thus the call
here to get rsp_len will get a wrong value. Thus the warnings, and the
following calculation is actually wrong.

I figure you can just replace this call for blk_rq_bytes() with
'job->reply_payload.payload_len'. Its essentially the same value, but
the later is not changed after the job is committed as far as I could see
in the source. Driver makes use of it, but only reading as far as I
could make out after browsing the code for a bit.

I did a quick test with that change in place and that seems to work fine
now. As far as my tests go, they behave as they did before.


                                                    Beste Grüße / Best regards,
                                                      - Benjamin Block

> +			hdr->din_resid = 0;
> +		else
> +			hdr->din_resid = rsp_len - job->reply_payload_rcv_len;
> +	} else {
> +		hdr->din_resid = 0;
> +	}
> +
> +	return ret;
> +}
> +

--
Linux on z Systems Development         /         IBM Systems & Technology Group
		  IBM Deutschland Research & Development GmbH
Vorsitz. AufsR.: Martina Koederitz     /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
