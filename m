From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/2] scsi command timeout fixes
Date: Fri, 13 Jun 2014 14:01:44 +0200
Message-ID: <1402660906-74661-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45830 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbaFMMB5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jun 2014 08:01:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Bart vn Assche <bvanassche@acm.org>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

I've received reports claiming they're seeing a double command completion
occasionally when a command timeout happens.

Delving into it I found this this indeed might happening; reason being
that the LLDD will only be informed about a timed-out command by
calling scsi_try_to_abort_command(). Anytime before that the LLDD
is free to assume the command is valid and might call scsi_done() on it.
Which then will lead to interesting issues in the error handler.

And while debugging this I've found we're setting DID_TIME_OUT incorrectly,
which might lead to spurious command timeout detection.

Hannes Reinecke (2):
  scsi_error: set DID_TIME_OUT correctly
  scsi: Do not complete timed-out command

 drivers/scsi/scsi.c       |  2 ++
 drivers/scsi/scsi_error.c | 16 +++++++++-------
 drivers/scsi/scsi_priv.h  |  1 +
 3 files changed, 12 insertions(+), 7 deletions(-)

-- 
1.7.12.4

