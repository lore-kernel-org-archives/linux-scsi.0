From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: Linux tape drivers
Date: Thu, 5 Apr 2007 00:54:19 +0300 (EEST)
Message-ID: <Pine.LNX.4.64.0704050016010.8139@kai.makisara.local>
References: <200704031508.37222.kern@sibbald.com>
 <20070403133904.0029ccd2.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704042029430.8139@kai.makisara.local> <200704042258.50296.kern@sibbald.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:32779 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbXDDVyY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Apr 2007 17:54:24 -0400
In-Reply-To: <200704042258.50296.kern@sibbald.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kern Sibbald <kern@sibbald.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, Willem Riede <wrlk@riede.org>

On Wed, 4 Apr 2007, Kern Sibbald wrote:

> On Wednesday 04 April 2007 20:46, Kai Makisara wrote:
...
> > > >   c. There is a real lack of information about any error condition
> > > >       (read/write). One can probably get it via direct SCSI commands, 
> but
> > > >       why not through an ioctl.
> > 
> > This is true. The problem is what and how to tell the user so that the 
> > solution is satisfactory for a reasonable number of years. The solutions I 
> > have thought about have not passed this test. One alternative is to pass 
> > the latest sense data to the user but thinking about the different error 
> > conditions, this is a problematic choice. Here also suggestions from and 
> > discussion with real users is needed.
> 
> Well, you have in front of you a "real" user.

Yes, you are one of the people I meant with "real users".

>                                               I was thinking about a new 
> ioctl() that would hopefully be simple, generic, and extensible enough that 
> it might be picked up by all Unixes. This is one case were even if it is a 
> Linux only solution, I will be really happy. Basically, when I get a -1 
> return from a read/write and ERRNO=EIO, I would like to be able to call an 
> ioctl() and get back some basic info about soft errors, hard errors, ...  If 
> you don't tell me that a new ioctl() is out of the question, I'll make a 
> proposal -- it will take me some time to put it together.
> 
The general attitude seems to be against new ioctls but I don't want to 
rule out that. The mt interface already uses ioctls and they solve the 
serialisation problem nicely in this case.

Whatever the method of delivery will be, the most difficult question is 
the contents and format. I don't know any good examples from other 
systems, so it has to be Linux-specific (and hopefully adopted by others 
as you say). I will wait with interest for your suggestion.

...
> > > >    e. Apparently only root can do the following (IMO, this is a bug or 
> > > >        programming oversight): 
> > > > 
> > > >          struct mtop mt;
> > > >          mt.mt_op = MTSETDRVBUFFER;
> > > >          mt.mt_count = MT_ST_CLEARBOOLEANS;
> > > >          mt.mt_count |= MT_ST_FAST_MTEOM;
> > > >          ...
> > > >          ioctl(fd, MIOCTOP, &mt);
> > > > 
> > > >       Typically Bacula runs tape daemon as non-root.  Is there a good 
> reason 
> > > >        why program that has write permission on the device cannot do 
> this
> > > >        ioctl() and is it possible to change this?
> > > > 
> > This is not a bug or an oversight, it is a design decision. The idea is 
> > that the system provides the same view of the tape to all users. This view 
> > is defined by the system manager (probably with startup scripts). If each 
> > user can change the behaviour, the next user never knows what to expect. 
> 
> Well, I agree that all users should have the same view.  However, when Bacula 
> has the drive open, it has it open exclusively, so no other users can view 
> the drive. When Bacula opens the drive, it should be able to ensure that the 
> drive, agrees with Bacula's concept of the drive.  When Bacula closes the 
> drive, I have no problem if the OS resets values to the common view.  Today, 
> if Bacula is running as bacula:disk rather than root:root, it cannot make the 
> above changes, even if the disk group has write access to the drive.

OK. I have not thought about this properly but one possible solution might
be something like this:
- separate the current and permanent behaviour flags; the current flags 
  define the behaviour
- the permanent flags are copied into the current flags when the device is
  opened (or at some other well-defined point)
- the booleans set with MTSETDRVBUFFER change always the current flags; if
  the user has CAP_SYS_ADMIN, also the permanent flags are changed

This would enable anyone to change the behaviour for his/her own purposes 
but there would still be a stable system-defined behaviour. There already 
are attributes that have a current and default value like block size.

I can see several problems in the details of this suggestion but I will 
think about those. One is that if someone having CAP_SYS_ADMIN wants just 
a temporary change, it is not possible. A solution would to have a new 
op code for temporary changes but this would require explicit changes to 
programs. Comments are welcome.

...
> > Strictly speaking MTSETDRVBUFFER does not need root privileges. It needs 
> > CAP_SYS_ADMIN. (Now I see that the error message is misleading and must be 
> > fixed.) Does using some other capability make your use easier but, at same 
> > time, limit the access to this command to a selected group of users?
> 
> Being relatively ignorant of the kernel, I wasn't aware of CAP_SYS_ADMIN.  I 
> now have a rough idea of what it is, I am unsure if another capability would 
> resolve the problem, because I'm not familar with how they are set.  
> 
Yes, setting the capabilities may be a problem. I don't know how well the 
different distributions are able to handle these finer-grained rights. 
A software package has to support ideally all distributions and the common 
denominator may be to be root for CAP_SYS_ADMIN ;-)

> It seems to me that anyone who is the "owner" or in the "group" and has write 
> permission on the device should be able to do MTSETDRVBUFFER.  There is no 
> need for any "other" who has write permission to have such access. I think 
> this would allow the sys admin to restrict it appropriately.
> 
This would be one solution but it sounds complicated. The primary test for 
a file is just if there is write access or not. It does not matter if the 
access right comes as user, group, or other.

> 
> Thanks for your responses.  I see I have some work to do organizing my 
> thoughts :-)

Thanks for your input.

-- 
Kai
