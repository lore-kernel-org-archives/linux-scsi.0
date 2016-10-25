From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v3 02/16] scsi: don't use fc_bsg_job::request and
 fc_bsg_job::reply directly
Date: Tue, 25 Oct 2016 09:43:14 +0200
Message-ID: <20161025074313.4ma4czgdj46imaei@linux-x5ow.site>
References: <cover.1476369687.git.jthumshirn@suse.de>
 <bbc682928173d64848ab0cbff689b1ad3d715fb7.1476369687.git.jthumshirn@suse.de>
 <ebc46cfa-0bee-aa71-ba0b-d7c86628df0c@linux.vnet.ibm.com>
 <20161014073821.qvkpjtwraqnwzzs3@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161014073821.qvkpjtwraqnwzzs3@linux-x5ow.site>
Sender: linux-kernel-owner@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Johannes Thumshirn <jth@kernel.org>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>s
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 14, 2016 at 09:38:21AM +0200, Johannes Thumshirn wrote:
> On Thu, Oct 13, 2016 at 05:55:11PM +0200, Steffen Maier wrote:
> > Hm, still behaves for me like I reported for v2:
> > http://marc.info/?l=linux-scsi&m=147637177902937&w=2
> 
> Hi Steffen,
> 
> Can you please try the following on top of 2/16?
> 
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index 4149dac..baebaab 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -3786,6 +3786,12 @@ enum fc_dispatch_result {
>  	int cmdlen = sizeof(uint32_t);	/* start with length of msgcode */
>  	int ret;
>  
> +	/* check if we really have all the request data needed */
> +	if (job->request_len < cmdlen) {
> +		ret = -ENOMSG;
> +		goto fail_host_msg;
> +	}
> +
>  	/* Validate the host command */
>  	switch (bsg_request->msgcode) {
>  	case FC_BSG_HST_ADD_RPORT:
> @@ -3831,12 +3837,6 @@ enum fc_dispatch_result {
>  		goto fail_host_msg;
>  	}
>  
> -	/* check if we really have all the request data needed */
> -	if (job->request_len < cmdlen) {
> -		ret = -ENOMSG;
> -		goto fail_host_msg;
> -	}
> -
>  	ret = i->f->bsg_request(job);
>  	if (!ret)
>  		return FC_DISPATCH_UNLOCKED;
> @@ -3887,6 +3887,12 @@ enum fc_dispatch_result {
>  	int cmdlen = sizeof(uint32_t);	/* start with length of msgcode */
>  	int ret;
>  
> +	/* check if we really have all the request data needed */
> +	if (job->request_len < cmdlen) {
> +		ret = -ENOMSG;
> +		goto fail_rport_msg;
> +	}
> +
>  	/* Validate the rport command */
>  	switch (bsg_request->msgcode) {
>  	case FC_BSG_RPT_ELS:
> 
> 
> 
> The rational behind this is, in fc_req_to_bsgjob() we're assigning
> job->request as req->cmd and job->request_len = req->cmd_len. But without
> checkinf job->request_len we don't know whether we're save to touch
> job->request (a.k.a. bsg_request).

Hi Steffen,
Did you have any chance testing this? I hacked fcping to work with non-FCoE
and rports as well and tested with FCoE and lpfc. No problems seen from my
side. I've also pused the series (With this change folded in) to my git 
tree at [1] if this helps you in any way.

[1] https://git.kernel.org/cgit/linux/kernel/git/jth/linux.git/log/?h=scsi-bsg-rewrite-v4

Thanks a lot,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
