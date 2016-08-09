From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH 0/6] cxlflash: Improvements and cleanup
Date: Tue,  9 Aug 2016 18:38:08 -0500
Message-ID: <1470785888-9112-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57912 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932373AbcHIXii (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2016 19:38:38 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u79NY7HR033154
	for <linux-scsi@vger.kernel.org>; Tue, 9 Aug 2016 19:38:37 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
	by mx0b-001b2d01.pphosted.com with ESMTP id 24qm9qaghe-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 09 Aug 2016 19:38:37 -0400
Received: from localhost
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Tue, 9 Aug 2016 17:38:37 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

This patch set contains various code improvements and cleanups that
were inspired by Al Viro upon reviewing the cxlflash driver. The core
improvement is that the driver will no longer cache the adapter file
descriptor associated with a context. This results in a user API change
that is documented alongside the modifications.

The series is based upon 4.8-rc1, intended for 4.9, and is bisectable.

Matthew R. Ochs (6):
  cxlflash: Avoid mutex when destroying context
  cxlflash: Cache owning adapter within context
  cxlflash: Add kref to context
  cxlflash: Transition to application close model
  cxlflash: Remove adapter file descriptor cache
  cxlflash: Update documentation

 Documentation/powerpc/cxlflash.txt |  44 ++++++++-
 drivers/scsi/cxlflash/superpipe.c  | 181 ++++++++++++++++---------------------
 drivers/scsi/cxlflash/superpipe.h  |   3 +-
 drivers/scsi/cxlflash/vlun.c       |  13 +--
 include/uapi/scsi/cxlflash_ioctl.h |  19 +++-
 5 files changed, 135 insertions(+), 125 deletions(-)

-- 
2.1.0

