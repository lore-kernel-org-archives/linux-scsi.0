From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [LSF/MM TOPIC][ATTEND] protection information and userspace
Date: Thu, 7 Feb 2013 02:01:39 -0800
Message-ID: <20130207100139.GB4773@blackbox.djwong.org>
References: <20130206195122.GA30652@sgi.com>
 <20130206202444.GA4771@blackbox.djwong.org>
 <20DAFDEA-0C44-478E-B406-C5B08BC67FBC@oracle.com>
 <20130207094012.GA28047@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37932 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155Ab3BGKBq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2013 05:01:46 -0500
Content-Disposition: inline
In-Reply-To: <20130207094012.GA28047@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chuck Lever <chuck.lever@oracle.com>, Ben Myers <bpm@sgi.com>, lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com

On Thu, Feb 07, 2013 at 01:40:14AM -0800, Joel Becker wrote:
> On Wed, Feb 06, 2013 at 03:34:49PM -0500, Chuck Lever wrote:
> > 
> > On Feb 6, 2013, at 3:24 PM, "Darrick J. Wong" <darrick.wong@oracle.com> wrote:
> > 
> > > On Wed, Feb 06, 2013 at 01:51:22PM -0600, Ben Myers wrote:
> > >> Hi,
> > >> 
> > >> I'm interested in discussing how to pass protection information to and from
> > >> userspace.  Maybe Martin could be enlisted for the discussion.
> > >> 
> > >> I read that some work has already been done in this area but have not been able
> > >> to locate it.  It looks like the bio-integrity code already makes it possible
> > >> to generate the t10-dif crc in the filesystem.  It would be good to be able to
> > >> get the guard and application tags back out to backup applications such as
> > >> xfsdump.  Enabling other applications to generate their own tags in userspace
> > >> is also interesting.
> > > 
> > > This one's been on my list for a couple of years (and companies) too.  A few
> > > years ago Joel Becker had support for it in his sys_dio proposal (that hasn't
> > > gone anywhere), and more recently I've theorized that we could add a magic
> > > fcntl/ioctl to make the kernel recognize, say, the first iovec of a O_DIRECT
> > > *{read,write}v call as the PI buffer, which I think is similar to how DIX gets
> > > PI data to a disk.  But it's not like I have any code to show for it.
> > > 
> > > I /think/ it's fairly straightforward to change the directio submit code to
> > > find the userspace PI buffer and amend the block integrity code to attach our
> > > own PI buffer.  You'd still have to let the block layer set the sector # field,
> > > but afaik that won't affect the crc or the app tag.
> > > 
> > > I hear that the NFS guys want to propose some sort of protocol for transmitting
> > > PI data (across NFS), but I haven't seen anything concrete yet.
> > 
> > I'm writing a requirements document for the NFS protocol which I can discuss at LSF.  The use cases for NFS for now would be virtual disk devices (hypervisors) or direct NFS access to storage from user space.
> > 
> > Like everyone else we are waiting for a magical VFS and user space API to appear that can pass PI to and from storage.
> 
> I'm happy to chat about it.  Unfortunately, like Darrick says, sys_dio()
> coding hasn't happened.  I do think we're better off with some kind of
> explicit API than some magic state on the file.  I mean, even something
> like:
> 
> 	ssize_t write_with_pi(int fd, const void *buf, size_t count,
> 			      const void *pi, size_t pi_count);
> 
> It's not as nice as a non-historical API (eg sys_dio), but it also
> probably plays nicer with buffered I/O.

I also pondered simply adding a new io_prep_* function + IO_CMD_ code to libaio
and all the other plumbing necessary to make that happen...

void io_prep_preadv_pi(struct iocb *iocb, int fd, const struct iovec *iov,
		       int iovcnt, long long offset, const void *pi,
		       size_t pi_count);

--D
> 
> Joel
> 
> > 
> > > Well, I hope I'll scrape together the time to hack together a PoC before LSF...
> > > on the other hand, I ran the discussion about PI userland interfaces at LPC2011
> > > and (shamefully) haven't done anything yet.
> > > 
> > > <end rambling>
> > > 
> > > --D
> > >> 
> > >> Regards,
> > >> 	Ben
> > >> --
> > >> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > >> the body of a message to majordomo@vger.kernel.org
> > >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > -- 
> > Chuck Lever
> > chuck[dot]lever[at]oracle[dot]com
> > 
> > 
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> 
> "I think it would be a good idea."  
>         - Mahatma Ghandi, when asked what he thought of Western
>           civilization
> 
> 			http://www.jlbec.org/
> 			jlbec@evilplan.org
