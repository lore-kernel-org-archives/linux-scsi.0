From: Chanho Min <chanho0207@gmail.com>
Subject: Re: [PATCH RESEND] remove the queue unlock in scsi_requset_fn
Date: Thu, 16 Aug 2012 10:35:59 +0900
Message-ID: <CAOAMb1COJbAF=ys7ZcpTuJNP6QzbQzuqz7gS4qPqSc1rfbnHTw@mail.gmail.com>
References: <CAOAMb1Dd5_KWQme+EzXdpnABk=A50+vXuLMoS+r5et6=o0605g@mail.gmail.com>
	<CAOAMb1Dp=E6fjMhdh6ze6Hq48qUixTpsqHZf3z742AUAqhU5Ug@mail.gmail.com>
	<1344946071.3117.26.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1344946071.3117.26.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

> functions will occur in line.  I also don't see why the sdev reference
> couldn't drop to zero here.
scsi_request_fn is called under the lock of request_queue->queue_lock.
If we drop the sdev reference to zero here,
scsi_device_dev_release_usercontext is
invoked and make request_queue to NULL. When caller of scsi_request_fn try to
unlock request_queue->queue_lock, the oops is occurred.

Thanks, Chanho
