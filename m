From: Christoph Hellwig <hch@lst.de>
Subject: Re: Bugs in multipath scsi in 4.3-rc2
Date: Sun, 4 Oct 2015 09:45:56 +0200
Message-ID: <20151004074556.GA13932@lst.de>
References: <20150925121636.GC12540@fergus.ozlabs.ibm.com> <20150925151802.GB20282@lst.de> <1443202278.2188.13.camel@HansenPartnership.com> <20150930151449.GC26299@lst.de> <20150930215303.GI2627@mtj.duckdns.org> <1443652494.2185.57.camel@HansenPartnership.com> <20151002125608.GB14899@lst.de> <1443792301.2209.4.camel@HansenPartnership.com> <20151002133423.GA15867@lst.de> <1443793497.2209.10.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49802 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbbJDHp7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Oct 2015 03:45:59 -0400
Content-Disposition: inline
In-Reply-To: <1443793497.2209.10.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Paul Mackerras <paulus@ozlabs.org>, linux-scsi@vger.kernel.org

On Fri, Oct 02, 2015 at 06:44:57AM -0700, James Bottomley wrote:
> I think I prefer restoring that to having to build in every dh module to
> get them to work.  If we take your proposed fix for the sync module load
> in the current scheme, any non-built in modules would never attach, so
> we'd be moving towards the conclusion that *every* device handler has to
> be non-modular.

You don't need to build every module in to make it work.  In 4.2 and earlier
we already only auto load modules when dm-multipath explicitly attaches
to them.  That will still work in 4.3+.  In fact we will now autoload
when activating through sysfs as well.  With the change I sent to Paul
we still won't autoload at scan time, which would be really useful to have,
but wasn't implemented previously.

> Skimming the code it looks like dh should be using the driver binding
> model rather than reinventing it.  That would decouple it better and
> make sure binding happened regardless of when the module was loaded.

I tried this early on but gave up because I ran into too many problems.
I can try to give it a spin again.
