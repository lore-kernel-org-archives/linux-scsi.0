From: Brian King <brking@us.ibm.com>
Subject: scsi_tcq.h questions
Date: Mon, 02 Aug 2004 16:11:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <410EADE7.3050307@us.ibm.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:17568 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263709AbUHBVLF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Aug 2004 17:11:05 -0400
Received: from northrelay04.pok.ibm.com (northrelay04.pok.ibm.com [9.56.224.206])
	by e1.ny.us.ibm.com (8.12.10/NS PXFA) with ESMTP id i72LB5OZ220444
	for <linux-scsi@vger.kernel.org>; Mon, 2 Aug 2004 17:11:05 -0400
Received: from us.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by northrelay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i72LC6DK070192
	for <linux-scsi@vger.kernel.org>; Mon, 2 Aug 2004 17:12:06 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have a question related to the utility functions found in scsi_tcq.h. 
The comment above scsi_activate_tcq indicates that the depth passed in 
should be the maximum depth the device can cope with and the real queue 
depth would be adjustable. This seems to contradict what is done in 
53c700.c, as queue depth is a sysfs file which is defaulted to 4 and can 
be raised to 16. Since scsi_adjust_queue_depth never calls 
blk_queue_resize_tags, we end up with a larger queue depth in scsi than 
the block layer is aware of.

So, which is correct? Should scsi_adjust_queue_depth be changed to call 
blk_queue_resize_tags and the comment be removed from scsi_activate_tcq, 
or should the call to scsi_adjust_queue_depth in scsi_activate_tcq be 
removed and the queue depth passed in scsi_activate_tcq be a true max 
queue depth, in which case 53c700 should be changed to reflect this?


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

