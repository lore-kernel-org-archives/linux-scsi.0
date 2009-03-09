From: Eric Moore <eric.moore@lsi.com>
Subject: [RFC 0/12] mpt2sas v00.100.11.15: 4th revision
Date: Mon, 9 Mar 2009 01:20:25 -0600
Message-ID: <20090309072022.GA18720@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og106.obsmtp.com ([64.18.2.165]:41416 "EHLO
	exprod7og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbZCIVAI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Mar 2009 17:00:08 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com

* This is new scsi lld device driver from LSI supporting the SAS 2.0 standard. I have split patchs by filename.
* Here is list of new 6gb host controllers:

  LSI SAS2004
  LSI SAS2008
  LSI SAS2108
  LSI SAS2116

* Here are the changes in the 4th posting of this patch set:

(1) fix compile errors when SCSI_MPT2SAS_LOGGING is not enabled
(2) add mpt2sas to the SCSI Mid Layer Makefile
(3) append mpt2sas_ to the naming of all non-static functions
(4) fix oops for SMP_PASSTHRU
(5) doorbell algorithm imported changes from windows driver

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

[PATCH 1/12] mpt2sas_base - Common API layer interface to MPT (Message Passing Technology) firmware.
[PATCH 2/12] mpt2sas_config - Common API for accessing firmware configuration pages.
[PATCH 3/12] mptsas_ctl - Storage Management Module.
[PATCH 4/12] mpt2sas_scsih - SCSI Host Layer.
[PATCH 5/12] mpt2sas_transport - Common API for accessing the Kernel SAS Transport Layer.
[PATCH 6/12] mpt2sas_debug - Common Header for debug logging.
[PATCH 7/12] mpi headers  -  Common MPI (Message Passing Interface) Headers.
[PATCH 8/12] Kconfig: mpt2sas Kernel configuration file.
[PATCH 9/12] Makefile - mpt2sas driver Makefile.
[PATCH 10/12] scsiml Kconfig - Adding mptsas to the common scsi ml Kconfig.
[PATCH 11/11] linux/miscdevice.h - Adding suport for MPT2SAS_MINOR(221)
[PATCH 12/12] scsiml Makefile - add mpt2sas to the SCSI Mid Layer Makefile

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
 mpt2sas_base.c      | 3435 +++++++++++++++++++++++++++++++
 mpt2sas_base.h      |  779 +++++++
 mpt2sas_config.c    | 1873 +++++++++++++++++
 mpt2sas_ctl.c       | 2516 +++++++++++++++++++++++
 mpt2sas_ctl.h       |  416 +++
 mpt2sas_debug.h     |  181 +
 mpt2sas_scsih.c     | 5687 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 mpt2sas_transport.c | 1211 +++++++++++
 18 files changed, 21991 insertions(+)

Signed-off-by: Eric Moore <eric.moore@lsi.com>
