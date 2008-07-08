From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [ANNOUNCE]: ISCSI target driver iSCSI-SCST released
Date: Tue, 08 Jul 2008 23:17:58 +0400
Message-ID: <4873BD66.1080300@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-04.mailcluster.net ([77.221.130.216]:38262 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753475AbYGHThn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jul 2008 15:37:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: scst-devel <scst-devel@lists.sourceforge.net>

I'm glad to announce that version 1.0.0 of iSCSI target driver 
iSCSI-SCST released and available for download from 
http://scst.sourceforge.net/downloads.html.

ISCSI-SCST is a forked (with all respects) version of IET with updates 
to work in SCST environment (http://scst.sourceforge.net) as well as 
with many improvements and bugfixes. ISCSI-SCST has the following major 
advantages over the mainline IET:

     * It uses full power of SCST without loosing existing features. 
Namely, you can additionally use with it:

           o Pass-through mode with one to many relationship, i.e. when
             multiple initiators can connect to the exported pass-through
             devices.

           o More advances devices visibility management, when different
             initiators can see different set of devices with different
             access permissions from the same target.

           o O_DIRECT, i.e. "BLOCKIO on files", mode, which has all
             advantages of BLOCKIO, but also supports files on file
             systems. Sometimes, in the appropriate cases, this mode
             can make performance difference in 100% or even more.

           o With 4KB blocks you can forget about abysmal write
             performance caused by misaligned partitions.

           o Virtual CD/DVD-ROMs without necessity for manual patching.

           o Ability to create target devices emulators in the user
             space.

           o Ability to create multi-transport SCSI targets, which can
             export (possibly, the same) devices over multiple
             transports.

     * It has many code improvements and cleanups, including stability 
and iSCSI RFC violations fixes. Many IET users use it for ages without 
problems, so they consider it problemless. But, in fact, unfortunately, 
it isn't so. IET works well only on "fast" paths and regularly used 
branches, in many other less used cases IET has various problems, from 
simply ignoring error processing, as it is with memory allocations, and 
crashing itself with BUG() macro, as it is for malformed packets from 
initiators, to possible data corruption.

     * Due to reworked I/O architecture and SCST backend iSCSI-SCST has 
better performance in many cases. In future with upcoming improvements 
in SCST core, like zero-copy with Linux cache, the performance 
difference is going to be even bigger. Currently in tests from a single 
initiator over a single connection on 1GbE hardware over FILEIO vdisk 
iSCSI-SCST with default settings usually outperforms tuned for best 
performance IET a on 3-30%. The difference is especially noticeably with 
real storage, not NULLIO or RAM disks. On 10GbE hardware the performance 
difference is often as high as 100-200% or even more. With higher number 
of initiators the difference will be even bigger. This is because 
iSCSI-SCST has less commands processing overhead per command, hence has 
smaller processing latency and puts less load on CPU.

Detail description of iSCSI-SCST you can find on its page
http://scst.sourceforge.net/target_iscsi.html.

This driver is being prepared in form of patch for review and
inclusion into the kernel.

Vlad

