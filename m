From: Meelis Roos <mroos@linux.ee>
Subject: Re: [PATCH] block: fix blk_queue_end_tag()
Date: Wed, 21 Dec 2011 08:36:06 +0200 (EET)
Message-ID: <alpine.SOC.1.00.1112210835010.6858@math.ut.ee>
References: <20111220233117.17757.71139.stgit@localhost6.localdomain6> <4EF17DC4.5010008@tao.ma>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:46935 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050Ab1LUGgJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Dec 2011 01:36:09 -0500
In-Reply-To: <4EF17DC4.5010008@tao.ma>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Cc: Dan Williams <dan.j.williams@intel.com>, axboe@kernel.dk, Tao Ma <boyu.mt@taobao.com>, Linux Kernel list <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Ed Nadolski <edmund.nadolski@intel.com>

> > -	if (unlikely(tag >= bqt->max_depth)) {
> > +	if (WARN_ONCE(tag >= bqt->real_max_depth,
> > +		      "%s: tag %d greater than tag map size: %d\n",
> > +		      __func__, tag, bqt->real_max_depth)) {
> >  		/*
> >  		 * This can happen after tag depth has been reduced.
> Please also change the comments here since it should never happen in the
> right workload.

What do you mean by right workload? Normal workload?

-- 
Meelis Roos (mroos@linux.ee)
