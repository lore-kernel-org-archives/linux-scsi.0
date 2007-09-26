From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: queued patches for SCSI for 2.6.24
Date: Wed, 26 Sep 2007 11:12:42 +0900
Message-ID: <20070925073735U.tomof@acm.org>
References: <1190768402.8707.20.camel@localhost.localdomain>
	<20070925065233Q.tomof@acm.org>
	<1190770955.8707.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:55361 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949AbXIZCMy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Sep 2007 22:12:54 -0400
In-Reply-To: <1190770955.8707.23.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: tomof@acm.org, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Tue, 25 Sep 2007 20:42:35 -0500
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Wed, 2007-09-26 at 10:28 +0900, FUJITA Tomonori wrote:
> > On Tue, 25 Sep 2007 20:00:02 -0500
> > James Bottomley <James.Bottomley@SteelEye.com> wrote:
> > 
> > > Andrew asked that I provide a status report of pending updates.  The
> > > list is attached below.  It's pretty much driver updates and minor bug
> > > fixes.  The main functionality changes are Kay's sysfs updates and the
> > > shift of the ULD attachement towards the block prep function.
> > 
> > Can we make new 'supporrted_mode' and 'active_mode' attributes look
> > better?
> > 
> > http://marc.info/?l=linux-scsi&m=118991196128245&w=2
> 
> Sure, but Jeff's suggestion was a good one to avoid me having to change
> hundreds of files.  Could you roll it up and resubmit?

This can be cleanly applied to scsi-misc.

-
From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH] set supported_mode to MODE_INITIATOR by default

This sets supported_mode to MODE_INITIATOR if a lld doesn't specify
supported_mode in scsi_host_template.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/hosts.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index adc9559..694015d 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -342,6 +342,10 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
 	shost->use_clustering = sht->use_clustering;
 	shost->ordered_tag = sht->ordered_tag;
+
+	if (!sht->supported_mode)
+		sht->supported_mode = MODE_INITIATOR;
+
 	shost->active_mode = sht->supported_mode;
 
 	if (sht->max_host_blocked)
-- 
1.5.2.4

