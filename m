From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Bugme-new] [Bug 8940] New: BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
Date: Sun, 26 Aug 2007 07:57:45 -0600
Message-ID: <20070826135745.GE14130@parisc-linux.org>
References: <bug-8940-10286@http.bugzilla.kernel.org/> <20070826005207.4f0b62ce.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:49108 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbXHZN5q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Aug 2007 09:57:46 -0400
Content-Disposition: inline
In-Reply-To: <20070826005207.4f0b62ce.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, bugme-daemon@bugzilla.kernel.org, dchris@gmail.com

On Sun, Aug 26, 2007 at 12:52:07AM -0700, Andrew Morton wrote:
> On Sat, 25 Aug 2007 09:47:40 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:
> > Problem Description: I got this error message:
> > BUG: unable to handle kernel NULL pointer dereference at virtual address
> > 00000000
> > in dmesg output when connecting a USB device. Turning off
> > CONFIG_SCSI_SCAN_ASYNC fixed the problem. Apparently there is a bug in SCSI
> > core code.

I don't think SCSI_SCAN_ASYNC is the problem.  It's probably a
coincidence.  SCSI_SCAN_ASYNC doesn't touch the call-path reported in
the backtrace.

In any case, if it is SCSI_SCAN_ASYNC-related, there's an outstanding
patch to fix the locking, which is slated for inclusion in 2.6.24.
http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=a93a091df8232fad60867d41fbc3be855a0b78f2

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
