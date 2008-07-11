From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RESEND PATCH 02/18] qla2xxx: Add	dev_loss_tmo_callbk/terminate_rport_io
 callback support.
Date: Fri, 11 Jul 2008 13:21:55 -0500
Message-ID: <4877A4C3.6010903@cs.wisc.edu>
References: <20080710235458.GQ29099@plap4-2.local> <1215734163-40825-2-git-send-email-andrew.vasquez@qlogic.com> <48779934.8020000@cs.wisc.edu> <20080711180437.GB55164@plap4-2.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:48845 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbYGKSWJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2008 14:22:09 -0400
In-Reply-To: <20080711180437.GB55164@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Seokmann Ju <seokmann.ju@qlogic.com>, James Smart <James.Smart@Emulex.Com>

Andrew Vasquez wrote:
> From: Seokmann Ju <seokmann.ju@qlogic.com>
> 
> Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
> Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> ---
> 
> 	On Fri, 11 Jul 2008, Mike Christie wrote:
> 
> 	> Andrew Vasquez wrote:
> 	>> +
> 	>> +static void
> 	>> +qla2x00_terminate_rport_io(struct fc_rport *rport)
> 	>> +{
> 	>> +	fc_port_t *fcport = *(fc_port_t **)rport->dd_data;
> 	>> +
> 	>> +	qla2x00_abort_fcport_cmds(fcport);
> 	>> +	scsi_target_unblock(&rport->dev);
> 	>
> 	> I sent a patch so the unblock is always done by the fc class.
> 	> http://marc.info/?l=linux-scsi&m=121263015008613&w=2
> 	>
> 	> Could we do that instead so qlogic and emulex and all other drivers behave 
> 	> the same?
> 
> 	Sure.  Here's a recut of the patch without the explicit
> 	scsi_target_unblock().


Thanks, I think maybe your first patch should go in with this patchset 
now. Later when my patch goes in I will cleanup the unblock for you.

Well, actually I guess it is buggy either way :) I think you guys need 
it right now for when the terminate callback is called when we remove 
the port. But if the terminate callback is called for just when the fast 
io fail tmo fires, we would unblock the queue and then IO in there will 
just bounce around because when it hits the queuecommand the rport 
chkready function will just queue it back up. My patches allow us to 
fail the IO instead of having it bounce around.

JamesB and JamesS, what do you guys think of my patches? I can just do 
this one
http://marc.info/?l=linux-scsi&m=121263015008613&w=2
(but not use the DID_TRANSPORT_ values)

so that we do not hit the problem above. I will also add some 
scsi_target_unblock calls when the terminate call back is called for 
rport removal so the drivers do not have to handle in those cases too.
