From: Christoph Hellwig <hch@lst.de>
Subject: Re: remove exofs, the T10 OSD code and block/scsi bidi support V3
Date: Wed, 19 Dec 2018 15:43:47 +0100
Message-ID: <20181219144347.GB23410@lst.de>
References: <20181111133211.13926-1-hch@lst.de> <4f4b6aff-6726-c500-e3e4-f8b73d641851@electrozaur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4f4b6aff-6726-c500-e3e4-f8b73d641851@electrozaur.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <ooo@electrozaur.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, martin.petersen@oracle.com, Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 26, 2018 at 07:11:10PM +0200, Boaz Harrosh wrote:
> On 11/11/18 15:32, Christoph Hellwig wrote:
> > The only real user of the T10 OSD protocol, the pNFS object layout
> > driver never went to the point of having shipping products, and we
> > removed it 1.5 years ago.  Exofs is just a simple example without
> > real life users.
> > 
> 
> You have failed to say what is your motivation for this patchset? What
> is it you are trying to fix/improve.

Drop basically unused support, which allows us to

 1) reduce the size of every kernel with block layer support, and
    even more for every kernel with scsi support
 2) reduce the size of the critical struct request structure by
    128 bits, thus reducing the memory used by every blk-mq driver
    significantly, never mind the cache effects
 3) stop having the maintainance overhead for this code in the
    block layer, which has been rather painful at times
