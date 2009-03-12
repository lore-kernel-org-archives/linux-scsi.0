From: Matthew Wilcox <willy@linux.intel.com>
Subject: Support READ CAPACITY 16 on more drives
Date: Thu, 12 Mar 2009 14:20:28 -0400
Message-ID: <1236882030-27964-1-git-send-email-willy@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ottawa-hs-206-191-39-47.d-ip.magma.ca ([206.191.39.47]:38382
	"EHLO gonzo.int.wil.cx" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756469AbZCLSa7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Mar 2009 14:30:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

We need to use READ CAPACITY 16 to determine features like 4k physical
sector size, and support for UNMAP.  This pair of patches let us try it
on really recent SCSI drives and all LibATA drives (where it's emulated
by libata so we know they support it).  It will not be tried on USB
devices, as the USB layer overrides their claims of support for recent
SCSI versions.

