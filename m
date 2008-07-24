From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Regression fix: Generalise last_sector_bug to avoid breaking more
 buggy devices
Date: Thu, 24 Jul 2008 11:15:00 +0100
Message-ID: <48885624.3020605@tuffmail.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:18921 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbYGXKOm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jul 2008 06:14:42 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1040749nfc.21
        for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2008 03:14:41 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>

You may remember the unfortunately named "last_sector_bug" workaround. 
It was applied to the SCSI SD driver to handle certain USB cardreaders. 
Unfortunately it introduced a regression by breaking certain other buggy
USB cardreaders.

I ended up driving this fix, as the sucker who bought the second lot of
buggy hardware.  Alan Stern from USB-land said that he's happy to see
this patch merged (after fixing my logic and critiquing the patch
description).  I'm grateful for his help and everyone else who chimed in
on the usb-storage mailing list.

The patch description goes into detail.  Here's a less formal description -


The original bug causes multi-sector accesses which include the last
sector of the device to fail.  The workaround was to split such accesses
in two, so that the last sector is accessed on it's own.  The overhead
is minimal and so it was applied to all USB storage devices.

Perversely, this revealed a second bug in a different set of card
readers.  This time, failure is caused by multi-sector accesses which
stop just short of the last sector.

This suggests a systemic failure in the design/testing of USB
cardreaders, where multi-sector accesses to the last sectors are
overlooked, and fencepost errors may be common.  What follows is a
general workaround to prevent multi-sector accesses touching any of the
last 8 hardware sectors.

Thanks
Alan
