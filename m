From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 5/7] qla2xxx: Simpify unregistration of FC-NVMe
 local/remote ports
Date: Thu, 20 Jul 2017 09:03:09 +0200
Message-ID: <20170720070308.GF5240@linux-x5ow.site>
References: <20170719185151.8564-1-himanshu.madhani@cavium.com>
 <20170719185151.8564-6-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35011 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751903AbdGTHDK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Jul 2017 03:03:10 -0400
Content-Disposition: inline
In-Reply-To: <20170719185151.8564-6-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

On Wed, Jul 19, 2017 at 11:51:49AM -0700, Himanshu Madhani wrote:
> -static void qla_nvme_abort_all(fc_port_t *fcport)
> -{
> -	int que, cnt;
> -	unsigned long flags;
> -	srb_t *sp;
> -	struct qla_hw_data *ha = fcport->vha->hw;
> -	struct req_que *req;
> -
> -	spin_lock_irqsave(&ha->hardware_lock, flags);
> -	for (que = 0; que < ha->max_req_queues; que++) {
> -		req = ha->req_q_map[que];
> -		if (!req)
> -			continue;
> -		if (!req->outstanding_cmds)
> -			continue;
> -		for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
> -			sp = req->outstanding_cmds[cnt];
> -			if ((sp) && ((sp->type == SRB_NVME_CMD) ||
> -			    (sp->type == SRB_NVME_LS)) &&
> -				(sp->fcport == fcport)) {
> -				atomic_inc(&sp->ref_count);
> -				spin_unlock_irqrestore(&ha->hardware_lock,
> -				    flags);
> -				qla_nvme_abort(ha, sp);
> -				spin_lock_irqsave(&ha->hardware_lock, flags);
> -				req->outstanding_cmds[cnt] = NULL;
> -				sp->done(sp, 1);
> -			}
> -		}
> -	}
> -	spin_unlock_irqrestore(&ha->hardware_lock, flags);
> -}
> -
>  static void qla_nvme_unregister_remote_port(struct work_struct *work)
>  {
>  	struct fc_port *fcport = container_of(work, struct fc_port,
> @@ -719,12 +679,13 @@ void qla_nvme_delete(struct scsi_qla_host *vha)
>  		ql_log(ql_log_info, fcport->vha, 0x2114, "%s: fcport=%p\n",
>  		    __func__, fcport);
>  
> +		init_completion(&fcport->nvme_del_done);
>  		nvme_fc_unregister_remoteport(fcport->nvme_remote_port);
>  		qla_nvme_wait_on_rport_del(fcport);
> -		qla_nvme_abort_all(fcport);

What changed the need to abort all outstanding commands?

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
