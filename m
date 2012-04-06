From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC] How to fix an async scan - rmmod race?
Date: Fri, 06 Apr 2012 18:15:25 +0100
Message-ID: <1333732525.2953.16.camel@dabdike>
References: <4F7DA4F8.90104@redhat.com> <4F7DDDCC.1070506@acm.org>
	   <4F7E0EBF.80407@cs.wisc.edu> <4F7EBD3A.8070509@redhat.com>
	  <1333725609.2953.12.camel@dabdike> <4F7F1687.9000309@acm.org>
	 <1333730146.2953.13.camel@dabdike> <4F7F214D.20500@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33854 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932107Ab2DFRPa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Apr 2012 13:15:30 -0400
In-Reply-To: <4F7F214D.20500@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Tomas Henzl <thenzl@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>

On Fri, 2012-04-06 at 17:01 +0000, Bart Van Assche wrote:
> On 04/06/12 16:35, James Bottomley wrote:
> 
> > On Fri, 2012-04-06 at 16:15 +0000, Bart Van Assche wrote:
> >> As far as I can see the queuecommand call in scsi_dispatch_cmd() can
> >> race with module removal - that call can be triggered while the host
> >> template is being unloaded. I'm not sure though what the best approach
> >> is to fix that race.
> > 
> > Um, it's a bit hard to see how.  It's not really possible to trigger
> > queuecommand except in the initial probe without an open device ... and
> > opening the device holds the module.
> 
> 
> Sorry, but I forgot to mention that it's not just scsi_dispatch_cmd()
> that invokes queuecommand via the host template. The SCSI error handler
> does that too. As far as I can see there is no protection in the SCSI
> error handler against LLD module removal. But maybe I overlooked something.

Consider where the command came from: either it's come from startup (the
current problem), operation (in which case the device must be open to
send and receive it) or teardown (which is synchronous).

James


