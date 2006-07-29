From: Dave Jones <davej@redhat.com>
Subject: Re: cd burning with plextor drives.
Date: Sat, 29 Jul 2006 13:22:05 -0400
Message-ID: <20060729172205.GG16946@redhat.com>
References: <20060729045249.GA23398@redhat.com> <20060729111240.GG13095@suse.de> <Pine.LNX.4.64.0607290953220.4168@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:13745 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S932183AbWG2RW0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jul 2006 13:22:26 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0607290953220.4168@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Jens Axboe <axboe@suse.de>, linux-scsi@vger.kernel.org

On Sat, Jul 29, 2006 at 10:04:46AM -0700, Linus Torvalds wrote:

 > We do it _correctly_ in the sane paths (ie we really have the "same table" 
 > in "verify_command()" in block/scsi_ioctl.c), and the thing is, when done 
 > correctly, the command access table is a perfectly fine idea.

Ah, that's what I was hunting for.  I must have poked through every
file in drivers/scsi/ looking for that ioctl. It never occured to me
to even look in block/

I've not looked too closely at exactly which method cdrecord was using
in the numerous bug reports we've had on this, but ..

 > Btw, it's entirely possible that you might hit the same problem with 
 > /dev/hdc too.

This may be the case.

 >  - only root can ever be allowed to generate commands that the kernel has 
 >    no clue what they are doing. NO WAY can we allow a user to generate 
 >    postentially hardware-changing special commands just because he can 
 >    access the CD-ROM (ie how would the kernel know that it's not a command 
 >    that says "rewrite the firmware with something that always reads goatse 
 >    off the disk"?)

I had visions of extending verify_command() to be of the form..

	if (devicevendor==PLEXTOR) {
		safe_for_write(ENABLE_BURN_PROOF);
		safe_for_write(ENABLE_FROBNICATOR);
	}
	etc..

 >  - if cdrecord tries to do some device-specific setup, and is upset that 
 >    it can't do it because the user isn't root, then it's obviously a 
 >    cdrecord bug. Which wouldn't surprise me at all

I concur it shouldn't fail completely. But at the same time, if a user
splashed out his pennies to get a modern writer with shiny features, it's
a bit crappy of us to make him be root to use them.

 > - can we _please_ not 
 >    rely on code that has been written by a certified nut-case?

It's a mystery to me why nothing better has come along over the years.

		Dave

-- 
http://www.codemonkey.org.uk
