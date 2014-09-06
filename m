From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 21/22] scsi: reduce messages for command failure
Date: Fri, 5 Sep 2014 17:35:11 -0700
Message-ID: <20140906003511.GC18426@infradead.org>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
 <1409247216-76074-22-git-send-email-hare@suse.de>
 <20140831222840.GM16432@infradead.org>
 <94D0CD8314A33A4D9D801C0FE68B402958C2F69F@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:32999 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaIFAfP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Sep 2014 20:35:15 -0400
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958C2F69F@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Hoffmann, Elliot" <elliot.hoffmann@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>

On Mon, Sep 01, 2014 at 01:14:23AM +0000, Elliott, Robert (Server Storage) wrote:
> Before this patch set, ratelimited printing was impossible because
> there were so many partial-line printk calls.  This patch set
> may resolve that problem.
> 
> Multiple related lines may still cause problems; if it prints
> CDB, sense key, and additional sense code on three lines, you
> don't want the CDB and sense key suppressed with the additional
> sense code still sneaking out (because command completions
> are concurrent).
> 
> If those issues can be overcome, then I'd favor offering ratelimited
> calls.  Maybe the logging level could be used to select the amount,
> like:
> 	0 = no prints
> 	1..n = ratelimited versions of the prints
> 	n+1..m = not ratelimited versions of the prints

I don't think an unlimited output into the printk buffer is sensible
with the number of IOPS we get from modern devices.  If you need
detailed output you should be using the binary trace buffer.
