From: "Chuck Tuffli" <Chuck_Tuffli@pmc-sierra.com>
Subject: RE: [RFC PATCH 1/1] libsas: Add data integrity support
Date: Mon, 14 Mar 2011 08:01:39 -0700
Message-ID: <BE430C874DBA6841A75E65151DCC6E1C09555A64@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca>
References: <20110309221948.GA11376@rtllnx49.pmc-sierra.bc.ca> <BAFD794CD4B64DDCBF3E3647EE9F9D9B@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:54254 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752154Ab1CNPfi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2011 11:35:38 -0400
Content-class: urn:content-classes:message
In-Reply-To: <BAFD794CD4B64DDCBF3E3647EE9F9D9B@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>, linux-scsi@vger.kernel.org

> From: Jack Wang [mailto:jack_wang@usish.com] 
> Sent: Sunday, March 13, 2011 6:22 AM
> To: Chuck Tuffli; linux-scsi@vger.kernel.org
> Subject: RE: [RFC PATCH 1/1] libsas: Add data integrity support
> 
> > From: Chuck Tuffli <chuck_tuffli@pmc-sierra.com>
> > 
> > This patch adds Data Integrity support to libsas
> > 
> > Signed-off-by: Chuck Tuffli <chuck_tuffli@pmc-sierra.com>
> > ---
> > 
> > diff --git a/drivers/scsi/libsas/sas_scsi_host.c
> > b/drivers/scsi/libsas/sas_scsi_host.c
> > index 2119871..91c6afe 100644
...
> > @@ -152,6 +178,10 @@ static struct sas_task *sas_create_task(struct
> > scsi_cmnd *cmd,
> >  	task->ssp_task.task_attr = TASK_ATTR_SIMPLE;
> >  	memcpy(task->ssp_task.cdb, cmd->cmnd, 16);
> > 
> > +	task->prot = scsi_get_prot_op(cmd);
> > +	task->prot_sg = scsi_prot_sglist(cmd);
> > +	task->prot_num_scatter = scsi_prot_sg_count(cmd);
> > +
> [Jack Wang] Should we also save prot_type into a field in task?
> Others looks fine.
> Reviewed-by: Jack Wang <jack_wang@usish.com>

Agreed. I'll generate a version 2 of the patch. Thanks for the review.

---chuck
