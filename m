From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/4] tcm: Add WriteCache + FUA Write support to TCM/FILEIO
Date: Thu, 26 Aug 2010 21:32:48 -0700
Message-ID: <1282883568-10809-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:45835 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751440Ab0H0Ecv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Aug 2010 00:32:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <teheo@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings hch, tejun and Co,

This patch series adds WriteCache + FUA Write emulation support into TCM v4 Core and
ConfigFS generic code at lio-core-2.6.git/lio-4.0.  The series changes the TCM
subsystem plugin API at include/target/target_core_transport.h:struct se_subsystem_api
that allows SYNCHRONIZE_CACHE emulation to be shared amoungst multiple TCM subsystem
plugins (eg: FILEIO, IBLOCK, RAMDISK).  This series includes initial support for
WCE=1 and DPOFUA=1 using the TCM/FILEIO subsystem plugin.

This first patch adds the device attribute infrastructure emulation into
target_core_transport.c and target_core_device.c, and adds four new configfs attributes
that appear in /sys/kernel/config/target/core/fileio_$ID/$DEV/attrib/

The second patch adds SYNCHRONIZE_CACHE and SYNCHRONIZE_CACHE_16 emulation code
capable of LBA + Range (Number of Blocks) context flushing in target_core_transport.c:
transport_generic_synchronize_cache(). This function uses the new struct se_subsystem_api
->do_sync_cache() and ->do_sync_cache_range() function pointers to make the calls out
into TCM subsystem plugin dependent code.

The third patch updates the MODE_SENSE* emulation for TYPE_DISK to change the
Caching Control Page to set WCE=1, and device type specific area for DPOFUA=1
for the FUA Write emulation bit.  And the final patch modifies TCM/FILEIO to use
the new struct se_subsystem_api callers using fs/sync.c:vfs_fsync() and
vfs_fsync_range() from below transport_generic_synchronize_cache()

Here are the remaining item(s) on the TODO:

	*) Support FUA READs..?
	*) Support for DPO aside from FUA WRITE/READ (is this possible..?)
	*) Using kernel level fcntl() to enable/disable O_SYNC using
	   emulate_write_cache configfs attribute (see patch #4)
	*) Add sense data for failed FUA WRITE task case in TCM/FILEIO
	   drivers/target/target_core_file.c:fd_do_task().

Comments are welcome,

Thanks!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (4):
  tcm: Add WriteCache and FUADPO infrastructure and attributes
  tcm: Add SYNCHRONIZE_CACHE* CDB infrastructure and emulation
  tcm: Add WriteCache and DPOFUA emulation bits to MODE_SENSE
  tcm/fileio: Add WriteCache and Forced Unit Access WRITE emulation

 drivers/target/target_core_configfs.c  |   16 +++
 drivers/target/target_core_device.c    |   84 +++++++++++++++++
 drivers/target/target_core_file.c      |  159 +++++++++++++++++++++++++++++++-
 drivers/target/target_core_transport.c |  156 ++++++++++++++++++++++++++++---
 include/target/target_core_base.h      |    7 ++
 include/target/target_core_device.h    |    4 +
 include/target/target_core_transport.h |   39 ++++++++
 7 files changed, 450 insertions(+), 15 deletions(-)

