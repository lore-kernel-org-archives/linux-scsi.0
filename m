From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [RFC][PATCH] scsi mid-layer multi-path
Date: Fri, 10 May 2002 12:20:58 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200205101920.g4AJKw921753@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from northrelay03.pok.ibm.com (northrelay03.pok.ibm.com [9.56.224.151])
	by e1.ny.us.ibm.com (8.12.2/8.12.2) with ESMTP id g4AJL2AH102174
	for <linux-scsi@vger.kernel.org>; Fri, 10 May 2002 15:21:04 -0400
Received: from gateway.beaverton.ibm.com (gateway.beaverton.ibm.com [138.95.180.1])
	by northrelay03.pok.ibm.com (8.11.1m3/8.11.2) with ESMTP id g4AJL0o19642
	for <linux-scsi@vger.kernel.org>; Fri, 10 May 2002 15:21:00 -0400
Received: from eng2.beaverton.ibm.com (eng2.beaverton.ibm.com [9.47.57.17])
	by gateway.beaverton.ibm.com (8.10.0.Beta10/8.11.6) with ESMTP id g4AJKxL24663
	for <linux-scsi@vger.kernel.org>; Fri, 10 May 2002 12:20:59 -0700 (PDT)
Received: (from patman@localhost)
	by eng2.beaverton.ibm.com (8.10.0.Beta10/8.8.5/token.aware-1.2) id g4AJKw921753
	for linux-scsi@vger.kernel.org; Fri, 10 May 2002 12:20:58 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi -

Here's a linux scsi mid-layer multi-path patch against 2.5.14 that I have
been working on with assistance from Mike Anderson and Brian Beattie:

http://www-124.ibm.com/storageio/multipath/scsi-multipath/releases/0.1/patch-2.5.14-mpath-0.1.0.gz

Any comments, suggestions, or testing would be greatly appreciated.

Further details:

SCSI mid-layer multi-path IO Version 0.1.0

This release note, the multi-path patch (against 2.5.14), qla 6.0 patch,
documentation, and TODO list can be found under:

http://www-124.ibm.com/storageio/multipath/scsi-multipath/index.php

The qla 6.0 Beta 20 drivers (for use with the Qlogic 2200 or 2300) can be
found under:

http://www.qlogic.com/support/os_detail.asp?seriesid=76&osid=26

Or directly at:

http://download.qlogic.com/drivers/3945/qla2x00src-v6.0b20.tgz

Install the patch, and configure the mid layer multi-path IO support
(CONFIG_SCSI_MULTI_PATH_IO). If you have multi-port devices with no
penalty for switching ports, or only multi-path hosts (multi-initiated
fabrics and busses), use round-robin multipath routing
(CONFIG_SCSI_PATH_POLICY_RR); if you are unsure, use the last path used
selection (CONFIG_SCSI_PATH_POLICY_LPU).

Currently, multi-path support requires a SCSI device that supports the
SCSI INQUIRY vital product device identification page (0x83). Devices not
supporting page 0x83 have multiple paths treated as if they are attached to
separate device.

Tests were run using an IBM 3542 (LSI Triton), as well as dual-ported FCP
Seagate drives (ST39173F, in a Clariion DAE), with all devices attached
via multiple adapters connected to an IBM 2109 (Brocade) fibre channel
switch.  Only qlogic 2200 and 2300 fibre adapters were tested - the
qlogicfc and qla2200 drivers were used with the 2200, and the qla2300
driver was used with the 2300. 

Switch portdisable/portenable commands were used to simulate failures.
The /proc/scsi/scsi_path/paths interface was used to re-enable failed
paths.

In addition, systems were booted (with only single paths to devices)
using:

	Adaptec 7896 with the aic7xxx driver, with IBM-PSG ST318203LC disks
	IPS adapter and driver

Simple single path tape IO was tested using a ISP1020 adapter with the
qlogicisp driver, and a single DLT drive.

No tests were run using multiple paths (multiple initiators or dual ported
devices) on SCSI parallel interfaces.

The multi-path patch removes several structures commonly used by adapter
drivers, the main patch includes fixes for the AIC, qlogicfc, and IPS
drivers; there is a separate patch for the qla 6.0 beta 20 drivers. It's
likely you'll have to make modifications if you use an adapter and driver
combination other than the those listed.

Some of the more significant items in the TODO list include: adding proper
SMP locking support; separating queue_lock from host_lock; fixing the error
handling code (currently, if all paths fail, the error handler will run
but not be able to retry any IO).

Ideally, the CONFIG_SCSI_MULTI_PATH_IO would be removed, and any code
not compiled when it is not defined also removed.

-- Patrick Mansfield
