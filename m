From: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] qla2xxx: don't include <generated/utsrelease.h>
Date: Wed, 21 Jun 2017 15:43:14 +0200
Message-ID: <1498052594.9688.0.camel@sipsolutions.net>
References: <20170621114005.29800-1-johannes@sipsolutions.net>
         <1498051773.3295.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44144 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751677AbdFUNnR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Jun 2017 09:43:17 -0400
In-Reply-To: <1498051773.3295.1.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 2017-06-21 at 13:29 +0000, Bart Van Assche wrote:
> On Wed, 2017-06-21 at 13:40 +0200, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > There's no need to use the static UTS_RELEASE string, since
> > utsname()->release contains the same.
> > 
> > This avoids rebuilding this file for every change of the
> > release string.

> > tcm_qla2xxx_wwn_version_show(struct config_item *item,
> >  		char *page)
> >  {
> >  	return sprintf(page,
> > -	    "TCM QLOGIC QLA2XXX NPIV capable fabric module %s on
> > %s/%s on "
> > -	    UTS_RELEASE"\n", QLA2XXX_VERSION, utsname()->sysname,
> > -	    utsname()->machine);
> > +	    "TCM QLOGIC QLA2XXX NPIV capable fabric module %s on
> > %s/%s on %s\n",
> > +	    QLA2XXX_VERSION, utsname()->sysname,
> > +	    utsname()->machine, utsname()->release);
> >  }

> Although this patch looks fine to me, I think removing the UTS
> release information from the output entirely would be even better. I
> think including that information in the output only made sense before
> LIO went upstream.

Well, yeah, maybe. But at least the part I preserved in the quote above
has userspace API implications, so I really didn't want to do that as a
drive-by patch submission :)

johannes
