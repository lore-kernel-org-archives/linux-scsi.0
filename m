From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH v4 00/10] Enhanced Unit Attention handling
Date: Thu,  1 Aug 2013 16:57:29 -0400
Message-ID: <1375390659-12495-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723Ab3HAU5n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Aug 2013 16:57:43 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r71KvhwO006205
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 1 Aug 2013 16:57:43 -0400
Received: from emilne.csb ([10.18.25.104])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r71KvgvZ031004
	for <linux-scsi@vger.kernel.org>; Thu, 1 Aug 2013 16:57:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

This patch set adds changes to the SCSI mid-layer, sysfs and scsi_debug
to provide enhanced support for Unit Attention conditions.

There was some discussion about this a couple of years ago on the linux-scsi
mailing list:  http://marc.info/?l=linux-scsi&m=129702506514742&w=2
Although one approach is to send all SCSI sense data to a userspace daemon
for processing, this patch set does not take that approach due to the
difficulty in reliably delivering all of the data.  An interesting UA
condition might not be delivered due to a flood of media errors, for example.

The mechanism used is to flag when certain UA ASC/ASCQ codes are received
that report asynchronous changes to the storage device configuration.
An appropriate uevent is then generated for the scsi_device or scsi_target
object.  The expecting_cc_ua flag is used for REPORTED LUNS DATA HAS CHANGED
unit attention conditions to avoid generating duplicate events on multiple
LUNs.

Changes made since earlier v3 version:
   - Put fixes to existing code in separate individual patches
   - Removed UA queue overflow condition reporting
   - Removed delayed_work aggregation mechanism for events
   - Eliminated separate scsi_device and scsi_target mechanisms
   - Changed to use a single environment variable for uevents
   - Clear expecting_cc_ua on successful commands
   - Added use of expecting_cc_ua for REPORTED LUNS DATA HAS CHANGED

Changes made since earlier v2 version:

   - Remove patch 1/8 "Generate uevent on sd capacity change"
   - Remove patch 8/8 "Streamline detection of FM/EOM/ILI status"
   - Changed scsi_debug to not generate UA on INQUIRY or REPORT_LUNS
   - Changed scsi_debug to only report UA queue overflow condition
     if dsense=1, as descriptor format sense data is needed

Changes made since earlier RFC version:

   - Remove patch 1/9 "Detect overflow of sense data buffer"
     Some scsi_debug changes in this patch were moved to patch 7/8
   - Corrected Kconfig help text
   - Change name of "sdev_evt_thread" to "sdev_evt_work"
   - Change name of "starget_evt_thread" to "starget_evt_work"
   - Pull code out of scsi_check_sense() that handles UAs into
     an exported function so that drivers can report conditions
     received asynchronously

Thanks to everyone for the comments on this patch series.

Ewan D. Milne (10):
  scsi: Fix incorrect function name in comment
  scsi: Correct size of envp[]
  scsi: Add missing newline to scsi_sysfs.c
  scsi: Change to use list_for_each_entry_safe
  scsi: Rename scsi_evt_thread() to scsi_evt_work()
  scsi: Move schedule_work() call to be outside lock
  scsi: Clear expecting_cc_ua on successful commands
  scsi: Generate uevents on certain unit attention codes
  scsi_debug: Add optional unit attention reporting
  scsi: Added scsi_target rescan capability to sysfs

 drivers/scsi/scsi_debug.c  | 131 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_error.c  | 125 ++++++++++++++++++++++++++++++++++--------
 drivers/scsi/scsi_lib.c    |  52 +++++++++++++++---
 drivers/scsi/scsi_priv.h   |   5 +-
 drivers/scsi/scsi_scan.c   |  33 ++----------
 drivers/scsi/scsi_sysfs.c  |  81 +++++++++++++++++++++++++---
 include/scsi/scsi_device.h |  11 +++-
 7 files changed, 372 insertions(+), 66 deletions(-)

-- 
1.7.11.7

