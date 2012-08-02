From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] fix NULL-pointer dereference on scsi_run_queue
Date: Thu, 02 Aug 2012 10:34:53 +0100
Message-ID: <1343900093.5073.15.camel@dabdike.int.hansenpartnership.com>
References: <CAOAMb1D+g0zzKGKjMPPp7V-XEwKB5AYGMDvUUbXNaHaz8ieTVg@mail.gmail.com>
	 <1343897839.5073.7.camel@dabdike.int.hansenpartnership.com>
	 <CAOAMb1C=fk_Ejm6TwOhoNLhP1TyRJ+QVi93VaqUmxoHsM1iXtQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOAMb1C=fk_Ejm6TwOhoNLhP1TyRJ+QVi93VaqUmxoHsM1iXtQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chanho Min <chanho0207@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-08-02 at 18:28 +0900, Chanho Min wrote:
> On Thu, Aug 2, 2012 at 5:57 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > On Thu, 2012-08-02 at 17:41 +0900, Chanho Min wrote:
> >> This patch is to fix a oops from a torn down device. When
> >> scsi_run_queue process starved queues, scsi_request_fn can race with
> >> scsi_remove_device. In this case, rarely, scsi_request_fn release the
> >> last reference and set sdev->request_queue to NULL. It result in
> >> NULL-pointer dereference when spin_unlock is tried with (NULL)->
> >> queue_lock. We need to add an extra reference to the device on both
> >> sides of the __blk_run_queue to hold reference until scsi_request_fn
> >> is finished.
> >
> > You need a recent kernel with this patch:
> >
> > commit 940f5d47e2f2e1fa00443921a0abf4822335b54d
> > Author: Bart Van Assche <bvanassche@acm.org>
> > Date:   Fri Jun 29 15:34:26 2012 +0000
> >
> >     [SCSI] Avoid dangling pointer in scsi_requeue_command()
> >
> > James
> It is different from my case. This is occured inside scsi_run_queue
> and on processing starved_list.
> Another sdev is obtained from starved_list.

Does it occur with that patch applied?

If it does, the likely fix would be to take a copy of the queue ... but
I'd like to understand why first.  An active command has an automatic
reference to the sdev_gendev, so it shouldn't be the normal case.  This
was broken by unprep because it releases the command from the queue and
drops the reference.  We may have another case like unjprep, but in that
case, we need to find it ... trying to add extra get/put_device() calls
will paper over the problem.

James
