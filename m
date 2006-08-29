From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fix scsi_send_eh_cmnd regression
Date: Tue, 29 Aug 2006 13:04:28 +0100
Message-ID: <20060829120428.GA25359@infradead.org>
References: <1156575622.2828.4.camel@max>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:45464 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S964931AbWH2MEu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Aug 2006 08:04:50 -0400
Content-Disposition: inline
In-Reply-To: <1156575622.2828.4.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

On Sat, Aug 26, 2006 at 03:00:22AM -0400, Mike Christie wrote:
> The callers of scsi_send_eh_cmnd are setting the cmnd buffer,
> and then scsi_send_eh_cmnd is copying that updated buffer to
> the old_cmnd variable. Then after the command runs, we end up
> copying that old_cmnd var which has the new cmnd to the scsi
> command buffer. When this command gets recent, all types of fun
> things happen like getting TUR or START_STOP commands with
> data and scatterlists.
> 
> This patch made against scsi-rc-fixes, has the callers of
> scsi_send_eh_cmnd pass in the command so scsi_send_eh_cmnd
> can do the right thing. This should go into 2.6.18 since this
> fixes a regression added when we removed some of the scsi_cmnd
> fields and replaced them with local variables.

Ok.  Thanks a lot for fixing this.

I really wish we had something like a regression test suite to find
things like this..
