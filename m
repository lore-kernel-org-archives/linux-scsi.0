From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] scsi/sata write barrier support
Date: Fri, 28 Jan 2005 07:58:00 +0100
Message-ID: <20050128065759.GD4800@suse.de>
References: <20050127120244.GO2751@suse.de> <200501272242.j0RMgoP5016154@falcon30.maxeymade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:22957 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261488AbVA1G6D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jan 2005 01:58:03 -0500
Content-Disposition: inline
In-Reply-To: <200501272242.j0RMgoP5016154@falcon30.maxeymade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Maxey <dwm@maxeymade.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org

On Thu, Jan 27 2005, Doug Maxey wrote:
> 
> On Thu, 27 Jan 2005 13:02:48 +0100, Jens Axboe wrote:
> >Hi,
> >
> >For the longest time, only the old PATA drivers supported barrier writes
> >with journalled file systems. This patch adds support for the same type
> >of cache flushing barriers that PATA uses for SCSI, to be utilized with
> >libata. 
> 
> What, if any mechanism supports changing the underlying write cache?  
> 
> That is, assuming this is common across PATA and SCSI drives, and it is 
> possible to turn the cache off on the IDE drives, would switching the 
> cache underneath require completing the inflight IO?

Not sure what you mean, switching it off while the io is in flight? You
cannot do that, either the cache state will change right before starting
the io or right after. The cache state at the start of the barrier write
will determine the action taken.

-- 
Jens Axboe

