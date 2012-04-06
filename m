From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [RFC] How to fix an async scan - rmmod race?
Date: Fri, 06 Apr 2012 17:59:07 +0000
Message-ID: <4F7F2EEB.5030108@acm.org>
References: <4F7DA4F8.90104@redhat.com> <4F7DDDCC.1070506@acm.org>    <4F7E0EBF.80407@cs.wisc.edu> <4F7EBD3A.8070509@redhat.com>   <1333725609.2953.12.camel@dabdike> <4F7F1687.9000309@acm.org>  <1333730146.2953.13.camel@dabdike> <4F7F214D.20500@acm.org> <1333732525.2953.16.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay01ant.iops.be ([212.53.4.34]:52115 "EHLO
	relay01ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869Ab2DFR7R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Apr 2012 13:59:17 -0400
In-Reply-To: <1333732525.2953.16.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tomas Henzl <thenzl@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>

On 04/06/12 17:15, James Bottomley wrote:

> On Fri, 2012-04-06 at 17:01 +0000, Bart Van Assche wrote:
>> Sorry, but I forgot to mention that it's not just scsi_dispatch_cmd()
>> that invokes queuecommand via the host template. The SCSI error handler
>> does that too. As far as I can see there is no protection in the SCSI
>> error handler against LLD module removal. But maybe I overlooked something.
> 
> Consider where the command came from: either it's come from startup (the
> current problem), operation (in which case the device must be open to
> send and receive it) or teardown (which is synchronous).


Thanks, that helps. As you might have noticed I'm trying to understand
all the lifetime and reference counting rules in the SCSI core. I've got
another question about the SCSI error handler: how is it guaranteed that
the 'struct scsi_driver' remains in existence as long as the SCSI error
handler thread is active ? scsi_send_eh_cmnd() needs a pointer to the
scsi_driver structure associated with the command it is sending as part
of the error recovery. But I haven't been able to figure out yet how it
is guaranteed that that scsi_driver structure remains around as long as
the SCSI error handler needs it.

Bart.
