From: Brian King <brking@us.ibm.com>
Subject: drivers/block/scsi_ioctl problem
Date: Tue, 14 Dec 2004 17:49:44 -0600
Message-ID: <41BF7C18.9090303@us.ibm.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37822 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261699AbULNXtp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Dec 2004 18:49:45 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.12.10/8.12.10) with ESMTP id iBENniV8031981
	for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2004 18:49:44 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id iBENniYQ241880
	for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2004 18:49:44 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id iBENnia1012278
	for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2004 18:49:44 -0500
Received: from [9.10.86.27] (kaled.rchland.ibm.com [9.10.86.27])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id iBENnidI012264
	for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2004 18:49:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Can someone explain to me the need for this bit of code in 
drivers/block/scsi_ioctl.c:

if (!(type & CMD_WARNED)) {
	cmd_type[cmd[0]] = CMD_WARNED;
	printk(KERN_WARNING "scsi: unknown opcode 0x%02x\n", cmd[0]);
}

I'm trying to convert an application to use SG_IO to /dev/sd* devices 
rather than using /dev/sg* devices and this is one problem I have been 
running into. Any time I issue a vendor specific scsi opcode I end up 
getting one of these error logs. Is there a good reason this error log 
is needed?


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
