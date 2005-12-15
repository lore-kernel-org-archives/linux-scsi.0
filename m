From: James.Smart@Emulex.Com
Subject: RE: [patch 6/6] statistics infrastructure - exploitation: zfcp
Date: Thu, 15 Dec 2005 10:27:47 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7BA6@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:60044 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750767AbVLOP2I convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Dec 2005 10:28:08 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mp3@de.ibm.com, arjan@infradead.org
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org, hch@infradead.org

This patch is right along the lines of what we did with this earlier patch
http://marc.theaimsgroup.com/?l=linux-scsi&m=110700743207792&w=2
which adds, at the sdev level, counters for # of requests performed,
# of requests completed, # of requests completed in error.

of all the stats you propose:
>>+	struct statistic		*stat_sizes_scsi_write;
>>+	struct statistic		*stat_sizes_scsi_read;
>>+	struct statistic		*stat_sizes_scsi_nodata;
>>+	struct statistic		*stat_sizes_scsi_nofit;
>>+	struct statistic		*stat_sizes_scsi_nomem;
>>+	struct statistic		*stat_sizes_timedout_write;
>>+	struct statistic		*stat_sizes_timedout_read;
>>+	struct statistic		*stat_sizes_timedout_nodata;
>>+	struct statistic		*stat_latencies_scsi_write;
>>+	struct statistic		*stat_latencies_scsi_read;
>>+	struct statistic		*stat_latencies_scsi_nodata;
>>+	struct statistic		*stat_pending_scsi_write;
>>+	struct statistic		*stat_pending_scsi_read;
>>+	struct statistic		*stat_erp;
>>+	struct statistic		*stat_eh_reset;

All of these are best served to be managed by the midlayer at the
sdev. Please don't make the LLDDs do the incrementing, etc - or something
that is owned by one layer, modified by another, and bounces back and forth.
The only question is the latency fields, as your statement on latency is a
good one. IMHO, the latency that matters is the latency the midlayer sees
when it calls queuecommand.  The LLDD interface is designed to not queue in
the LLDD's, and you really can't peek lower than the LLDD to know when the
i/o actually hits the wire. So - just measure at the queuecommand/scsidone level
(or up in the block request queue level).

And, if we are expanding stats from the earlier 3 things, we ought to follow
the framework the fc transport used for stats (stolen from the network world)
and create a subdirectory under the /sys/block/<>/ object that reports
the stats.

-- james s
