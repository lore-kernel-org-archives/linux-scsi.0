From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [patchset 0/5] Refactoring scsi_error to facilitate in synchronous
 REQUEST_SENSE
Date: Mon, 10 Sep 2007 17:11:23 +0300
Message-ID: <46E5508B.7030108@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:16352 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756985AbXIJOMX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Sep 2007 10:12:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Greg
Cc: Christoph Hellwig <hch@infradead.org>


In motivation to abstract scsi_cmnd members and insulate
drivers/transports from scsi_cmnd internals. The last
place left was the REQUEST_SENSE sequence when done
synchronous, by drivers.

Also all these drivers would do a use_sg==0 command
invocation, preventing from doing cleanups on these
drivers/transports. So this patchset is left-overs
from Christoph's 2.6.18 cleanups.

In this patchset I have re-factored scsi_error to
make it possible for drivers to use an abstract
(easy to use, I hope) API for invoking a REQUEST_SENSE
command. The API is declared in scsi/scsi_eh.h

[patch 1/5] scsi_error: code cleanup before refactoring of scsi_send_eh_cmnd()
  Move some code around and add new fixtures here. So next patch is
  left a Mechanical breakup of code.

[patch 2/5] scsi_error: Refactoring scsi_error to facilitate in synchronous REQUEST_SENSE
  Here new API is introduced in scsi/scsi_eh.h and mechanical move of code
  to the new functions.

[PATCH 3/5] usb: transport.c use scsi_eh API in REQUEST_SENSE execution
  Use above API for drivers/usb/storage/transport.c. Now that last
  User of use_sg==0, we can do the USB storage cleanups.

[PATCH 4/5] NCR5380: Use scsi_eh API for REQUEST_SENSE invocation
  All NCR5380 family of drivers used to send a REQUEST_SENSE
  command.

[PATCH 5/5] arm: fas216 Use scsi_eh API for REQUEST_SENSE invocation
	drivers/scsi/arm/fas216.c need change also.

Please Test as much as possible, and report any problems/differences.

Boaz Harrosh
 
