From: Douglas Gilbert <dougg@torque.net>
Subject: Re: drivers/block/scsi_ioctl problem
Date: Wed, 15 Dec 2004 15:32:47 +1000
Message-ID: <41BFCC7F.2050005@torque.net>
References: <41BF7C18.9090303@us.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:45266 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261888AbULOFbq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Dec 2004 00:31:46 -0500
In-Reply-To: <41BF7C18.9090303@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: linux-scsi@vger.kernel.org

Brian King wrote:
> Can someone explain to me the need for this bit of code in 
> drivers/block/scsi_ioctl.c:
> 
> if (!(type & CMD_WARNED)) {
>     cmd_type[cmd[0]] = CMD_WARNED;
>     printk(KERN_WARNING "scsi: unknown opcode 0x%02x\n", cmd[0]);
> }
> 
> I'm trying to convert an application to use SG_IO to /dev/sd* devices 
> rather than using /dev/sg* devices and this is one problem I have been 
> running into. Any time I issue a vendor specific scsi opcode I end up 
> getting one of these error logs. Is there a good reason this error log 
> is needed?

Brian,
I think command filtering was retrofitted into the block
SG_IO code. You only need read permissions to execute an
ioctl and FORMAT could be unfortunate.


IMO this code snippet should be moved from below the snippet
you showed to the top of the procedural lines in that function:

         /* And root can do any command.. */
         if (capable(CAP_SYS_RAWIO))
                 return 0;


That command filtering seems pretty haphazard, aimed mainly at
cd/dvd devices. The START STOP command is regarded as "safe
for read"** while SERVICE ACTION IN (12), (16), MAINTENANCE IN
and PERSISTENT RESERVE IN are _not_ considered "safe for read".

** the sd driver doesn't react well when some other mechanism
explicity spins down a dsik.

Doug Gilbert


