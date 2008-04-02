From: Greg KH <greg@kroah.com>
Subject: Re: transport_class: BUG if we can't release the attribute
	container
Date: Tue, 1 Apr 2008 23:32:32 -0700
Message-ID: <20080402063232.GD8158@kroah.com>
References: <1206203957.4393.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:56170 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbYDBGc4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Apr 2008 02:32:56 -0400
Content-Disposition: inline
In-Reply-To: <1206203957.4393.16.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sat, Mar 22, 2008 at 11:39:17AM -0500, James Bottomley wrote:
> Every current transport class calls transport_container_release but
> ignores the return value.  This is catastrophic if it returns an error
> because the containers are part of a global list and the next action of
> almost every transport class is to free the memory used by the
> container.
> 
> Fix this by making transport_container_release a void, but making it BUG
> if attribute_container_release returns an error ... this catches the
> root cause of a system panic much earlier.  If we don't do this, we get
> an eventual BUG when the attribute container list notices the corruption
> caused by the freed memory it's still referencing.
> 
> Also made attribute_container_release __must_check as a reminder.
> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> 
> ---
> 
> diff --git a/drivers/base/transport_class.c b/drivers/base/transport_class.c
> index 40bca48..06861ae 100644
> --- a/drivers/base/transport_class.c
> +++ b/drivers/base/transport_class.c
> @@ -108,7 +108,7 @@ EXPORT_SYMBOL_GPL(anon_transport_class_register);
>   */
>  void anon_transport_class_unregister(struct anon_transport_class *atc)
>  {
> -	attribute_container_unregister(&atc->container);
> +	BUG_ON(attribute_container_unregister(&atc->container));

BUG_ON() should not do anything in the macro except test for a value, no
function calling.  I think checkpatch.pl checks for this...

If you change that, I have no problem with this.

thanks,

greg k-h
