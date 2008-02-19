From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: SCSI RAM driver
Date: Tue, 19 Feb 2008 06:31:20 -0700
Message-ID: <20080219133120.GA23001@parisc-linux.org>
References: <20080218063658.GF21012@parisc-linux.org> <20080219221442L.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:47504 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbYBSNbY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Feb 2008 08:31:24 -0500
Content-Disposition: inline
In-Reply-To: <20080219221442L.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: linux-scsi@vger.kernel.org, kristen.c.accardi@intel.com, fujita.tomonori@lab.ntt.co.jp, dougg@torque.net

On Tue, Feb 19, 2008 at 10:14:53PM +0900, FUJITA Tomonori wrote:
> I see that two drivers have very different objectives but if we add
> use_thread option to scsi_debug (we can do easily), it seems that
> scsi_debug can provide all the features that scsi_ram does.

It's not just use_thread.  It's also discard_read/discard_write.
And scsi_ram has a different data storage model from scsi_debug --
scsi_debug simulates an arbitrarily sized disc by wrapping around some
small (virtually) contiguous allocation of pages; scsi_ram actually
allocates the amount of ram that it's told to.  This can be solved with
another module parameter, of course.

I'm in no way opposed to merging the two; it's a question of whether
Doug will mind me doing some surgery on his driver.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
