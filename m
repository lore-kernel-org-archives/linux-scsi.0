From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2] lpfc: Fix possible NULL pointer dereference
Date: Fri, 9 Dec 2016 10:45:33 +0100
Message-ID: <20161209094533.GB8391@linux-x5ow.site>
References: <1469799056-7708-1-git-send-email-jthumshirn@suse.de>
 <yq1ziovn40r.fsf@sermon.lab.mkp.net>
 <1481223690.2361.13.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48835 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932331AbcLIJpj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 9 Dec 2016 04:45:39 -0500
Content-Disposition: inline
In-Reply-To: <1481223690.2361.13.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Tyrel Datwyler <turtle.in.the.kernel@gmail.com>, James Smart <james.smart@broadcom.com>

On Thu, Dec 08, 2016 at 11:01:30AM -0800, James Bottomley wrote:
> On Tue, 2016-08-02 at 01:17 -0400, Martin K. Petersen wrote:
> > > > > > > "Johannes" == Johannes Thumshirn <jthumshirn@suse.de>
> > > > > > > writes:
> > 
> > Johannes> Check for the existence of piocb->vport before accessing
> > it.
> > 
> > Applied to 4.8/scsi-queue.
> 
> OK, now that this has caused problems, could learn the lessons from it?
> 
> Lines like this:
> 
> +       BUG_ON(!piocb || !piocb->vport);
> 
> Should never appear in code.  They only have the potential to cause
> problems if the condition is inexact and they provide precisely no
> information over what a NULL deref in the kernel is going to tell us
> anyway ... this one even obscures information because you don't know if
> pciob was null or pciob->vport when it triggers.
> 
> The rule is never BUG_ON a NULL pointer unless you have an extremely
> good reason why the kernel NULL deref handler isn't adequate (which
> should be documented in the commit log).

Yup I fully agree, but shouldn't we take as a 2nd lesson that BUG_ON()s
generally aren't an extremely good idea? I personally think a lot of
BUG_ON()s in driver code can be eliminated with proper error handling.

That said, mea culpa.

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
