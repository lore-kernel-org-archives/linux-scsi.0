From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Bugs in multipath scsi in 4.3-rc2
Date: Fri, 02 Oct 2015 06:44:57 -0700
Message-ID: <1443793497.2209.10.camel@HansenPartnership.com>
References: <20150925121636.GC12540@fergus.ozlabs.ibm.com>
	 <20150925151802.GB20282@lst.de>
	 <1443202278.2188.13.camel@HansenPartnership.com>
	 <20150930151449.GC26299@lst.de> <20150930215303.GI2627@mtj.duckdns.org>
	 <1443652494.2185.57.camel@HansenPartnership.com>
	 <20151002125608.GB14899@lst.de>
	 <1443792301.2209.4.camel@HansenPartnership.com>
	 <20151002133423.GA15867@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47907 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753518AbbJBNo7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2015 09:44:59 -0400
In-Reply-To: <20151002133423.GA15867@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Tejun Heo <tj@kernel.org>, Paul Mackerras <paulus@ozlabs.org>, linux-scsi@vger.kernel.org

On Fri, 2015-10-02 at 15:34 +0200, Christoph Hellwig wrote:
> On Fri, Oct 02, 2015 at 06:25:01AM -0700, James Bottomley wrote:
> > That doesn't matter: if you modprobe alua after all devices are
> > discovered, it will attach correctly to all potential devices from the
> > alua module_init.  This means the effect is the same whether the
> > request_module is sync or async ... the object is to get the device
> > attached to alua if it is an alua device.
> 
> No, in 4.3-rc it won't.  We removed that feature.

I think I prefer restoring that to having to build in every dh module to
get them to work.  If we take your proposed fix for the sync module load
in the current scheme, any non-built in modules would never attach, so
we'd be moving towards the conclusion that *every* device handler has to
be non-modular.

Skimming the code it looks like dh should be using the driver binding
model rather than reinventing it.  That would decouple it better and
make sure binding happened regardless of when the module was loaded.

James


