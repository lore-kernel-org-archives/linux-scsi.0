From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux tape drivers
Date: Tue, 3 Apr 2007 13:39:04 -0700
Message-ID: <20070403133904.0029ccd2.akpm@linux-foundation.org>
References: <200704031508.37222.kern@sibbald.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42766 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945929AbXDCUkC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Apr 2007 16:40:02 -0400
In-Reply-To: <200704031508.37222.kern@sibbald.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kern Sibbald <kern@sibbald.com>
Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org, Willem Riede <wrlk@riede.org>


(cc's added, with permission)

On Tue, 3 Apr 2007 15:08:37 +0200
Kern Sibbald <kern@sibbald.com> wrote:

> Hello,
> 
> I am the project manager for Bacula, an Open Source network backup program 
> that runs on all popular OSes.  After your presentation at FOSDEM in Febrary, 
> we briefly talked about Linux tape driver problems I am encountering, and you 
> offered to put me in touch with the appropriate kernel developers.
> 
> I would much appreciate any help in this.  Since the problems concern all tape 
> drivers, I provide a very brief outline of what my would like to discuss.  
> First, I must mention that the Linux SCSI driver works perfectly fine with 
> Bacula, it is simply a question of possible improvements, under item 2 below.
> 
> Issues for discussion:
> 
> 1. Bugs:
>    a. Other than the OSST driver, apparently no IDE/SATA tape driver works
>        with Bacula. I don't have such a drive (working on it), but from user
>        reports, it appears to me that there are problems of permitting 
>        variable length blocks, and more serious, when writing to the end of
>        the tape, either the logical end of tape indicator is ignored, or when
>        it is encountered, all further I/O is prohibited -- including a WEOF. 
>        This makes reliable writing of multiple reel tapes impossible.
> 
>        By the way, these IDE/SATA drives work with Bacula using the same
>        source code cross-compiled with GNU C++ on Linux, then run on Windows
>        machines, so it is most likely a driver issue rather than anything in
>        Bacula or the hardware.
> 
> 2. Usability of the current tape driver API (not bugs)
>   a. With the new O_NONBLOCK flag introduced in kernel 2.5.x, opening
>       a tape drive and finding out if a volume is mounted is much more 
>       complicated.  It is really inconvenient and required a lot more code
>       in prior kernels.  This should be an item for discussion.
>   b. There is no simple way to determine if a tape is in a drive -- it is 
>       at least 20 or 30 lines of C code to do it right.
>   c. There is a real lack of information about any error condition
>       (read/write). One can probably get it via direct SCSI commands, but
>       why not through an ioctl.
>   d. The same as c. above, but for all kinds of error information that 
>        can be important -- particularly soft errors.  An ioctl() that returns
>        additional information could be very useful.  Currently we get it by
>        using external SCSI programs such as mtx tapeinfo for TapeAlerts,
>        and smartclt for errors.
>    e. Apparently only root can do the following (IMO, this is a bug or 
>        programming oversight): 
> 
>          struct mtop mt;
>          mt.mt_op = MTSETDRVBUFFER;
>          mt.mt_count = MT_ST_CLEARBOOLEANS;
>          mt.mt_count |= MT_ST_FAST_MTEOM;
>          ...
>          ioctl(fd, MIOCTOP, &mt);
> 
>       Typically Bacula runs tape daemon as non-root.  Is there a good reason 
>        why program that has write permission on the device cannot do this
>        ioctl() and is it possible to change this?
> 
> There are probably a few other items that I have forgotten.  I consider #1 
> rather important (at least for Bacula).  Item #2 is something more long term 
> and some of my requests may have compatibility issues to consider.

I don't think that any particular individual maintains the tape code as a
whole, so progress will probably be slow, I'm afraid.

Kai maintains the scsi tape driver and Willem looks after OSST.  Perhaps they
can comment on some of the issues which you identify?

Thanks.
