From: Calvin Owens <calvinowens@fb.com>
Subject: [RESEND][PATCH 0/6] Fixes for memory corruption in mpt2sas
Date: Mon, 8 Jun 2015 20:50:50 -0700
Message-ID: <1433821856-2815280-1-git-send-email-calvinowens@fb.com>
References: <1431661322-3097935-1-git-send-email-calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20679 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752713AbbFIDvS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2015 23:51:18 -0400
In-Reply-To: <1431661322-3097935-1-git-send-email-calvinowens@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>
Cc: MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, calvinowens@fb.com, kernel-team@fb.com

Hello all,

This patchset attempts to address problems we've been having with
panics due to memory corruption from the mpt2sas driver.

I will provide a similar set of fixes for mpt3sas, since we see
similar issues there as well. "Porting" this to mpt3sas will be
trivial since the part of the driver I'm touching is nearly identical
between the two, so I thought it would be simpler to review a patch
against mpt2sas alone at first.

I've tested this on a handful of large storage boxes over the past few
weeks, so far it seems to have completely eliminated the memory
corruption panics.

Thanks,
Calvin


Total diffstat:

 drivers/scsi/mpt2sas/mpt2sas_base.h      |  20 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c     | 482 +++++++++++++++++++++----------
 drivers/scsi/mpt2sas/mpt2sas_transport.c |  12 +-
 3 files changed, 359 insertions(+), 155 deletions(-)

Patches:

* [PATCH 1/6] Add refcount to sas_device struct
* [PATCH 2/6] Refactor code to use new sas_device refcount
* [PATCH 3/6] Fix unsafe sas_device_list usage
* [PATCH 4/6] Add refcount to fw_event_work struct
* [PATCH 5/6] Refactor code to use new fw_event refcount
* [PATCH 6/6] Fix unsafe fw_event_list usage
