From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Block timeouts seem not to be working
Date: Thu, 11 Sep 2008 10:05:21 -0500
Message-ID: <1221145521.3330.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40762 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755530AbYIKPFY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Sep 2008 11:05:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <Jens.Axboe@oracle.com>, Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

I just noticed this with a rather finickey SAS system I have.  It's got
a SATA DVD attached over an expander.  Periodically the DVD just hangs
up, so we wait for the timeout and then send a phy reset which clears
it.

What I'm seeing with the new block timer code is that the timer never
expires.  I can dig some more into this, but if you wanted to test it as
well, the timer code is easy to excite.  Just throw away one command in
every 128 or so in the queuecommand routine of your favourite HBA
driver.

James


