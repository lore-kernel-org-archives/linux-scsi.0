From: Csillag Tamas <cstamas@digitus.itk.ppke.hu>
Subject: qla2xxx errors? (2.6.19)
Date: Sun, 10 Jun 2007 12:00:11 +0200
Message-ID: <20070610100011.GG5705@digitus>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jugis.itk.ppke.hu ([193.225.109.42]:48916 "EHLO
	jugis.itk.ppke.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbXFJKGm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Jun 2007 06:06:42 -0400
Received: from jugis (jugis [127.0.0.1])
	by checked.jugis.itk.ppke.hu (Postfix) with ESMTP id E03FD154DFD
	for <linux-scsi@vger.kernel.org>; Sun, 10 Jun 2007 12:06:41 +0200 (CEST)
Received: from jugis (jugis [127.0.0.1])
	by checked.jugis.itk.ppke.hu (Postfix) with ESMTP id 1F0201637F7
	for <linux-scsi@vger.kernel.org>; Sun, 10 Jun 2007 12:00:30 +0200 (CEST)
Received: from rivendell2 (rivendell.itk.ppke.hu [193.225.109.193])
	by jugis.itk.ppke.hu (Postfix) with ESMTP id EB47314B322
	for <linux-scsi@vger.kernel.org>; Sun, 10 Jun 2007 12:00:11 +0200 (CEST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

The university I work at has 4 Blade HS20 servers connected to a IBM
DS400 storage via Fibre Channel.
The fibre channel module is:

06:01.0 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev 02)
06:01.1 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev 02)

# lsmod
Module                  Size  Used by
...
qla2xxx               143584  1

# l /lib/firmware 
total 244
lrwxrwxrwx 1 root root     21 2007-05-05 22:02 ql2300_fw.bin -> ql2300_fw.bin.3.03.18

With recent kernels filesystem corruption occurs under high disk I/O.
I have just tried 2.6.19 and I got the same, but kernel 2.6.18 and
before looks safe.

The test I use is the following:
I first checkout the kernel's git tree:
# git-clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux-2.6.git
Then
# for i in {100..400}; do; rsync -a linux-2.6.git/ c2_$i& done
.... waiting for finish
# for i in {100..400}; do; rsync -a linux-2.6.git/ c3_$i& done
.... waiting for finish
# for i in {100..400}; do; rsync -a linux-2.6.git/ c4_$i& done

Some error messages:
ReiserFS: warning: is_tree_node: node level 32010 does not match to the expected one 1
ReiserFS: sdb1: warning: vs-5150: search_by_key: invalid format found in block 8093723. Fsck?
ReiserFS: sdb1: warning: vs-13070: reiserfs_read_locked_inode: i/o failure occurred trying to find stat data of [961831 1064427 0x0 SD]

I am able to reproduce this errors.

With other filesystems I get similar errors.

I suspect a bug in qla2xxx, but I am not sure.
Can you help me how to track down this problem?

Thanks in advance.

PS: please cc to me.
-- 
CSILLAG Tamas (cstamas) - http://digitus.itk.ppke.hu/~cstamas
