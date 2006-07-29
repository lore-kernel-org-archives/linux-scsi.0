From: Douglas Gilbert <dougg@torque.net>
Subject: Re: cd burning with plextor drives.
Date: Sat, 29 Jul 2006 14:39:07 -0400
Message-ID: <44CBAB4B.7050308@torque.net>
References: <20060729045249.GA23398@redhat.com>  <20060729111240.GG13095@suse.de> <1154180419.9447.61.camel@mulgrave.il.steeleye.com> <Pine.LNX.4.64.0607291005200.4168@g5.osdl.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:43161 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932199AbWG2SjW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jul 2006 14:39:22 -0400
In-Reply-To: <Pine.LNX.4.64.0607291005200.4168@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <axboe@suse.de>, Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sat, 29 Jul 2006, James Bottomley wrote:
>> I concur.  If we're going to allow users access to burn CDs, it's
>> impossible to police them with certainty as this case indicates.
> 
> Not so. I can (and have) written tons of CD's as a normal user, with 
> perfect security.
> 
> No, the kernel shouldn't allow device-specific commands. That goes without 
> saying. Whether this is a sg.c problem, or a cdrecord problem is unclear, 
> I suspect it's the latter. 

Command filtering has always been dubious. The sg driver
takes the approach of allowing through a small number of
"safe" (often mandatory) SCSI _Primary_ Commands (SPC). It
takes no special account of the Multimedia Commands (MMC),
cdrecord or the SCSI Block Commands (SBC). The sg driver
filter does lean a little towards SBC by allowing the
READ CAPACITY command to be accessed O_RDONLY.

The block layer SG_IO filter bends over backwards to
support MMC and hence cdrecord. So it supports one
device _type_ specific class. Due to vendor specific
commands (e.g. from plextor) it cannot keep cdrecord
completely happy.

For a comparison of the two filters see table 3 in:
http://www.torque.net/sg/sg_io.html
That table highlights another difference between the
two filters:
  - sg: allow some commands to be accessed O_RDONLY
    and let all commands to be accessed O_RDWR
  - block SG_IO: has three states: allow some commands
    to be accessed O_RDONLY, a larger set O_RDWR and
    the rest with CAP_SYS_RAW_IO

The latter approach is harder to keep correct. Two glaring
faults are REPORT LUNS (mandatory since SPC-3) and
READ CAPACITY(16); both are "safe" but need CAP_SYS_RAW_IO
capability (usually root permissions). This may not annoy
cdrecord but it would peeve other pass through users.


If a user has read write permissions on
a full device (not just a partition in it) why shouldn't
they be able to send any (SCSI/ATA/...) pass through
command to it? When the sg driver was used to burn cd
and dvds in lk 2.4 series the window manager needed to
arrange for the GUI owner to have write permissions
on cd and dvd writing devices. No root permissions or
CAP_SYS_RAW_IO capability was needed.

Doug Gilbert
