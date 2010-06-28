From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] block: fix leaks associated with discard request payload
Date: Mon, 28 Jun 2010 09:57:38 +0200
Message-ID: <20100628075738.GA26606@lst.de>
References: <20100627185927K.fujita.tomonori@lab.ntt.co.jp> <20100627193253P.fujita.tomonori@lab.ntt.co.jp> <20100627110712.GA14511@lst.de> <20100627212952D.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100627212952D.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: hch@lst.de, snitzer@redhat.com, axboe@kernel.dk, dm-devel@redhat.com, James.Bottomley@suse.de, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, akpm@linux-foundation.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Jun 27, 2010 at 09:32:07PM +0900, FUJITA Tomonori wrote:
> On Sun, 27 Jun 2010 13:07:12 +0200
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > > How about this?
> > 
> > As I tried to explain before this utterly confuses the I/O completion
> > path.  With the patch applied even a simple mkfs.xfs that issues discard
> > just hangs.
> 
> Wired. I just tried mkfs.xfs against scsi_debug with my block patches
> (I saw one discard command). Seemed that it worked fine.

I've tracked it down to the call to scsi_requeue_command in scsi_end_request.
When the command is marked BLOCK_PC we'll just get it back as such in
->prep_fn next time, but now it's reverting to the previous state.
While I see the problems with leaking ressources in that case I still
can't quite explain the hang I see.
