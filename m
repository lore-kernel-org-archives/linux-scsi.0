From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Need help with another aic94xx sequencer problem
Date: Tue, 22 Aug 2006 15:28:39 -0500
Message-ID: <1156278519.19615.31.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([64.109.89.108]:35465 "EHLO
	accolon.hansenpartnership.com") by vger.kernel.org with ESMTP
	id S932097AbWHVU2n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Aug 2006 16:28:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Tarte, Robert" <Robert_Tarte@adaptec.com>, "Hammer, Jack" <Jack_Hammer@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

While abusing my sas topology (to try to get it to give me errors) I
came across this one with STP tasks:

When the aic94xx loses a task in sas_execute_tasks(), the timeout fires
and wakes the waiter (this leaves the task set pending and aborted).  In
response, sas_execute_task() tries to call lldd_abort_task()
(asd_abort_task()) on it.  Here we panic failing the BUG_ON(!list_empty)
check in aic94xx_hwi.h:asd_ascb_free().

What happens is that the abort comes back with TF_TMF_NO_CTX + 0xFF00
from the sequencer, which asd_abort_task() treats as success and then
panics because the original task is still active.

Either the abort function or the sequencer code is clearly wrong, but
not having access to the sequencer to look, I can't tell.  What should 
this return mean from the sequencer?  My suspicion is that it means the
STP task abort isn't actually formulated properly.

James


