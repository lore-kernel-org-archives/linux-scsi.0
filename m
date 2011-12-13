From: James Smart <james.smart@emulex.com>
Subject: [PATCH 0/7] lpfc 8.3.28: Update lpfc to revision 8.3.28
Date: Tue, 13 Dec 2011 13:20:18 -0500
Message-ID: <1323800420.1111.10.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:31044 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755171Ab1LMS0t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2011 13:26:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set updates the lpfc driver to revision 8.3.28.

The patches for 8.3.28 contain:

Miscellaneous fixes in sysfs and mgmt interfaces:
- Added SLI4 INTF_TYPE and SLI_FAMILY as sub-field to the fwrev sysfs
  attribute (CR 124103)
- Added a sysfs attribute "protocol" to report SLI4 port link protocol
  type (CR 124102)
- Increment mix-and-match minor number by 1 for added "protocol" sysfs
  attribute. (124102)
- Move the link speed check into the generic sli3/sli4 code
  path. (CR 124185, 124122)
- Deleted check for inExtWLen (CR 122523)
- Add the word "offline" to message 2889 (CR 124385)
- Conditionalize the firmware upgrade/downgrade so that it is only
  attempted for SLI4 type 2 boards (CR 124406)
- Return an error if the mbox sysfs is called. (CR 124210)
- When port_state is less than LPFC_VPORT_READY, report
  FC_PORTSTATE_BYPASSED (CR 120018)
- Added driver support for performing persistent linkdown based on
  configure region 23 (CR 124534)
- Added restore state and error log when sysfs board_mode attribute
  access failed (CR 124158)
- Added support for SLI4_CONFIG non-embedded COMN_GET_CNTL_ADDL_ATTR
  pass-through (CR 124466)
- Rejecting un-supported multi-buffer mailbox commands (CR 124771)
- Byte swap the extended data request and response data for extended
  mailbox data (CR 125081)

Adapter (SLI) interface fixes:
- Modify WQ handling to use entry_repost (CR 123981)
- Fix for ABTS.  Do not free original IOCB whenever ABTS fails. (CR 115829)
- Check board for FCoE before reading FCoE paramaters (CR124731)
- Add support for SLI4 FC Loop mode (CR 124721)
- Add support for resource count changes during fw reset. (CR 125888, 125675)
- Increase CQE count from 256 to 1024. (CR 126149)

Add support for ABTS failure handling:
- Add asynchronous ABTS notification event feature to driver (CR 124578)
- Change driver message 3092 and 3116 to KERN_WARNING (CR 124768)
- Alter the SCR ELS command to use the temporary RPI and the
  Destination DID for SLI4-FC (CR 126070)

FC and SCSI Discovery Fixes:
- Clear the virtual fabrics bit (word 1 bit 30) when sending the FLOGI
  and FDISC. (CR 124339)
- Return a MLQUEUE_DEVICE_BUSY if the driver detects that an I/O is being
  retried too quickly (CR 124668)
- Remove NDLP reference put in lpfc_cmpl_els_logo_acc for all but fabric
  nodes (CR 123924)
- Only retry FDISCs every second and stop retrying after devloss number
  of retries (CR 13939)
- Check to see if vports are unloading before adding them to the vport
  work array. (CR 124996)
- Fixed illegal state transition during driver unload (CR 124191)
- Added missing protection on setting/clearing of vport->fc_flag bit (CR 126002)
- Set NPIV flag in lpfc_mbx_process_link_up for all ports sli3 and
  above. (CR 126094)
- Clear FCP command bytes that are not used. (CR 126209)

Critical Miscellaneous fixes
- Make lpfc_sli4_pci_mem_unset interface type aware (CR 124390)
- Convert byte count to word count when calling __iowrite32_copy (CR 122550)
- Checked the ERR1 and ERR2 registers for error attention due to SLI
  Port state affected by forced debug dump. (CR 122986, 122426, 124859)
- Use the lpfc_readl routine instead of the readl for the port status
  register read in lpfc_handle_eratt_s4 (CR 125403)
- Call lpfc_sli4_queue_destroy inside of lpfc_sli4_brdreset before doing
  a pci function reset (CR 125124, 125168, 125572, 125622)
- Zero out the HBQ when it is allocated (CR 125663)
- Alter port reset log messages to indicate error type (CR 125989)
- Added proper NULL pointer checking to all the places that accessing
  the queue memory (CR 125832)

Add Loopback support for SLI4 adapters
- Add Basic support for SLI4 Loopback.
  (CR 124951, 125766, 124951, 125843, 125832, 125843)
- Added missing protection in setting/clearing of phba->link_flag bit
  field (CR 125994)
- Use link type and link number obtained from READ_CONFIG mailbox
  command. (CR 126264)

Update Version to 8.3.28.


The patches were cut against scsi-misc-2.6

-- james s


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>





