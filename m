From: Hannes Reinecke <hare@suse.de>
Subject: [RFC PATCH 0/3] scsi: make asynchronous aborts mandatory
Date: Tue,  4 Nov 2014 13:11:10 +0100
Message-ID: <1415103073-90276-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44689 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234AbaKDMLQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Nov 2014 07:11:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

asynchronous abort have been activated since v3.14, and we haven't
received any failure reports so far. So we should make asynchronous
aborts mandatory and remove the no_async_aborts flag from the SCSI
host structure.
With this we can also cleanup the failure path in SCSI EH.

Hannes Reinecke (3):
  scsi: make scsi_eh_scmd_add() always succeed
  scsi: make eh_eflags persistent
  scsi: make asynchronous aborts mandatory

 Documentation/scsi/scsi_eh.txt |  31 +++++------
 drivers/scsi/scsi_error.c      | 113 +++++++----------------------------------
 drivers/scsi/scsi_lib.c        |   4 +-
 drivers/scsi/scsi_priv.h       |   3 +-
 include/scsi/scsi_eh.h         |   1 +
 include/scsi/scsi_host.h       |   5 --
 6 files changed, 34 insertions(+), 123 deletions(-)

-- 
1.8.5.2

