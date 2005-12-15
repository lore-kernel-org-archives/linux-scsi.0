From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch 6/6] statistics infrastructure - exploitation: zfcp
Date: Thu, 15 Dec 2005 08:37:08 +0100
Message-ID: <1134632229.16486.3.camel@laptopd505.fenrus.org>
References: <43A044E6.7060403@de.ibm.com>
	 <20051214165900.GA26580@infradead.org>  <43A0E8E7.1060706@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:59349 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S965162AbVLOHhM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Dec 2005 02:37:12 -0500
In-Reply-To: <43A0E8E7.1060706@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke <mp3@de.ibm.com>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On Thu, 2005-12-15 at 04:54 +0100, Martin Peschke wrote:
> Christoph Hellwig wrote:
> 
> >>+	atomic_t		read_num;
> >>+	atomic_t		write_num;
> >>+	struct statistic_interface	*stat_if;
> >>+	struct statistic		*stat_sizes_scsi_write;
> >>+	struct statistic		*stat_sizes_scsi_read;
> >>+	struct statistic		*stat_sizes_scsi_nodata;
> >>+	struct statistic		*stat_sizes_scsi_nofit;
> >>+	struct statistic		*stat_sizes_scsi_nomem;
> >>+	struct statistic		*stat_sizes_timedout_write;
> >>+	struct statistic		*stat_sizes_timedout_read;
> >>+	struct statistic		*stat_sizes_timedout_nodata;
> >>+	struct statistic		*stat_latencies_scsi_write;
> >>+	struct statistic		*stat_latencies_scsi_read;
> >>+	struct statistic		*stat_latencies_scsi_nodata;
> >>+	struct statistic		*stat_pending_scsi_write;
> >>+	struct statistic		*stat_pending_scsi_read;
> >>+	struct statistic		*stat_erp;
> >>+	struct statistic		*stat_eh_reset;
> >>    
> >>
> >
> >NACK.  pretty much all of this is generic and doesn't belong into an LLDD.
> >We already had this statistics things with emulex and they added various
> >bits to the core in response.
> >
> >
> >  
> >
> Agreed. It's not necessarily up to LLDDs to keep track of request sizes, 
> request latencies, I/O queue utilization, and error recovery conditions 
> by means of statistics. This could or maybe should be done in a more 
> central spot.
> 
> With regard to latencies, it might make some difference, though, how 
> many layers are in between that cause additional delays. Then the 
> question is which latency one wants to measure.

even if the LLDD measures these, the stats belong a level up, so that
all LLDD's export the same. I think you got half of Christophs point,
but not this last bit: even when it's the LLDD that needs to measure the
stat, it still shouldn't be LLDD specific, and thus defined one if not
two layers up. 

