From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [SAS ANNOUNCEMENT] MPT Fusion driver 3.02.07 update
Date: Tue, 9 Nov 2004 17:26:05 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C37672A@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:718 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261810AbUKJA0d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2004 19:26:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, "Stephens, Larry" <larry.stephens@lsil.com>

On Tuesday, November 09, 2004 7:20 AM, Christoph Hellwig wrote:
> 
> On Mon, Nov 08, 2004 at 04:35:06PM -0700, Moore, Eric Dean wrote:
> > 
> > On Saturday, November 06, 2004 4:03 PM, Christoph Hellwig wrote:
> > > 
> > >  - ioc->sasDeviceList still exists although it's not actually 
> > > traversed,
> > >    and quite a lot od dead code to fill it
> > 
> > Yes this is being used, and its not dead code.  Its filled 
> and deleted
> > in mptscsih.c when devices are added and removed.  It appears now
> > that you had me removed the CSMI IOCTLs last week, this code will be
> > needed in other aspects such as sas transport layer, misc 
> future features, 
> > and debugging.
> 
> Aka it's not used in the current code but may in the future.  
> Please keep
> it around as a patch or whatever until your introduce actual 
> users of it.
> 

This sas device list is being used in the driver, and we do
have actual users of it; and they are HP, DELL, SUN, and others. 
The CSMI IOCTLs are temporarily removed from the driver as you have 
rejected it even though I know of nobody else so far that has complained
about this.
We are in talks with HP, so lets let them decide how to proceed
on this API.  Meanwhile this sas device list is required by LSI. Besides, I 
wonder why your so strong in having this removed?  This is really small
code compared with would be required if we have to scan the topology for
each and every ioctl.


> I'm pretty sure we will try to do this kind of bookkepping in the sas
> transport class later on.

Ok - when will the sas transport layer be available?
CSMI is avialable today.

> 
> > >  - what's that ->last_lun thing about?
> > 
> > This fixes a bug sent to us by Tom Coughlan of Redhat; here
> > is the description of the bug from Tom : 
> > 
> > "When SPARSELUN is set, the SCSI midlayer unconditionally probes LUN
> > values up to max_lun in the SCSI host template.  In recent 
> versions of
> > the mpt fusion driver this is set to 256. The problem is that on
> > non-U320 SCSI (non-packetized) the identify message is 
> used, and its LUN
> > field is only 6 bits, allowing only 64 LUNs. This causes
> > selectio/reselection problems on the SCSI bus, resulting the
> > configuration of non-existant devices, or maybe worse."
> 
> Just setting max_lun in struct Scsi_Host before calling scsi_scan_host
> to either MPT_LAST_LUN or MPT_NON_IU_LAST_LUN should fix that issue.
> 
> The max_lun parameter in the host template is just the default value
> set during scsi_host_alloc.

Ok - your suggestion is not going to work.  We only know whether IU is
enabled or not through domain validation, which is done in the context
of scsi_scan_host.  Our SCSI firmware only supports packetized at U320
speeds, and the issue came about when some device with SPARSELUN set
negotiated at Fast 80.  This implementions solves the issue reported 
by Redhat and their customers, and will be avaliable in RHEL3 Update 4.  
Its not clear to me why your wanting to break this?

