From: Brian King <brking@us.ibm.com>
Subject: Calling scsi_deactivate_tcq with active tags
Date: Tue, 27 Jul 2004 17:46:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4106DB5C.6000607@us.ibm.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:10425 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266687AbUG0Wq7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jul 2004 18:46:59 -0400
Received: from northrelay02.pok.ibm.com (northrelay02.pok.ibm.com [9.56.224.150])
	by e5.ny.us.ibm.com (8.12.10/8.12.9) with ESMTP id i6RMkrjw548538
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jul 2004 18:46:53 -0400
Received: from us.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by northrelay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i6RMm4OK129602
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jul 2004 18:48:04 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm in the process of adding the proper 
scsi_activate_tcq/scsi_deactivate_tcq to the ipr driver and ran into a 
problem. There doesn't seem to be any way to safely call 
scsi_deactivate_tcq at runtime. I keep hitting the BUG(bqt->busy) check 
in blk_queue_free_tags. Is there a way for a LLD to be able to call this 
at runtime to a device that is being used? I tried doing a 
scsi_device_quiesce/scsi_device_resume around the scsi_deactivate_tcq 
call, but I still hit the problem.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

