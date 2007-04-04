From: Kern Sibbald <kern@sibbald.com>
Subject: Re: Linux tape drivers
Date: Wed, 4 Apr 2007 22:58:49 +0200
Message-ID: <200704042258.50296.kern@sibbald.com>
References: <200704031508.37222.kern@sibbald.com> <20070403133904.0029ccd2.akpm@linux-foundation.org> <Pine.LNX.4.64.0704042029430.8139@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from matou.sibbald.com ([194.158.240.20]:26129 "EHLO
	matou.sibbald.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbXDDU7I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Apr 2007 16:59:08 -0400
In-Reply-To: <Pine.LNX.4.64.0704042029430.8139@kai.makisara.local>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, Willem Riede <wrlk@riede.org>

On Wednesday 04 April 2007 20:46, Kai Makisara wrote:
...
> > > 
> > > Issues for discussion:
> > > 
> > > 1. Bugs:
> > >    a. Other than the OSST driver, apparently no IDE/SATA tape driver 
works
> > >        with Bacula. I don't have such a drive (working on it), but from 
user
> > >        reports, it appears to me that there are problems of permitting 
> > >        variable length blocks, and more serious, when writing to the end 
of
> > >        the tape, either the logical end of tape indicator is ignored, or 
when
> > >        it is encountered, all further I/O is prohibited -- including a 
WEOF. 
> > >        This makes reliable writing of multiple reel tapes impossible.
> > > 
> > >        By the way, these IDE/SATA drives work with Bacula using the same
> > >        source code cross-compiled with GNU C++ on Linux, then run on 
Windows
> > >        machines, so it is most likely a driver issue rather than 
anything in
> > >        Bacula or the hardware.
> > > 
> 
> Others have already answered this and I agree with their view. All of the 
> tape drives seem to use the SSC command set or something close to that. 
> One high-level driver should be enough to implement the user semantics.
>  
> Libata should be able to drive the SATA/IDE drives using and the drives 
> are visible as SCSI devices in Linux. In future there should be no real 
> need for ide-scsi. Probably very few people have tried libata with tapes 
> and there may be some problems to fix. Someone should test this with 
> real devices and report the problems back to libata maintainers.

Thanks, I'll look into using libdata and ask our users to try it. 

> 
> > > 2. Usability of the current tape driver API (not bugs)
> > >   a. With the new O_NONBLOCK flag introduced in kernel 2.5.x, opening
> > >       a tape drive and finding out if a volume is mounted is much more 
> > >       complicated.  It is really inconvenient and required a lot more 
code
> > >       in prior kernels.  This should be an item for discussion.
> 
> The reasons for the change were:
> 1. To be compatible with the Unix standards, and
> 2. To be compatible with other Unix tape driver semantics.
> 
> Because of these reasons the changes should probably not be reversed but 
> there may be something to improve in the implementation. Suggestions?

I was aware of the reasons for the change, and see the limitations in what can 
be done.  I will spend a little time making my thoughts/suggestions clear and 
get back to you.

> 
> > >   b. There is no simple way to determine if a tape is in a drive -- it 
is 
> > >       at least 20 or 30 lines of C code to do it right.
> 
> Why not use GMT_ONLINE() with MTIOCGET? The definition from the st man 
> page is:
> 
> GMT_ONLINE(x): The last open() found the drive with a tape in place and 
> ready for operation.
> 
> If it does not work correctly, it can be fixed. (Of course, if you want to 
> see if a tape is in a drive but not loaded, it is more difficult.)

I will look at it, but have not tried it because it is a Linux specific 
solution, which I try to avoid.  I'll respond more on this when responding 
correctly to item a above.

> 
> > >   c. There is a real lack of information about any error condition
> > >       (read/write). One can probably get it via direct SCSI commands, 
but
> > >       why not through an ioctl.
> 
> This is true. The problem is what and how to tell the user so that the 
> solution is satisfactory for a reasonable number of years. The solutions I 
> have thought about have not passed this test. One alternative is to pass 
> the latest sense data to the user but thinking about the different error 
> conditions, this is a problematic choice. Here also suggestions from and 
> discussion with real users is needed.

Well, you have in front of you a "real" user.  I was thinking about a new 
ioctl() that would hopefully be simple, generic, and extensible enough that 
it might be picked up by all Unixes. This is one case were even if it is a 
Linux only solution, I will be really happy. Basically, when I get a -1 
return from a read/write and ERRNO=EIO, I would like to be able to call an 
ioctl() and get back some basic info about soft errors, hard errors, ...  If 
you don't tell me that a new ioctl() is out of the question, I'll make a 
proposal -- it will take me some time to put it together.

> 
> > >   d. The same as c. above, but for all kinds of error information that 
> > >        can be important -- particularly soft errors.  An ioctl() that 
returns
> > >        additional information could be very useful.  Currently we get it 
by
> > >        using external SCSI programs such as mtx tapeinfo for TapeAlerts,
> > >        and smartclt for errors.
> 
> Looking at what the current drives provide in log and what the kernel can 
> log, I currently think that this information is best obtained with 
> external tools, like you do. The number of things that can be asked from 
> the drives is very large and defining a kernel interface is difficult. The 
> set also is evolving. (User's suggestions are also here welcome :-)

Yes, the information is there, and I agree with all your points, but getting 
the info into Bacula or any other backup program and displayed for the user 
is somewhat kludgy.

> 
> One way to proceed might be to make a user space library that presents an 
> API to users and implements it using SG_IO. If the API seems to stabilize 
> and be suitable for kernel implementation, it could be later implemented 
> in the kernel.

Yes, this is an excellent idea.

> 
> > >    e. Apparently only root can do the following (IMO, this is a bug or 
> > >        programming oversight): 
> > > 
> > >          struct mtop mt;
> > >          mt.mt_op = MTSETDRVBUFFER;
> > >          mt.mt_count = MT_ST_CLEARBOOLEANS;
> > >          mt.mt_count |= MT_ST_FAST_MTEOM;
> > >          ...
> > >          ioctl(fd, MIOCTOP, &mt);
> > > 
> > >       Typically Bacula runs tape daemon as non-root.  Is there a good 
reason 
> > >        why program that has write permission on the device cannot do 
this
> > >        ioctl() and is it possible to change this?
> > > 
> This is not a bug or an oversight, it is a design decision. The idea is 
> that the system provides the same view of the tape to all users. This view 
> is defined by the system manager (probably with startup scripts). If each 
> user can change the behaviour, the next user never knows what to expect. 

Well, I agree that all users should have the same view.  However, when Bacula 
has the drive open, it has it open exclusively, so no other users can view 
the drive. When Bacula opens the drive, it should be able to ensure that the 
drive, agrees with Bacula's concept of the drive.  When Bacula closes the 
drive, I have no problem if the OS resets values to the common view.  Today, 
if Bacula is running as bacula:disk rather than root:root, it cannot make the 
above changes, even if the disk group has write access to the drive.

> 
> I understand your view. The problem is that the same Linux is used in 
> different types of systems. The design was aimed enabling controlled use 
> of tapes in large systems where some users know very little about tapes. 
> Your use is a small user base system where it can be assumed that the 
> users know quite well what they are doing (either really know or use a 
> limited set of tools that "know").

I agree with the above, and hope we can accomplish both it and what I am 
asking for.

> 
> Strictly speaking MTSETDRVBUFFER does not need root privileges. It needs 
> CAP_SYS_ADMIN. (Now I see that the error message is misleading and must be 
> fixed.) Does using some other capability make your use easier but, at same 
> time, limit the access to this command to a selected group of users?

Being relatively ignorant of the kernel, I wasn't aware of CAP_SYS_ADMIN.  I 
now have a rough idea of what it is, I am unsure if another capability would 
resolve the problem, because I'm not familar with how they are set.  

It seems to me that anyone who is the "owner" or in the "group" and has write 
permission on the device should be able to do MTSETDRVBUFFER.  There is no 
need for any "other" who has write permission to have such access. I think 
this would allow the sys admin to restrict it appropriately.


Thanks for your responses.  I see I have some work to do organizing my 
thoughts :-)

Kern
