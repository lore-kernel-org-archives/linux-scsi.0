From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 7979] New: 2.6.20-rt2: high prio task yields
 journal commit I/O error
Date: Fri, 9 Feb 2007 16:18:03 -0800
Message-ID: <20070209161803.fda37642.akpm@linux-foundation.org>
References: <200702092345.l19NjVr6021127@fire-2.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56939 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946794AbXBJASK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Feb 2007 19:18:10 -0500
In-Reply-To: <200702092345.l19NjVr6021127@fire-2.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, rcrocomb@ieee.org

On Fri, 9 Feb 2007 15:45:31 -0800
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=7979
> 
>            Summary: 2.6.20-rt2: high prio task yields journal commit I/O
>                     error

Well you've been having fun there.

I'd say that you've hit two (maybe 1.5) bugs in the scsi code:

- I assume that your high-priority task has starved a scsi kernel thread
  for so long that when that thread finally got control, it decided that
  something had timed out and declared an error.

  Maybe.  Or perhaps the card decided that it hadn't been serviced for so
  long that it declared an error.  It would need someone who is familiar
  with scsi and aic7xxx to determine that.

- In response to the timeout, aic7xxx error handling went and passed crap
  into the scatter/gather unmapping code and the kernel oopsed.


Frankly, I doubt if either of these things (or at least, the first one) are
likely to be fixed in a hurry and I'd suggest that you look at continuing
your work on (say) a SATA or IDE machine, sorry.
