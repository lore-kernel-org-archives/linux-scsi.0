From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH RFC 0/6] SCSI Userspace Target
Date: Tue, 07 Feb 2006 21:10:42 +0900
Message-ID: <20060207211042W.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:47824 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP id S965037AbWBGMKo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Feb 2006 07:10:44 -0500
Received: from vcs3.rdh.ecl.ntt.co.jp (vcs3.rdh.ecl.ntt.co.jp [129.60.39.110])
	by tama5.ecl.ntt.co.jp (8.12.11/8.12.11) with ESMTP id k17CAgim021074
	for <linux-scsi@vger.kernel.org>; Tue, 7 Feb 2006 21:10:42 +0900 (JST)
Received: from mfs3.rdh.ecl.ntt.co.jp (mfs3.rdh.ecl.ntt.co.jp [129.60.39.112])
	by vcs3.rdh.ecl.ntt.co.jp (8.12.11/8.12.11) with ESMTP id k17CAfTh029519
	for <linux-scsi@vger.kernel.org>; Tue, 7 Feb 2006 21:10:41 +0900 (JST)
Received: from nttmail3.ecl.ntt.co.jp ([129.60.39.100])
	by mfs3.rdh.ecl.ntt.co.jp (8.12.11/8.12.11) with ESMTP id k17CAfLY007240
	for <linux-scsi@vger.kernel.org>; Tue, 7 Feb 2006 21:10:41 +0900 (JST)
Received: from dmailsv1.y.ecl.ntt.co.jp (dmailsv1.y.ecl.ntt.co.jp [129.60.53.14])
	by nttmail3.ecl.ntt.co.jp (8.12.11/8.12.11) with ESMTP id k17CAeEM014371
	for <linux-scsi@vger.kernel.org>; Tue, 7 Feb 2006 21:10:40 +0900 (JST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is the second version of the SCSI Userspace target framework.
The goal of the project is to push most of the target code to
userspace. The only parts we kept in the kernel were for transferring
data between the LLD and userpsace by using the packet socket mmapped
IO interface.

Please refer to the first submission in last month for further
details.

http://marc.theaimsgroup.com/?l=linux-scsi&m=113815791805410&w=2


Thanks to everyone who provided comments on the first round. We have
incorporated all comments.

New in this submission:

o Replace our mapping code with the helper functions (such as
bio_map_user)
o Use the struct requests end_io_data instead of adding something new
to scsi_cmnd
o Replace netlink code with the packet socket mmapped IO interface
o Add another target LLD example, IBM Virtual SCSI target LLD.


You need the 3rd, 4th, and 5th patches to compile the code though they
are outside scsi-ml. We submit them to other places later too.

This time we included IBM Virtual SCSI target LLD based on ibmvscsis
LLD. We have not changed the software iscsi target LLD since the first
submission.

We updated the corresponding user-space tools:

http://svn.berlios.de/svnroot/repos/stgt/branches/use-scsi-ml


Thanks,

Mike Christie and FUJITA Tomonori
