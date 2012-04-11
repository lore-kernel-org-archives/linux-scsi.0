From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] How to fix an async scan - rmmod race?
Date: Wed, 11 Apr 2012 13:17:46 -0500
Message-ID: <4F85CACA.8060803@cs.wisc.edu>
References: <4F7DA4F8.90104@redhat.com> <4F7DDDCC.1070506@acm.org>    <4F7E0EBF.80407@cs.wisc.edu> <4F7EBD3A.8070509@redhat.com>   <1333725609.2953.12.camel@dabdike> <4F7F1687.9000309@acm.org>  <1333730146.2953.13.camel@dabdike> <4F7F214D.20500@acm.org> <1333732525.2953.16.camel@dabdike> <4F81CCF9.8010408@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45115 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755908Ab2DKSR7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Apr 2012 14:17:59 -0400
In-Reply-To: <4F81CCF9.8010408@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Tomas Henzl <thenzl@redhat.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>

On 04/08/2012 12:38 PM, Bart Van Assche wrote:
> On 04/06/12 17:15, James Bottomley wrote:
> 
>> Consider where the command came from: either it's come from startup (the
>> current problem), operation (in which case the device must be open to
>> send and receive it) or teardown (which is synchronous).
> 
> 
> And what about e.g. sd_check_events() or sr_check_events() ?

Are those setup to run from the open functions, so we will have done a
get on the module (sd_open() -> check_disk_change()) for those.

> 
> Maybe I should explain why I started looking at the SCSI error handler
> in so much detail. While running disk removal tests against ib_srp I
> found out that the SCSI error handler thread can invoke the LLD's abort
> and reset handlers long after scsi_remove_host() finished. That's why I
> came up with this patch: "[PATCH 05/15] ib_srp: Avoid that SCSI error
> handling triggers a crash"
> (http://www.mail-archive.com/linux-rdma@vger.kernel.org/msg11234.html).
> But I'm still wondering whether that's the right approach. Should this
> issue be addressed in each LLD or in the SCSI core ?
> 

I would like scsi core to handle this, but I think right now drivers are
doing work arounds like your patch.

For example FC drivers will call fc_remove_host which sets things up so
no new IO can be sent to the device after that function has completed
and will call some callouts like dev_loss_tmo_callbk to cleanup
outstanding IO. The problem is that when it calls scsi_remove_host that
could cause commands like cache sync from sd.c's shutdown to get failed
(the queuecommand function will call the fc check ready function which
will fail the IO immediately).

iSCSI drivers will call scsi_remove_target, do a iscsi logout and
cleanup outstanding commands if needed, set things up so new IO is
failed (I do not think there should be new IO because scsi_remove_target
should have removed the devices and the iscsi logout/shutdown code made
sure the iscsi queues were empty), then call scsi_remove_host.
