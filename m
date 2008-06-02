From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] ipr: Fix HDIO_GET_IDENTITY oops for SATA devices
Date: Mon, 02 Jun 2008 11:27:46 -0500
Message-ID: <48441F82.6060706@linux.vnet.ibm.com>
References: <12124164141515-patch-mail.ibm.com> <48441AEE.6050605@garzik.org>
Reply-To: brking@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:44240 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbYFBQ1z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2008 12:27:55 -0400
In-Reply-To: <48441AEE.6050605@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, linux-ide@vger.kernel.org, miltonm@bga.com, Tejun Heo <htejun@gmail.com>

Jeff Garzik wrote:
> Brian King wrote:
>> Currently, ipr does not support HDIO_GET_IDENTITY to SATA devices.
>> An oops occurs if userspace attempts to send the command. Since hald
>> issues the command, ensure we fail the ioctl in ipr. This is a
>> temporary solution to the oops. Once the ipr libata EH conversion
>> is upstream, ipr will fully support HDIO_GET_IDENTITY.
>>
>> Tested-by: Milton Miller <miltonm@bga.com>
>> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
>> ---
>>
>>  linux-2.6-bjking1/drivers/scsi/ipr.c |    6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> I was pretty happy with the rough draft of your EH conversion...  where 
> does that stand now?

Unfortunately, it sits in the pile of things I haven't had time to
work on... There are two issues that I need to resolve before it can
replace what is currently in mainline.

1. Since freeze() cannot be implemented like on a SATA HBA, this causes
   problems on port removal. Current removal procedure assumes it can just
   freeze the port and free up all command/DMA resources. Need to abort
   outstanding ops for SAS. This should be solvable with some libata-eh
   changes.

2. dev_res allocated memory (ata_port) gets freed on rphy_device_del,
   rather than on the last put, which causes ata_port to get freed
   too soon. Possible solution would be to free dev_res allocated memory
   on the last put rather than on device_del.

The second problem was the one I got stuck on. Perhaps Tejun can chime in
here... Would it be possible to change dev_res to free allocated memory
on release rather than delete time?

There is also the issue of HBA queue limits. Since each SATA rphy uses its
own SCSI host, we lost host queue limit enforcement. I've implemented a
request_limit in ipr in order to solve this for ipr, but this really
does not scale well to lots of SATA devices, so we would probably need
queue groups at the block level before moving libsas to the new API.

-Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center
