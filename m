From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] libsas: fix ata list corruption issue
Date: Thu, 10 Mar 2011 20:28:35 -0500
Message-ID: <4D797AC3.2050202@garzik.org>
References: <1299798798.11933.167.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1299798798.11933.167.camel@mulgrave.site>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 03/10/2011 06:13 PM, James Bottomley wrote:
> I think this stems from a misunderstanding of how the ata error handler
> works.  ata_scsi_cmd_error_handler() gets called with a passed in list
> of commands to handle.  However, that list may still not be empty when
> it exits.  The command ata_scsi_port_error_handler() must be called
> (which takes no list) before the list will be completely emptied.  This
> bites the sas error handler because the two are called from different
> functions and the original list has gone out of scope before
> ata_scsi_port_error_handler() is called. leading to some commands
> dangling on bare stack, which is a potential memory corruption issue.
> Fix this by manually deleting all outstanding commands from the on-stack
> list before it goes out of scope.

Good catch...


