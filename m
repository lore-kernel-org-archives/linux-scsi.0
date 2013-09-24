From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: SCSI's heuristics for enabling WRITE SAME still need work [was:
 dm mpath: disable WRITE SAME if it fails]
Date: Tue, 24 Sep 2013 11:15:13 -0400
Message-ID: <20130924151513.GB16165@redhat.com>
References: <20130919161043.GA27081@redhat.com>
 <20130920212142.GA17898@redhat.com>
 <yq1eh8jf8wq.fsf@sermon.lab.mkp.net>
 <1379960325.4010.32.camel@localhost.localdomain>
 <52412581.2010909@suse.de>
 <20130924123449.GA16083@redhat.com>
 <yq1hadaba87.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038Ab3IXPPR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Sep 2013 11:15:17 -0400
Content-Disposition: inline
In-Reply-To: <yq1hadaba87.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, emilne@redhat.com, device-mapper development <dm-devel@redhat.com>, dgilbert@interlog.com

On Tue, Sep 24 2013 at  9:49am -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike> So are there drives like this?:
> Mike> 1) don't support RSOC
> Mike> 2) do support WRITE SAME
> Mike> 3) do populate VPD page with either WRITE SAME w/ discard bit set
> Mike>    or UNMAP?
> 
> Yes.
> 
> But again, the fundamental issue here is not the drives. It's the
> controller firmware. I am not aware of a single SPI/SAS/FC drive that
> does not support at least WRITE SAME(10).
> 
> For DIX and T10 PI I have a capabilities mask that each HBA driver fills
> out that tells the sd driver what the controller can do. And this is
> combined with whatever the drive reports to figure out whether integrity
> protection can be enabled.
> 
> I have been contemplating doing something similar for "fancy" SCSI
> commands. We could have a flag in the scsi host template that controls
> whether the device supports WRITE SAME, EXTENDED COPY, etc. The
> advantage being that we do the matching at discovery time instead of
> once a WRITE SAME is issued.
> 
> This would also permit HBA drivers to toggle the feature on a per
> instance basis. I.e. if "RAID controller firmware rev is lower than XYZ,
> do not support WRITE SAME".
> 
> I'll do a PoC later today...

Sounds promising, thanks!
