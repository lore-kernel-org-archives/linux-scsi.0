From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 09/14] scsi: fix the {host,target,device}_blocked
	counter mess
Date: Thu, 10 Jul 2014 08:06:17 +0200
Message-ID: <20140710060617.GB7675@lst.de>
References: <1403715121-1201-1-git-send-email-hch@lst.de> <1403715121-1201-10-git-send-email-hch@lst.de> <53BD2391.90800@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53BD2391.90800@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Robert Elliott <Elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 09, 2014 at 01:12:17PM +0200, Hannes Reinecke wrote:
> Hmm. I guess there is a race window between
> atomic_read() and atomic_set().
> Doesn't this cause issues when someone calls atomic_set() just before the 
> call to atomic_read?

There is a race window just _after_ the atomic_read, but it's harmless.
The whole _blocked scheme is a backoff to avoid resubmitting I/O all
the time when the HBA or target returned a busy status.  If we race
an incorrectly reset it we will submit I/O and just get a busy indicator
again.

On the other hand doing the atomic_set all the time introduces three atomic
in the I/O completion part that are entirely pointless most of the time.

I guess I should add something like this as a comment to the code..

Note that the old code didn't use any sort of synchronization either.
