From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] libsas: fix ata list corruption issue
Date: Fri, 11 Mar 2011 11:19:25 -0600
Message-ID: <1299863968.1970.0.camel@localhost.localdomain>
References: <1299798798.11933.167.camel@mulgrave.site>
	 <4D797AC3.2050202@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:37010 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200Ab1CKRTl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2011 12:19:41 -0500
In-Reply-To: <4D797AC3.2050202@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>

On Thu, 2011-03-10 at 20:28 -0500, Jeff Garzik wrote:
> On 03/10/2011 06:13 PM, James Bottomley wrote:
> > I think this stems from a misunderstanding of how the ata error handler
> > works.  ata_scsi_cmd_error_handler() gets called with a passed in list
> > of commands to handle.  However, that list may still not be empty when
> > it exits.  The command ata_scsi_port_error_handler() must be called
> > (which takes no list) before the list will be completely emptied.  This
> > bites the sas error handler because the two are called from different
> > functions and the original list has gone out of scope before
> > ata_scsi_port_error_handler() is called. leading to some commands
> > dangling on bare stack, which is a potential memory corruption issue.
> > Fix this by manually deleting all outstanding commands from the on-stack
> > list before it goes out of scope.
> 
> Good catch...

I cannot tell a lie: it was the list debugger code that told me
something was wrong ... I just looked at it to see what the problem was.

James


