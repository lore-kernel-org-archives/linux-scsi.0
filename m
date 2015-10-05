From: Lee Duncan <lduncan@suse.com>
Subject: [PATCHv2 0/1] Update SCSI hosts to use idr for host number mgmt
Date: Mon,  5 Oct 2015 16:01:10 -0700
Message-ID: <cover.1444085255.git.lduncan@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36101 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbbJEXBW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Oct 2015 19:01:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Lee Duncan <lduncan@suse.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>

This patch updates the SCSI hosts module to use the idr
index-management routines to manage its host_no index instead
of using an ATOMIC integer. This means that host numbers
can now be reclaimed and re-used.

It also updates the hosts module to use the idr routine idr_find()
to lookup hosts based on the host number, hopefully speeding
up said lookup.

After noticing that my idr calling sequences where very close
to those in other modules, I considered creating some idr helper
functions (and using them), but because idr usage almost always
requires the caller to manage their own locks, I gave up on
this approach (as suggested by Tejon -- thank you).

Lee Duncan (1):
  SCSI: update hosts module to use idr index management

 drivers/scsi/hosts.c | 60 +++++++++++++++++++++++++---------------------------
 1 file changed, 29 insertions(+), 31 deletions(-)

-- 
2.1.4

