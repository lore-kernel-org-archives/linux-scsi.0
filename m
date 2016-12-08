From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2] lpfc: Fix possible NULL pointer dereference
Date: Thu, 08 Dec 2016 11:01:30 -0800
Message-ID: <1481223690.2361.13.camel@HansenPartnership.com>
References: <1469799056-7708-1-git-send-email-jthumshirn@suse.de>
         <yq1ziovn40r.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53184 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753769AbcLHTBd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2016 14:01:33 -0500
In-Reply-To: <yq1ziovn40r.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Tyrel Datwyler <turtle.in.the.kernel@gmail.com>, James Smart <james.smart@broadcom.com>

On Tue, 2016-08-02 at 01:17 -0400, Martin K. Petersen wrote:
> > > > > > "Johannes" == Johannes Thumshirn <jthumshirn@suse.de>
> > > > > > writes:
> 
> Johannes> Check for the existence of piocb->vport before accessing
> it.
> 
> Applied to 4.8/scsi-queue.

OK, now that this has caused problems, could learn the lessons from it?

Lines like this:

+       BUG_ON(!piocb || !piocb->vport);

Should never appear in code.  They only have the potential to cause
problems if the condition is inexact and they provide precisely no
information over what a NULL deref in the kernel is going to tell us
anyway ... this one even obscures information because you don't know if
pciob was null or pciob->vport when it triggers.

The rule is never BUG_ON a NULL pointer unless you have an extremely
good reason why the kernel NULL deref handler isn't adequate (which
should be documented in the commit log).

James

