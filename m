From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: SCSI_OWNER_LOWLEVEL, scsicmd->owner & scsicmd->state visibility in the LLD
Date: Thu, 25 Aug 2005 16:19:46 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F017F25BC@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:28599 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932539AbVHYUTs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Aug 2005 16:19:48 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id j7PKJlc11064
	for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2005 13:19:47 -0700
Received: from otce2k03.adaptec.com (otce2k03.adaptec.com [10.12.1.72])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id j7PKJlg31428
	for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2005 13:19:47 -0700
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

The aacraid driver does not maintain a list of outstanding commands to
the controller. The 'active' list is effectively maintained by the
controller Firmware state that reports back an index upon completion to
the 'active FIB' so that it may be placed back into the free list.

I want to add a means to reset the adapter (typically when it faults),
late model firmware offers an IOP_RESET command. I will be resetting the
adapter in the eh_handler context, ioctl context (for legacy kernels),
sysfs context and in a background kernel watchdog thread observing
adapter health indicators.

The problem is I must complete all outstanding commands in the
controller ala:

	command->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
SAM_STAT_TASK_SET_FULL;
	command->scsi_done(command);

In the name of performance (not maintaining two active lists, the one in
the scsi layer, and another in the driver) I noticed that I can discern
the commands that should be completed at Adapter Reset as:

	__shost_for_each_device(dev, host) {
      	spin_lock_irqsave(&dev->list_lock, flags);
      	list_for_each_entry(command, &dev->cmd_list, list)
			if (command->request &&
			  command->request->rq_status != RQ_INACTIVE &&
/* All commands that are active */
			  command->owner == SCSI_OWNER_LOWLEVEL &&
/* All commands owned by the driver */
			  command->state != SCSI_STATE_FAILED)
/* Remove any commands that have made it into the error handler */

But I am *sure* this is misplaced since command->state usage is
deprecated in recent cleanup patches, and command->owner's manifests are
maintained in .../drivers/scsi/scsi_priv.h probably (?) to obscure them
from the driver's view. (NOTE: 2.4 kernels 'command->request &&
command->request->rq_status != RQ_INACTIVE' with
'command->serial_number')

Is there an 'approved' API to acquire the low level driver outstanding
list, subtracting the commands that are already on the road to
completion but are tied up in the error handler? Is there an 'approved'
style to complete commands safely *within* the above loop, or must I do
it outside the loop?

Sincerely -- Mark Salyzyn
