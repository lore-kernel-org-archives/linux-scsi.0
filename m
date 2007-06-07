From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: Very slow writes with mptsas
Date: Thu, 7 Jun 2007 16:23:42 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D707C473C@NAMAIL4.ad.lsil.com>
References: <4666F7A0.8080605@torque.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:44315 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936855AbXFGWXv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jun 2007 18:23:51 -0400
Content-class: urn:content-classes:message
In-Reply-To: <4666F7A0.8080605@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net, Matthew Jacob <lydianconcepts@gmail.com>
Cc: bloch@verdurin.com, linux-scsi@vger.kernel.org, linux-precision@dell.com

On Wednesday, June 06, 2007 12:06 PM, Douglas Gilbert wrote: 

> 
> Matthew Jacob wrote:
> > The FreeBSD problem was fixed by Scott Long a couple of days ago by
> > doing some cut through SAS stuff that enabled Write Cache for SATA
> > drives. Why LSI-Logic couldn't just blitheringly synthesize 
> mode page
> > 8 is beyond me, but okay.
> > 
> > I dunno whether the issue here is the same one Scott 
> tackled- probably
> > given the messages. Eric- you listening in on this?
> 
> Matt,
> Just in case Eric doesn't answer, I suspect if the
> HBA firmware can be upgraded (from Dell or LSI?) then
> WCE (write cache enable) in the caching mode page
> will be supported. It is one of the few mode page
> settings that is required to be implemented in SAT.
> 
> The other field that should be changeable is DRA
> (disable read ahead). Both work on my LSI SAS HBA.
> 

There is two ways this can be done.    

(1) In Linux, we expose hidden raid components to the sg layer, and you
can use some of Doug Gilberts sg utilties to modify the WCE bit in the
caching mode pages to each physical disk.  I've used sg_modes to read
them, and sg_wr_modes to write them back out.   

(2) You can enable write caching in the volume settings of the firmware
config page called RAID_VOLUME_PAGE_0.    In the VolumeSettings, bit 0,
there is "WriteCachingEnabled" bit.
When this is set to one, all the write caching is enabled for all the
hidden physical disks.    You can modify the VolumeSettings by sending a
RAID_ACTION request, with the MPI_RAID_ACTION set to
CHANGE_VOLUME_SETTINGS, with the ActionDataWord field corresponding to
the VolumeSettings; e.g. set bit 0 to one.    We have a tool called
lsiutil that will enable this.   Let me know, and I will send that
source over.    I don't know why the firmware doesn't allows the caching
page to be modified to the volume.

Eric


