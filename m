From: Mark Mokryn <markm@il.marvell.com>
Subject: Problem in SCSI error handling 2.4/2.6
Date: Thu, 13 May 2004 11:21:42 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40A33016.7010805@il.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shosh.galileo.co.il ([199.203.130.250]:47015 "EHLO
	il.marvell.com") by vger.kernel.org with ESMTP id S263970AbUEMIWP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 May 2004 04:22:15 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, andmike@us.ibm.com, Jeff Garzik <jgarzik@pobox.com>

According to the SCSI spec, a LUN may abort all outstanding commands in 
case of an error (bit QERR set in the control mode page).
This may occur on many SCSI/FC drives or storage systems, and will 
certainly the case for SATA (libata) when dealing with NCQ or TCQ drives.

The problem is that the Linux SCSI error handler (2.4 & 2.6) identically 
handles commands failed due to MEDIUM_ERROR and ABORTED_COMMAND by 
marking both types as NEEDS_RETRY.

What we have seen in such a case is that the error handler will simply 
requeue these commands, and in most cases, the exact scenario (several 
commands requeued and then aborted due to a single medium error) will be 
repeated ad nauseum until the retry limit. The result is often that all 
of the aborted commands are needlessly failed.

The correct fix is to never retry commands failed due to medium error. 
Rest assured that when a drive returns this status, exhaustive retries 
and error correction algorithms have been applied at the drive level. No 
storage system has the incentive of returning medium error if the error 
is recoverable.

If the error handler insists on retrying such commands, then at least 
set a lower retry limit on medium errors (though I believe this is 
pointless, and may just cause more aborted commands).

In any case - setting the same retry limit on medium errors and aborted 
commands is a bug.

-Mark



