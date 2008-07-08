From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [ANNOUNCE]: Generic SCSI Target Mid-level For Linux (SCST), target
 drivers for iSCSI and QLogic Fibre Channel cards released
Date: Tue, 08 Jul 2008 23:14:45 +0400
Message-ID: <4873BCA5.10103@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-03.mailcluster.net ([77.221.130.215]:59116 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753934AbYGHTko (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jul 2008 15:40:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: scst-devel <scst-devel@lists.sourceforge.net>

I'm glad to announce that version 1.0.0 of Generic SCSI Target Middle 
Level for Linux (SCST) was released and available for download from 
http://scst.sourceforge.net/downloads.html

SCST is a subsystem of the Linux kernel that provides a standard 
framework for SCSI target drivers development. It is designed to provide 
unified, consistent interface between SCSI target drivers and Linux 
kernel and simplify target drivers development as much as possible. It 
has the following main features:

     *  Simple, easy to use interface with target drivers. Particularly, 
SCST core performs required pre- and post- processing of incoming 
requests as well as necessary error recovery.

     * Undertakes most problems, related to execution contexts, thus 
practically eliminating one of the most complicated problem in the 
kernel drivers development. For example, a target driver for QLogic 
22xx/23xx cards, which has all necessary features, is only about 2000 
lines of code long.

     * Very low overhead, fine-grained locks and simplest commands 
processing path, which allow to reach maximum possible performance and 
scalability. Particularly, incoming requests can be processed in the 
caller's context or in one of the internal SCST core's tasklets, 
therefore no extra context switches required.

     * Device handlers, i.e. plugins, architecture provides extra 
flexibility by allowing various I/O modes in backstorage handling. For 
example, pass-through device handlers allow to use real SCSI hardware 
and vdisk device handler allows to use files as virtual disks.

     * Provides advanced per-initiator devices visibility management 
(LUN masking), which allows different initiators to see different set of 
devices with different access permissions. For instance, initiator A 
could see exported from target T devices X and Y read-writable, and 
initiator B from the same target T could see devices Y read-only and Z 
read-writable.

     * Emulates necessary functionality of SCSI host adapter, because 
from remote initiators point of view SCST acts as a SCSI host with its 
own devices.

The following I/O modes are supported by SCST:

	* Pass-through mode with one to many relationship, i.e. when multiple 
initiators can connect to the exported pass-through devices, for 
virtually all SCSI devices types: disks (type 0), tapes (type 1), 
processors (type 3), CDROMs (type 5), MO disks (type 7), medium changers 
(type 8) and RAID controllers (type 0xC)

	* FILEIO mode, which allows to use files on file systems or block 
devices as virtual remotely available SCSI disks or CDROMs with benefits 
of the Linux page cache

	* BLOCKIO mode, which performs direct block I/O with a block device, 
bypassing page-cache for all operations. This mode works ideally with 
high-end storage HBAs and for applications that either do not need 
caching between application and disk or need the large block throughput.

	* User space mode using scst_user device handler, which allows to 
implement in the user space virtual SCSI devices in the SCST environment.

Detail description of SCST, its drivers and utilities you can find on 
SCST home page http://scst.sourceforge.net.

Comparison with the mainstream target middle level STGT you can find on 
the SCST vs STGT page http://scst.sourceforge.net/scstvsstgt.html. In 
short, SCST has the following main advantages over STGT:

  - Better performance (in many cases tens of %% and more) with 
potential for further improvement, for example, by implementing 
zero-copy cache I/O.

  - Monolithic in-kernel architecture, which follows standard Linux 
kernel paradigm to eliminate distributed processing. It is simpler, 
hence more reliable and maintainable.

SCST is being prepared in form of patch for review and inclusion to the 
kernel.

Vlad
