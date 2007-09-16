From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] aic94xx: fix smartctl utility problem
Date: Sun, 16 Sep 2007 15:43:20 -0400
Message-ID: <46ED8758.6040203@garzik.org>
References: <1189792710.6030.3.camel@linux.site>	 <1189875940.3339.12.camel@localhost.localdomain> <1189960632.3383.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:34094 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbXIPTn3 (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Sun, 16 Sep 2007 15:43:29 -0400
In-Reply-To: <1189960632.3383.4.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Gilbert Wu <Gilbert_Wu@adaptec.com>, Linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Sat, 2007-09-15 at 12:05 -0500, James Bottomley wrote:
>> On Fri, 2007-09-14 at 10:58 -0700, Gilbert Wu wrote:
>>> Fixed the problem that "smartctl -a /dev/some_sata_disk -d ata"  does
>>> not work on SATA device. ( The smartctl v5.38 does need "-d ata"
>>> option.)
>>>   The aic94xx need to return ATA output register for all ATA commands
>>> except ATA Read/Write commands.
>>>   The aic94xx also mark out the DRQ bit from status register which is
>>> treated as AC_ERR_HSM (host state machine violation) error by top layer
>>> if it set to one.
>>>  The firmware of aic94xx chip handle all ATA handshaking, data transfer
>>> and return ATA output register which is sent by the device.  So the DRQ
>>> bit may not reflect the last state of device when the command finished
>>> and it is no meaning for the caller.
>>>
>>> Signed-off-by: Gilbert Wu <gilbert_wu@adaptec.com>
>> I'm afraid this can't go in.  It has a bad effect on my expander remote
>> ATAPI device:
> 
> OK, found the root cause: your CSMI_TASK flag is getting set on all
> packet commands.  I can think of two fixes: either smartctl should never
> be used on ATAPI devices (reasonable, since smart is a disc protocol),
> so we predicate the check by a test for the device being ATA:
> 
> 	if (dev->sata_dev.command_set == ATA_COMMAND_SET
> 	    && !is_ata_rw_cmd(scb->ata_task.fis.command))
> 
> Or simply add ATA_CMD_PACKET to your is_ata_rw_cmd() switch.

Agreed.  I missed that in my review.

	Jeff



