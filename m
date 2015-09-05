From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 0/1] Update scsi hosts to use idr for host number mgmt
Date: Sat,  5 Sep 2015 13:44:52 -0700
Message-ID: <cover.1441412268.git.lduncan@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35957 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbbIEUpC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Sep 2015 16:45:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, hare@suse.com, jthumshirn@suse.de, JBottomley@Parallels.com, Lee Duncan <lduncan@suse.com>

This is an updated version of a patch I submitted a few days ago.

The previous versions of this patch updated the scsi hosts module
to use the ida helper routines to allocate host numbers, instead
of using a simple integer.

Based on a suggestion by Christoph Hellwig, I decided to use the
idr helper routines instead of the ida set, since the idr functions
can also associate a pointer with an index.

This patch uses idr to manage the host number index as well
as to simplify looking up a host based on that index.

No helper routines were supplied/needed since the users
of these APIs do not seem to have uniform calling sequences.

A separate patch sequence follows which will add helper routines
for the ida index functions.

Lee Duncan (1):
  Update scsi hosts to use idr for host number mgmt

 drivers/scsi/hosts.c | 59 +++++++++++++++++++++++++---------------------------
 1 file changed, 28 insertions(+), 31 deletions(-)

-- 
2.1.4

