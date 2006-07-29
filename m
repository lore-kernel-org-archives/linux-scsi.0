From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: cd burning with plextor drives.
Date: Sat, 29 Jul 2006 10:04:46 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0607290953220.4168@g5.osdl.org>
References: <20060729045249.GA23398@redhat.com> <20060729111240.GG13095@suse.de>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="21872808-1389251931-1154192686=:4168"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:56300 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751134AbWG2RFD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jul 2006 13:05:03 -0400
In-Reply-To: <20060729111240.GG13095@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--21872808-1389251931-1154192686=:4168
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT



On Sat, 29 Jul 2006, Jens Axboe wrote:
> 
> I'd greatly prefer just ripping the entire command access table out, it
> was a mistake to begin with and still just a horrible solution.

Well, I don't think the _notion_ of a command access table is the problem 
per se. 

I just think that "sg.c" is badly done.

We do it _correctly_ in the sane paths (ie we really have the "same table" 
in "verify_command()" in block/scsi_ioctl.c), and the thing is, when done 
correctly, the command access table is a perfectly fine idea.

And the thing is, that "verify_command()" is absolutely _required_. As 
root, you can send any command you want, but we really _do_ want normal 
users to be able to send a sane subset, without allowing them to do other 
things just because they have write access to the medium.

> In fact, I think we should decide soon what to do about it. At the
> storage summit, there was general consensus on just killing it as well.

I don't think there's any point to killing it.

The fact is, anybody who works with a known storage device simply SHOULD 
NOT USE THE sg.c INTERFACES. Only totally insane people (ie Jörg 
Schilling) think that it's even remotely sane. If you know it's a storage 
device, you should use the proper block interfaces, and instad of doing

	cdrecord -dev=ATA:1,0,0

the person should really have done

	cdrecord -dev=/dev/hdc

or something sane, and gone through the proper channels, instead of going 
through the nightmare that is Schillings "brain").

In fact, I would seriously suggest that distributions should disallow the 
insane interfaces to cdrecord.

"sg.c" makes sense for SCSI laser range fingers and other strange stuff. 
It does _not_ make sense for CD-ROM access.

Btw, it's entirely possible that you might hit the same problem with 
/dev/hdc too. But at that point it should be 100% obvious that

 - only root can ever be allowed to generate commands that the kernel has 
   no clue what they are doing. NO WAY can we allow a user to generate 
   postentially hardware-changing special commands just because he can 
   access the CD-ROM (ie how would the kernel know that it's not a command 
   that says "rewrite the firmware with something that always reads goatse 
   off the disk"?)

 - if cdrecord tries to do some device-specific setup, and is upset that 
   it can't do it because the user isn't root, then it's obviously a 
   cdrecord bug. Which wouldn't surprise me at all - can we _please_ not 
   rely on code that has been written by a certified nut-case?

And in either case, I don't think this is a kernel bug, unless it also 
happens as root, of course.

		Linus
--21872808-1389251931-1154192686=:4168--
