From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.2
Date: Fri, 28 Nov 2003 12:03:38 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031128120338.A8954@infradead.org>
References: <03112816062402.31165@naveenb-lnx.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:30468 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262174AbTK1MDj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Nov 2003 07:03:39 -0500
Content-Disposition: inline
In-Reply-To: <03112816062402.31165@naveenb-lnx.cisco.com>; from naveenb@cisco.com on Fri, Nov 28, 2003 at 04:06:24PM +0530
List-Id: linux-scsi@vger.kernel.org
To: Naveen Burmi <naveenb@cisco.com>
Cc: linux-scsi@vger.kernel.org, davmyers@cisco.com

> 2.  iscis-kernel.h:
>         - only backward-compat cruft, should go away.

still too much left. the file should really be empty..
e.g. the HAS_ ifdefs should just go away, dito for all those
macros that aren't needed.

> 8.  - host and hba can't be NULL in ->queuecommand per defintion,
>         similarly id, lun cdbsize and use_sg can't be bigger than you
>         set in the template.

BUG_ON(host == NULL); isn't needed either, you'd get the same oops
when dereferencing a NULL pointer two lines later.

> 10.  - the procfs code is a mess.  Please move it over to
>         proper per-device / per-host sysfs attributes as procfs
>         support in HBA drivers is deprecated.

please don't add an attribute group, just use the shost_attrs field
in the host template. iscsi_show_device() doesn't look like a good
idea, what about adding an iscsi pseudo device as parent to identify
the device as iscsi in sysfs?

This whole find_keyword business is not good.  sysfs files are
supposed to have a single value.  We should probably do some
brainstorming on the right API for this..

