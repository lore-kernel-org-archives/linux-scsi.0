From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH 0/2] mpt2sas/mpt3sas resource cleanup fixes
Date: Fri,  2 Aug 2013 16:01:22 -0400
Message-ID: <1375473684-12566-1-git-send-email-joe.lawrence@stratus.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub5.stratus.com ([134.111.1.18]:43729 "EHLO
	mailhub5.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab3HBUCz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Aug 2013 16:02:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sreekanth.Reddy@lsi.com, Joe Lawrence <joe.lawrence@stratus.com>

Hi Sreekanth,

When testing unrelated PCI hotplug API, I hit a crash in mpt2sas when
pci_enable_device_mem failed in mpt2sas_base_map_resources.

It looks like mpt2sas_base_free_resources is not careful enough about
cleaning up only the resources that have been setup.  For example,
ioc->chip may not have been mapped yet, but mpt2sas_base_free_resources
calls functions that expect that it is.  Also, it seems that the
ioc->reply_queue_list head is initialized too late, as _base_free_irq
assumes that it is safe to iterate.

I reproduced / tested this by inserting a "return -ENODEV" at the top of
mpt2sas_base_map_resources.  I don't have access to mpt3sas HW, but that
driver code looks exactly the same.

Patches based off of 3.11.0-rc3.

Regards,

Joe Lawrence (2):
  mpt2sas: fix cleanup on controller resource mapping failure
  mpt3sas: fix cleanup on controller resource mapping failure

 drivers/scsi/mpt2sas/mpt2sas_base.c  | 16 +++++++++-------
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |  1 +
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 16 +++++++++-------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  1 +
 4 files changed, 20 insertions(+), 14 deletions(-)

-- 
1.8.3.1

