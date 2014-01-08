From: Jan Kara <jack@suse.cz>
Subject: Re: Terrible performance of sequential O_DIRECT 4k writes in SAN
 environment. ~3 times slower then Solars 10 with the same HBA/Storage.
Date: Wed, 8 Jan 2014 02:17:13 +0100
Message-ID: <20140108011713.GA5212@quack.suse.cz>
References: <CA+QCeVQRrqx=CrxyuAe7k0e0y4Nqo7x_8jtkuD99VM8L9Dxp+g@mail.gmail.com>
 <20140106201032.GA13491@quack.suse.cz>
 <20140107155830.GA28395@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44123 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754654AbaAHBRS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Jan 2014 20:17:18 -0500
Content-Disposition: inline
In-Reply-To: <20140107155830.GA28395@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Sergey Meirovich <rathamahata@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Gluk <git.user@gmail.com>

On Tue 07-01-14 07:58:30, Christoph Hellwig wrote:
> On Mon, Jan 06, 2014 at 09:10:32PM +0100, Jan Kara wrote:
> >   This is likely a problem of Linux direct IO implementation. The thing is
> > that in Linux when you are doing appending direct IO (i.e., direct IO which
> > changes file size), the IO is performed synchronously so that we have our
> > life simpler with inode size update etc. (and frankly our current locking
> > rules make inode size update on IO completion almost impossible). Since
> > appending direct IO isn't very common, we seem to get away with this
> > simplification just fine...
> 
> Shouldn't be too much of a problem at least for XFS and maybe even ext4
> with the workqueue based I/O end handler.  For XFS we protect size
> updates by the ilock which we already taken in that handler, not sure
> what ext4 would do there.
  Well, I was specifically worried about i_mutex locking. In particular:
Before we report appending IO completion we need to update i_size.
To update i_size we need to grab i_mutex.

Now this is unpleasant because inode_dio_wait() happens under i_mutex so
the above would create lock inversion. And we cannot really do
inode_dio_done() before grabbing i_mutex as that would open interesting
races between truncate decreasing i_size and DIO increasing it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
