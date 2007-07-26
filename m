From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/21] advansys: Move to scsi hotplug initialisation model
Date: Thu, 26 Jul 2007 19:01:12 +0100
Message-ID: <20070726180112.GA3392@infradead.org>
References: <20070726171141.GE19275@parisc-linux.org> <11854705779-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:54280 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933678AbXGZSBN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 14:01:13 -0400
Content-Disposition: inline
In-Reply-To: <11854705779-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Thu, Jul 26, 2007 at 01:22:42PM -0400, Matthew Wilcox wrote:
>  - Switch from scsi_register/scsi_unregister to scsi_host_alloc,
>    scsi_add_host, scsi_scan_host and scsi_host_put.
>  - Rename the scsi_host_template to advansys_template
>  - Move the memory freeing on error from advansys_wide_init_chip()
>    back into advansys_board_found() as we need to free it if
>    scsi_add_host() returns an error.

If you switch to new style allocation please also remove ->detect and
->release.  We don't really want half-conversions to the new model.

