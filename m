From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] How to fix an async scan - rmmod race?
Date: Wed, 11 Apr 2012 13:30:21 -0500
Message-ID: <4F85CDBD.6050407@cs.wisc.edu>
References: <4F7DA4F8.90104@redhat.com> <4F7DDDCC.1070506@acm.org>    <4F7E0EBF.80407@cs.wisc.edu> <4F7EBD3A.8070509@redhat.com>   <1333725609.2953.12.camel@dabdike> <4F7F1687.9000309@acm.org>  <1333730146.2953.13.camel@dabdike> <4F7F214D.20500@acm.org> <1333732525.2953.16.camel@dabdike> <4F81CCF9.8010408@acm.org> <4F85CACA.8060803@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45130 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932647Ab2DKSad (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Apr 2012 14:30:33 -0400
In-Reply-To: <4F85CACA.8060803@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Tomas Henzl <thenzl@redhat.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>

On 04/11/2012 01:17 PM, Mike Christie wrote:
> For example FC drivers will call fc_remove_host which sets things up so
> no new IO can be sent to the device after that function has completed
> and will call some callouts like dev_loss_tmo_callbk to cleanup
> outstanding IO. The problem is that when it calls scsi_remove_host that

One correction. I meant to write scsi_target_remove above.

fc_remove_host sets the rport state then calls rport_delete_work which
then calls scsi_target_remove and it does callbacks like
dev_loss_tmo_callbk and terminate_rport_io. So scsi_remove_host would
not cause commands like sync cache to fail. That would be
scsi_target_remove. By the time the driver calls scsi_remove_host the
scsi_target_remove calls would have already removed the devices.

Same thing happens though. Because fc_remove_host sets the rport state
to FC_PORTSTATE_DELETED when scsi_remove_target removes the devices and
the sd.c shutdown code is run, IO from that would get failed by the fc
check ready function.


> could cause commands like cache sync from sd.c's shutdown to get failed
> (the queuecommand function will call the fc check ready function which
> will fail the IO immediately).
> 
