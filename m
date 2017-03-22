From: Christoph Hellwig <hch@lst.de>
Subject: Re: support ranges TRIM for libata
Date: Wed, 22 Mar 2017 19:19:47 +0100
Message-ID: <20170322181947.GA4733@lst.de>
References: <20170320204319.12628-1-hch@lst.de> <20170321185901.GB3706@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170321185901.GB3706@htj.duckdns.org>
Sender: linux-block-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com, axboe@kernel.dk, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 21, 2017 at 02:59:01PM -0400, Tejun Heo wrote:
> I do like the fact that this is a lot simpler than the previous
> implementation but am not quite sure we want to deviate significantly
> from what we do for other commands (command translation).  Is it
> because fixing the existing implementation would involve invaisve
> changes including memory allocations?

The current implementation already has the issue of that it does
corrupt user data reliably if the using SG_IO for WRITE SAME commands.

Doing ranges using translation would turn into a nightmare because
ATA TRIM ranges are 16 bits long while SCSI UNAMP ranges are 32-bit,
so we effectively can't translated them without introducing a
non-standard hook between libata and scsi to communicate that
limit.  And once we're down that path we might as well just do the
right thing directly.
