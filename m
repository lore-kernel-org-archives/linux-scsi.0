From: "Ed Lin" <ed.lin@promise.com>
Subject: RE: [PATCH 1/4] stex: fix id mapping issue(v3)
Date: Mon, 16 Apr 2007 20:46:36 -0700
Message-ID: <B70A50D07063384EB9BCE3330D18414F0327F161@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:4056 "EHLO
	nonameb.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031070AbXDQDow convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Apr 2007 23:44:52 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, jeff <jeff@garzik.org>, Promise_Linux <Promise_Linux@promise.com>



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
> Sent: Thursday, April 05, 2007 6:58 AM
> To: Christoph Hellwig
> Cc: Ed Lin; linux-scsi; jeff; Promise_Linux
> Subject: Re: [PATCH 1/4] stex: fix id mapping issue(v3)
> 
> 
> On Thu, 2007-04-05 at 08:42 +0100, Christoph Hellwig wrote:
> > On Wed, Apr 04, 2007 at 08:05:59PM -0500, James Bottomley wrote:
> > > Erm, there's a simple way out of this:  That's the BLIST_FORCELUN
> > > option.  This is why most of the RAID devices have entries in
> > > scsi_devinfo.c like:
> > > 
> > >         {"ADAPTEC", "AACRAID", NULL, BLIST_FORCELUN},
> > > 
> > > Which overrides the CONFIG_SCSI_MULTI_LUN setting for the 
> particular
> > > device.  We can easily add an entry for stex as well.
> > 
> > IMHO we should kill CONFIG_SCSI_MULTI_LUN and add blacklist 
> enries for
> > devices that don't handle scanning for luns > 1 instead.  I 
> think the
> > RH/Fedora kernel has started collecting these blacklist entries for
> > a long time already.
> 
> I wouldn't disagree with that.  There have been several schools of
> thought on this:  One was that every multi-lun device since SPC should
> support REPORT LUNS, so MULTI_LUN should be off by default and we
> whitelist non SPC compliant multi-lun devices.  If we also 
> added a host
> hook to allow RAID devices to declare themselves, then I think we
> capture 99% of the current cases.
> 
> Another is just to make it on by default.  I note that both SLES10 and
> RHEL5 now define it on, so I can't see much argument in support of a
> distro setting it off.
> 
> James
> 
> 
>

Sorry for the late reply.

What lun means is different between our firmware and os scsi,
firmware's lun is used to manage multi-disk used in multi-raid,
driver can't just assign os scsi lun to be firmware's lun,
or firmware will confuse and use it by wrong.

We prefer to fix this problem in the driver, as we did the
mapping at driver side in previous upstream versions.

This is the result of Promise internal discussion. We have
difficulty to do so (in the firmware side), although we want to
comply to the community's requirement. We want to hear further
opinions on this issue, so that we know what to do next.

Thanks,

Ed Lin
 
