From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [Bug 101011] Kernel Oops when disconnecting a mounted ext4 usb
 stick
Date: Fri, 14 Aug 2015 14:39:31 -0400
Message-ID: <20150814183931.GA3050@thunk.org>
References: <bug-101011-11613@https.bugzilla.kernel.org/>
 <bug-101011-11613-PGvplgVz20@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59434 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbbHNSjh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Aug 2015 14:39:37 -0400
Content-Disposition: inline
In-Reply-To: <bug-101011-11613-PGvplgVz20@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Fri, Aug 14, 2015 at 11:02:14AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=101011
> 
> I can also confirm that this bug is present in latest stable kernel (4.1.5) and
> reverting commit from comment 6 seems to fix it.

Christoph,

I've since gotten two reports from users that reverting your commit:
"08439fec266c3: ext4: remove block_device_ejected" fixes a crash when
a USB stick is yanked from their system.  Looking at the reported
stack dump, it looks like the crash is happening in
account_page_dirtied() when it updates some bdi-specific statistics.

I haven't been paying attention to the recent changes in how bdi gets
torn down after the device gets removed, and in fact finding the
recent changes wasn't obvioius enough after doing a brief search, but
it seems to me that if reverting this patch is making any kind of
differences, then the assertion in the commit description:

    bdi->dev now never goes away, so this function became useless.

it implies that bdi->dev *does* become NULL, and checking for this is
useful.  In any case, I don't see any harm in reverting this commit;
what do you think?

Thanks,

					- Ted
