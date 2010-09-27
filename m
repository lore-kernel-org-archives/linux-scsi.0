From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: I/O topology fixes for big physical block size
Date: Mon, 27 Sep 2010 12:41:02 -0400
Message-ID: <1285605664-27027-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:62076 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759829Ab0I0Qlw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2010 12:41:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jaxboe@fusionio.com, James.Bottomley@hansenpartnership.com, snitzer@redhat.com, linux-scsi@vger.kernel.org

Mike Snitzer reported that he has access to a device that supports thin
provisioning but does not use the Block Limits VPD page to indicate
discard granularity. Instead it reports a huge (1MB) physical block
size. That caused a bit of fallout in the topology stack which assumed a
physical block size of 4KiB or less.

[PATCH 1/2] block: Ensure physical block size is unsigned int
[PATCH 2/2] sd: Fix overflow with big physical blocks
