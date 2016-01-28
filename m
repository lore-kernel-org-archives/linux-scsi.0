From: Suganath prabu Subaramani <suganath-prabu.subramani@avagotech.com>
Subject: [mpt3sas driver patches 00/10] mpt3sas driver enhancements and
Date: Thu, 28 Jan 2016 12:06:57 +0530
Message-ID: <1453963027-19770-1-git-send-email-suganath-prabu.subramani@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:32933 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106AbcA1Ghc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2016 01:37:32 -0500
Received: by mail-pf0-f182.google.com with SMTP id x125so18621598pfb.0
        for <linux-scsi@vger.kernel.org>; Wed, 27 Jan 2016 22:37:31 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, krishnaraddi.mankani@avagotech.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@avagotech.com, chaitra.basappa@avagotech.com, sreekanth.reddy@avagotech.com

From: Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>

Here is the change list:
Posting 10 patches for mpt3sas driver enhancements and few fixes.
  * Updated hardware description headers with MPI v2.6 and
    mpt3sas_pci_table[] with vendor_ids,device_ids of Cutlass and
    Intruder HBA which has support for 4 ports.
  * Static analyzer(coverity) tool identified defects.
  * Never block the SEP device even for the delay not
    responding events. Blocking the SEP device will create a deadlock while
    adding any device to the OS.
  * Modified host queue algorithm to treat global credits and
    highPriority credits as two different values.
  * Module parameter to enable/disable configuring
    affinity hint for msix vector.
  * Added support for configurable Chain Frame Size for
    SAS 3.0 HBA'S.
  * Updated MPI version and MPI header files.
  * Fix for Asynchronous completion of timedout IO and task abort
    of timedout IO.
  * Updated driver version to 12.100.00.00

Suganath prabu Subramani (10):
  mpt3sas: Added support for high port count HBA variants.
  mpt3sas: Used IEEE SGL instead of MPI SGL while framing a SMP
    Passthrough request message.
  mpt3sas: Fix static analyzer(coverity) tool identified defects
  mpt3sas: Never block the Enclosure device
  mpt3sas: Make use of additional HighPriority credit message frames for
    sending SCSI IO's
  mpt3sas: Added smp_affinity_enable module parameter.
  mpt3sas: Add support for configurable Chain Frame Size
  mpt3sas: Updated MPI Header to 2.00.42
  mpt3sas: Fix for Asynchronous completion of timedout IO and task abort
    of timedout IO.
  mpt3sas: Updating mpt3sas driver version to 12.100.00.00

 drivers/scsi/mpt3sas/mpi/mpi2.h          |  82 +++++++++-
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h     | 127 +++++++++++++--
 drivers/scsi/mpt3sas/mpi/mpi2_init.h     |  22 ++-
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h      | 117 ++++++++++++-
 drivers/scsi/mpt3sas/mpi/mpi2_raid.h     |   5 +-
 drivers/scsi/mpt3sas/mpi/mpi2_sas.h      |  10 +-
 drivers/scsi/mpt3sas/mpi/mpi2_tool.h     |   5 +-
 drivers/scsi/mpt3sas/mpi/mpi2_type.h     |   5 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c      | 149 ++++++++++++-----
 drivers/scsi/mpt3sas/mpt3sas_base.h      |  47 +++++-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       |  37 ++++-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 272 ++++++++++++++++++++++++++++---
 drivers/scsi/mpt3sas/mpt3sas_transport.c |  25 +--
 13 files changed, 769 insertions(+), 134 deletions(-)

Thanks,
Suganath prabu S
-- 
1.8.3.1

