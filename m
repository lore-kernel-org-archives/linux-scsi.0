From: Swen Schillig <swen@vnet.ibm.com>
Subject: Re: [RFC] let LLD handle bsg_job_timeout
Date: Mon, 04 Jan 2010 14:36:52 +0100
Message-ID: <1262612212.4650.6.camel@localhost.localdomain>
References: <1260434723.2955.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:33658 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab0ADNgy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2010 08:36:54 -0500
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate2.uk.ibm.com (8.13.1/8.13.1) with ESMTP id o04DareI024231
	for <linux-scsi@vger.kernel.org>; Mon, 4 Jan 2010 13:36:53 GMT
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com [9.149.37.212])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o04Dar6o667846
	for <linux-scsi@vger.kernel.org>; Mon, 4 Jan 2010 13:36:53 GMT
Received: from d06av01.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av01.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o04Daq23006703
	for <linux-scsi@vger.kernel.org>; Mon, 4 Jan 2010 13:36:53 GMT
In-Reply-To: <1260434723.2955.25.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Smart@emulex.com

James

unfortunately I posted below RFC not to you but to James B.
Anyhow, it appeared on the SCSI list, have you read it by accident ?

Could you give me an idea whether the suggested change is an option ?

Thanks in advance.
Swen

On Thu, 2009-12-10 at 09:45 +0100, Swen Schillig wrote:
> The current fc_bsg_job_timeout function offers 
> only two possibilities to a LLD to deal with timed out requests.
> Either you deal with it offering a callback or not, 
> in both scenarios the environment is cleaned up afterwards.
> 
> Unfortunately we (zfcp) don't have the option
> to easily abort a request. Our hardware is running its 
> own timer taking care of requests but unfortunately our only chance is
> to wait until we receive a response. Up until then we need
> the environment because the hardware might write into the provided
> buffers.
> 
> The following code snippet would solve the issue for us
> but maybe someone has a better idea on how to deal with the
> described situation.
> 
> Cheers Swen
> ---
>  drivers/scsi/scsi_transport_fc.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> Index: HEAD/drivers/scsi/scsi_transport_fc.c
> ===================================================================
> --- HEAD.orig/drivers/scsi/scsi_transport_fc.c
> +++ HEAD/drivers/scsi/scsi_transport_fc.c
> @@ -3500,7 +3500,10 @@ fc_bsg_job_timeout(struct request *req)
>  	if (!done && i->f->bsg_timeout) {
>  		/* call LLDD to abort the i/o as it has timed out */
>  		err = i->f->bsg_timeout(job);
> -		if (err)
> +		if (err == -EAGAIN) {
> +			job->ref_cnt--;
> +			return BLK_EH_RESET_TIMER;
> +		} else if (err)
>  			printk(KERN_ERR "ERROR: FC BSG request timeout - LLD "
>  				"abort failed with status %d\n", err);
>  	}
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


