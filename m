From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] convert scsi core to use module_param interfaces
Date: Fri, 6 Jun 2003 08:17:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030606081701.A30221@beaverton.ibm.com>
References: <20030604145717.A8394@beaverton.ibm.com> <20030606073732.B13259@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:12939 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261852AbTFFPI2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2003 11:08:28 -0400
Content-Disposition: inline
In-Reply-To: <20030606073732.B13259@infradead.org>; from hch@infradead.org on Fri, Jun 06, 2003 at 07:37:32AM +0100
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Fri, Jun 06, 2003 at 07:37:32AM +0100, Christoph Hellwig wrote:
> I don't think we can just change the name of the scsi core module -
> to much userspace stuff is relying on that.  Changing the prefix would
> be nice but I have no idea how we can do that.

Is it that bad? 

Do all distros that build with scsi build it into the kernel by default?

The only option (ignoring logging) we have in 2.4 is max_scsi_luns,
changing its name from max_scsi_luns to max_luns means users already have
to modify their modules.conf. For boot command line, users have to change
to scsi[_mod].whatever no matter what.

If not changing the module name:

Rusty had suggested undef/define KBUILD_MODNAME, that might not be very
nice for use across files, and/or we could get a patch into moduleparam.h
that gives a cleaner define name.

But it is cleaner to have the modprobe name option look like the boot
command line, i.e.:

	modprobe scsi max_luns=1

	scsi.max_luns=1

> We should also kill the scsi substrings in the individual options now
> that we have a regular prefix, I'll submit a patch.

The patch looks good.

-- Patrick Mansfield
