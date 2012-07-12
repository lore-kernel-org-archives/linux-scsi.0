From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Why are DID_ABORT and TASK_ABORTED handled differently?
Date: Thu, 12 Jul 2012 18:09:46 +0100
Message-ID: <1342112986.3021.51.camel@dabdike.int.hansenpartnership.com>
References: <4FFF0033.2090902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54563 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161291Ab2GLRJu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jul 2012 13:09:50 -0400
In-Reply-To: <4FFF0033.2090902@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2012-07-12 at 18:49 +0200, Paolo Bonzini wrote:
> Currently, DID_ABORT relays the failure to the upper layer, while TASK
> ABORTED (after the suggestion at
> http://marc.info/?l=linux-scsi&m=121932916906009&w=2 was implemented)
> retries the command.

They should be separate things.  TASK_ABORTED is a SCSI status code that
should be returned unmolested by the driver.  All the DID_ codes are for
host internal errors.  DID_ABORT means the host was told to abort the
command ... the implication is it was by the user or some other process,
so it's a hard failure.

> Is it correct that when TAS=0 an aborted task (from TMF, persistent
> reservation or anything else) can result in DID_ABORT?  There are some
> clues of this in the drivers, but on the other hand scsi-debug has a
> very strange usage of DID_ABORT:

No. Hosts shouldn't try to interpret status codes, that's what the mid
layer does.

> static const int illegal_condition_result =
>         (DRIVER_SENSE << 24) | (DID_ABORT << 16) |
>         SAM_STAT_CHECK_CONDITION;
> 
> ...
>         /* DIX + T10 DIF */
>         if (scsi_debug_dix && scsi_prot_sg_count(SCpnt)) {
>                 int prot_ret = prot_verify_read(SCpnt, lba, num, ei_lba);
> 
>                 if (prot_ret) {
>                         mk_sense_buffer(devip, ABORTED_COMMAND, 0x10,
> prot_ret);
>                         return illegal_condition_result;
>                 }
>         }
> 
> 
> If it is the case that they are similar, is there any reason why the two
> are handled differently?

That looks to be a bug in scsi_debug.

James


