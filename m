From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 22/23] drbd: implement REQ_OP_WRITE_ZEROES
Date: Fri, 31 Mar 2017 09:17:53 +0200
Message-ID: <20170331071753.GA3308@lst.de>
References: <20170323143341.31549-1-hch@lst.de> <20170323143341.31549-23-hch@lst.de> <20170330100641.GI5939@soda.linbit> <20170330114408.GA15777@lst.de> <20170330134957.GA508@redhat.com> <yq1pogy3i6u.fsf@oracle.com> <20170330231550.GA3102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170330231550.GA3102@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, agk@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 30, 2017 at 07:15:50PM -0400, Mike Snitzer wrote:
> I got pretty far along with implementing the DM thinp support for
> WRITE_ZEROES in terms of thinp's DISCARD support (more of an
> implementation detail.. or so I thought).
> 
> But while discussing this effort with Jeff Moyer he asked: shouldn't the
> zeroed blocks be provisioned?  This is a fairly embarassing question not
> to be able to answer in the moment.  So I clearly need to learn what the
> overall intent of WRITE_ZEROES actually is.

It is to ensure the that the block range it's called on returns zeroes
on future reads.  Currently if REQ_UNMAP is set you may free the space
allocation, else not.

After looking at the callers I think this is the wrong way around, so
I'm going to invert the flag, so that the two callers that care that
blocks are allocated will set it instead.
