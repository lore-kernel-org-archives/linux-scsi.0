From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 6/21] advansys: Move to scsi hotplug initialisation model
Date: Thu, 26 Jul 2007 12:04:46 -0600
Message-ID: <20070726180446.GI19275@parisc-linux.org>
References: <20070726171141.GE19275@parisc-linux.org> <11854705779-git-send-email-matthew@wil.cx> <20070726180112.GA3392@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:45943 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932284AbXGZSEs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 14:04:48 -0400
Content-Disposition: inline
In-Reply-To: <20070726180112.GA3392@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Thu, Jul 26, 2007 at 07:01:12PM +0100, Christoph Hellwig wrote:
> On Thu, Jul 26, 2007 at 01:22:42PM -0400, Matthew Wilcox wrote:
> >  - Switch from scsi_register/scsi_unregister to scsi_host_alloc,
> >    scsi_add_host, scsi_scan_host and scsi_host_put.
> >  - Rename the scsi_host_template to advansys_template
> >  - Move the memory freeing on error from advansys_wide_init_chip()
> >    back into advansys_board_found() as we need to free it if
> >    scsi_add_host() returns an error.
> 
> If you switch to new style allocation please also remove ->detect and
> ->release.  We don't really want half-conversions to the new model.

That happened in patch 4.  The function that looks for ISA and VL is still
called advansys_detect, but I can rename it to advansys_probe_legacy if
you want.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
