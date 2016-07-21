From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] block: add flag for single-threaded submission
Date: Thu, 21 Jul 2016 07:38:08 -0700
Message-ID: <20160721143808.GA29902@infradead.org>
References: <1468936978-9124-1-git-send-email-hare@suse.de>
 <1468936978-9124-2-git-send-email-hare@suse.de>
 <20160721055431.GB14568@infradead.org>
 <2cef3971-54cc-73d6-dbff-acd1379d19d5@suse.de>
 <0030fdc3-bd7d-2e91-56ae-c20086a55d22@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0030fdc3-bd7d-2e91-56ae-c20086a55d22@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel-redhat.com@suse.de, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Jens Axboe <axboe@fb.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 21, 2016 at 08:37:10AM +0200, Hannes Reinecke wrote:
> Looking closer do I _really_ need that for blk-mq?
> >From my understanding any hctx can only run on one dedicated cpu, to
> which the hctx is bound.

That's not the case.  A hctx exists for each hardware queue, and a CPU
must be mapped to a hctx.  So if you have less hctx than CPUs (e.g. just
one) you have multiple CPUs that could submit on a hctx.
