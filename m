From: Chanho Min <chanho0207@gmail.com>
Subject: Re: [PATCH] fix NULL-pointer dereference on scsi_run_queue
Date: Wed, 8 Aug 2012 12:42:44 +0900
Message-ID: <CAOAMb1BNSTaG8N68jcEDV3gNt6V7BM9HkjUuXHeebhLNHe18kA@mail.gmail.com>
References: <CAOAMb1D+g0zzKGKjMPPp7V-XEwKB5AYGMDvUUbXNaHaz8ieTVg@mail.gmail.com>
	<501CE4E5.20604@acm.org>
	<501D51D1.2010806@cs.wisc.edu>
	<501D83A1.7040900@acm.org>
	<501DA3F0.4090009@cs.wisc.edu>
	<50200561.4020100@acm.org>
	<CAOAMb1BWWzYPSode-6Y9+O5eNhMc-bYofCNwMRmzeC9-nhRb4g@mail.gmail.com>
	<5020E031.9080406@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5020E031.9080406@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

> I'm afraid that without the second half of that patch the following race
> is still possible:
> - sdev reference count drops to zero while scsi_run_queue() is in
>   progress and while that sdev is on the starved_list of its SCSI host;
>   scsi_device_dev_release_usercontext() call is scheduled but not yet
>   executed.
> - scsi_run_queue() takes that sdev off the local starved_list.
> - scsi_run_queue() calls get_device() and that call fails since the
>   sdev reference count is zero.
> - scsi_device_dev_release_usercontext() gets scheduled and frees the
>   sdev.
> - scsi_run_queue() proceeds and calls __blk_run_queue() on a freed
>   queue, which is what we were trying to avoid.
Thank you for the explanation. It look correct. Let's check one more thing.
What If __scsi_remove_device doesn't release device? : reference count
is more than 2.
So We lost starved_list but device is exist. Is there any issue about this?

Chanho,
