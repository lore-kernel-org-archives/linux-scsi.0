From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 0/7] fix block timeout residue problems
Date: Sun, 30 Nov 2008 10:12:25 -0600
Message-ID: <1228061545.4115.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35348 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751118AbYK3QM0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Nov 2008 11:12:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, Jens Axboe <Jens.Axboe@oracle.com>

It looks like there was only a partial conversion of the SCSI layer to
the block timeout.  The missing piece was killing timeout in struct
scsi_device and leaving it with a zero value.  This has already resulted
in a regression:

http://bugzilla.kernel.org/show_bug.cgi?id=12120

But on closer inspection, there were lots of other dangling driver uses
of the timeout value which would likewise have introduced hard to trace
regressions.

This patch series eliminates the timeout variable from struct
scsi_device and makes everything uniformly use the block timeout.  Any
wrong use of the scsi device timeout will now result in a compile
failure.

It's getting late in the -rc series to push this through, but hopefully
it won't delay 2.6.28 too much.

James


