From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 1/3] Remove two cancel_delayed_work() calls from the
 error handler
Date: Tue, 27 May 2014 08:09:49 +0000
Message-ID: <1401178172.14454.12.camel@dabdike>
References: <538359DB.9080601@acm.org> <53835A52.9010306@acm.org>
	 <53835C55.6070400@redhat.com> <5384476F.6010705@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:37787 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbaE0IJv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 May 2014 04:09:51 -0400
In-Reply-To: <5384476F.6010705@acm.org>
Content-Language: en-US
Content-ID: <581ACFF18670CD4D9A8E0A80C3B1822A@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "bvanassche@acm.org" <bvanassche@acm.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "hare@suse.de" <hare@suse.de>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "jdl1291@gmail.com" <jdl1291@gmail.com>

On Tue, 2014-05-27 at 10:06 +0200, Bart Van Assche wrote:
> On 05/26/14 17:23, Paolo Bonzini wrote:
> > Il 26/05/2014 17:14, Bart Van Assche ha scritto:
> >> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> >> index 88d46fe..c972eab 100644
> >> --- a/drivers/scsi/scsi.c
> >> +++ b/drivers/scsi/scsi.c
> >> @@ -334,7 +334,7 @@ void scsi_put_command(struct scsi_cmnd *cmd)
> >>      list_del_init(&cmd->list);
> >>      spin_unlock_irqrestore(&cmd->device->list_lock, flags);
> >>
> >> -    cancel_delayed_work(&cmd->abort_work);
> >> +    WARN_ON_ONCE(delayed_work_pending(&cmd->abort_work));
> >>
> >>      __scsi_put_command(cmd->device->host, cmd);
> >>  }
> >> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> >> index f17aa7a..5232583 100644
> >> --- a/drivers/scsi/scsi_error.c
> >> +++ b/drivers/scsi/scsi_error.c
> >> @@ -193,7 +193,7 @@ scsi_abort_command(struct scsi_cmnd *scmd)
> >>          SCSI_LOG_ERROR_RECOVERY(3,
> >>              scmd_printk(KERN_INFO, scmd,
> >>                      "scmd %p previous abort failed\n", scmd));
> >> -        cancel_delayed_work(&scmd->abort_work);
> >> +        WARN_ON_ONCE(delayed_work_pending(&scmd->abort_work));
> >>          return FAILED;
> >>      }
> >>
> >>
> > 
> > I still prefer a BUG_ON in scsi_put_command, but anyway: series
> > 
> > Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Hello Paolo,
> 
> As you probably know scsi_put_command() can get called from softirq
> context. A BUG_ON() in that context might make it unnecessary hard for a
> user to collect call traces.

Why?  The messages dumped are the same, the trace just starts from the
IRQ context ... I don't see what the problem is.

The question isn't ease of gathering the data, it's correctness.  The
point is that if the assert fails we have a free of an in-use command
leading to a nasty use after free ... the machine state is hosed at that
point.

James

