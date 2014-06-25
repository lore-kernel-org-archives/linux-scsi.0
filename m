From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH v2 00/11] mptfusion/mpt2/mpt3 static checker fixups
Date: Wed, 25 Jun 2014 17:00:58 -0400
Message-ID: <1403730058-19872-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c11o145.mxlogic.net ([208.65.144.68]:46825 "EHLO
	p01c11o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932AbaFYVCF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2014 17:02:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Christoph Hellwig <hch@lst.de>, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>, Joe Lawrence <joe.lawrence@stratus.com>

v2:

Combined the mptfusion and mpt{2,3}sas static checker patches,
re-ordering them by driver.  Updated Reviewed-by and Acked-by tags as
well as Sreekanth's email address.  Based off v3.16-rc2, compile tested.

patches dropped:

* mpt3sas: fix possible memory leak in mpt3sas_send_trigger_data_event

  Christoph suggested combining this into a single allocation, so this
  patch was transformed into two new patches (removing the Reviewed-by
  and Acked-by tags):

  mpt2sas-combine-fw_event_work-and-its-event_data.patch
  mpt3sas-combine-fw_event_work-and-its-event_data.patch

* mptfusion: initChainBuffers should return errno

  Christoph noted that the whole callchain uses -1 instead of errno.
  Let it be.


patches modified:

* mptfusion: zero kernel-space source of copy_to_user

  A static checker false-positive brought me here, Christoph suggested
  using memdup_user.

* mptfusion: combine fw_event_work and its event_data

  Remove the unnecessary sz variables.

* mptfusion: tweak null pointer checks

  Moved commentry from myself (JL) and Christoph (HCH) into the commit
  message.


In the mpt{2,3}sas-combine-fw_event_work-and-its-event_data patches, I
was wondering if the alignment attribute should be:

  __attribute__ ((aligned (sizeof(unsigned long))))

instead of:

  char event_data[0] __aligned(4)

Regards,

Joe Lawrence (11):
  mpt2sas: correct scsi_{target,device} hostdata allocation
  mpt2sas: combine fw_event_work and its event_data
  mpt2sas: annotate ioc->reply_post_host_index as __iomem
  mpt3sas: correct scsi_{target,device} hostdata allocation
  mpt3sas: combine fw_event_work and its event_data
  mptfusion: mark file-private functions as static
  mptfusion: remove redundant kfree checks
  mptfusion: use memdup_user
  mptfusion: make adapter prod_name[] a pointer
  mptfusion: combine fw_event_work and its event_data
  mptfusion: tweak null pointer checks

 drivers/message/fusion/mptbase.c     |   23 +++++------
 drivers/message/fusion/mptbase.h     |    2 +-
 drivers/message/fusion/mptctl.c      |   18 +++------
 drivers/message/fusion/mptfc.c       |    3 +-
 drivers/message/fusion/mptsas.c      |   74 ++++++++++++++++------------------
 drivers/message/fusion/mptsas.h      |    2 +-
 drivers/message/fusion/mptscsih.c    |   19 ++++-----
 drivers/message/fusion/mptspi.c      |    5 +--
 drivers/scsi/mpt2sas/mpt2sas_base.c  |    9 +++--
 drivers/scsi/mpt2sas/mpt2sas_base.h  |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |   58 +++++++++++++++-----------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   62 +++++++++++++++-------------
 12 files changed, 137 insertions(+), 140 deletions(-)

-- 
1.7.10.4

