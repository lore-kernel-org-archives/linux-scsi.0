From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] scsi_host sysfs updates scsi-misc-2.5 [0/2]
Date: Mon, 12 May 2003 13:35:07 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030512203507.GC3226@beaverton.ibm.com>
References: <20030509063321.GA3259@beaverton.ibm.com> <1052711864.1768.7.camel@mulgrave> <20030512063833.GA4133@beaverton.ibm.com> <1052761851.2093.55.camel@mulgrave> <1052762365.2148.59.camel@mulgrave> <20030512184140.GB3226@beaverton.ibm.com> <1052770234.1769.75.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:63677 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S262590AbTELUUC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 May 2003 16:20:02 -0400
Content-Disposition: inline
In-Reply-To: <1052770234.1769.75.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, mochel@osdl.org

James Bottomley [James.Bottomley@steeleye.com] wrote:
> On Mon, 2003-05-12 at 13:41, Mike Anderson wrote:
> > I would like to have feedback from Mochel on the device_initialize
> > call.
> > 
> > The documentation I have read indicates the device_initialize call was to
> > allow the struct device to be usable for reference counting. I think we
> > should determine if that is the intent and can we call kobj_set_kset_s
> > in device_initialize.
> > 
> > Another option may be to set the ktype value on our struct device
> > kobject until device_add overrides this with the call to kobj_set_kset_s.
> 
> I can confirm that moving kobj_set_kset_s fixes my boot up problem (with
> your other patch).  However, now I'm running into an obscure slab
> corruption issue, so I suspect the move has to be more carefully
> orchestrated.

I checked out that setting kobj.ktype also seems to solve the problem
(using a hacked version of scsi_debug and calling scsi_register followed
by a call to scsi_unregister). This would give a more localized work
around, but device_initialize kobj_set_kset_s may be a better choice.

What slab size? (size-512)

-andmike
--
Michael Anderson
andmike@us.ibm.com

