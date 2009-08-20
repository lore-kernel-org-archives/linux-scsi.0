From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH, RFC] xfs: batched discard support
Date: Thu, 20 Aug 2009 08:42:36 -0600
Message-ID: <1250779356.5533.15.camel@mulgrave.site>
References: <20090816004705.GA7347@infradead.org>
	 <20090819203916.GA25296@elte.hu> <4A8CA956.2060406@rtr.ca>
	 <4A8D5442.1000302@redhat.com>  <4A8D5FDB.7080505@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4A8D5FDB.7080505@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Ric Wheeler <rwheeler@redhat.com>, Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Linus Torvalds <torvalds@linux-foundation.org>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, IDE/ATA development list <linux-ide@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2009-08-20 at 10:38 -0400, Mark Lord wrote:
> Would it still be okay to do the TRIMs when the entire parity stripe
> (across all members) is being discarded?  (As opposed to just partial
> data there being dropped)

Not really.  The problem is that array verification is done at the block
level not the fs level (although, I suppose, we could change that).  So
a fully discarded stripe still has to verify OK (as in what's read for
the parity must match what's read for the data).  All of this is the
reason for the TPRZ bit for SCSI UNMAP ... and why WRITE_SAME is also
under consideration for discards in T10.

James


