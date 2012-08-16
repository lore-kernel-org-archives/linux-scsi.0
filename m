From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH RESEND] remove the queue unlock in scsi_requset_fn
Date: Thu, 16 Aug 2012 07:52:35 +0000
Message-ID: <502CA6C3.4040903@acm.org>
References: <CAOAMb1Dd5_KWQme+EzXdpnABk=A50+vXuLMoS+r5et6=o0605g@mail.gmail.com> <CAOAMb1Dp=E6fjMhdh6ze6Hq48qUixTpsqHZf3z742AUAqhU5Ug@mail.gmail.com> <1344946071.3117.26.camel@dabdike.int.hansenpartnership.com> <CAOAMb1COJbAF=ys7ZcpTuJNP6QzbQzuqz7gS4qPqSc1rfbnHTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOAMb1COJbAF=ys7ZcpTuJNP6QzbQzuqz7gS4qPqSc1rfbnHTw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chanho Min <chanho0207@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 08/16/12 01:35, Chanho Min wrote:
>> functions will occur in line.  I also don't see why the sdev reference
>> couldn't drop to zero here.
> scsi_request_fn is called under the lock of request_queue->queue_lock.
> If we drop the sdev reference to zero here,
> scsi_device_dev_release_usercontext is
> invoked and make request_queue to NULL. When caller of scsi_request_fn try to
> unlock request_queue->queue_lock, the oops is occurred.

Whether or not your patch is applied, if the put_device() call in
scsi_request_fn() decreases the sdev reference count to zero, the
scsi_request_fn() caller will still try to unlock the queue lock after
scsi_request_fn() finished and hence will trigger a use-after-free. I'm
afraid the only real solution is to modify the SCSI and/or block layers
such that scsi_remove_device() can't finish while scsi_request_fn() is
in progress. And once that is guaranteed the get_device() / put_device()
pair can be left out from scsi_request_fn().

Bart.
