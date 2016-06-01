From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 1/2] scsi: fix race between simultaneous decrements
 of ->host_failed
Date: Wed, 01 Jun 2016 11:38:54 -0400
Message-ID: <1464795534.23285.4.camel@linux.vnet.ibm.com>
References: <1464683898-9877-1-git-send-email-fangwei1@huawei.com>
	 <BF6B9AADDDF11740967545E971C7C0DE6B861A22@MAIL1.pickering.lenbrook.com>
	 <38efc40d-fec9-3278-abb8-2a78c4146a8c@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:40413 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758610AbcFAPjJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2016 11:39:09 -0400
Received: from localhost
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
	Wed, 1 Jun 2016 09:39:07 -0600
In-Reply-To: <38efc40d-fec9-3278-abb8-2a78c4146a8c@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Kevin Groeneveld <KGroeneveld@lenbrook.com>, Wei Fang <fangwei1@huawei.com>, "tj@kernel.org" <tj@kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "corbet@lwn.net" <corbet@lwn.net>
Cc: "hch@infradead.org" <hch@infradead.org>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>

On Wed, 2016-06-01 at 08:29 -0700, Bart Van Assche wrote:
> On 06/01/2016 07:36 AM, Kevin Groeneveld wrote:
> > > Subject: [PATCH v2 1/2] scsi: fix race between simultaneous
> > > decrements of ->host_failed
> > 
> > I wonder if this could be related to 
> > http://www.spinics.net/lists/linux-scsi/msg86808.html?
> > 
> > I never did get to the bottom of that.  If I have time I hope to
> > retest my scsi hang issue with this patch.
> 
> I've never seen that hang with the ib_srp driver (which is a SCSI 
> LLD). That probably means that the SATA code uses the SCSI error 
> handler in another way than other SCSI LLDs.

It's the ata_sas error handler, which is split between libsas and
libata.  It does one thread of execution per ata port when the strategy
handler is invoked.  This behaviour is pretty much unique at the
moment.

James


