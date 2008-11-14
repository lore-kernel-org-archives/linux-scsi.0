From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11898] mke2fs hang on AIC79 device.
Date: Fri, 14 Nov 2008 07:41:03 -0800 (PST)
Message-ID: <20081114154103.8A5C6108057@picon.linux-foundation.org>
References: <bug-11898-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751204AbYKNPlh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2008 10:41:37 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mAEFf41s004524
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2008 07:41:05 -0800
In-Reply-To: <bug-11898-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11898





------- Comment #38 from anonymous@kernel-bugs.osdl.org  2008-11-14 07:41 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Wed, 2008-11-12 at 02:47 -0800, bugme-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=11898
> 
> 
> 
> 
> 
> ------- Comment #37 from vandrove@vc.cvut.cz  2008-11-12 02:47 -------
> Patch from #36 fixes hangs & crashes.  Thanks.

Great, thanks!

> So only remaining problem (for me...) is that with default setup I'm now
> getting only 50% of throughput I was getting with 2.6.27 - I can get ~40% back
> by limiting disks to 8 requests (so 31 per SATA controller is not hit that
> frequently), at the cost of making random I/O much worse...  Here are
> sequential write data (dd if=/dev/zero of=/xxx) - with default setting ~25MBps
> * 4, with restricting disks to 8 commands ~39MBps * 4.  2.6.27 gets ~47MBps *
> 4, and 2.6.27 with sata_sil24 patch to increase PCIe read length gets ~51MBps *
> 4 (which is present in current git tree tested here).
> 
> Default setting:
> 
> gwy:~# ./x.sh
> 4000+0 records in
> 4000+0 records out
> 4194304000 bytes (4.2 GB) copied, 110.417 s, 38.0 MB/s
> gwy:~# 4000+0 records in
> 4000+0 records out
> 4194304000 bytes (4.2 GB) copied, 155.827 s, 26.9 MB/s
> 4000+0 records in
> 4000+0 records out
> 4194304000 bytes (4.2 GB) copied, 206.971 s, 20.3 MB/s
> 4000+0 records in
> 4000+0 records out
> 4194304000 bytes (4.2 GB) copied, 206.301 s, 20.3 MB/s
> 
> Only 8 requests per drive; there are 4 drives sharing one tag map with 31
> entries:
> 
> gwy:~# for a in /sys/block/*/queue/nr_requests; do echo 8 > $a; done
> gwy:~# ./x.sh
> 4000+0 records in
> 4000+0 records out
> 4194304000 bytes (4.2 GB) copied, 103.588 s, 40.5 MB/s
> gwy:~# 4000+0 records in
> 4000+0 records out
> 4194304000 bytes (4.2 GB) copied, 110.86 s, 37.8 MB/s
> 4000+0 records in
> 4000+0 records out
> 4194304000 bytes (4.2 GB) copied, 105.978 s, 39.6 MB/s
> 4000+0 records in
> 4000+0 records out
> 4194304000 bytes (4.2 GB) copied, 107.94 s, 38.9 MB/s

Um, you might want to report this one separately.  I'd suggest to both
the IDE and SCSI lists:

linux-scsi@vger.kernel.org
linux-ide@vger.kernel.org

Appending it to a bug report we're getting ready to close is a sure way
of losing the information.

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
