From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH RFC 0/9] [SCSI] Enhanced sense and Unit Attention handling
Date: Fri, 18 Jan 2013 11:27:05 -0500
Message-ID: <1358526434-1173-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881Ab3ARQ1Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jan 2013 11:27:16 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0IGRFAq012948
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 18 Jan 2013 11:27:16 -0500
Received: from emilne.csb (dhcp-186-175.bos.redhat.com [10.16.186.175])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r0IGRFnD026564
	for <linux-scsi@vger.kernel.org>; Fri, 18 Jan 2013 11:27:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

This patch set adds changes to the SCSI mid-layer, sysfs and scsi_debug
to provide enhanced support for Unit Attention conditions, as well as
detection of reported sense data overflow conditions and some changes
to sense data processing.  It also adds a uevent when the reported
capacity changes on an sd device.

There was some discussion about this a couple of years ago on the linux-scsi
mailing list:  http://marc.info/?l=linux-scsi&m=129702506514742&w=2
Although one approach is to send all SCSI sense data to a userspace daemon
for processing, this patch set does not take that approach due to the
difficulty in reliably delivering all of the data.  An interesting UA
condition might not be delivered due to a flood of media errors, for example.

The mechanism used is to flag when certain UA ASC/ASCQ codes are received
that report asynchronous changes to the storage device configuration.
An appropriate uevent is then generated for the scsi_device or scsi_target
object.  An aggregation mechanism is used to avoid generating uevents at
too high a rate, and to coalesce multiple UAs reported by LUNs on the
same target for a REPORTED LUNS DATA HAS CHANGED sense code.

The changes are (mostly) enabled by a new kernel config option
CONFIG_SCSI_ENHANCED_UA.  If this config option is not used, no new
uevents are generated.  There are some changes to kernel logging messages
if CONFIG_SCSI_ENHANCED_UA is enabled, because the existing messages
explicitly stated that the kernel did not do anything with the information.

Note that checkpatch is reporting errors on patch 7/9 relating to macros
in scsi_sysfs.c -- I believe these errors are incorrect and have sent a
message to the checkpatch maintainer.  The macros were derived from
existing ones already in the file.

Ewan D. Milne (9):
  [SCSI] Detect overflow of sense data buffer
  [SCSI] Generate uevent on sd capacity change
  [SCSI] Add a kernel config option for enhanced Unit Attention support
  [SCSI] Rename scsi_evt_xxx to sdev_evt_xxx and scsi_event to
    sdev_event
  [SCSI] Add support for scsi_target events
  [SCSI] Generate uevents for certain Unit Attention codes
  [SCSI] Add sysfs support for enhanced Unit Attention handling
  [SCSI] Add sense and Unit Attention generation to scsi_debug
  [SCSI] Streamline detection of FM/EOM/ILI status

 drivers/scsi/Kconfig       |  12 +++
 drivers/scsi/scsi_debug.c  | 168 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_error.c  | 198 ++++++++++++++++++++++++++++++++++++++++-----
 drivers/scsi/scsi_lib.c    | 178 +++++++++++++++++++++++++++++++++++++---
 drivers/scsi/scsi_priv.h   |  10 ++-
 drivers/scsi/scsi_scan.c   |  54 ++++++-------
 drivers/scsi/scsi_sysfs.c  | 148 ++++++++++++++++++++++++++++++---
 drivers/scsi/sd.c          |   9 +++
 include/scsi/scsi_cmnd.h   |   4 +
 include/scsi/scsi_device.h |  64 ++++++++++++++-
 include/scsi/scsi_eh.h     |   7 ++
 11 files changed, 773 insertions(+), 79 deletions(-)

-- 
1.7.11.7

