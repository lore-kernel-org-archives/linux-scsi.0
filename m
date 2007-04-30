From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fill in scsi_host_template module owner
Date: Mon, 30 Apr 2007 17:02:33 +0100
Message-ID: <20070430160233.GA27438@infradead.org>
References: <200704301653.56687.okir@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:57098 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423645AbXD3QCf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Apr 2007 12:02:35 -0400
Content-Disposition: inline
In-Reply-To: <200704301653.56687.okir@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Kirch <okir@lst.de>
Cc: linux-scsi@vger.kernel.org

On Mon, Apr 30, 2007 at 04:53:55PM +0200, Olaf Kirch wrote:
> I recently ran into an oops that happens because you
> can shut down all of iSCSI even though you still have
> iSCSI targets mounted. It turned out that iscsi's
> scsi_host_template missed a THIS_MODULE, so
> reference counting wasn't done properly. Brief
> inspection showed that this seems to be a rather
> wide-spread problem. Here's a patch to address this.

Two comments:

 - a driver should handle hot unplugs proper, even if THIS_MODULE
   is set this can happen if the hardware just goes away.
 - strictly speaking many of the drivers in your patch already set
   up the owner because scsi_module.c already does it for them.
   But we try to get rid of scsi_module.c so this is an improvement,
   you can now remove setting .module in scsi_module.c

