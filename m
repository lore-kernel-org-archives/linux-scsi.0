From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: [PATCH V4 0/9] aacraid: Patchset for aacraid driver version 41052
Date: Fri, 29 Jan 2016 14:45:41 -0800
Message-ID: <1454107550-24173-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:36178 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755532AbcA2Wfj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jan 2016 17:35:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Scott.Benesh@pmcs.com, jthumshirn@suse.de, thenzl@redhat.com, shane.seymour@hpe.com, RaghavaAditya.Renukunta@pmcs.com

This patchset includes the following changes (bug fixes and new feature
support) specific to aacraid driver.

V2:
Removed aac_fib_free_tag function
Setup relevant fib variables only once
Created aac_fib_vector_assign function
Made EEH functions static
Added character device status macros
changed location of aac->shutdown to prevent race condition
Withdrew patch that disables device ID wild card binding
Added Reviewed-by, Cc and Fixes tags from  mailing list

V3:
Moved aac_send_shutdown to top of __aac_shutdown
Converted aac->adapter_shutdown to atomic

V4:
Reverted adapter_shutdown from atomic
Used mutex to prevent shutdown race conditions on ioctl path

Raghava Aditya Renukunta (9):
 [SCSI] aacraid: SCSI blk tag support
 [SCSI] aacraid: Fix RRQ overload
 [SCSI] aacraid: Added EEH support
 [SCSI] aacraid: Fix memory leak in aac_fib_map_free
 [SCSI] aacraid: Set correct msix count for EEH recovery
 [SCSI] aacraid: Fundamental reset support for Series 7
 [SCSI] aacraid: Fix AIF triggered IOP_RESET
 [SCSI] aacraid: Fix character device re-initialization
 [SCSI] aacraid: Update driver version

 drivers/scsi/aacraid/aachba.c   |  27 ++---
 drivers/scsi/aacraid/aacraid.h  |  15 ++-
 drivers/scsi/aacraid/commctrl.c |   3 +
 drivers/scsi/aacraid/comminit.c |   6 +-
 drivers/scsi/aacraid/commsup.c  |  69 +++++++++++-
 drivers/scsi/aacraid/dpcsup.c   |   2 -
 drivers/scsi/aacraid/linit.c    | 241 ++++++++++++++++++++++++++++++++++++----
 drivers/scsi/aacraid/src.c      |  30 ++---
 8 files changed, 320 insertions(+), 73 deletions(-)

-- 
1.9.1

