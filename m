From: Christoph Hellwig <hch@lst.de>
Subject: Re: [patch 6/7] ps3: ROM Storage Driver
Date: Wed, 30 May 2007 12:13:49 +0200
Message-ID: <20070530101348.GD24586@lst.de>
References: <20070525083607.784351000@sonycom.com> <20070525083632.677742000@sonycom.com> <20070529104948.GC29351@lst.de> <Pine.LNX.4.62.0705291308280.7698@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:54958 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578AbXE3KO0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2007 06:14:26 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0705291308280.7698@pademelon.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Christoph Hellwig <hch@lst.de>, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, May 29, 2007 at 01:11:41PM +0200, Geert Uytterhoeven wrote:
> > This looks very inefficient.  Just set sg_tablesize of your driver
> > to 1 to avoid getting mutiple segments.
> 
> The disadvantage of setting sg_tablesize = 1 is that the driver will get small
> requests (PAGE_SIZE) most of the time, which is very bad for performance.

If you set .clustering = 1 in your host template you will frequently
get larger requests.

For any sane hypervisor or hardware the copy should be worth
than that.  Then again a sane hardware or hypervisor would support
SG requests..

