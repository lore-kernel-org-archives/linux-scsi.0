From: Nishanth Aravamudan <nacc@us.ibm.com>
Subject: no set_current_state() before schedule_timeout() (OSST)
Date: Tue, 13 Jul 2004 17:40:54 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40F41EA6.9000900@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:63135 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265682AbUGMRle (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jul 2004 13:41:34 -0400
List-Id: linux-scsi@vger.kernel.org
To: osst@riede.org
Cc: osst@linux1.onstream.nl, linux-scsi@vger.kernel.org, kernel-janitors@lists.osdl.org

Hi,

In continuing to replace, where appropriate, code with msleep() calls, I 
ran across the following file(s) / function(s), which do not invoke 
set_current_state() before schedule_timeout(), which causes the latter 
to return immediately:

drivers/scsi/osst.c::osst_reposition_and_retry()

If someone could tell me which state (TASK_INTERRUPTIBLE or 
TASK_UNINTERRUPTIBLE) is desired, I can fix this and perhaps replace the 
calls with msleep().

Thanks,
Nish
