From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH v3 0/6] [SCSI] Enhanced sense and Unit Attention handling
Date: Wed, 19 Jun 2013 13:42:35 -0400
Message-ID: <1371663761-22481-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756776Ab3FSRmo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Jun 2013 13:42:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, rwheeler@redhat.com

From: "Ewan D. Milne" <emilne@redhat.com>

This patch set adds changes to the SCSI mid-layer, sysfs and scsi_debug
to provide enhanced support for Unit Attention conditions, as well as
detection of a unit attention queue overflow condition and the ability
for drivers to report sense data outside of normal command completion.

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

The changes are enabled by a new kernel config option CONFIG_SCSI_ENHANCED_UA.
If this config option is not used, no new uevents are generated.  There are
some changes to kernel logging messages if CONFIG_SCSI_ENHANCED_UA is enabled,
because the existing messages explicitly stated that the kernel did not do
anything with the information.

Note that checkpatch is reporting errors on patch 5/6 relating to macros
in scsi_sysfs.c -- I believe these errors are incorrect and have sent a
message to the checkpatch maintainer.  The macros were derived from
existing ones already in the file.

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

Ewan D. Milne (6):
  [SCSI] Add a kernel config option for enhanced Unit Attention support
  [SCSI] Rename scsi_evt_xxx to sdev_evt_xxx and scsi_event to
    sdev_event
  [SCSI] Add support for scsi_target events
  [SCSI] Generate uevents for certain Unit Attention codes
  [SCSI] Add sysfs support for enhanced Unit Attention handling
  [SCSI] Add sense and Unit Attention generation to scsi_debug

 drivers/scsi/Kconfig       |  12 +++
 drivers/scsi/scsi_debug.c  | 138 +++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_error.c  | 187 ++++++++++++++++++++++++++++++++++++++++-----
 drivers/scsi/scsi_lib.c    | 176 ++++++++++++++++++++++++++++++++++++++----
 drivers/scsi/scsi_priv.h   |  10 ++-
 drivers/scsi/scsi_scan.c   |  54 +++++++------
 drivers/scsi/scsi_sysfs.c  | 146 ++++++++++++++++++++++++++++++++---
 include/scsi/scsi_cmnd.h   |   4 +
 include/scsi/scsi_device.h |  62 ++++++++++++++-
 include/scsi/scsi_eh.h     |   5 ++
 10 files changed, 716 insertions(+), 78 deletions(-)

-- 
1.7.11.7

