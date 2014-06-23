From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [regression] fix 32-bit breakage in block device read(2) (was Re:
 32-bit bug in iovec iterator changes)
Date: Mon, 23 Jun 2014 08:44:40 +0100
Message-ID: <20140623074440.GV18016@ZenIV.linux.org.uk>
References: <20140621035144.GA8526@thunk.org>
 <20140621055306.GP18016@ZenIV.linux.org.uk>
 <20140621230922.GA13188@thunk.org>
 <20140621234913.GQ18016@ZenIV.linux.org.uk>
 <1403395400.2592.4.camel@jarvis.lan>
 <20140622002618.GR18016@ZenIV.linux.org.uk>
 <1403397164.2177.40.camel@dabdike.int.hansenpartnership.com>
 <20140622005352.GS18016@ZenIV.linux.org.uk>
 <20140622010032.GT18016@ZenIV.linux.org.uk>
 <20140622115007.GA5333@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:56986 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaFWHox (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jun 2014 03:44:53 -0400
Content-Disposition: inline
In-Reply-To: <20140622115007.GA5333@thunk.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Theodore Ts'o <tytso@mit.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, Jun 22, 2014 at 07:50:07AM -0400, Theodore Ts'o wrote:
> On Sun, Jun 22, 2014 at 02:00:32AM +0100, Al Viro wrote:
> > 
> > PS: I agree that it's worth careful commenting, obviously, but
> > before sending it to Linus (*with* comments) I want to get a
> > confirmation that this one-liner actually fixes what Ted is seeing.
> > I have reproduced it here, and that change makes the breakage go
> > away in my testing, but I'd like to make sure that we are seeing the
> > same thing.  Ted?
> 
> Hep, that fixes things.  Thanks for explaining what was going on!

OK, here it is, hopefully with sufficient comments:
    
blkdev_read_iter() wants to cap the iov_iter by the amount of
data remaining to the end of device.  That's what iov_iter_truncate()
is for (trim iter->count if it's above the given limit).  So far,
so good, but the argument of iov_iter_truncate() is size_t, so on
32bit boxen (in case of a large device) we end up with that upper
limit truncated down to 32 bits *before* comparing it with iter->count.

Easily fixed by making iov_iter_truncate() take 64bit argument -
it does the right thing after such change (we only reach the
assignment in there when the current value of iter->count is greater
than the limit, i.e. for anything that would get truncated we don't
reach the assignment at all) and that argument is not the new
value of iter->count - it's an upper limit for such.

The overhead of passing u64 is not an issue - the thing is inlined,
so callers passing size_t won't pay any penalty.

Reported-by: Theodore Tso <tytso@mit.edu>
Tested-by: Theodore Tso <tytso@mit.edu>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---

diff --git a/include/linux/uio.h b/include/linux/uio.h
index ddfdb53..17ae7e3 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -94,8 +94,20 @@ static inline size_t iov_iter_count(struct iov_iter *i)
 	return i->count;
 }
 
-static inline void iov_iter_truncate(struct iov_iter *i, size_t count)
+/*
+ * Cap the iov_iter by given limit; note that the second argument is
+ * *not* the new size - it's upper limit for such.  Passing it a value
+ * greater than the amount of data in iov_iter is fine - it'll just do
+ * nothing in that case.
+ */
+static inline void iov_iter_truncate(struct iov_iter *i, u64 count)
 {
+	/*
+	 * count doesn't have to fit in size_t - comparison extends both
+	 * operands to u64 here and any value that would be truncated by
+	 * conversion in assignement is by definition greater than all
+	 * values of size_t, including old i->count.
+	 */
 	if (i->count > count)
 		i->count = count;
 }
