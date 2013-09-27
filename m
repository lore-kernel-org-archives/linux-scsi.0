From: Vishal Annapurve <vannapurve@nvidia.com>
Subject: Fwd: [PATCH] usb-storage: scsiglue: Changing the command result
Date: Fri, 27 Sep 2013 17:07:58 +0530
Message-ID: <52456E16.7060007@nvidia.com>
References: <52441C1F.8020200@nvidia.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------080607040600090903030901"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hqemgate16.nvidia.com ([216.228.121.65]:18692 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab3I0LiB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Sep 2013 07:38:01 -0400
In-Reply-To: <52441C1F.8020200@nvidia.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

--------------080607040600090903030901
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

There was a recent commit in mainline for the scsi devices which do not
respond properly to medium access command:

commit    18a4d0a22ed6c54b67af7718c305cd010f09ddf8

[SCSI] Handle disk devices which can not process medium access commands
We have experienced several devices which fail in a fashion we do not
currently handle gracefully in SCSI. After a failure these devices will
respond to the SCSI primary command set (INQUIRY, TEST UNIT READY, etc.)
but any command accessing the storage medium will time out.

I came across a USB drive which showed similar problem and what I see is
usb storage is still not able to cope with such devices properly.

The control flow downwards is like:
scsi_times_out --> Setting cmd->result as DID_TIME_OUT
scsi_error_handler
scsi_unjam_host
scsi_eh_abort_cmds
command_abort    (sets US_FLIDX_TIMED_OUT for us->dflags
                                    calls stop_transport,
                                    and waits for)    usb_stor_control_thread (which is waiting for
                                                                     transport call to return inside
                                                                     usb_stor_invoke_transport)
                                                                     both usb_stor_control_thread and
                                                                     usb_stor_invoke_transport
                                                      check for us->dflags timed_out bit and
                                                       set the result as DID_ABORT
                                                       and signal completion for command_abort
                                                       to complete
......
sd_eh_action
checks for cmd->result and finds out that it's DID_ABORT rather than
DID_TIME_OUT.

This patch updates the command result to be TIME_OUT explicitly before
returning from command_abort in scsiglue.c.

I would like to know if this patch can work out for such USB Storage
devices? What would be the better way to do the same?


Regards,
Vishal Annapurve


-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------

--------------080607040600090903030901
Content-Type: text/x-patch;
	name="usb_storage_scsi_medium_access_timeout.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="usb_storage_scsi_medium_access_timeout.patch"

From: Vishal Annapurve <vannapurve@nvidia.com>
Subject: [PATCH] usb-storage: Changing the command result

This change updates the returned result to scsi layer to use
DID_TIMEOUT flag as a result status rather than DID_ABORT for
commands aborted due to timeout.

Signed-off-by: Vishal Annapurve <vannapurve@nvidia.com>
---
 drivers/usb/storage/scsiglue.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index a74e9d8..e7b532e 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -353,6 +353,15 @@ static int command_abort(struct scsi_cmnd *srb)
 
 	/* Wait for the aborted command to finish */
 	wait_for_completion(&us->notify);
+	/* Given that this bit would be only set in case of timedout
+	 * command, we can return with DID_TIME_OUT, as scsi layer needs
+	 * to use this result rather than DID_ABORT.
+	 * This is a WR to avoid removing DID_ABORT altogether
+	 * and before the final control goes to scsi layer change the
+	 * result to be timedout.
+	 */
+	us->srb->result = DID_TIME_OUT << 16;
+
 	return SUCCESS;
 }
 
-- 
1.8.4




--------------080607040600090903030901--
