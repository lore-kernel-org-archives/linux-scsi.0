From: James Smart <james.smart@emulex.com>
Subject: [PATCH 0/6] lpfc 8.3.27: Update lpfc to revision 8.3.27
Date: Mon, 10 Oct 2011 21:31:38 -0400
Message-ID: <1318296700.5189.9.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht2.emulex.com ([138.239.113.184]:33726 "EHLO
	exht2.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751213Ab1JKBiQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Oct 2011 21:38:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set updates the lpfc driver to revision 8.3.27.

The patches for 8.3.27. contain:

- Miscellanous logic and interface fixes
  - Fix lpfc_init_vfi_cmpl to check the interface type for interface type 0
    before parsing the results.
  - Cast uint32_t values that are multiplied to uint64_t before the
    multiplication.
  - Instead of "break" statement when PCI read returned error, use the goto
    statement to the end of the routine after setting return value
  - moved the msleep(10) to the beginning of the wait loop for checking the
    SLIPort_Status register
  - Added the code to follow the existing wait for SLIPort_Status register RDY,
    ERR, and RN bits to be set by the port before proceeding to perform PCI
    function reset.
  - Do not override ulpCt_h and ulpCt_l for SLI 4 ports.
  - For vport delete, call lpfc_nlp_put when the vport's vpi state is not
    marked with VPI_REGISTERED.
  - Added missed fields into the driver's Controller Attributes Structure
  - Changed ringing EQ/CQ/RQ doorbell register to be dependent on the size
    of the queue.
  - Return -EACCES in issue_reset if cfg_enable_hba_reset is zero.
  - Added new logging flag LOG_FCP_UNDER 0x00040000 to qualify underrun logging.
  - Add a check in the fabric name display routine to display 0 if the port
    state is <= FLOGI.
  - Add a check to the switch statement in lpfc_decode_firmware_rev to check
    for an 'X'.

- Changed worst case mailbox timeout

- Change algorithm for getting physical port name

- Fix queue allocation failure recovery
  - Move the allocation of the Queues closer to the creation of the queues.
  - If there is a problem with creation, or if the HBA is reset, the queues
    will be completely freed and re allocated.
  - Only allocate fcp_eq_hdl if cfg_fcp_eq_count is non-zero.

- T10 additions for SLI4
  - Added T10 DIFF error injection code.
  - Added T10 DIFF structure definitions for SLI4 devices.

- Change driver version to 8.3.27


The patches were cut against scsi-misc-2.6

-- james s


  Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
  Signed-off-by: James Smart <james.smart@emulex.com>





