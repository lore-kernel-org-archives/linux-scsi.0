From: Bob Doyle <doyle@primenet.com>
Subject: BusLogic update - take 2
Date: Wed, 14 Jan 2004 22:13:39 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40062183.D31421D7@primenet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp3.roc2.gblx.net ([64.215.96.102]:2510 "EHLO
	smtp3.roc2.gblx.net") by vger.kernel.org with ESMTP id S264905AbUAOFNu
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jan 2004 00:13:50 -0500
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

This is my second pass through the BusLogic SCSI driver.  It
incorporates some comments received on the first version.

This patch is against linux-2.6.1.  It works for me but the normal
caveats apply.

Please retrieve (~150kb) from:

<http://home.globalcrossing.net/~doyle/buslogic.patch>

Deleted dead code:
- BusLogic_ReportTargetDeviceInfo()
- BusLogic_SelectQueueDepths()
- BusLogic_SendBusDeviceReset()
- BusLogic_ResetCommand()

Fixed:
- removed dependency on "scsi_obsolete.h"
  o Changes to BusLogic_ResetHostAdapter()
  o Changes to BusLogic_AbortCommand()
- removed the gratuitous typedefs per Christoph's comments
- several functions with incorrect __init and __exit sections.
- Removed vestiges of the 'Error Recovery' command line function (which
  is fundamentally incompatible with the new EH design).

Left to do:
- Test eh_abort_handler
- Test eh_host_reset_handler
- Test as module
- Straighten out FlashPoint conditional compile so it doesn't
  require #include "FlashPoint.c". 
- Please ignore the long line length and the very lengthy
  identifiers (for now).

Bob.
