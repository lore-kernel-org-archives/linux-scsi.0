From: Nishanth Aravamudan <nacc@us.ibm.com>
Subject: no set_current_state() before schedule_timeout() (53C700)
Date: Tue, 13 Jul 2004 17:34:02 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40F41D0A.4050109@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:53161 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S265502AbUGMReR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jul 2004 13:34:17 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, kernel-janitors@lists.osdl.org

Hi,

In continuing to replace, where appropriate, code with msleep() calls, I 
ran across the following file(s) / function(s), which do not invoke 
set_current_state() before schedule_timeout(), which causes the latter 
to return immediately:

drivers/scsi/53c700.c::NCR_700_bus_reset()

If someone could tell me which state (TASK_INTERRUPTIBLE or 
TASK_UNINTERRUPTIBLE) is desired, I can fix this and perhaps replace the 
calls with msleep().

Thanks,
Nish
