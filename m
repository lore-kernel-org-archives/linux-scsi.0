From: Jeff Garzik <jgarzik@pobox.com>
Subject: SCSI synchronization and error handling
Date: Wed, 30 Jun 2004 15:43:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40E317D9.80904@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:41862 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261682AbUF3Tnf
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jun 2004 15:43:35 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>


I'm doing some more work on my scsi LLD, libata, and have a few 
questions for the experts in the crowd.

In ATA, some commands need to be sent when no other commands are queued 
to hardware.  Let's say I have a command stream that looks like

	queued write
	queued read
	queued read
	queued write
	non-queued SMART command
	queued write
	queued write

What's the best way to ensure that the SMART command is only executed 
after preceding, queued commands are completed?  My guess is to return 
MLQUEUE_BUSY if (a) ->queuecommand is passed a non-queued command AND 
(b) there are commands queued to hardware already.



