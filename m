From: bloch@verdurin.com
Subject: Re. bug 6052 Megaraid problem on x86_64
Date: Thu, 16 Feb 2006 16:24:48 +0000
Message-ID: <20060216162448.GA7240@bloch.smith.man.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from i-195-137-43-42.freedom2surf.net ([195.137.43.42]:48103 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S932319AbWBPQY4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Feb 2006 11:24:56 -0500
Received: from localhost.localdomain (bloch [127.0.0.1])
	by localhost.localdomain (8.13.1/8.13.1) with ESMTP id k1GGOmVk032017
	for <linux-scsi@vger.kernel.org>; Thu, 16 Feb 2006 16:24:48 GMT
Received: (from adam@localhost)
	by localhost.localdomain (8.13.1/8.13.1/Submit) id k1GGOmCo032016
	for linux-scsi@vger.kernel.org; Thu, 16 Feb 2006 16:24:48 GMT
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I've altered the controller to use "cachedio" as suggested by 
Gorazd Golob and rebooted with the iommu=nomerge parameter.

At least I've been able to create and mount an ext3 filesystem.

However, when I tried untarring a kernel there was a journal error and
it was remounted read-only.

Here are the relevant system messages:

EXT3 FS on sdb2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
EXT3-fs error (device sdb2): ext3_new_block: Allocating block in system
zone - block = 44335105
Aborting journal on device sdb2.
EXT3-fs error (device sdb2) in ext3_reserve_inode_write: Journal has
aborted
ext3_abort called.
EXT3-fs error (device sdb2): ext3_journal_start_sb: Detected aborted
journal
Remounting filesystem read-only
__journal_remove_journal_head: freeing b_committed_data
__journal_remove_journal_head: freeing b_committed_data
__journal_remove_journal_head: freeing b_committed_data
__journal_remove_journal_head: freeing b_frozen_data
__journal_remove_journal_head: freeing b_frozen_data
__journal_remove_journal_head: freeing b_frozen_data
__journal_remove_journal_head: freeing b_frozen_data
__journal_remove_journal_head: freeing b_committed_data
__journal_remove_journal_head: freeing b_frozen_data
__journal_remove_journal_head: freeing b_frozen_data
__journal_remove_journal_head: freeing b_frozen_data
__journal_remove_journal_head: freeing b_frozen_data
__journal_remove_journal_head: freeing b_frozen_data

Any other suggestions for tracking this one down?

Details are at:

http://bugzilla.kernel.org/show_bug.cgi?id=6052

It appears to be a problem with the SATA 150-4 on an x86_64 box with 8G
RAM.
