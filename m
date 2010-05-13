From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET] libata: implement ->set_capacity()
Date: Thu, 13 May 2010 17:56:42 +0200
Message-ID: <1273766206-17402-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:33055 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932220Ab0EMP5U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 May 2010 11:57:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, linux-kernel@vger.kernel.org
Cc: ben@decadent.org.uk

Hello, Jens, James, Jeff,

This patchset implements ->set_capacity() in libata so that HPA can be
unlocked on demand.

 0001-block-restart-partition-scan-after-resizing-a-device.patch
 0002-SCSI-implement-sd_set_capacity.patch
 0003-libata-use-the-enlarged-capacity-after-late-HPA-unlo.patch
 0004-libata-implement-on-demand-HPA-unlocking.patch

0001 makes partition scan code to restart after ->set_capacity().
This makes sure that partitions which start beyond the HPA limit are
discovered.

0002 implements ->set_capacity() in sd.

0003 makes libata accept device capacity larger than the initial one.

0004 implements ->set_capacity() in libata which asks libata EH to
unlock HPA, waits and returns the new capacity.

Ben Hutchings suggeseted implementing ->set_capacity() in libata and
also reported the bug in the current partition scan code where it
fails to discover partitions which start beyond the HPA limit.

Unlocking HPA on-demand seems to be the safest default way to deal
with HPA.  Leaving HPA alone by default could fail to detect or
truncate existing partitions while unlocking by default make it more
prone to obscure data corruptions when combined with BIOSes beliving
that they exclusively own the area beyond HPA limit.

0001 should be routed through the block tree.  0002 should go through
SCSI but given the dependency and that libata is the only user, it
would probably much easier to route it through libata-dev#upstream
together with 0003 and 0004.

The patches are based on top of libata-dev#upstream but apply fine on
top of mainline too.

This patchset is available in the following git branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata-dev.git set-capa

and contains the following changes.

 drivers/ata/libata-core.c |    6 +++---
 drivers/ata/libata-scsi.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/sd.c         |   26 ++++++++++++++++++++++++++
 fs/partitions/check.c     |    7 ++++---
 include/linux/libata.h    |    3 +++
 include/scsi/scsi_host.h  |   11 +++++++++++
 6 files changed, 89 insertions(+), 6 deletions(-)

Thanks.

--
tejun
