From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [RFC] How to fix an async scan - rmmod race?
Date: Fri, 06 Apr 2012 17:01:01 +0000
Message-ID: <4F7F214D.20500@acm.org>
References: <4F7DA4F8.90104@redhat.com> <4F7DDDCC.1070506@acm.org>   <4F7E0EBF.80407@cs.wisc.edu> <4F7EBD3A.8070509@redhat.com>  <1333725609.2953.12.camel@dabdike> <4F7F1687.9000309@acm.org> <1333730146.2953.13.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay01ant.iops.be ([212.53.4.34]:56609 "EHLO
	relay01ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab2DFRBF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Apr 2012 13:01:05 -0400
In-Reply-To: <1333730146.2953.13.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tomas Henzl <thenzl@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>

On 04/06/12 16:35, James Bottomley wrote:

> On Fri, 2012-04-06 at 16:15 +0000, Bart Van Assche wrote:
>> As far as I can see the queuecommand call in scsi_dispatch_cmd() can
>> race with module removal - that call can be triggered while the host
>> template is being unloaded. I'm not sure though what the best approach
>> is to fix that race.
> 
> Um, it's a bit hard to see how.  It's not really possible to trigger
> queuecommand except in the initial probe without an open device ... and
> opening the device holds the module.


Sorry, but I forgot to mention that it's not just scsi_dispatch_cmd()
that invokes queuecommand via the host template. The SCSI error handler
does that too. As far as I can see there is no protection in the SCSI
error handler against LLD module removal. But maybe I overlooked something.

Bart.
