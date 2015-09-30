From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Bugs in multipath scsi in 4.3-rc2
Date: Wed, 30 Sep 2015 15:34:54 -0700
Message-ID: <1443652494.2185.57.camel@HansenPartnership.com>
References: <20150925121636.GC12540@fergus.ozlabs.ibm.com>
	 <20150925151802.GB20282@lst.de>
	 <1443202278.2188.13.camel@HansenPartnership.com>
	 <20150930151449.GC26299@lst.de> <20150930215303.GI2627@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42346 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753687AbbI3We5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Sep 2015 18:34:57 -0400
In-Reply-To: <20150930215303.GI2627@mtj.duckdns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Paul Mackerras <paulus@ozlabs.org>, linux-scsi@vger.kernel.org

On Wed, 2015-09-30 at 17:53 -0400, Tejun Heo wrote:
> Hello, Christoph.
> 
> On Wed, Sep 30, 2015 at 05:14:49PM +0200, Christoph Hellwig wrote:
> > The problem is that async probing deadlocks vs a synchronous
> > request_module, as Tejun figured out based on the thrad in
> > http://thread.gmane.org/gmane.linux.kernel/1420814
> > 
> > Tejun, if I understand the thread and your patch right there really
> > isn't any good altenative to a synchronous request_module, and you
> > thus disabled autoloading elevator modules, right?
> 
> Yeap, that's right.  IIRC, the conclusion was "let's not do that".

Perhaps we don't have to be that draconian.  There's no real reason we
can't autoload asynchronously.  If the module isn't ready by the time we
come to check the attachment, then it will attach to the device later
when the module init routine runs.

Should we do anything to limit the module_request floods?  This will
likely happen for every LUN of an ALUA system ... there can be hundreds
of those.

James


