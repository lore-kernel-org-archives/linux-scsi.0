From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [patch 2/2] zfcp: Add FC pass-through support
Date: Tue, 7 Apr 2009 19:17:58 -0400
Message-ID: <49DBDF26.6090601@emulex.com>
References: <20090406163145.686874000@de.ibm.com> <20090406163534.659628000@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:65093 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbZDGXSI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2009 19:18:08 -0400
In-Reply-To: <20090406163534.659628000@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sven Schuetz <sven@linux.vnet.ibm.com>



Christof Schmitt wrote:
--- a/drivers/s390/scsi/zfcp_fc.c       2009-04-06 17:23:25.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fc.c       2009-04-06 17:24:30.000000000 +0200
...
> +static void zfcp_fc_generic_els_handler(unsigned long data)
> +{
> +       struct zfcp_els_fc_job *els_fc_job = (struct zfcp_els_fc_job *) data;
> +       struct fc_bsg_job *job = els_fc_job->job;
> +       struct fc_bsg_reply *reply = job->reply;
> +
> +       if (els_fc_job->els.status) {
> +               /* request rejected or timed out */
> +               reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_REJECT;
> +               goto out;
> +       }
> +
> +       reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
> +       reply->reply_payload_rcv_len = blk_rq_bytes(job->req->next_rq);

My intent was to not have the LLDD reference (or even know about) the
request structures and that bsg exists underneath.

Thus, for the last line above, it should be:
           reply->reply_payload_rcv_len = job->reply_payload->data_len;

Although, I'm a little surprised that your els interface doesn't supply the
received data length to you, rather than the global assumption that you sized 
the reply buffer for exactly what you always get.


> +struct zfcp_ct_fc_job {
> +       struct zfcp_send_ct ct;
> +       struct fc_bsg_job *job;
> +};
> +
> +static void zfcp_fc_generic_ct_handler(unsigned long data)
> +{
> +       struct zfcp_ct_fc_job *ct_fc_job = (struct zfcp_ct_fc_job *) data;
> +       struct fc_bsg_job *job = ct_fc_job->job;
> +
> +       job->reply->reply_data.ctels_reply.status = ct_fc_job->ct.status ?
> +                               FC_CTELS_STATUS_REJECT : FC_CTELS_STATUS_OK;
> +       job->state_flags = FC_RQST_STATE_DONE;
> +       job->reply->reply_payload_rcv_len = blk_rq_bytes(job->req->next_rq);

same comment as above.

> +       job->job_done(job);
> +
> +       zfcp_wka_port_put(ct_fc_job->ct.wka_port);
> +
> +       kfree(ct_fc_job);
> +}

Are you going to add support for the ELS/CT request timing out (e.g. for
bsg_timeout callback) ?

Everything else looks good, and looks like it wasn't much effort to support.
Great.

-- james s

