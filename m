From: Jens Axboe <axboe@suse.de>
Subject: Re: drivers/block/scsi_ioctl problem
Date: Wed, 15 Dec 2004 08:18:53 +0100
Message-ID: <20041215071852.GM3157@suse.de>
References: <41BF7C18.9090303@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:35230 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262217AbULOHSz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Dec 2004 02:18:55 -0500
Content-Disposition: inline
In-Reply-To: <41BF7C18.9090303@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Dec 14 2004, Brian King wrote:
> Can someone explain to me the need for this bit of code in 
> drivers/block/scsi_ioctl.c:
> 
> if (!(type & CMD_WARNED)) {
> 	cmd_type[cmd[0]] = CMD_WARNED;
> 	printk(KERN_WARNING "scsi: unknown opcode 0x%02x\n", cmd[0]);
> }
> 
> I'm trying to convert an application to use SG_IO to /dev/sd* devices 
> rather than using /dev/sg* devices and this is one problem I have been 
> running into. Any time I issue a vendor specific scsi opcode I end up 
> getting one of these error logs. Is there a good reason this error log 
> is needed?

It was added to be able to find out which opcode was rejected and thus
caused an application malfunction. It dumps the specific opcode only
once, is that such a huge problem?

-- 
Jens Axboe

