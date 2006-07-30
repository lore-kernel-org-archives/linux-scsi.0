From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: cd burning with plextor drives.
Date: Sun, 30 Jul 2006 12:21:16 +0200
Message-ID: <20060730102115.GD8910@bitwizard.nl>
References: <20060729045249.GA23398@redhat.com> <20060729111240.GG13095@suse.de> <Pine.LNX.4.64.0607290953220.4168@g5.osdl.org> <20060729172205.GG16946@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.126.206.180]:65416 "HELO abra2.bitwizard.nl")
	by vger.kernel.org with SMTP id S932211AbWG3KVR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Jul 2006 06:21:17 -0400
Content-Disposition: inline
In-Reply-To: <20060729172205.GG16946@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Jens Axboe <axboe@suse.de>, linux-scsi@vger.kernel.org

On Sat, Jul 29, 2006 at 01:22:05PM -0400, Dave Jones wrote:
> I had visions of extending verify_command() to be of the form..
> 
> 	if (devicevendor==PLEXTOR) {
> 		safe_for_write(ENABLE_BURN_PROOF);
> 		safe_for_write(ENABLE_FROBNICATOR);
> 	}
> 	etc..

Almost there.... 

Instead it should walk a (device-specific (*)) table, that specifies
what is "safe". The table has masks to specify which bits are
important and what values are expected and allowed etc etc.

This table could be initialized "empty". 

Next a simple interface should allow root to modify the table. 


I expect that after doing this, the code above the suggestion could be
deleted, and that the currently-hardcoded policy could move into the
default table, instead of having the table start out empty. This might
be a performance tradeoff (i.e. even though it reduces code size, the
hardcoded version may be much quicker than walking the table every
time).

Now distributions/users/sysadmins can chose: 

A) leave as is: The ACME DVDwriter's new SuperDVDProof feature
   will only work as root once implemented in cdrecord. 

B) insert a table entry: "everything allowed". This will allow
   users to shoot themselves in the foot. 

C) Be smart about it, and provide a mechanism to detect ACME
   drives with the feature, select the appropriate config file
   and upload the corresponding table.

Everybody happy?

	Roger. 


(*) /dev/hdc, not "Plextor". 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
