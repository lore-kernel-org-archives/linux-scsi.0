From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] fix EH thread teardown
Date: Tue, 13 Sep 2005 21:05:36 +0200
Message-ID: <20050913190536.GA26985@lst.de>
References: <200509131901.33033@bilbo.math.uni-mannheim.de> <Pine.LNX.4.44L0.0509131457530.4662-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:39641 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S965048AbVIMTFr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2005 15:05:47 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0509131457530.4662-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>, Christoph Hellwig <hch@lst.de>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, Sep 13, 2005 at 03:03:19PM -0400, Alan Stern wrote:
> On Tue, 13 Sep 2005, Rolf Eike Beer wrote:
> 
> > Looks like someone has to build a waitqueue to fix this.
> 
> Tell me what you think of this patch.  I'm not sure whether that 
> condition, host_busy == host_failed, is correct for the call to 
> wait_event_interruptible.

I don't think we even need the waitque, a wake_up_process can replace
it when there's only a single process waiting on it ever.  Similarly
we don't need eh_alive - EH must be alive after scsi_add_host returned,
and no command may be in flight before that.

