From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] sr: Ensure disk is revalidated when media changes
Date: Fri, 8 Apr 2011 09:20:41 -0700
Message-ID: <20110408162041.GB3871@mtj.dyndns.org>
References: <8d830b21c0b944d26f29dc1e0c42c0bef8d448c2.1301595169.git.amit.shah@redhat.com>
 <20110401154327.GA6593@mtj.dyndns.org>
 <20110405065129.GC2872@amit-x200.redhat.com>
 <20110406100620.GA4142@mtj.dyndns.org>
 <BANLkTinpRJHr+293kPzS1=hCWRPamOOGfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BANLkTinpRJHr+293kPzS1=hCWRPamOOGfw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Amit Shah <amit.shah@redhat.com>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, Markus Armbruster <armbru@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Fri, Apr 08, 2011 at 12:37:56PM +0100, Stefan Hajnoczi wrote:
> There is a related issue I have been discussing with Amit:
> https://lkml.org/lkml/2011/3/23/156
> 
> On media change the inode size is not updated by the sr driver or the
> universal cdrom driver.  A userspace process that holds a /dev/sr0
> file descriptor open across media change causes all processes on the
> system to see the old medium size when they do lseek(fd, 0, SEEK_END).
> 
> I think it would make sense to refresh the inode size on media change
> so that even open file descriptors see the new size and a single
> process cannot force a stale value for all other userspace processes
> on the system.

Hmmm... I don't know.  Maybe we can but I'm not sure whether there's a
good reason for it.  cdrom is locked while opened after all.  Are
there actual problems?

Thanks.

-- 
tejun
