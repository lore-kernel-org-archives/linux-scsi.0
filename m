From: Christoph Hellwig <hch@infradead.org>
Subject: Re: HBAAPI
Date: Fri, 16 Apr 2004 13:10:53 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040416131053.D5080@infradead.org>
References: <3356669BBE90C448AD4645C843E2BF2802C01631@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:59664 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262974AbUDPMK4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Apr 2004 08:10:56 -0400
Content-Disposition: inline
In-Reply-To: <3356669BBE90C448AD4645C843E2BF2802C01631@xbl.ma.emulex.com>; from James.Smart@Emulex.com on Thu, Apr 08, 2004 at 09:12:13AM -0400
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.com>
Cc: Linux SCSI Reflector <linux-scsi@vger.kernel.org>

On Thu, Apr 08, 2004 at 09:12:13AM -0400, Smart, James wrote:
> The jist of HBAAPI is that each vendor supplies a "provider" module that
> implements the API for the specific hardware. Ours converts into a lot of
> ioctls. We see this as a great opportunity to remove the need for a
> vendor-specific provider module, and simply have a standard API, supported
> by linux FC drivers. There is already a sample application and template
> provider over on SourceForge that can be leveraged. We are offering to ante
> up a proposal for this API.

I'm not exactly happy with the HBAAPI, like about everything from SNIA
it's a pretty braindead spec.  But if you want a standard implementation
for Linux I'd suggest the different FC HBA Vendors sit together and tell
what additional kernel support they'd need for a _single_ implementation
of that library instead of the loadable module mess.

> Has there been any thoughts/efforts in doing this in the past ? Any
> recommendations for how this should be implemented ?  Any general thoughts?

Most of the HBA ABI functions that are about attribute querying should be
handle through the FC transport attributes.  The entry points ending up
sending down certain scsi commands should invoke SG_IO, for the other
someone has to come up with ideas.

> HBAAPI provides an interface for setting persistent device mappings. What
> are the current thoughts on how driver-level persistent data should be
> maintained/saved/etc ?

Do you mean persistant mappings from WWNNs to scsi target/lun numbers or
mappings of either of those to Linux device names?

