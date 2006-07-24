From: "Scott Lowrey" <slowrey@nextone.com>
Subject: Fusion MPT Modules for Linux 2.6.11 and LSI Logic 53c1030?
Date: Mon, 24 Jul 2006 09:42:04 -0400
Message-ID: <8812D8156467224C9E9739E513037EF1011446A0@moe.nextone.local>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail2.nextone.com ([209.125.86.105]:15029 "EHLO
	mail2.nextone.com") by vger.kernel.org with ESMTP id S932154AbWGXNmG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jul 2006 09:42:06 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

My apologies for the long-winded overview.   I want to include all
relevant information.  If you'd like to skip to the questions at the
end, feel free.

We have recently encountered a severe I/O wait-bound condition on Intel
servers using the SE7520JR2 mainboard.  This board contains a built-in
LSI Logic 53c1030 SCSI adaptor capable of RAID 0 and RAID 1.  Our
servers are configured with two 72GB Fujitsu drives in a RAID 1 array.

Our Linux system is a bit of a hybrid.  We started out a year or so ago
with a system based on SuSE 9.1 Pro and the 2.6.8 kernel (SuSE 9.1 is
packaged with 2.6.5 but we had an immediate need to update to fix a
malloc() bug).  We have since made several updates, one of which
included an update to kernel 2.6.11 (specifically, 2.6.11.4-21.11) to
fix a critical problem with related to packet capture.  We always use
kernel source packages from SuSE.  So, what we now have is a relatively
recent SuSE kernel running with a relatively old set of SuSE packages
(some have been updated but most are from 9.1).

The problem occurs when a fairly high number of disk writes occur - we
can reproduce the problem by copying large files around or by using 'cat
/dev/urandom > /tmp/file'.  The symptoms are shown by 'iostat' as a very
high average wait time (from 7000 - 12000 ms) and 100% CPU utilization.
This condition persists for several minutes after the disk writing has
stopped.  The machine slows down and, on some occasions, becomes
unusable for long periods.

The problem goes away immediately if we disable RAID - either by
hot-pulling one of the drives or by deleting the RAID in the MPT BIOS.

I've searched many web sites and mailing lists, including this one, and
found several reports of similar problems.  From what I gather, there is
something going wrong with the RAID resync process.  I can't follow the
discussions too far passed that point because I'm not a SCSI expert.  At
any rate, the number of solutions seems to equal the number of system
configurations, so I'll describe our kernel situation and a possible
solution that we've found before asking The Questions.

Anyway, we think we have found a potential solution that involves
updating the MPT modules in our kernel.  We stumbled across the
mptlinux-3.02.60-3 DKMS patch at ftp.lsil.com (the LSI web site offers
3.02.52-1 for SuSE 9.1 users - we figured we'd go with the newer version
since we have a newer kernel). After applying this "module swap", the
problem appears to be fixed.  But we'd prefer not to distribute a DKMS
patch to our customers, so we are currently attempting to rebuild our
kernel with a patch generated from the DKMS source.

As one more point of interest: we can reproduce this problem with a
stock SuSE 9.1 distro, but it goes away with SuSE 9.3 and SuSE 10.0. If,
however, we transplant a 9.3 or 10.0 kernel into our distro, the problem
returns!  Argh.

So, my questions are these:

Is there a "correct" version of the MPT Fusion modules we should be
using with our kernel?

Is there something in our system configuration that might be aggravating
the problem?

Thanks very much.

--
Scott Lowrey
slowrey@NexTone.com

