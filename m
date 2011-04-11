From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation problem
Date: Mon, 11 Apr 2011 14:38:30 -0400
Message-ID: <1302547069-sup-103@think>
References: <20110308045626.GD1956@dastard> <20110319000755.GD1110@tux1.beaverton.ibm.com> <20110321140451.GA7153@quack.suse.cz> <1300716666-sup-2087@think> <20110321164305.GC7153@quack.suse.cz> <20110406232938.GF1110@tux1.beaverton.ibm.com> <20110407165700.GB7363@quack.suse.cz> <20110408203135.GH1110@tux1.beaverton.ibm.com> <20110411124229.47bc28f6@corrin.poochiereds.net> <1302543595-sup-4352@think> <20110411182541.GA29511@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20110411182541.GA29511@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Layton <jlayton@redhat.com>, djwong <djwong@us.ibm.com>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Joel Becker <jlbec@evilplan.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Excerpts from Christoph Hellwig's message of 2011-04-11 14:25:41 -0400:
> On Mon, Apr 11, 2011 at 01:41:16PM -0400, Chris Mason wrote:
> > Actually this isn't a nit.  Keeping the page locked closes an important
> > hole where it can become writeback again.  It might fix the last
> > remaining problem.
> 
> Note that the generic block_page_mkwrite atually does that.  But only
> xfs and nilfs2 actually make use of it.
> 

Btrfs does return VM_FAULT_LOCKED though.  I had forgotten to look for
this in the ext4 page_mkwrite call.

-chris
