From: Muthu Kumar <muthu.lkml@gmail.com>
Subject: [RFC] SCSI: drivers: Remove unnecessary assignment of scsi_done in
 driver queuecommand
Date: Sun, 8 Jul 2012 16:35:03 -0700
Message-ID: <CAFR8uecYu3PjJceHprk8ZNx7GLp7gFLQM0coKPhnjLvYDWAS8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:33871 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab2GHXfF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Jul 2012 19:35:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jej B <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>

[ CCing signed-off, acked-by of original patch - let me know if anyone
else needs to be added ]

Jeff, James,

In the following commit:
----------
commit f281233d3eba15fb225d21ae2e228fd4553d824a
Author: Jeff Garzik <jeff@garzik.org>
Date:   Tue Nov 16 02:10:29 2010 -0500

    SCSI host lock push-down
---------

queuecommand syntax is changed to no longer passing done() routine as
parameter. Instead, in scsi_dispatch_command and scsi_send_eh_cmnd,
scsi_cmd->scsi_done is set to done() before calling the driver
specific queuecommand.
But all the drivers queuecommand routines still do the redundant assignment:

scsi_cmd->scsi_done = done

For example:

cciss_scsi_queue_command_lck():
..
cmd->scsi_done = done;    // save this for use by completion code
..

How about removing all such redundant assignments?

Regards,
Muthu
