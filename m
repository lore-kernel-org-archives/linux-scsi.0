From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Bugs in multipath scsi in 4.3-rc2
Date: Fri, 02 Oct 2015 06:25:01 -0700
Message-ID: <1443792301.2209.4.camel@HansenPartnership.com>
References: <20150925121636.GC12540@fergus.ozlabs.ibm.com>
	 <20150925151802.GB20282@lst.de>
	 <1443202278.2188.13.camel@HansenPartnership.com>
	 <20150930151449.GC26299@lst.de> <20150930215303.GI2627@mtj.duckdns.org>
	 <1443652494.2185.57.camel@HansenPartnership.com>
	 <20151002125608.GB14899@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47804 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751919AbbJBNZF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2015 09:25:05 -0400
In-Reply-To: <20151002125608.GB14899@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Tejun Heo <tj@kernel.org>, Paul Mackerras <paulus@ozlabs.org>, linux-scsi@vger.kernel.org

On Fri, 2015-10-02 at 14:56 +0200, Christoph Hellwig wrote:
> On Wed, Sep 30, 2015 at 03:34:54PM -0700, James Bottomley wrote:
> > Perhaps we don't have to be that draconian.  There's no real reason we
> > can't autoload asynchronously.  If the module isn't ready by the time we
> > come to check the attachment, then it will attach to the device later
> > when the module init routine runs.
> 
> I don't think this works.  We're attaching just after the request_module
> call, so modprobe doesn't really have a chance to finish before we
> return.

Yes, I suspect it will mostly happen in the alua attach, except for
large LUN sets.

> > Should we do anything to limit the module_request floods?  This will
> > likely happen for every LUN of an ALUA system ... there can be hundreds
> > of those.
> 
> Once the alua module is loaded there won't be any request_module calls.
> If you build with device handler support but without ALUA support
> you'll get a lot of calls, but that's not any different than probing
> for other optional features.

That doesn't matter: if you modprobe alua after all devices are
discovered, it will attach correctly to all potential devices from the
alua module_init.  This means the effect is the same whether the
request_module is sync or async ... the object is to get the device
attached to alua if it is an alua device.

The only drawback of an async request_module is that we get a flood of
request_modules()s from every LUN on an array until alua is loaded.

> Personally I think we probably should simple build ALUA support into
> scsi_mod if SCSI_DH is selected, as that's part of the standard and
> supported by any modern multi pathing device.

I suppose; the code size is roughly the same as scsi_dh.o which we just
made non modular.

James



