From: Calvin Owens <calvinowens@fb.com>
Subject: [PATCH 0/2 v2] Fixes for memory corruption in mpt2sas
Date: Sat, 11 Jul 2015 21:24:54 -0700
Message-ID: <1436675096-324527-1-git-send-email-calvinowens@fb.com>
References: <1433821856-2815280-1-git-send-email-calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35769 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750709AbbGLEZo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Jul 2015 00:25:44 -0400
In-Reply-To: <1433821856-2815280-1-git-send-email-calvinowens@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>
Cc: MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, calvinowens@fb.com

Hello all,

This patchset attempts to address problems we've been having with
panics due to memory corruption from the mpt2sas driver.

Thanks,
Calvin

Patches in this series:
[PATCH 1/2] mpt2sas: Refcount sas_device objects and fix unsafe list usage
[PATCH 2/2] mpt2sas: Refcount fw_events and fix unsafe list usage

Changes since v1:
	* Squished patches 1-3 and 4-6 into two patches
	* s/BUG_ON(!spin_is_locked/assert_spin_locked/g
	* Use more succinct fuction names
	* Store a pointer to the sas_device object in ->hostdata to eliminate
	  the need for several lookups on the lists.
	* Remove the fw_event from fw_event_list at the start of
	  _firmware_event_work()
	* Explicitly separate fw_event_list removal from fw_event freeing

Total diffstat:

 drivers/scsi/mpt2sas/mpt2sas_base.h      |  22 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c     | 535 +++++++++++++++++++++----------
 drivers/scsi/mpt2sas/mpt2sas_transport.c |  12 +-
 3 files changed, 396 insertions(+), 173 deletions(-)

Diff showing changes v1 => v2:
	http://jcalvinowens.github.io/stuff/mpt2sas-patchset-v1v2.patch
