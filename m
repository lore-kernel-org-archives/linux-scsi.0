From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH, RFC] xfs: batched discard support
Date: Sat, 15 Aug 2009 21:35:17 -0400
Message-ID: <4A876255.10606@rtr.ca>
References: <20090816004705.GA7347@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090816004705.GA7347@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> Given that everyone is so big in the discard discussion I'd like to
> present what I had started to prepare for XFS.  I didn't plan to send it
> out until I get my hands onto a TRIM capable device (or at least get
> time to add support to qemu), and so far it's only been tested in
> dry-run mode.
> 
> The basic idea is to add an ioctl which walks the free space btrees in
> each allocation group and simply discard everythin that is free.  Given
> that XFS doesn't gragment freespace very much that's a very efficient
> way to do it.  In addition we also already support setting a threshold
> under which we don't bother to discard an extent, it's currently
> hardcoded in the helper tool.  In the future we could also add things
> like a sequence number in the AG headers if anything has changed at all,
> but let's leave those optimizations until we need them.
> 
> XFS locks the allocation btree using the btree buffers, so we do not
> block allocations from any extent which we're not currenly discarding.
> 
> Now the caveat for that is that we really do want to do the discard
> synchronously, that is wait for the request to finish.  That's what
> I've implemented in this patch, but it's the part I haven't been
> able to test so far.  (and yes, this should be separate patch, but it's
> really just an RFC for now)
> 
> Mark, any chance to try it?  Just create an XFS filesystem, age it a
> bit and then call the attached little trim.c program on the mountmoint
> (or any file inside the filesystem for that matter)
..

Looking at it now.  Thanks, Christoph!
