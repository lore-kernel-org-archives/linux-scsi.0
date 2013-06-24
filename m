From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v11 6/9] Make scsi_remove_host() wait until error
 handling finished
Date: Mon, 24 Jun 2013 12:19:17 -0700
Message-ID: <1372101557.2013.76.camel@dabdike.int.hansenpartnership.com>
References: <51B86E26.6030108@acm.org> <51B86FC1.6000103@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34901 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750954Ab3FXTTT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jun 2013 15:19:19 -0400
In-Reply-To: <51B86FC1.6000103@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Joe Lawrence <jdl1291@gmail.com>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>

On Wed, 2013-06-12 at 14:55 +0200, Bart Van Assche wrote:
> A SCSI LLD may start cleaning up host resources as soon as
> scsi_remove_host() returns. These host resources may be needed by
> the LLD in an implementation of one of the eh_* functions. So if
> one of the eh_* functions is in progress when scsi_remove_host()
> is invoked, wait until the eh_* function has finished. Also, do
> not invoke any of the eh_* functions after scsi_remove_host() has
> started.

We already have state guards for this, don't we?  That's the
SHOST_*_RECOVERY ones.  When eh functions are active, the host
transitions to a recovery state, so the wait could just wait on that
state rather than implement an open coded counting semaphore.

However, what's the reasoning behind wanting to do this?  In theory all
necessary resources for the eh thread should only be freed in the
release callback.  That means they aren't freed until all error recovery
completes.

James


