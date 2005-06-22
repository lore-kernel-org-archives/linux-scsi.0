From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/5] scsi host / scsi target state model update
Date: Wed, 22 Jun 2005 17:03:59 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0506221657200.5325-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:9384 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S262302AbVFVVEF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jun 2005 17:04:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Mike:

In your first patch, you don't allow transitions from SHOST_RECOVERY to 
SHOST_CANCEL nor the other way around.  So this section of the patch looks 
suspicious:

@@ -60,12 +136,11 @@ static void scsi_host_cancel(struct Scsi
 {
        struct scsi_device *sdev;
 
-       set_bit(SHOST_CANCEL, &shost->shost_state);
+       scsi_host_set_state(shost, SHOST_CANCEL);
        shost_for_each_device(sdev, shost) {
                scsi_device_cancel(sdev, recovery);
        }
-       wait_event(shost->host_wait, (!test_bit(SHOST_RECOVERY,
-                                               &shost->shost_state)));
+       wait_event(shost->host_wait, (shost->shost_state != SHOST_RECOVERY));
 }


In fact there are lots of places in the patch where scsi_host_set_state 
is called and the return value is not checked.  They may end up causing 
trouble.

Also, is it a good idea to allow write access to the shost_state 
attribute?  For debugging, yes, okay, but in general it doesn't seem like 
a good thing.

Alan Stern

