From: Christoph Hellwig <hch@infradead.org>
Subject: Re: sym2 error handler sleeps with irqs off
Date: Sun, 13 Jul 2003 14:35:33 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030713143533.A24729@infradead.org>
References: <20030711062045.GA9236@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.mvhi.com ([195.224.96.167]:29711 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S266018AbTGMNUs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Jul 2003 09:20:48 -0400
Content-Disposition: inline
In-Reply-To: <20030711062045.GA9236@krispykreme>; from anton@samba.org on Fri, Jul 11, 2003 at 04:20:46PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: linux-scsi@vger.kernel.org

On Fri, Jul 11, 2003 at 04:20:46PM +1000, Anton Blanchard wrote:
> +		local_save_flags(flags);

I don't think you need to save the flags.

> +		spin_unlock_irq(cmd->device->host->host_lock);
>  		down(&ep->sem);
> +		local_irq_restore(flags);
> +		spin_lock(cmd->device->host->host_lock);

When we drop it we should probably drop it as long as it's safe.

