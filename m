From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 3/3] dm mpath: add support for using previously attached
 scsi_dh
Date: Tue, 8 May 2012 09:36:52 -0400
Message-ID: <20120508133652.GA8383@redhat.com>
References: <1336447147-3830-1-git-send-email-snitzer@redhat.com>
 <1336447147-3830-2-git-send-email-snitzer@redhat.com>
 <4FA8BBA3.3030705@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560Ab2EHNhX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 May 2012 09:37:23 -0400
Content-Disposition: inline
In-Reply-To: <4FA8BBA3.3030705@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, agk@redhat.com, babu.moger@netapp.com, sekharan@us.ibm.com, linux-scsi@vger.kernel.org

On Tue, May 08 2012 at  2:22am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> On 05/08/2012 05:19 AM, Mike Snitzer wrote:
> > Use the previously attached scsi_dh if "default" is provided as the
> > hardware handler name (the new 'use_default_hw_handler' flag is set in
> > the multipath structure).
> > 
> > Leverage scsi_dh_attach's ability to increment the scsi_dh's reference
> > count if the same scsi_dh name is provided when attaching -- currently
> > attached scsi_dh name is determined with scsi_dh_attached_handler_name.
> > 
> Not sure it that's the correct way.
> 
> Using 'default' as the hardware handler name has the drawback that
> the original information (ie the original hardware handler name)
> is lost.
> 
> So if there is no 'default', eg if the kernel module hasn't been
> loaded, we wouldn't know which hardware handler to load.

What I've done does depend on all relevant scsi_dh being available
very early (either as builtins or loaded before the HBA drivers) so that
the scsi_dh gets attached during the drivers' SCSI device scan.

> I'd rather have a feature 'default_hw_handler' which then could be
> passed into the kernel module. With that we would retain both, the
> original implementation and the default case.

My change retains the original and allows "default" to have multipath
just use what the kernel already detected and attached via .match

Please be more precise with what it is you're proposing (either with
description or working patches).

Thanks!
Mike
