From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] scsi_host sysfs updates scsi-misc-2.5 [0/2]
Date: Mon, 12 May 2003 11:41:40 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030512184140.GB3226@beaverton.ibm.com>
References: <20030509063321.GA3259@beaverton.ibm.com> <1052711864.1768.7.camel@mulgrave> <20030512063833.GA4133@beaverton.ibm.com> <1052761851.2093.55.camel@mulgrave> <1052762365.2148.59.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:25013 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S262303AbTELS0i
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 May 2003 14:26:38 -0400
Content-Disposition: inline
In-Reply-To: <1052762365.2148.59.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, mochel@osdl.org

James Bottomley [James.Bottomley@steeleye.com] wrote:
> On Mon, 2003-05-12 at 12:50, James Bottomley wrote:
> > Surprisingly, it still fails.  I've debugged the refcounting and I see
> > it fall to zero in scsi_host_put but the dev release method doesn't
> > trigger for no reason I can see.
> > 
> > It's probably a kobject initialisation problem somewhere.
> 
> OK, found it.  the ->release is triggered by the kobj_kset, which isn't
> set until device_add time, not device init time.
> 
> Therefore, we shouldn't really put and get objects until they've been
> added (or the kobj_set_kset_s needs to be moved to device_initialize()).
> 

I would like to have feedback from Mochel on the device_initialize
call.

The documentation I have read indicates the device_initialize call was to
allow the struct device to be usable for reference counting. I think we
should determine if that is the intent and can we call kobj_set_kset_s
in device_initialize.

Another option may be to set the ktype value on our struct device
kobject until device_add overrides this with the call to kobj_set_kset_s.

-andmike
--
Michael Anderson
andmike@us.ibm.com

