From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH] allow sleep inside EH hooks
Date: Fri, 27 May 2005 08:11:09 +0100
Message-ID: <20050527071109.GB27256@infradead.org>
References: <4296A2C7.4090107@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:51166 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261929AbVE0HLO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 03:11:14 -0400
Content-Disposition: inline
In-Reply-To: <4296A2C7.4090107@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, May 27, 2005 at 12:32:07AM -0400, Jeff Garzik wrote:
> 
> SCSI EH processing already serializes things during EH, so this spinlock 
> isn't really needed.
> 
> Removing the spinlock outright would break drivers that surround logic 
> with spin_unlock_irq()..spin_lock_irq(), so I introduced ->unlocked_eh 
> option.

Linus has vetoed such conditional locking in the past.  However if you do
it don't make it EH specific but introduce a ->concurrent flag that disables
taking host_lock for ->queuecommand aswell.

