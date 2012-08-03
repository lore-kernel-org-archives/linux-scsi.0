From: Chanho Min <chanho0207@gmail.com>
Subject: Re: [PATCH] fix NULL-pointer dereference on scsi_run_queue
Date: Fri, 3 Aug 2012 11:28:43 +0900
Message-ID: <CAOAMb1B6ZyW33HT5+qc3pw2Fxi=baradQHYxeAbE9cf=hwWzzQ@mail.gmail.com>
References: <CAOAMb1D+g0zzKGKjMPPp7V-XEwKB5AYGMDvUUbXNaHaz8ieTVg@mail.gmail.com>
	<1343897839.5073.7.camel@dabdike.int.hansenpartnership.com>
	<CAOAMb1C=fk_Ejm6TwOhoNLhP1TyRJ+QVi93VaqUmxoHsM1iXtQ@mail.gmail.com>
	<1343900093.5073.15.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55273 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab2HCC2p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Aug 2012 22:28:45 -0400
In-Reply-To: <1343900093.5073.15.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>

> Does it occur with that patch applied?
I'm trying to reproduce it with that patch. but, It is unlikely to be fixed.
because scsi_run_queue is invoked from scsi_requeue_run_queue,
not scsi_requeue_command.

> If it does, the likely fix would be to take a copy of the queue ... but
> I'd like to understand why first.  An active command has an automatic
> reference to the sdev_gendev, so it shouldn't be the normal case.  This
> was broken by unprep because it releases the command from the queue and
> drops the reference.  We may have another case like unjprep, but in that
__scsi_remove_device drops the last reference under race condition.

> case, we need to find it ... trying to add extra get/put_device() calls
> will paper over the problem.
yes, extra reference is not good to fix.
But, As long as scsi_device_dev_release_usercontext set request_queue
to NULL, Isn't it necessary to ensure that __blk_run_queue don't release device?

Thanks a lot!
Chanho Min
