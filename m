From: James.Smart@Emulex.Com
Subject: [Announce] Emulex lpfcdriver v8.0.13 available
Date: Wed, 20 Oct 2004 10:20:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0B1E13B586976742A7599D71A6AC733C02F224@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:14723 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S270378AbUJTOUx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Oct 2004 10:20:53 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id i9KEKpgI029940
	for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2004 07:20:52 -0700 (PDT)
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Smart@Emulex.Com

Christoph,

FYI - the 8.0.13 lpfc driver has been posted to SourceForge.

The driver contains the following notable changes (refer to the ChangeLog for more detail):
- Incorporated the 4 patches received from you since 8.0.12.
- Discovery fixes due to extensive testing of Suspend I/O patch.
- Added support for proposed FC transport patches for host attributes and statistics.
- Of the six binary attributes that previously existed:
   The statistics attributes was replaced by the FC transport patch
   The ctlreg and mbox attributes remain for user-space maintenance.
   The slimem attribute is ifdef'd out and will be removed. We are
     finalizing the removal of internal dependencies.
   The HBAAPI attributes of sendrnid and ct pass are ifdef'd out, and are
     present simply for reference.
- Added ifdef's so the driver compiles/runs on:
   Base Kernel: 2.6.5, 2.6.9
   Kernel + Suspend patch : 2.6.5 and 2.6.9-bk1 (make BUILD_FC_TRANS=1)
   Kernel + Suspend patch + FC stat/attr patch: 2.6.9-bk1 + patches (make BUILD_FC_TRANS=2)
- The ppc64 makefile issue was corrected.

At this point, I'd like to start a last call on modifications to driver.

My work list contains the following items:
- Complete 2 patches for the FC transport:
  Patch 1:
    Adds port attributes for stargets, and for remote ports
      that are not scsi targets.
    Handles consistent target id bindings on behalf of the LLDD.
  Patch 2:
    Adds HBAAPI sysfs service interfaces
- Update the driver to support the above FC transport patches
- Remove any unnecessary ifdef'd code (DFC_DEBUG, etc).

>From prior email, I believe have addressed all comments, with the possible exception of the following:
 - streamline I/O submission path
 - sort out memory allocation issues
Given the patches from you, and the prior statement on 8.0.12 of "Except for the binary attributes the update looks nice to me" - are these to your satisfaction ?

Please comment on any other issues that may be outstanding.

Thanks.

-- James S


The tarball is here:
http://prdownloads.sourceforge.net/lpfcxxxx/lpfcdriver-2.6-8.0.13.tar.gz?download

The full ChangeLog is on SourceForge:
http://sourceforge.net/forum/forum.php?forum_id=415795
