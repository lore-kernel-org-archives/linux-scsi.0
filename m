From: Alan Stern <stern@rowland.harvard.edu>
Subject: Repeating Scsi_Cmnd serial numbers in the error-handler
Date: Wed, 30 Apr 2003 10:20:53 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0304301014310.762-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:3332 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261362AbTD3OId (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Apr 2003 10:08:33 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

While the SCSI error handler is in operation it may issue some commands on
its own behalf, in particular REQUEST-SENSE and TEST-UNIT-READY.  These
both get transmitted via scsi_send_eh_cmnd(), which does not increment the
serial number.  Consequently these commands are issued with the same
serial number as the failed command they are trying to recover from.  
This makes life difficult for drivers like usb-storage which rely on the
serial number to be a unique tag for purposes of matching up requests with
responses.

This ought to be very easy to fix, but I prefer to leave it up to someone
who knows more than I do about the details of the SCSI system.

Alan Stern

