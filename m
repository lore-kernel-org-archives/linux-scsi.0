From: Matthew Wilcox <matthew@wil.cx>
Subject: advansys update 2007-07-30
Date: Mon, 30 Jul 2007 10:55:08 -0600
Message-ID: <20070730165508.GH21219@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:41687 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758693AbXG3QzJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jul 2007 12:55:09 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


It's Monday morning, so time for another round of patches.

I'd like to thank jejb for merging the Lindent patch into Linus'
tree already.  And I'd like to thank jgarzik for being indefatigable
in his reviews.  I'd also like to thank jgarzik for telling me about
isa_register_driver which I wasn't previously aware of.

 - Moved ioport variable from EISA patch to request_region patch
 - Moved advansys_interrupt patch early in the sequence
 - Kill uses of asc_host array earlier
 - Added isa_driver 
 - Free wide memory in its own function (paired with advansys_wide_init_chip)
   instead of freeing the memory in advansys_board_found and advansys_release
 - Added comment to advansys_eisa_probe about the mysterious inw()
 - Check pci_resource_len in advansys_pci_probe
 - No longer attempt to drive devices when a register_driver call fails

I have the following todo list for this driver:
 - use_sg?
 - irq number shenanigan
 - replace spin_lock_irqsave with spin_lock in interrupt handler
 - should boardp->lock just be using the host lock?
 - delete no-ops DvcEnterCritical and DvcLeaveCritical
 - define DRV_NAME "advansys"
 - add __FUNCTION__ to ASC_PRINTx and ASC_DBGx
 - sort out CONFIG_PCI/CONFIG_EISA/CONFIG_ISA situation
 - Get rid of more prototypes

as well as the FIXME comment in the driver source:
/* FIXME:
 *
 *  1. Although all of the necessary command mapping places have the
 *     appropriate dma_map.. APIs, the driver still processes its internal
 *     queue using bus_to_virt() and virt_to_bus() which are illegal under
 *     the API.  The entire queue processing structure will need to be
 *     altered to fix this.
 *  2. Need to add memory mapping workaround. Test the memory mapping.
 *     If it doesn't work revert to I/O port access. Can a test be done
 *     safely?
 *  3. Handle an interrupt not working. Keep an interrupt counter in
 *     the interrupt handler. In the timeout function if the interrupt
 *     has not occurred then print a message and run in polled mode.
 *  4. Need to add support for target mode commands, cf. CAM XPT.
 *  5. check DMA mapping functions for failure
 *  6. Remove internal queueing
 *  7. Use scsi_transport_spi
 *  8. advansys_info is not safe against multiple simultaneous callers
 *  9. Kill boardp->id
 * 10. Add module_param to override ISA/VLB ioport array
 */

(why do I have two lists?  Not quite sure.  The one outside the driver
is more like notes to myself)

As before the patches will be available as a reply to this mail, and at
http://www.kernel.org/pub/linux/kernel/people/willy/advansys-2007-07-30/
and http://git.kernel.org/?p=linux/kernel/git/willy/advansys.git;a=shortlog

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
