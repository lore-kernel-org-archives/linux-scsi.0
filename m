From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] fix NULL-pointer dereference on scsi_run_queue
Date: Sat, 04 Aug 2012 20:18:41 +0000
Message-ID: <501D83A1.7040900@acm.org>
References: <CAOAMb1D+g0zzKGKjMPPp7V-XEwKB5AYGMDvUUbXNaHaz8ieTVg@mail.gmail.com> <501CE4E5.20604@acm.org> <501D51D1.2010806@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <501D51D1.2010806@cs.wisc.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Chanho Min <chanho0207@gmail.com>, James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 08/04/12 16:46, Mike Christie wrote:
> I think we have to have scsi-ml do a get_device when a sdev is added to
> the starved entry and then do a put_device when it is removed (must do
> these under the host lock for the starved entry case too). I am not sure
> if that is just a hack/papering-over of the problem and there are more
> issues like this.

That would result in a more complex patch than the patch at the start of
this thread, isn't it ? Also, IMHO it would help to document which
functions in the scsi-ml are called with an sdev reference and which
ones not. That would make the scsi-ml code easier to verify for issues
like the one reported at the start of this thread.

Bart.
