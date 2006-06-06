From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 6657] New: Domain validation failures on
 aic7xxx
Date: Tue, 6 Jun 2006 09:18:40 -0700
Message-ID: <20060606091840.a39afe5a.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:20927 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751272AbWFFQSr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jun 2006 12:18:47 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id k56GIi2g002939
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 09:18:44 -0700
Received: from box (shell0.pdx.osdl.net [10.9.0.31])
	by shell0.pdx.osdl.net (8.13.1/8.11.6) with SMTP id k56GIfTF020940
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 09:18:42 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Apparently a regression.

(I thought the plan was to make scsi_drivers-other@kernel-bugs.osdl.org
auto-forward stuff to linux-scsi?)


Begin forwarded message:

Date: Tue, 6 Jun 2006 08:53:16 -0700
From: bugme-daemon@bugzilla.kernel.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 6657] New: Domain validation failures on aic7xxx


http://bugzilla.kernel.org/show_bug.cgi?id=6657

           Summary: Domain validation failures on aic7xxx
    Kernel Version: 2.6.16
            Status: NEW
          Severity: high
             Owner: scsi_drivers-other@kernel-bugs.osdl.org
         Submitter: william@brodie-tyrrell.org


Most recent kernel where this bug did not occur: 2.6.10
Distribution: Gentoo
Hardware Environment: x86, AHA19160, WD18310
Software Environment:
Problem Description: 

In 2.6.14 and 2.6.16 I get domain validation errors on my WD18310 connected to a
19160, causing it to drop back to asynchronous rather than 40 or 80MHz wide.  

Domain validation reports parity errors, write buffer failures, performs resets
and generally stuffs around for a few minutes before deciding it will allow async.

I have 2 other discs (Seagate SX118202LS) attached to the same chain which still
work.  My scsi system works perfectly in 2.6.10 with no data corruption.

I have a very similar issue with a dual SYM53C896 in a different machine: it
works in 2.6.10 but produces occasional noise in dmesg:
sym0:9:0:phase change 6-7 11@17cd5f84 resid=6.
On newer (>= 2.6.14) kernels, it completely fails to boot, giving the same sort
of parity errors I'm having with the aic7xxx driver.  When I checked at the time
(a while ago now), there was NO change in the relevant driver between kernel
versions.  The only changes are to the scsi architecture.

This leads me to believe the bug is not in the aic7xxx driver but the new scsi
domain validation code that was overhauled somewhere around 2.6.13-14.

Some of my error messages look a lot like those in #5268.

Steps to reproduce: Use kernel >=2.6.14 with aic7892 or 53C896.

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
