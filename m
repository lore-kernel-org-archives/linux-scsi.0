From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/17] scsi_dh_alua: Use workqueue for RTPG
Date: Tue, 12 May 2015 10:16:59 +0200
Message-ID: <20150512081659.GB27168@lst.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-15-git-send-email-hare@suse.de> <20150511134914.GA7795@lst.de> <5550B5B4.4070605@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44149 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932126AbbELIRB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 May 2015 04:17:01 -0400
Content-Disposition: inline
In-Reply-To: <5550B5B4.4070605@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

So how about the following idea for GTPG and STPG handling:

 - we keep a single thread workqueue, but per target group instead
   of global to avoid concurrency issues hitting us too badly, after
   all workqueues are cheap these days.
 - GTPG keeps the per-group work_item, but instead of the separate
   lsit for STPG we just add the work item to the alua_queue_data
   structure, which at the point might also get a new name relecting
   the use a bit better.  STPG remains synchronous.

Btw, any chance to also publish a git tree to make reviewing easier?
