From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] fix up request buffer reference in various scsi drivers
Date: Thu, 8 Jun 2006 07:01:14 -0600
Message-ID: <20060608130114.GG1651@parisc-linux.org>
References: <20060603112113.GA17018@lst.de> <44880BEA.90707@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:47832 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S964829AbWFHNBP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jun 2006 09:01:15 -0400
Content-Disposition: inline
In-Reply-To: <44880BEA.90707@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, linux-scsi@vger.kernel.org

On Thu, Jun 08, 2006 at 07:37:14AM -0400, Jeff Garzik wrote:
> Christoph Hellwig wrote:
> >Various scsi drivers use scsi_cmnd.buffer and scsi_cmnd.bufflen in their
> >queuecommand functions.  Those fields are internal storage for the
> >midlayer only and are used to restore the original payload after
> >request_buffer and request_bufflen have been overwritten for EH.  Using
> >the buffer and bufflen fields means they do very broken things in error
> >handling.
> 
> False statement, for libata.

Why?  I don't see anywhere in libata where it touches ->buffer or
->bufflen other than the two cases Christoph removed.
