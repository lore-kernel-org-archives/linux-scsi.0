From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Fri, 30 Jul 2010 09:07:32 +0200
Message-ID: <20100730070732.GA6291@lst.de>
References: <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100729014431.GD4506@thunk.org> <20100729024334.GA21736@redhat.com> <20100729084225.GA30446@lst.de> <20100729200217.GD28704@redhat.com> <20100729200655.GB17767@lst.de> <20100730031721.GA31762@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100730031721.GA31762@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Ted Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 29, 2010 at 11:17:21PM -0400, Vivek Goyal wrote:
> To me it looked like as if everything is there and it is just a matter
> of skipping elevator draining and request queue draining.

The problem is that is just appears to be so.  The code blocking only
the next barrier for tagged writes is there, but in that form it doesn't
work and probably never did.  When I try to use it and debug it I always
get my post-flush request issued before the barrier request has
finished.

