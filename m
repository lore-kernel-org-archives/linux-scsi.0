From: Ayman El-Khashab <ayman@elkhashab.com>
Subject: need help solving mpt2sas target unplug can hang worker thread
Date: Tue, 14 Feb 2012 07:15:41 -0600
Message-ID: <20120214131541.GA28005@crust.elkhashab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18625 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756418Ab2BNNPn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2012 08:15:43 -0500
Received: from crust.elkhashab.com (localhost [127.0.0.1])
	by crust.elkhashab.com (8.14.3/8.14.3/Debian-9.4) with ESMTP id q1EDFfsF028256
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2012 07:15:41 -0600
Received: (from ayman@localhost)
	by crust.elkhashab.com (8.14.3/8.14.3/Submit) id q1EDFf9S028255
	for linux-scsi@vger.kernel.org; Tue, 14 Feb 2012 07:15:41 -0600
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm doing this on powerpc/4xx (if that matters).  Basically
I can normally hot-plug or hot-remove disks from the mpt2sas
just fine.  It is easy to replicate on my system if I unplug
the drive during the enumeration process.  Based on what I
see, I gather it is in the scsi layer rather than the
mpt2sas driver, but I don't have that much experience in the
scsi driver to be certain.

There are 2 cases that cause this ...

1) Device never finishes the initial enumerate sequence
because there is something wrong with the drive, firmware on
the drive, etc.  

2) The drive was unplugged before the enumeration completes.

*MAYBE* this is addressed by the null pointer dereference
patches I've seen posted.  In any case, I get the thread
dumping every 120s, I cannot remove the driver module from
the kernel.  My only option is to reboot.  It would be great
if it didn't happen at all, but even if I can reset the
controller and get things back to a happier time, that would
be perfect.  Any tips for how I might accomplish that or is
there a particular patch I should take a look at / apply?

Thanks
Ayman
