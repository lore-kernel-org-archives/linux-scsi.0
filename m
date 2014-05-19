From: Paolo Bonzini <pbonzini@redhat.com>
Subject: dangling pointers and/or reentrancy in scmd_eh_abort_handler?
Date: Mon, 19 May 2014 16:08:27 +0200
Message-ID: <537A105B.4080504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754279AbaESOId (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 May 2014 10:08:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bart Van Assche <bvanassche@acm.org>, Ulrich Obergfell <uobergfe@redhat.com>

Hi all,

I'm trying to understand asynchronous abort in the current upstream 
code, and the code seems to have some dubious locking.

Here are some examples of the issue:

1) dangling pointers: scsi_put_command calls cancel_delayed_work(), but 
that doesn't mean that the scmd_eh_abort_handler couldn't be already 
running.  If the scmd_eh_abort_handler starts while the softirq handler 
is calling scsi_put_command (e.g. scsi_finish_command -> 
scsi_io_completion -> scsi_end_request -> scsi_next_command), the 
pointer to the Scsi_Cmnd* becomes invalid in the middle of the abort 
handler.

2) reentrancy: the softirq handler and scmd_eh_abort_handler can run 
concurrently, and call scsi_finish_command without any lock protecting 
the calls.  You can then get memory corruption.



I don't have any reproducer for this; we're seeing related crashes in 
virtio-scsi EH but those are due to a bug in the driver.  But it means 
that I have no sensible way to write the eh_abort_handler.

Example (1) means that the eh_abort_handler cannot use the passed 
Scsi_Cmnd, because it might not even be valid when entering the 
eh_abort_handler.  Example (2) means that the eh_abort_handler cannot 
return SUCCESS if it detects that the command has been completed in the 
meanwhile.

Paolo
