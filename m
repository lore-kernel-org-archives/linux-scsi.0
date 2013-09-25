From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: SCSI's heuristics for enabling WRITE SAME still need work [was:
 dm mpath: disable WRITE SAME if it fails]
Date: Wed, 25 Sep 2013 22:52:28 +0200
Message-ID: <52434D0C.1090008@fastmail.fm>
References: <20130919161043.GA27081@redhat.com> <20130920212142.GA17898@redhat.com> <yq1eh8jf8wq.fsf@sermon.lab.mkp.net> <1379960325.4010.32.camel@localhost.localdomain> <52412581.2010909@suse.de> <20130924123449.GA16083@redhat.com> <yq1hadaba87.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54203 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755291Ab3IYUwc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Sep 2013 16:52:32 -0400
In-Reply-To: <yq1hadaba87.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>, emilne@redhat.com, device-mapper development <dm-devel@redhat.com>, dgilbert@interlog.com, linux-scsi@vger.kernel.org

On 09/24/2013 03:49 PM, Martin K. Petersen wrote:
>>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
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
> 

Martin,

I'm afraid we have another problem. I'm currently working on to get
discard working for our LSI2008 HBAs with attached sata-SSDs and the
heuristics in sd_read_write_same with based on VPD page 0x89 is not
correct for this HBA - its SATL supports write-same (although it does
"Logical block address out of range" at the end of the device, I'm going
to look into this tomorrow).

So allow LSI SATL or remove this check at all?


Thanks,
Bernd
