From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [SCSI] fix wrong context bugs in SCSI
Date: Wed, 08 Feb 2006 09:31:02 -0600
Message-ID: <1139412662.3003.5.camel@mulgrave.il.steeleye.com>
References: <1139342419.6065.8.camel@mulgrave.il.steeleye.com>
	 <1139342922.6065.12.camel@mulgrave.il.steeleye.com>
	 <20060208085629.GE4338@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030347AbWBHPbO@vger.kernel.org>
In-Reply-To: <20060208085629.GE4338@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2006-02-08 at 09:56 +0100, Jens Axboe wrote:
> Hmm, this (and further up) could fail, yet you don't check.

By and large, you have process context, so this isn't going to be a
problem.

> I don't think this API is very nice to be honest, there's no good way to
> handle failures - you can't just sleep and loop retry the execute if you
> are in_interrupt(). I'd prefer passing in a work_queue_work (with a
> better name :-) that has been allocated at a reliable time during
> initialization.

Yes, I agree ... however, the failure is less prevalent in the new code
than the old.  The problem is that we may need to execute multiple puts
for a single target from irq contex, so under this scheme you need a wqw
(potentially) for every get.

I could solve this by binding the API more tightly into the device
model, so the generic device contains the wqw and it is told that the
release function of the final put must be called in process context, but
that's an awful lot of code changes.

James
