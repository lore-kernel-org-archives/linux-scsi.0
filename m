From: Jens Axboe <axboe@suse.de>
Subject: Re: Q: assumptions on make_request() and request_fn()
Date: Thu, 19 Sep 2002 08:23:45 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020919062345.GH16579@suse.de>
References: <3D88E7BC.63735D7E@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3D88E7BC.63735D7E@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Sep 18 2002, Luben Tuikov wrote:
> What are the assumtions for calling make_request() or
> the request_fn()?
> 
> Interrupt context or process context or both?

make_request_fn() is called from process context, no locks held. It
often sleeps.

request_fn() is called with (2.4: io_request_lock, 2.5: q->queue_lock)
held, and interrupts disabled. The context _may_ be process, it may also
be from an interrupt handler for requeueing etc.

-- 
Jens Axboe

