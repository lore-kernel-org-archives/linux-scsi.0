From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v2] scsi: libsas: fix length error in sas_smp_handler()
Date: Fri, 8 Dec 2017 09:49:46 +0000
Message-ID: <9f0c1405-d0ba-9bc4-b91a-8cc9f9b5ba23@huawei.com>
References: <20171207105751.27225-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:2272 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753450AbdLHJuP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 8 Dec 2017 04:50:15 -0500
In-Reply-To: <20171207105751.27225-1-yanaijie@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hch@lst.de
Cc: linux-scsi@vger.kernel.org, jthumshirn@suse.de, hare@suse.com

On 07/12/2017 10:57, Jason Yan wrote:
> The bsg_job_done() requires the length of payload received, but we give
> it the untransferred residual.
>

As I understand, this patches fixes (SES) enclosure management for 
libsas, so it's quite an important patch.

Thanks,
John

> Fixes: 651a01364994 ("scsi: scsi_transport_sas: switch to bsg-lib for SMP passthrough")
> Reported-and-tested-by: chenqilin <chenqilin2@huawei.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> CC: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/libsas/sas_expander.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index 50cb0f3..6c40ecc 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -2143,7 +2143,7 @@ void sas_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
>  		struct sas_rphy *rphy)
>  {
>  	struct domain_device *dev;
> -	unsigned int reslen = 0;
> +	unsigned int rcvlen = 0;
>  	int ret = -EINVAL;
>
>  	/* no rphy means no smp target support (ie aic94xx host) */
> @@ -2177,12 +2177,12 @@ void sas_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
>
>  	ret = smp_execute_task_sg(dev, job->request_payload.sg_list,
>  			job->reply_payload.sg_list);
> -	if (ret > 0) {
> -		/* positive number is the untransferred residual */
> -		reslen = ret;
> +	if (ret >= 0) {
> +		/* bsg_job_done() requires the length received  */
> +		rcvlen = job->reply_payload.payload_len - ret;
>  		ret = 0;
>  	}
>
>  out:
> -	bsg_job_done(job, ret, reslen);
> +	bsg_job_done(job, ret, rcvlen);
>  }
>
