From: Brian King <brking@us.ibm.com>
Subject: Re: drivers/block/scsi_ioctl problem
Date: Wed, 15 Dec 2004 13:13:25 -0600
Message-ID: <41C08CD5.10309@us.ibm.com>
References: <41BF7C18.9090303@us.ibm.com> <20041215071852.GM3157@suse.de>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:15311 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262450AbULOTN3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Dec 2004 14:13:29 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.12.10/8.12.10) with ESMTP id iBFJDQ8F006623
	for <linux-scsi@vger.kernel.org>; Wed, 15 Dec 2004 14:13:26 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id iBFJDQft285072
	for <linux-scsi@vger.kernel.org>; Wed, 15 Dec 2004 14:13:26 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.12.11) with ESMTP id iBFJDQLX008465
	for <linux-scsi@vger.kernel.org>; Wed, 15 Dec 2004 14:13:26 -0500
In-Reply-To: <20041215071852.GM3157@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On Tue, Dec 14 2004, Brian King wrote:
> 
>>Can someone explain to me the need for this bit of code in 
>>drivers/block/scsi_ioctl.c:
>>
>>if (!(type & CMD_WARNED)) {
>>	cmd_type[cmd[0]] = CMD_WARNED;
>>	printk(KERN_WARNING "scsi: unknown opcode 0x%02x\n", cmd[0]);
>>}
>>
>>I'm trying to convert an application to use SG_IO to /dev/sd* devices 
>>rather than using /dev/sg* devices and this is one problem I have been 
>>running into. Any time I issue a vendor specific scsi opcode I end up 
>>getting one of these error logs. Is there a good reason this error log 
>>is needed?
> 
> 
> It was added to be able to find out which opcode was rejected and thus
> caused an application malfunction. It dumps the specific opcode only
> once, is that such a huge problem?

Ok. I didn't realize that it was only dumped once. That's not as bad. I 
guess it might be better if it were only dumped if the op actually failed.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
