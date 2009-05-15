From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH block#for-2.6.31 2/3] block: set rq->resid_len to blk_rq_bytes()
 on issue
Date: Fri, 15 May 2009 19:38:27 +0400
Message-ID: <4A0D8C73.50208@ru.mvista.com>
References: <4A0D86DB.9000203@kernel.org> <4A0D87D2.7090806@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4A0D87D2.7090806@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Borislav Petkov <petkovbb@googlemail.com>, Pete Zaitcev <zaitcev@redhat.com>, Eric Moore <Eric.Moore@lsi.com>, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Hello.

Tejun Heo wrote:

> In commit c3a4d78c580de4edc9ef0f7c59812fb02ceb037f, while introducing
> rq->resid_len, the default value of residue count was changed from
> full count to zero.  The conversion was done under the assumption that
> when a request fails residue count wasn't defined.  However, Boaz and
> James pointed out that this wasn't true and the residue count should
> be preserved for failed requests too.

> This patchset restores the original behavior by setting rq->resid_len
> to blk_rq_bytes(rq) on issue and restoring explicit clearing in
> affected drivers.  While at it, take advantage of the fact that
> rq->resid_len is set to full count where applicable.

> * ide-cd: rq->resid_len cleared on pc success

> * mptsas: req->resid_len cleared on success

> * sas_expander: rsp/req->resid_len cleared on success

> * mpt2sas_transport: req->resid_len cleared on success

> * ide-cd, ide-tape, mptsas, sas_host_smp, mpt2sas_transport, ub: take
>   advantage of initial full count to simplify code

> Signed-off-by: Tejun Heo <tj@kernel.org>

    The patch looks er... strange at some places.

> Index: block/drivers/message/fusion/mptsas.c
> ===================================================================
> --- block.orig/drivers/message/fusion/mptsas.c
> +++ block/drivers/message/fusion/mptsas.c
> @@ -1357,7 +1357,8 @@ static int mptsas_smp_handler(struct Scs
>  		smprep = (SmpPassthroughReply_t *)ioc->sas_mgmt.reply;
>  		memcpy(req->sense, smprep, sizeof(*smprep));
>  		req->sense_len = sizeof(*smprep);
> -		rsp->resid_len = blk_rq_bytes(rsp) - smprep->ResponseDataLength;
> +		req->resid_len = 0;
> +		rsp->resid_len -= smprep->ResponseDataLength;

    Is negative resid_len intended here? If so, shouldn't it be simply:

		rsp->resid_len = -smprep->ResponseDataLength;


> Index: block/drivers/scsi/libsas/sas_expander.c
> ===================================================================
> --- block.orig/drivers/scsi/libsas/sas_expander.c
> +++ block/drivers/scsi/libsas/sas_expander.c
> @@ -1937,7 +1937,11 @@ int sas_smp_handler(struct Scsi_Host *sh
>  	if (ret > 0) {
>  		/* positive number is the untransferred residual */
>  		rsp->resid_len = ret;
> +		req->resid_len = 0;
>  		ret = 0;
> +	} else if (ret == 0) {
> +		rsp->resid_len = 0;
> +		req->resid_len = 0;

    ???

> Index: block/drivers/scsi/libsas/sas_host_smp.c
> ===================================================================
> --- block.orig/drivers/scsi/libsas/sas_host_smp.c
> +++ block/drivers/scsi/libsas/sas_host_smp.c
> @@ -176,9 +176,6 @@ int sas_smp_host_handler(struct Scsi_Hos
>  	resp_data[1] = req_data[1];
>  	resp_data[2] = SMP_RESP_FUNC_UNK;
>  
> -	req->resid_len = blk_rq_bytes(req);
> -	rsp->resid_len = blk_rq_bytes(rsp);
> -

    ???

>  	switch (req_data[1]) {
>  	case SMP_REPORT_GENERAL:
>  		req->resid_len -= 8;
> Index: block/drivers/scsi/mpt2sas/mpt2sas_transport.c
> ===================================================================
> --- block.orig/drivers/scsi/mpt2sas/mpt2sas_transport.c
> +++ block/drivers/scsi/mpt2sas/mpt2sas_transport.c
> @@ -1170,8 +1170,8 @@ transport_smp_handler(struct Scsi_Host *
>  
>  		memcpy(req->sense, mpi_reply, sizeof(*mpi_reply));
>  		req->sense_len = sizeof(*mpi_reply);
> -		rsp->resid_len = blk_rq_bytes(rsp) -
> -				 mpi_reply->ResponseDataLength;
> +		req->resid_len = 0;
> +		rsp->resid_len -= mpi_reply->ResponseDataLength;

    Again, is negative resid_len intended?

MBR, Sergei
