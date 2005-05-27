From: Christoph Hellwig <hch@infradead.org>
Subject: Re: sleeping in scsi EH
Date: Fri, 27 May 2005 08:09:54 +0100
Message-ID: <20050527070954.GA27256@infradead.org>
References: <42968560.7020608@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:48862 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261922AbVE0HJ6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 03:09:58 -0400
Content-Disposition: inline
In-Reply-To: <42968560.7020608@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, May 26, 2005 at 10:26:40PM -0400, Jeff Garzik wrote:
> 
> What are the rules for sleeping (msleep, etc.) in the normal EH hooks?
> 
>         int (* eh_abort_handler)(struct scsi_cmnd *);
>         int (* eh_device_reset_handler)(struct scsi_cmnd *);
>         int (* eh_bus_reset_handler)(struct scsi_cmnd *);
>         int (* eh_host_reset_handler)(struct scsi_cmnd *);
> 
> If I could sleep in these functions, then I could eliminate libata's use 
> of ->eh_strategy_handler().

You can sleep in them.  You must however release the host lock and enable
irqs first and reverse that before returning.  The error handlers don't
need the host lock, but we're stuck with the unfortunate calling convention
for now.

