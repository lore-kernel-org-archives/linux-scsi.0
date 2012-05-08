From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 3/3] dm mpath: add support for using previously attached
 scsi_dh
Date: Tue, 8 May 2012 10:05:41 -0400
Message-ID: <20120508140541.GB8383@redhat.com>
References: <1336447147-3830-1-git-send-email-snitzer@redhat.com>
 <1336447147-3830-2-git-send-email-snitzer@redhat.com>
 <4FA8BBA3.3030705@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755763Ab2EHOGm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 May 2012 10:06:42 -0400
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

BTW, on this point: How is the original handler's name lost with my
patches?  I set m->hw_handler_name to the original (aka attached)
handler's name (as returned scsi_dh_attached_handler_name).

"default" is only used as a key to trigger the use of the attached
handler (it causes m->use_default_hw_handler to be set).

Was my description or code somehow unclear?  Guess so... otherwise I'd
not be clarifying this... unfortunately I'm not seeing where I fell
short.

Mike
