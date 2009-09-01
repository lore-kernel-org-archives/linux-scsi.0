From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA.
Date: Tue, 01 Sep 2009 09:23:32 -0500
Message-ID: <1251815012.3864.55.camel@mulgrave.site>
References: <1251415060.16297.58.camel@ank32.eng.vmware.com>
	 <1251739735.16169.20.camel@ank32.eng.vmware.com>
	 <1251741624.18828.83.camel@mulgrave.site>
	 <1251755593.16169.51.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35245 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921AbZIAOXn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2009 10:23:43 -0400
In-Reply-To: <1251755593.16169.51.camel@ank32.eng.vmware.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akataria@vmware.com
Cc: Robert Love <robert.w.love@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Dmitry Torokhov <dtor@vmware.com>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Maxime Austruy <maustruy@vmware.com>, Bhavesh Davda <bhavesh@vmware.com>

On Mon, 2009-08-31 at 14:53 -0700, Alok Kataria wrote:
> Hi James, 
> 
> Thanks for your comments. 
> 
> On Mon, 2009-08-31 at 11:00 -0700, James Bottomley wrote:
> > On Mon, 2009-08-31 at 10:28 -0700, Alok Kataria wrote:
> > > VMware PVSCSI driver - v2.
> > 
> > OK, so the first thing that springs to mind is that we already have one
> > of these things: the ibmvscsi ... is there no way we can share code
> > between this and the other PV drivers?
> 
> I took a quick look at the ibmvscsi driver, and there are lot of
> differences between the two, mainly the ABI that is shared between the
> hypervisor and driver differ.

Well, that's pretty abstractable, surely?  However, there is an
interesting question of what the best hypervisor interface actually is.

>  Also the ibmvscsi driver seems to offer a
> lot of other features as well, like the SRP. 

SRP is the protocol transfer abstraction.  It's just a way of packaging
up SCSI commands for transfer over a DMA protocol (OK, so it was
envisaged that the DMA protocol would be RDMA, but a hypervisor
interface is also a DMA protocol).

> The pvscsi driver is a simple SCSI adapter driver and is basically no
> different than any other SCSI driver written for a particular HBA.

Well, it is really ... hopefully all the hypervisor interfaces won't
decide to be completely incompatible, so there's a good chance of code
sharing between them.

James


