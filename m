From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: HBAAPI
Date: 08 Apr 2004 08:56:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081432604.1885.87.camel@mulgrave>
References: <3356669BBE90C448AD4645C843E2BF2802C01631@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:47041 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261857AbUDHN4q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Apr 2004 09:56:46 -0400
In-Reply-To: <3356669BBE90C448AD4645C843E2BF2802C01631@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.com>
Cc: Linux SCSI Reflector <linux-scsi@vger.kernel.org>

On Thu, 2004-04-08 at 08:12, Smart, James wrote:
> We have a fair number of ioctls which provide the functionality of HBAAPI.
> HBAAPI is a user-level API for interacting with/configuring FC HBAs. There
> are similar efforts occuring for iSCSI, etc.

Well, as you probably saw from the qla2xxx driver driver submission, the
ioctls got sliced out before final driver acceptance.

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

Yes, this needs to be done as part of the FC transport class.

> Some of the payload/buffer sizes for the API can exceed 4k in size. Thus,
> moving them to sysfs and potentially converting them to multiple operations
> is problematic.  Right now, the thought is to leave them as ioctls.  If you
> have other ideas, let me know.

There's a binay blob api for sysfs.  If the size is known (or
approximateable) we can probably get the interface fixed to work
correctly.

> HBAAPI provides an interface for setting persistent device mappings. What
> are the current thoughts on how driver-level persistent data should be
> maintained/saved/etc ?

Persistent device mapping from the driver is not going in.  Use udev
instead.

James


