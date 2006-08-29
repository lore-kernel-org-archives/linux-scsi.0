From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] scsi_transport_sas: remove local_attached flag
Date: Tue, 29 Aug 2006 10:03:39 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D702E286B@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:51654 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S965040AbWH2QDm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Aug 2006 12:03:42 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tuesday, August 29, 2006 9:35 AM, James Bottomley wrote: 

> I think the object should be to have all the SAS cards 
> display the same
> thing, so support for internal SMP passthrough looks to be the way to
> implement this.  Also, if the SAS transport class does this, 
> then we can
> hook that up to BSG instead of having to have the drivers do it
> individually.

Ok, I will look into passing internal smp request so link_errors
and link/phy reset can work for expander phys.

It maybe a couple weeks as sles10 activities have been keeping
rather busy of late.

> 
> I understood there was some architectural objection to doing SMP
> passthrough from the LSI architects ... does that still exist?
> 

I think their main complaint was they didn't want transport layer doing
discovery. Something that would be redundant as fusion fw already
handles
that, and that would introduce a performance hit with all the primitives
bouncing around. What we currently do is reading config pages to
determine
what was setup by firmware, which is fine with them.  I believe you
already 
assured me that the transport layer wouldn't take over discovery if we 
exported a portal.  My idea of the portal was for Doug Gilberts smputils
to use generic interface, instead of the current mptctl interface.  To
what
extent would transport layer use the portal besides exporting it to
userspace?

Eric

