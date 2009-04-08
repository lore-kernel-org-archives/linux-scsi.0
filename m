From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [patch 2/2] zfcp: Add FC pass-through support
Date: Wed, 8 Apr 2009 09:39:49 +0200
Message-ID: <20090408073949.GA4905@schmichrtp.de.ibm.com>
References: <20090406163145.686874000@de.ibm.com> <20090406163534.659628000@de.ibm.com> <49DBDF26.6090601@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:36280 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759445AbZDHHjw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2009 03:39:52 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.13.1/8.13.1) with ESMTP id n387dpUu029510
	for <linux-scsi@vger.kernel.org>; Wed, 8 Apr 2009 07:39:51 GMT
Received: from d12av04.megacenter.de.ibm.com (d12av04.megacenter.de.ibm.com [9.149.165.229])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n387dpwF3837992
	for <linux-scsi@vger.kernel.org>; Wed, 8 Apr 2009 09:39:51 +0200
Received: from d12av04.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av04.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n387doKN031818
	for <linux-scsi@vger.kernel.org>; Wed, 8 Apr 2009 09:39:51 +0200
Content-Disposition: inline
In-Reply-To: <49DBDF26.6090601@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sven Schuetz <sven@linux.vnet.ibm.com>

On Tue, Apr 07, 2009 at 07:17:58PM -0400, James Smart wrote:
> Christof Schmitt wrote:
> --- a/drivers/s390/scsi/zfcp_fc.c       2009-04-06 17:23:25.000000000 +0200
> +++ b/drivers/s390/scsi/zfcp_fc.c       2009-04-06 17:24:30.000000000 +0200
> ...
>> +static void zfcp_fc_generic_els_handler(unsigned long data)
>> +{
>> +       struct zfcp_els_fc_job *els_fc_job = (struct zfcp_els_fc_job *) data;
>> +       struct fc_bsg_job *job = els_fc_job->job;
>> +       struct fc_bsg_reply *reply = job->reply;
>> +
>> +       if (els_fc_job->els.status) {
>> +               /* request rejected or timed out */
>> +               reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_REJECT;
>> +               goto out;
>> +       }
>> +
>> +       reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
>> +       reply->reply_payload_rcv_len = blk_rq_bytes(job->req->next_rq);
>
> My intent was to not have the LLDD reference (or even know about) the
> request structures and that bsg exists underneath.
>
> Thus, for the last line above, it should be:
>           reply->reply_payload_rcv_len = job->reply_payload->data_len;
>
> Although, I'm a little surprised that your els interface doesn't supply the
> received data length to you, rather than the global assumption that you 
> sized the reply buffer for exactly what you always get.

I guess this is one thing we have to investigate. Either use the
data_lan or get the data from the hardware.

>> +struct zfcp_ct_fc_job {
>> +       struct zfcp_send_ct ct;
>> +       struct fc_bsg_job *job;
>> +};
>> +
>> +static void zfcp_fc_generic_ct_handler(unsigned long data)
>> +{
>> +       struct zfcp_ct_fc_job *ct_fc_job = (struct zfcp_ct_fc_job *) data;
>> +       struct fc_bsg_job *job = ct_fc_job->job;
>> +
>> +       job->reply->reply_data.ctels_reply.status = ct_fc_job->ct.status ?
>> +                               FC_CTELS_STATUS_REJECT : FC_CTELS_STATUS_OK;
>> +       job->state_flags = FC_RQST_STATE_DONE;
>> +       job->reply->reply_payload_rcv_len = blk_rq_bytes(job->req->next_rq);
>
> same comment as above.
>
>> +       job->job_done(job);
>> +
>> +       zfcp_wka_port_put(ct_fc_job->ct.wka_port);
>> +
>> +       kfree(ct_fc_job);
>> +}
>
> Are you going to add support for the ELS/CT request timing out (e.g. for
> bsg_timeout callback) ?

We don't have an interface to our hardware to abort ELS or CT
requests. I suggested to remove the bsg_timeout callback, since there
is not much zfcp can do here. Any pending request will timeout in the
SAN or in the HBA if there is not response.

> Everything else looks good, and looks like it wasn't much effort to support.
> Great.

Yes, the result looks good.

With 2.6.30-rc1 being out, the next merge window will be for 2.6.31.
Are you going to push the FC passthrough support for 2.6.31?

--
Christof Schmitt
