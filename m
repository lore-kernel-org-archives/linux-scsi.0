From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] make fc transport removal of target configurable
Date: Tue, 13 Jun 2006 12:59:59 -0500
Message-ID: <1150221599.3441.54.camel@mulgrave.il.steeleye.com>
References: <448DF5DA.3070800@sgi.com>
	 <20060613070714.GA16358@infradead.org> <448E9C34.6070707@emulex.com>
	 <448EDCEB.50702@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:25302 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750919AbWFMSAN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jun 2006 14:00:13 -0400
In-Reply-To: <448EDCEB.50702@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: James.Smart@Emulex.Com, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jim Nead <jnead@sgi.com>, Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>

On Tue, 2006-06-13 at 10:42 -0500, Michael Reed wrote:
> Mounted file systems have no clue either.  Even with no activity on the
> fs, if the target stays missing beyond the device loss timeout and then
> returns, the file system cannot be accessed without intervention.
> 
> When the target does return, the file system has to be unmounted and
> remounted on a new "sd" device.  This is even if there was no activity
> on the file system while its target was absent, i.e., it wouldn't otherwise
> require an unmount/remount.

But lets examine the options:  If you leave an uncontactable target
hanging around, the SCSI error handler will activate anyway when the
command timeout passes (currently 30s) and the device will be offlined.
Bringing it back online will require user intervention and likely
necessitate an unmount and a remount to repair the filesystem anyway.
Even if you go further and hold off the error handler, what this will do
is slowly hang the system since anything that touches an inode on the
blocked target will be put into D wait.  I really think pro-actively
removing the target is better than either of the other two options.

The device loss timer represents an acceptable compromise between the
need to keep the target across short disconnect/reconnect events and the
need to keep the system functioning.

James


