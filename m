From: Matthew Wilcox <willy@debian.org>
Subject: Re: HBAAPI
Date: Thu, 8 Apr 2004 15:25:51 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040408142551.GA18329@parcelfarce.linux.theplanet.co.uk>
References: <3356669BBE90C448AD4645C843E2BF2802C01631@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:49854 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261804AbUDHOZx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Apr 2004 10:25:53 -0400
Content-Disposition: inline
In-Reply-To: <3356669BBE90C448AD4645C843E2BF2802C01631@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.com>
Cc: Linux SCSI Reflector <linux-scsi@vger.kernel.org>

On Thu, Apr 08, 2004 at 09:12:13AM -0400, Smart, James wrote:
> We have a fair number of ioctls which provide the functionality of HBAAPI.
> HBAAPI is a user-level API for interacting with/configuring FC HBAs. There
> are similar efforts occuring for iSCSI, etc.
> 
> The jist of HBAAPI is that each vendor supplies a "provider" module that
> implements the API for the specific hardware. Ours converts into a lot of
> ioctls. We see this as a great opportunity to remove the need for a
> vendor-specific provider module, and simply have a standard API, supported
> by linux FC drivers. There is already a sample application and template
> provider over on SourceForge that can be leveraged. We are offering to ante
> up a proposal for this API. 
> 
> Has there been any thoughts/efforts in doing this in the past ? Any
> recommendations for how this should be implemented ?  Any general thoughts?

I know this is going to sound a little weird, but take a look at
ethtool_ops (net/core/ethtool.c).  There's a certain amount of cruft
because it was done badly initially and drivers needed to be converted
gradually, but that shouldn't be necessary for a new API.

If all FC/iSCSI drivers have a scsihba_ops API, then at least we
can have typesafe APIs within the kernel for configuring this stuff.
All the parsing gets handled in one place.  It makes the discussion
about how/what/why to expose to userland a different issue ...

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
