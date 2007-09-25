From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [GIT PATCH] SCSI bug fix for 2.6.23-rc8
Date: Tue, 25 Sep 2007 12:55:24 -0500
Message-ID: <1190742924.3345.42.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:34973 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751507AbXIYRz1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 13:55:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is, unfortunately, not a recent regression but it's only been
recently diagnosed.  Apparently the SCSI Parallel transport class domain
validation cable width detection wasn't working, leading to cases where
controllers with damaged cables would end up hanging the system (the
reported one was an aic79xx controller, but the potential is there for
all SPI based systems).  This bug would *only* affect systems whose
cable integrity or connectors were compromised, so it isn't life
threatening to every SCSI Parallel installation, but the consequence of
running into it is a system hang.

The fix is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

James Bottomley (1):
      scsi_transport_spi: fix domain validation failure from incorrect
width setting

And the diffstat:

 scsi_transport_spi.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

James



