From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [RFC] libata new EH document
Date: Thu, 01 Sep 2005 19:03:34 -0400
Message-ID: <431788C6.1090007@adaptec.com>
References: <20050901043850.15186.qmail@web51611.mail.yahoo.com>	 <43169520.6040008@gmail.com>  <20050901055421.GA23496@havoc.gtf.org>	 <1125581097.4834.5.camel@mulgrave>  <4317755C.5080700@adaptec.com>	 <1125611718.4946.20.camel@mulgrave>  <43177B95.4040602@adaptec.com>	 <1125613408.4946.28.camel@mulgrave>  <43178281.20203@adaptec.com> <1125615684.4946.36.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1125615684.4946.36.camel@mulgrave>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>, ltuikov@yahoo.com, Albert Lee <albertcc@tw.ibm.com>, linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, Doug Maxey <dwm@maxeymade.com>
List-Id: linux-scsi@vger.kernel.org

On 09/01/05 19:01, James Bottomley wrote:
> On Thu, 2005-09-01 at 18:36 -0400, Luben Tuikov wrote:
> 
>>So are you claiming that 
>>    "the error handler clears contingent allegiance conditions" ?
>>
>>Please point me to the lines in the source code where it does this
>>and how it does it.
> 
> 
> That's this bit:
> 
> static void scsi_unjam_host(struct Scsi_Host *shost)
> {
> 	unsigned long flags;
> 	LIST_HEAD(eh_work_q);
> 	LIST_HEAD(eh_done_q);
> 
> 	spin_lock_irqsave(shost->host_lock, flags);
> 	list_splice_init(&shost->eh_cmd_q, &eh_work_q);
> 	spin_unlock_irqrestore(shost->host_lock, flags);
> 
> 	SCSI_LOG_ERROR_RECOVERY(1, scsi_eh_prt_fail_stats(shost, &eh_work_q));
> 
> 	if (!scsi_eh_get_sense(&eh_work_q, &eh_done_q))
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Yeah, that ought to do it. ;-)

	Luben


> 		if (!scsi_eh_abort_cmds(&eh_work_q, &eh_done_q))
> 			scsi_eh_ready_devs(shost, &eh_work_q, &eh_done_q);
> 
> James
> 
> 
> 

