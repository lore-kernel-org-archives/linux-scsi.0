From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 3/4] libfcoe: Add fcoe_sysfs
Date: Sat, 17 Mar 2012 09:07:07 +0000
Message-ID: <1331975227.2855.8.camel@dabdike>
References: <20120316193640.5369.56932.stgit@localhost6.localdomain6>
	 <20120316193656.5369.47569.stgit@localhost6.localdomain6>
	 <20120317002517.GA22430@kroah.com> <4F63E4E9.2010504@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36330 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756305Ab2CQJHO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Mar 2012 05:07:14 -0400
In-Reply-To: <4F63E4E9.2010504@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Love, Robert W" <robert.w.love@intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "giridhar.malavali@qlogic.com" <giridhar.malavali@qlogic.com>, "james.smart@emulex.com" <james.smart@emulex.com>, "bprakash@broadcom.com" <bprakash@broadcom.com>

On Sat, 2012-03-17 at 01:12 +0000, Love, Robert W wrote:
> >> +    ctlr->id = atomic_inc_return(&ctlr_num) - 1;
> > Does this work properly over the long run?  Shouldn't you use the
> idr
> > interface instead, to keep holes from showing up?
> 
> I'm not familiar wit the idr interface. I'll ask around and fix this.
> 
The rule of thumb we've been using for idr in SCSI is that we don't
bother with it unless the name space is constrained.  So for sd<x> we
use it because we have a limited device space to fill (constrained by
minor numbers) for target<n> we just use an incrementing counter because
<n> is unconstrained.

James


