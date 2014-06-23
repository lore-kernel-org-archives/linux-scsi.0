From: Christoph Hellwig <hch@lst.de>
Subject: Re: scsi-mq
Date: Mon, 23 Jun 2014 09:09:51 +0200
Message-ID: <20140623070951.GB12267@lst.de>
References: <1402580946-11470-1-git-send-email-hch@lst.de> <53A05068.4080702@acm.org> <53A10B3A.6050705@kernel.dk> <53A13B19.2010305@acm.org> <94D0CD8314A33A4D9D801C0FE68B402958B41923@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958B41923@G9W0745.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jun 21, 2014 at 12:52:22AM +0000, Elliott, Robert (Server Storage) wrote:
> Some of those context switches might be from scsi_end_request(), 
> which always schedules the scsi_requeue_run_queue() function via the
> requeue_work workqueue for scsi-mq.  That causes lots of context 
> switches from a busy application thread (e.g., fio) to a 
> kworker thread.

Jens has been prodding me to fix this up, I'll send a patch soon that avoids
the workqueue unless we need to kick other queues and thus walk the list
of LUNs.
