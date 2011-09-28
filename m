From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] Queue free fix (was Re: [PATCH] block: Free queue
 resources at blk_release_queue())
Date: Wed, 28 Sep 2011 14:16:49 -0400
Message-ID: <20110928181649.GA27441@infradead.org>
References: <CA+55aFyL76hD7o_839G7tKa0y6dFRcK-kC+g_h_coEp=Qk23pw@mail.gmail.com>
 <1317183038.17578.9.camel@dabdike.hansenpartnership.com>
 <4E832A55.30709@kernel.dk>
 <1317219074.19034.4.camel@dabdike.hansenpartnership.com>
 <4E832BD2.50409@kernel.dk>
 <CA+55aFyFht3njKVep+aT_m5URxRxayZyb6K2ukW6+kazHf8EKA@mail.gmail.com>
 <1317224616.19034.41.camel@dabdike.hansenpartnership.com>
 <20110928174859.GA21628@redhat.com>
 <20110928175304.GA3985@infradead.org>
 <20110928180905.GB21628@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110928180905.GB21628@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Linus Torvalds <torvalds@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 28, 2011 at 02:09:05PM -0400, Vivek Goyal wrote:
> I had thought of implementing a separate lock for throttling. Then I
> noticed few operations like checking for queue flags where I would
> be required to hold queue locks.

Can you do a writeup of these issues?  E.g. if the flags are throtteling
specific we can move them to a separate flags field, if not we can
see if we can make them atomic or similar.

Right now on high iops device queue_lock is the major killer for
performance.  It's one major reason (*) why a lot of the high iops devices
are all moving to ->make_request, which has other issues.

(*) others are struct request allocation and the pointless merge hash
