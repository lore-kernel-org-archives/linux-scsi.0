From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC v2] block integrity: Stabilize(?) pages during writeback
Date: Fri, 22 Apr 2011 08:50:01 -0400
Message-ID: <1303476503-sup-4141@think>
References: <1300716666-sup-2087@think> <20110321164305.GC7153@quack.suse.cz> <20110406232938.GF1110@tux1.beaverton.ibm.com> <20110407165700.GB7363@quack.suse.cz> <20110408203135.GH1110@tux1.beaverton.ibm.com> <20110411124229.47bc28f6@corrin.poochiereds.net> <1302543595-sup-4352@think> <1302569212.2580.13.camel@mingming-laptop> <20110412005719.GA23077@infradead.org> <1302742128.2586.274.camel@mingming-laptop> <20110422000226.GA22189@tux1.beaverton.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <20110422000226.GA22189@tux1.beaverton.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: djwong <djwong@us.ibm.com>
Cc: Mingming Cao <cmm@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, Jeff Layton <jlayton@redhat.com>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Joel Becker <jlbec@evilplan.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, Dave Hansen <dave@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Excerpts from Darrick J. Wong's message of 2011-04-21 20:02:26 -0400:
> Hi everyone,
> 
> I've finally managed to get together a patch that seems to provide stable pages
> during writeback, or at least gets us to the point that after several days of
> running tests I don't see DIF checksum errors anymore. :)
> 
> The last two pieces to go into this puzzle were (a) bio_integrity_prep needs to
> walk the process tree to find all userland ptes that map to a particular memory
> page and revoke write access, and

Hmm, did you need the bio_integrity_prep change for all the filesystems?
This should be happening already as part of using page_mkwrite.

-chris
