From: Hannes Reinecke <hare@suse.de>
Subject: [RFC PATCH 0/4] libfc: Do not send ABTS when resetting exchanges
Date: Fri,  5 Aug 2016 14:54:59 +0200
Message-ID: <1470401703-87045-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45357 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759674AbcHEMzR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Aug 2016 08:55:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

here's a patchset to fixup an issue reported by QLogic: when running
against a certain target the libfc stack would get in an infinite loop
sending ABTS when trying to reset a connection.
The problem is that the libfc stack is sending ABTS for any open exchanges
when removing an rport, totally ignorant of the fact that in most cases
we are already logged out of the said remote port.
This patchset alters the handling slightly so that we will only ever reset
open exchanges after we have either logged out of the port or an implicit
logout can be assumed.
With that we don't need to send ABTS any more during rport reset.

As usual, comments and reviews are welcome.

Hannes Reinecke (4):
  libfc: Issue PRLI after a PRLO has been received
  libfc: send LOGO for PLOGI failure
  libfc: reset exchange manager during LOGO handling
  libfc: do not send ABTS when resetting exchanges

 drivers/scsi/libfc/fc_exch.c  |  1 -
 drivers/scsi/libfc/fc_rport.c | 26 +++++++++++++++++++++++---
 2 files changed, 23 insertions(+), 4 deletions(-)

-- 
1.8.5.6

