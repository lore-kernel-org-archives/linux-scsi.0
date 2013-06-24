From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH v11 8/9] Save and restore host_scribble during error
 handling
Date: Mon, 24 Jun 2013 02:08:45 +0000
Message-ID: <1372039724.2386.17.camel@dabdike>
References: <51B86E26.6030108@acm.org> <51B8702C.6030508@acm.org>
	 <51C79F11.2060906@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:48223 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab3FXCIt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Jun 2013 22:08:49 -0400
In-Reply-To: <51C79F11.2060906@cs.wisc.edu>
Content-Language: en-US
Content-ID: <70726D3629FAB846A9997C314D442115@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi <linux-scsi@vger.kernel.org>, Joe Lawrence <jdl1291@gmail.com>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, Hannes Reinecke <hare@suse.de>

On Sun, 2013-06-23 at 20:21 -0500, Mike Christie wrote:
> On 6/12/13 7:57 AM, Bart Van Assche wrote:
> > A SCSI LLD may overwrite host_scribble in its queuecommand()
> > implementation. Several drivers need that field to process
> > requests and aborts correctly. Hence this field must be saved
> > by scsi_eh_prep_cmnd() and must be restored by
> > scsi_eh_restore_cmnd().
> >
> > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> > Cc: James Bottomley <JBottomley@Parallels.com>
> > Cc: Mike Christie <michaelc@cs.wisc.edu>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: Tejun Heo <tj@kernel.org>
> 
> 
> How have we not hit this before :) ?

Well, because the patch is making bogus assumptions and then acting on
them.   host_scribble may only exist for the lifetime of the command ...
meaning from when we pass the command into the hba to when it comes
back.  When we begin error recovery, that lifetime is over, so
host_scribble should be cleared at this point to reuse the command
because that's how it is on a pristine command, so this patch, if
applied, would cause us to violate that assumption.

Fortunately, I don't think any HBA driver expects host_scribble to be
NULL, so they all unconditionally overwrite the value in their
queuecommand routines if they use it, so I think the net effect of
applying this would have been zero, but it could easily have been
unfortunate.

> Looks ok.

Oops, minus 10 review kudos points for you.  However, you seem to have a
stock of several million of these built up over the years, so the net
effect on your maintainer trust rating for reviews is zero.

James

