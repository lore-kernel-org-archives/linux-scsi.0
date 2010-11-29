From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] megaraid_sas: Convert SHT->queuecommand() to run host_lock-less
Date: Mon, 29 Nov 2010 17:41:00 +0100
Message-ID: <20101129164100.GA22820@lst.de>
References: <1290928656-31116-1-git-send-email-nab@linux-iscsi.org> <1290928656-31116-4-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:44583 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593Ab0K2QlK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Nov 2010 11:41:10 -0500
Content-Disposition: inline
In-Reply-To: <1290928656-31116-4-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Bo Yang <Bo.Yang@lsi.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@suse.de>

On Sat, Nov 27, 2010 at 11:17:36PM -0800, Nicholas A. Bellinger wrote:
>  /**
> - * megasas_get_cmd -	Get a command from the free pool
> + * __megasas_get_cmd -	Get a command from the free pool
>   * @instance:		Adapter soft state
>   *
>   * Returns a free command from the pool
> + * Locking: Called with instance->cmd_pool_lock w/ spin_lock_irqsave
>   */
> -static struct megasas_cmd *megasas_get_cmd(struct megasas_instance
> -						  *instance)
> +static struct megasas_cmd *
> +__megasas_get_cmd(struct megasas_instance *instance)
>  {
> +	struct megasas_cmd *cmd;
>  	unsigned long flags;
> -	struct megasas_cmd *cmd = NULL;
>  
>  	spin_lock_irqsave(&instance->cmd_pool_lock, flags);

--- snip ---

> +static struct megasas_cmd *
> +megasas_get_cmd(struct megasas_instance *instance)
> +{
> +	struct megasas_cmd *cmd;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&instance->cmd_pool_lock, flags);

I can't see how this works.

