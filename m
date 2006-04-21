From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH] dc395x: dynamically map scatter-gather for PIO (take 2)
Date: Fri, 21 Apr 2006 15:04:23 -0700
Message-ID: <20060421150423.1416908a.rdunlap@xenotime.net>
References: <Pine.LNX.4.60.0604022004520.17410@poirot.grange>
	<20060413132932.31871824.rdunlap@xenotime.net>
	<Pine.LNX.4.60.0604132256490.4711@poirot.grange>
	<20060419172733.d61e3365.rdunlap@xenotime.net>
	<Pine.LNX.4.60.0604212341260.3237@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:5608 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1751364AbWDUWB6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Apr 2006 18:01:58 -0400
Received: from midway.site ([71.111.157.99]) by xenotime.net for <linux-scsi@vger.kernel.org>; Fri, 21 Apr 2006 15:01:56 -0700
In-Reply-To: <Pine.LNX.4.60.0604212341260.3237@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, Sebastian@schnapsleichen.de, roubert@df.lth.se, lenehan@twibble.org

On Fri, 21 Apr 2006 23:42:43 +0200 (CEST) Guennadi Liakhovetski wrote:

> On Wed, 19 Apr 2006, Randy.Dunlap wrote:
> 
> > I have a patch that seems to work for the data-in phase of the
> > aha152x (_cs) driver.  However, the data-out phase is causing
> > data corruption.  (I'm only using it on a test target, so no big
> > deal.)
> 
> Could you provide some detail? Your current patch? Maybe try to debug the 
> data corruption if it is reproducible / predictable?

I think I see the problem.  If the data-out phase terminates early
(due to some chip interrupt), the driver (datao_end) needs to set
the sg, residual, etc., fields to cause another data-out phase
at the correct buffer address, but my modifications don't quite
maintain that buffer address, residual, etc., so that datao_end
can back up to them.  I hope to have a fix for that soon.

My current (ugly, debug) patch is at
  http://www.xenotime.net/linux/patches/aha152x-sg-pio.patch 

---
~Randy
