From: Russell King <rmk@arm.linux.org.uk>
Subject: 2.6.0-test9: scsi_dev_flags
Date: Sun, 26 Oct 2003 14:47:41 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031026144741.A4326@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([212.18.232.186]:14602 "EHLO
	caramon.arm.linux.org.uk") by vger.kernel.org with ESMTP
	id S263179AbTJZOro (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Oct 2003 09:47:44 -0500
Received: from flint.arm.linux.org.uk ([2002:d412:e8ba:1:201:2ff:fe14:8fad])
	by caramon.arm.linux.org.uk with asmtp (TLSv1:DES-CBC3-SHA:168)
	(Exim 4.22)
	id 1ADmBC-0007ak-JP
	for linux-scsi@vger.kernel.org; Sun, 26 Oct 2003 14:47:42 +0000
Received: from rmk by flint.arm.linux.org.uk with local (Exim 4.22)
	id 1ADmBB-0001CX-SK
	for linux-scsi@vger.kernel.org; Sun, 26 Oct 2003 14:47:41 +0000
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

How are scsi_dev_flags supposed to work?

2.6.0-test9 appears to have an argument with my syquest drive - it
attempts to spin it up without a cartridge being present.  This doesn't
cause any ill effects except a rather long (== about 8 minutes) delay
in booting.

So, I originally added it to the blacklist in scsi_devinfo.c.  This
worked.  I then realised that it was marked as deprecated, in favour
of passing quirks on the command line.

So, I then tried doing exactly that:

	scsi_dev_flags=SyQuest:SQ3270S:4096

4096 being the BLIST flag value corresponding to BLIST_NOSTARTONADD.

However, it appears that 2.6.0-test9 is completely ignoring this, and
it still tries to spin up the drive without cartridge.  The manufacturer
string is "SyQuest" and the model string is "SQ3270S" so I'm don't
believe the command line string is in error.

An additional question comes out from this - if quirk information is now
to be passed on the kernel command line, how are users supposed to work
out the correct command line argument to give for their quirky hardware
given that it doesn't appear to be as trivial as the code suggests?
(IOW, the scsi_dev_flags option appears to be rather undocumented!)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:  2.6 PCMCIA      - http://pcmcia.arm.linux.org.uk/
                 2.6 Serial core
