From: Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: kernel oops in del_gendisk with one queue for many disks under 2.6.x
Date: Tue, 20 Apr 2004 16:46:42 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <408537D2.7010902@shadowconnect.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.133.118.2] ([213.133.118.2]:55204 "EHLO
	mail.shadowconnect.com") by vger.kernel.org with ESMTP
	id S262990AbUDTOnv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Apr 2004 10:43:51 -0400
Received: from p50807ae9.dip.t-dialin.net ([80.128.122.233] helo=shadowconnect.com)
	by mail.shadowconnect.com with asmtp (TLSv1:AES256-SHA:256)
	(Exim 4.21)
	id 1BFwTV-0000IH-Li
	for linux-scsi@vger.kernel.org; Tue, 20 Apr 2004 16:43:49 +0200
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hello,

the i2o_block driver uses one queue per controller. If there are more
then one disk attached to the controller, the kernel oopses, if the 
module is removed, while deleting the second disk:

Call Trace:
<ffffffff801da37e>{kobject_del+27}
<ffffffff801da390>{kobject_unregister+9}
<ffffffff8022c344>{elv_unregister_queue+21}
<ffffffff8022fe47>{blk_unregister_queue+33}
<ffffffff80230c21>{unlink_gendisk+9}
<ffffffff801ae60b>{del_gendisk+77}
<ffffffffa0037ef2>{:i2o_block:i2o_block_exit+262}
<ffffffff8014c516>{sys_delete_module+321}
<ffffffff80166c1c>{sys_munmap+70}
<ffffffff801112ba>{system_call+126}

My question is, what is the best solution to the problem?

a) use one queue per disk?
b) set the queue to NULL for the other disks, that are on the same 
controller?
c) ???

Any help is highly appreciated.

Best regards,


Markus Lidel

