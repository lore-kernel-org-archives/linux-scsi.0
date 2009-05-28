From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug 13311] New: mptsas: ioc0: removing ssp device, kernel oops
Date: Thu, 28 May 2009 01:00:38 -0700
Message-ID: <20090528010038.b4d3b2b9.akpm@linux-foundation.org>
References: <bug-13311-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759039AbZE1IBI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 May 2009 04:01:08 -0400
In-Reply-To: <bug-13311-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mike.tummy@gmail.com
Cc: linux-scsi@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org, Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Thu, 14 May 2009 18:17:10 GMT bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=13311
> 
>            Summary: mptsas: ioc0: removing ssp device, kernel oops

I'd have thought that the severity of this problem is not matched by
the response.

>            Product: SCSI Drivers
>            Version: 2.5
>     Kernel Version: 2.6.27.21

Is it reproducible?  If so, is there any change that it can be retested
under a 2.6.29-based kernel?

Thanks.

<searches through a wordwrapped mess.  Sigh>

> May 12 05:20:20 tile01-primary kernel: RIP: 0010:[<ffffffff802fe7c2>]  [<ffffffff802fe7c2>] sysfs_find_dirent+0x9/0x2f

OK, I assume that the scsi driver did something bad to sysfs and
that sysfs then fell on its face.

Really, given the frequency and imaginativeness with which drivers
abuse sysfs, the driver-core should be more robust.

Kay, would you have time to plunk through this and see if we can
strengthen the sysfs code a bit so it doesn't crash?

But the core bug is presumably in the mptsas driver.  Perhaps you can
also see if you can work out what it did wrong?

Thanks.
