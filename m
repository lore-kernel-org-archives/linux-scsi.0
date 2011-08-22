From: James Smart <james.smart@emulex.com>
Subject: [PATCH 0/4] lpfc 8.3.26: Update lpfc to revision 8.3.26
Date: Sun, 21 Aug 2011 21:47:28 -0400
Message-ID: <1313977649.21906.3.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:6384 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752891Ab1HVBsE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Aug 2011 21:48:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set updates the lpfc driver to revision 8.3.26.

The patches for 8.3.26. contain:


- Fix issues pertaining to SCSI/FC protocol.
  - Allow frames destined to 0xFFFFFE to be processed by the driver by matching
    that DID with the physical port.
  - Call lpfc_sli_issue_iocb with context1 set to ndlp
  - In echo command accept function, adjust memcpy to limit memcpy to 1K
  - Set LPFC_SLI3_BG_ENABLED properly upon completion.
  - Skip the INIT_VFI call in lpfc_register_fcf if the FCF is already
    registered and go immediately to initial flogi.
  - use "status" variable instead of "ret" variable to hold the return of the
    fc_block_scsi_eh.

- Fix HBA initialization issues.
  - Swap all values that come from the firmware image on little endian systems.
  - Moved the incrementing of temp_offset after the copy
    fixed the write object loop to use temp_offset to figure out where the end
    of the image is instead of offset.
  - Added the necessary codes for properly bringing the driver instance offline
    and then trying to bring the port back online with the PCI function IP
    reset. If it fails to bring the SLI port back online, it will fall through
    to bringing the SLI port to HBA error offline.
  - Add a call in the probe_one_s3 and probe_one_s4 routines to get the
    Modeldesc
  - Change OCe50100 to OCe15100
  - Made the error log also include the PCI BAR bitmap returned from kernel call
    pci_select_bars().


- Fix SYSFS interface issues.
  - In the lpfc_sli4_pdev_status_reg_wait() routine, after initial 100ms delay
    following write to PHYSDEV_CONTROL register for the firmware reaction, check
    the RN bit and ERR bit of the SLIPORT_STATUS register. If none of them
    became 1, the previous PHYSDEV_CONTROL register should be considered failed
    due to lack of privilege and error for no permission should be returned
    immediately without getting into the wait for RDY bits on the SLIPORT_STATUS
    register.
  - Remove the driver check on dev->is_physfn before proceed to perform the
    PHYSDEV_CONTROL register write, and let the PCI function's privilege
    setting and driver handling of PHYSDEV_CONTROL register write failure to
    handle the reset-ability through the SLI port.
  - Added key to ctlreg_write to prevent unauthorized or unexpected write to
    the control register.
  - Change return to EACCES for sysfs access that are failed because hba_reset
    is disabled.

- Change driver version to 8.3.26


The patches were cut against scsi-misc-2.6

-- james s


  Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
  Signed-off-by: James Smart <james.smart@emulex.com>





