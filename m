From: Mark Goodwin <mgoodwin@redhat.com>
Subject: Re: [PATCH RFC] Reduce amount of TURs sent in error recovery
Date: Mon, 11 Apr 2011 10:52:23 +1000
Message-ID: <4DA250C7.60904@redhat.com>
References: <4D80F6D0.1010404@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab1DKAw1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Apr 2011 20:52:27 -0400
In-Reply-To: <4D80F6D0.1010404@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Jeffery <dhjeffery@gmail.com>
Cc: linux-scsi@vger.kernel.org

On 03/17/2011 04:43 AM, David Jeffery wrote:
> In error recovery, most scsi error recovery stages will send a TUR command
> for every bad command when a driver's error handler reports success.  When
> several bad commands to the same device, this results in a device
> being probed multiple times.
>
> This becomes very problematic if the device or connection is in a state
> where the device still doesn't respond to commands even after a recovery
> function returns success.  The error handler must wait for the test
> commands to time out.  The time waiting for the redundant commands can
> drastically lengthen error recovery.
>
> This patch alters the scsi mid-layer's error routines to send test commands
> once per device instead of once per bad command.  This can drastically
> lower error recovery time.
>

Looks good to me - it should also make recovery times far more predictable,
which is something a lot of sites currently struggle with because it depends
on the workload (number of queued commands at the time of the failure).
With this patch, those sites will need to re-tune their timeouts, right?

Has this been tested on real FC h/w yet, or just with scsi_debug?
We have a patch to make testing easier: it adds a new sd state 'zombie',
which stops a particular device/path from queueing any commands,
basically as follows (not the whole patch, just the gist of it) :

--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -554,7 +554,10 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
                 cmd->result = (DID_NO_CONNECT << 16);
                 scsi_done(cmd);
         } else {
-               rtn = host->hostt->queuecommand(cmd, scsi_done);
+               if (cmd->device->sdev_state == SDEV_ZOMBIE)
+                       rtn = 0; /* will timeout so err handler will run */
+               else
+                       rtn = host->hostt->queuecommand(cmd, scsi_done);
         }

Would we want to consider adding this to the patch set too? It will allow
affected sites to more easily tune their timeouts and redundancy config
(i.e. echo zombie > /sys/block/sdX/device/state to simulate a failure).

Cheers
-- Mark Goodwin
