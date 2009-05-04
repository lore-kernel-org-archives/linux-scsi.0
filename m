From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Linux doesn't support bigger than 2TB IEEE-1394 disk
Date: Mon, 04 May 2009 16:45:14 +0200
Message-ID: <49FEFF7A.3090603@s5r6.in-berlin.de>
References: <85681F9DCBFF144DA59C70D83EBC1DA2E1EDE7@EIOISER.ioi.com.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:45803 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbZEDOpc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2009 10:45:32 -0400
In-Reply-To: <85681F9DCBFF144DA59C70D83EBC1DA2E1EDE7@EIOISER.ioi.com.tw>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ronald <Ronald@ioi.com.tw>
Cc: linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org

Ronald wrote at linux1394-user:
> Linux doesn't support bigger than 2TB IEEE-1394 disk.
> 
> Will Linux have new driver for this issue?

(Adding Cc: linux-scsi)

As far as I can tell, Linux does support IEEE 1394 disks of any size. 
However, if I'm not mistaken, disks larger than 2 TB require that the 
READ CAPACITY (16) command is used to check the disk's capacity, rather 
than the usual READ CAPACITY (10) command.  Somebody correct me if I'm 
wrong.

By far most firmwares of IEEE 1394/ SBP-2 chipsets implement only the 
RBC (Reduced Block Commands) command set specification, or at least 
claim so in their INQUIRY response.  If I understood correctly, the 
Linux SCSI stack will never send READ CAPACITY (16) to them since this 
command is not included in RBC.

It is only part of the more general SBC (SCSI Block Commands) 
specification.  But Linux won't also send READ CAPACITY (16) to disks 
which claim SBC support, unless they also claim conformance to a 
reasonably recent SCSI revision (I don't remember which one and am too 
lazy to check).  This is because older firmwares may crash if they 
receive READ CAPACITY (16).

Ronald, do you know of a specific series of SBP-2 firmwares which do 
actually support READ CAPACITY (16) properly but are treated by Linux as 
if they wouldn't?  If so, we could add a workaround to our drivers to 
treat them like recent SBC implementations.  We would have to match 
against their firmware_revision field which you get logged in dmesg if 
you load the sbp2 or firewire-sbp2 driver with the module parameter 
workarounds=0x1000.

(Still, I could be mistaken and the problem might be something else than 
which READ CAPACITY flavor to use.  Maybe somebody more familiar with 
the block oriented SCSI command sets could comment.)
-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/
