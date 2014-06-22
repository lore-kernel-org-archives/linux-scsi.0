From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: 32-bit bug in iovec iterator changes
Date: Sat, 21 Jun 2014 17:03:20 -0700
Message-ID: <1403395400.2592.4.camel@jarvis.lan>
References: <20140619153550.GA12836@thunk.org> <53A308DE.7080000@fb.com>
	 <20140619160801.GB4907@thunk.org> <20140619162144.GC4907@thunk.org>
	 <20140619223820.GN4453@dastard> <20140621035144.GA8526@thunk.org>
	 <20140621055306.GP18016@ZenIV.linux.org.uk>
	 <20140621230922.GA13188@thunk.org>
	 <20140621234913.GQ18016@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60042 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751160AbaFVADW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jun 2014 20:03:22 -0400
In-Reply-To: <20140621234913.GQ18016@ZenIV.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Theodore Ts'o <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, 2014-06-22 at 00:49 +0100, Al Viro wrote:
> On Sat, Jun 21, 2014 at 07:09:22PM -0400, Theodore Ts'o wrote:
> > On Sat, Jun 21, 2014 at 06:53:07AM +0100, Al Viro wrote:
> > > 
> > > ed include/linux/uio.h <<EOF
> > > /iov_iter_truncate/s/size_t/u64/
> > > w
> > > q
> > > EOF
> > > 
> > > Could you check if that fixes the sucker?
> > 
> > The following patch (attached at the end) appears to fix the problem,
> > but looking at uio.h, I'm completely confused about *why* it fixes the
> > problem.  In particular, iov_iter_iovec() makes no sense to me at all,
> > and I don't understand how the calculation of iov_len makes any sense:
> > 
> > 		.iov_len = min(iter->count,
> > 			       iter->iov->iov_len - iter->iov_offset),
> 
> Eh?   We have iov[0].iov_base..iov[0].iov_base+iov[0].iov_len - 1 for
> area covered by the first iovec.  First iov_offset bytes have already
> been consumed.  And at most count bytes matter.  So yes, this iov_len
> will give you equivalent first iovec.
> 
> Said that, iov_iter_iovec() will die shortly - it's a rudiment of older
> code, with almost no users left.  But yes, it is correct.
> 
> > It also looks like uio.h is mostly about offsets to memory pointers,
> > and so why this would make a difference when the issue is the block
> > device offset goes above 2**30?
> 
> It is, and your patch is a huge overkill.
> 
> > There must be deep magic going on here, and so I don't know if your
> > s/size_t/u64/g substitation also extends to the various functions that
> > have size_t in them:
> 
> No, it does not.  It's specifically about iov_iter_truncate(); moreover,
> it matters to only one caller of that sucker.  Namely,
> 
> static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
> {
>         struct file *file = iocb->ki_filp;
>         struct inode *bd_inode = file->f_mapping->host;
>         loff_t size = i_size_read(bd_inode);
>         loff_t pos = iocb->ki_pos;
> 
>         if (pos >= size)
>                 return 0;
> 
>         size -= pos;
>         iov_iter_truncate(to, size);
>         return generic_file_read_iter(iocb, to);
> }
> 
> What happens here is capping to->count, to guarantee that we won't even look
> at anything past the end of block device.  Alternative fix would be to
> have
> 	if (pos >= size)
> 		return 0;
> 	if (to->size + pos > size) {
> 		/* note that size - pos fits into size_t in this case,
> 		 * so it's OK to pass it to iov_iter_truncate().
> 		 */
> 		iov_iter_truncate(to, size - pos);
> 	}
>         return generic_file_read_iter(iocb, to);
> in there.  Other callers are passing it size_t values already, so we don't
> need similar checks there.
> 
> Or we can make iov_iter_truncate() take an arbitrary u64 argument, seeing that
> it's inlined anyway.  IMO it's more robust that way...
> 
> Anyway, does the following alone fix the problem you are seeing?
> 
> diff --git a/include/linux/uio.h b/include/linux/uio.h
> index ddfdb53..dbb02d4 100644
> --- a/include/linux/uio.h
> +++ b/include/linux/uio.h
> @@ -94,7 +94,7 @@ static inline size_t iov_iter_count(struct iov_iter *i)
>  	return i->count;
>  }
>  
> -static inline void iov_iter_truncate(struct iov_iter *i, size_t count)
> +static inline void iov_iter_truncate(struct iov_iter *i, u64 count)
>  {
>  	if (i->count > count)
>  		i->count = count;

Al, how can that work?  i->count is size_t, which is 32 bit, so we're
going to get truncation errors. I could see this possibly working if
count in struct iov_iter becomes u64 (which is going to have a lot of
knock on consequences, but it seems to me that at least kvec.iov_len and
iov_iter.iov_offset have to become u64 as well.

James


