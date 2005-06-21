From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Questions about scsi_target_reap and starget/sdev lifecyle
Date: Tue, 21 Jun 2005 21:10:56 +0100
Message-ID: <20050621201056.GA29658@infradead.org>
References: <20050621171209.GB29396@us.ibm.com> <Pine.LNX.4.44L0.0506211526360.634-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:10153 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262297AbVFUULH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jun 2005 16:11:07 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0506211526360.634-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, Jun 21, 2005 at 04:04:06PM -0400, Alan Stern wrote:
> This objection runs up against an issue we discussed some time ago.  
> Should the intended meaning of scsi_remove_host be simply that the kernel
> needs to stop using the HBA reasonably soon?  In that case you are right.  
> Or should the intended meaning be that the HBA is actually gone
> (hot-unplugged) and all further attempts to use it will fail?  In that
> case it doesn't matter.  The best ways to resolve this issue may be to
> have a separate scsi_host_gone routine or to add an extra argument to
> scsi_remove_host.

It must mean both because we don't know whether a hot unplug happened or
not.  The ->remove callbacks don't tell us.

