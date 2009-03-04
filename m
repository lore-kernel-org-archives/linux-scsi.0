From: Eric Moore <eric.moore@lsi.com>
Subject: [RFC 0/11] mpt2sas v00.100.11.11: 3rd revision
Date: Tue, 3 Mar 2009 22:07:00 -0700
Message-ID: <20090304050657.GA4194@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og106.obsmtp.com ([64.18.2.165]:39046 "EHLO
	exprod7og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221AbZCDSra (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2009 13:47:30 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id n24IlQCq005350
	for <linux-scsi@vger.kernel.org>; Wed, 4 Mar 2009 10:47:26 -0800 (PST)
Received: from localhost (emoore-test1.co.lsil.com [172.21.46.33])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id n24IlMAl013456
	for <linux-scsi@vger.kernel.org>; Wed, 4 Mar 2009 10:47:30 -0800
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

* This is new scsi lld device driver from LSI supporting the SAS 2.0 standard. I have split patchs by filename.
* Here is list of new 6gb host controllers:

  LSI SAS2004
  LSI SAS2008
  LSI SAS2108
  LSI SAS2116

* Here are the changes in the 3rd posting of this patch set:

(1) add readl following writel from the function that disables interrupts
(2) replace 0xFFFFFFFFFFFFFFFFULL with ~0ULL
(3) when calling pci_enable_msix, only pass one msix entry (instead of 15).
(4) remove the "current HW implementation uses..... " comment in the sources
(5) merged bug fix for SIGIO/POLLIN notifcation; reported by the storlib team.

* Here are the changes in the 2nd posting of this patch set:

(1) use little endian types in the mpi headers
(2) merged in bug fix's from inhouse drivers.

* Here is a summary of the patchs:

[PATCH 1/11] mpt2sas_base - Common API layer interface to MPT (Message Passing Technology) firmware.
[PATCH 2/11] mpt2sas_config - Common API for accessing firmware configuration pages.
[PATCH 3/11] mptsas_ctl - Storage Management Module.
[PATCH 4/11] mpt2sas_scsih - SCSI Host Layer.
[PATCH 5/11] mpt2sas_transport - Common API for accessing the Kernel SAS Transport Layer.
[PATCH 6/11] mpt2sas_debug - Common Header for debug logging.
[PATCH 7/11] mpi headers  -  Common MPI (Message Passing Interface) Headers.
[PATCH 8/11] Kconfig: mpt2sas Kernel configuration file.
[PATCH 9/11] Makefile - mpt2sas driver Makefile.
[PATCH 10/11] scsiml Kconfig - Adding mptsas to the common scsi ml Kconfig.
[PATCH 11/11] linux/miscdevice.h - Adding suport for MPT2SAS_MINOR(221)

* diffstat output

 Kconfig             |   66
 Makefile            |    7
 mpi/mpi2.h          | 1067 +++++++++
 mpi/mpi2_cnfg.h     | 2151 +++++++++++++++++++
 mpi/mpi2_init.h     |  420 +++
 mpi/mpi2_ioc.h      | 1295 +++++++++++
 mpi/mpi2_raid.h     |  295 ++
 mpi/mpi2_sas.h      |  282 ++
 mpi/mpi2_tool.h     |  249 ++
 mpi/mpi2_type.h     |   61
 mpt2sas_base.c      | 3390 +++++++++++++++++++++++++++++++
 mpt2sas_base.h      |  780 +++++++
 mpt2sas_config.c    | 1863 +++++++++++++++++
 mpt2sas_ctl.c       | 2502 ++++++++++++++++++++++
 mpt2sas_ctl.h       |  416 +++
 mpt2sas_debug.h     |  181 +
 mpt2sas_scsih.c     | 5663 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 mpt2sas_transport.c | 1207 +++++++++++
 18 files changed, 21895 insertions(+)

Signed-off-by: Eric Moore <eric.moore@lsi.com>
