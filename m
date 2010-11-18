From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] libata: 'done' related SCSI cleanups
Date: Thu, 18 Nov 2010 10:27:20 +0100
Message-ID: <4CE4F178.8030807@kernel.org>
References: <20101118040412.GA20168@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:40325 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755561Ab0KRJ1c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2010 04:27:32 -0500
In-Reply-To: <20101118040412.GA20168@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Hello, Jeff.

On 11/18/2010 05:04 AM, Jeff Garzik wrote:
> 
> Checked this into #upstream...
> 
> We cannot easily remove 'scsidone' pointer from struct ata_queued_cmd,
> because of the following code in __ata_eh_qc_complete():
> 
> 	static void ata_eh_scsidone(struct scsi_cmnd *scmd)
> 	{
> 	        /* nada */
> 	}
> 
> 	...
> 
> 	spin_lock_irqsave(ap->lock, flags);
>         qc->scsidone = ata_eh_scsidone;
> 	__ata_qc_complete(qc);
> 	spin_unlock_irqrestore(ap->lock, flags);
> 
> 	scsi_eh_finish_cmd(scmd, &ap->eh_done_q);
> 
> I guess we're avoiding scsi_eh_done() here, Tejun?

No, we're avoiding the usual scsi_done() as after EH they're done by
scsi_eh_flush_done_q().  We can factor out ata_scsi_qc_complete() and
atapi_qc_complete() and create EH variants which don't call ->scsidone
but I'm not sure that would worth the hassle.

Thank you.

-- 
tejun
