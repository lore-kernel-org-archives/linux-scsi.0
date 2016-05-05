From: Paul Mackerras <paulus@ozlabs.org>
Subject: Re: [PATCH] scsi: Make scsi_vpd_lun_id() able to use T10 vendor ID
 based designators
Date: Thu, 5 May 2016 22:41:36 +1000
Message-ID: <20160505124136.GA8374@fergus.ozlabs.ibm.com>
References: <20160504065830.GB19436@oak.ozlabs.ibm.com>
 <5729C920.1040206@suse.de>
 <20160505035010.GA4635@oak.ozlabs.ibm.com>
 <572AFDC9.1000607@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:42270 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbcEEMlt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 May 2016 08:41:49 -0400
Content-Disposition: inline
In-Reply-To: <572AFDC9.1000607@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

On Thu, May 05, 2016 at 10:01:13AM +0200, Hannes Reinecke wrote:
> On 05/05/2016 05:50 AM, Paul Mackerras wrote:
> > On Wed, May 04, 2016 at 12:04:16PM +0200, Hannes Reinecke wrote:
...
> >> Nearly.
> >> The thing is, a T-10 vendor specific ID is _supposed_ to be an ASCII
> >> string. So I'd rather have it decoded as such.
> > 
> > Do we need to defend against non-printing characters in the string?
> > 
> I really would like to stick to ASCII output here, as most vendors put a
> meaningful string in here.
> Those who don't we should be going with the '.' normal method and print
> a dot '.' instead.
> (Can't we fix up snprintf do do it for us? Would be soo cool ...)
> 
> >> And we're missing decoding for 'vendor-specific' ID, too.
> > 
> > There's no guarantee that this would be ASCII, right?  So would you
> > print it in hex?
> > 
> Yes, that's the plan here.
> 
> > Also, is there a preference between these types?  For example, is an
> > 8-byte EUI-64 preferable to a vendor-specific ID of any length?
> > 
> Yes. I'd treat T10 vendor ID descriptors with the lowest preference
> (irrespective of the length), eclipsed (sic) only by the truly vendor
> specific ones.

Well, the disks on my system all have the same vendor-specific ID,
unfortunately -- a '0' followed by 19 spaces.  Here are the
designators for all the disks on my system:

scsi 0:2:0:0: 02 01 00 20 'IBM     IPR-0   5EC4AB0000000020'
scsi 0:2:0:0: 02 00 00 14 '0                   '
scsi 0:2:1:0: 02 01 00 20 'IBM     IPR-0   5EC28C0000000080'
scsi 0:2:1:0: 02 00 00 14 '0                   '
scsi 0:2:2:0: 02 01 00 20 'IBM     IPR-0   5EC28C0000000060'
scsi 0:2:2:0: 02 00 00 14 '0                   '
scsi 0:2:3:0: 02 01 00 20 'IBM     IPR-0   5EC28C0000000040'
scsi 0:2:3:0: 02 00 00 14 '0                   '
scsi 0:2:4:0: 02 01 00 20 'IBM     IPR-0   5EC28C0000000020'
scsi 0:2:4:0: 02 00 00 14 '0                   '
scsi 0:2:5:0: 02 01 00 20 'IBM     IPR-0   5EC28C00000000C0'
scsi 0:2:5:0: 02 00 00 14 '0                   '
scsi 0:2:6:0: 02 01 00 20 'IBM     IPR-0   5EC28C00000000A0'
scsi 0:2:6:0: 02 00 00 14 '0                   '

> And actually I would make the vendor-specific decoding the default
> entry, too, as we might come across some other descriptors which we
> cannot decode (yet). And by having a default method for decoding we
> ensure to always be able to come up with an ALUA identification.
> Otherwise we might end up in the same situation as we're in now.

What would happen if we pick a designator which is not unique across
different disks?  Would we think that they were all the same disk?

Paul.
