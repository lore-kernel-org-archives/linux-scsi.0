From: Nishanth Aravamudan <nacc@us.ibm.com>
Subject: no set_current_state() before schedule_timeout() (scsi_lib)
Date: Tue, 13 Jul 2004 17:45:44 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40F41FC8.5070705@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:51878 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265689AbUGMRp4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jul 2004 13:45:56 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kernel-janitors@lists.osdl.org

Hi,

In continuing to replace, where appropriate, code with msleep() calls, I 
ran across the following file(s) / function(s), which do not invoke 
set_current_state() before schedule_timeout(), which causes the latter 
to return immediately:

drivers/scsi/scsi_lib.c::scsi_device_quiesce()

If someone could tell me which state (TASK_INTERRUPTIBLE or 
TASK_UNINTERRUPTIBLE) is desired, I can fix this and perhaps replace the 
calls with msleep().

Thanks,
Nish
