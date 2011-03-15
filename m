From: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [RFC-v2 12/12] iscsi-target: Add Makefile/Kconfig and update
 TCM top level
Date: Tue, 15 Mar 2011 02:03:53 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1103150201050.26293@swampdragon.chaosbits.net>
References: <1300103829-10337-1-git-send-email-nab@linux-iscsi.org> <1300103829-10337-13-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20445 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339Ab1COBEN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Mar 2011 21:04:13 -0400
In-Reply-To: <1300103829-10337-13-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Douglas Gilbert <dgilbert@interlog.com>

On Mon, 14 Mar 2011, Nicholas A. Bellinger wrote:

> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
[...]
> diff --git a/drivers/target/Makefile b/drivers/target/Makefile
> index 60028fe..b038b7d 100644
> --- a/drivers/target/Makefile
> +++ b/drivers/target/Makefile
> @@ -24,3 +24,4 @@ obj-$(CONFIG_TCM_PSCSI)		+= target_core_pscsi.o
>  
>  # Fabric modules
>  obj-$(CONFIG_TCM_LOOP_FABRIC)	+= tcm_loop/
> +obj-$(CONFIG_ISCSI_TARGET)	+= iscsi/
> diff --git a/drivers/target/iscsi/Kconfig b/drivers/target/iscsi/Kconfig
> new file mode 100644
> index 0000000..cc34243
> --- /dev/null
> +++ b/drivers/target/iscsi/Kconfig
> @@ -0,0 +1,17 @@
> +config ISCSI_TARGET
> +	tristate "Linux-iSCSI.org iSCSI Target Mode Stack"
> +	select CRYPTO
> +	select CRYPTO_CRC32C
> +	select CRYPTO_CRC32C_INTEL if X86
> +	help
> +	Say Y here to enable the ConfigFS enabled Linux-iSCSI.org iSCSI
> +	Target Mode Stack.
> +
> +if ISCSI_TARGET
> +
> +config ISCSI_TARGET_DEBUG
> +	bool "LIO-Target iscsi_debug.h ring buffer messages"
> +	help
> +	Say Y here to enable the legacy DEBUG_ISCSI macros in iscsi_debug.h
> +
> +endif
[...]

Perhaps this is a stupid question, but if these are "legacy" macros, why 
not save our users from having to deal with a new config option that is 
presumably going to go away again soon-ish and instead make those legacy 
macros go away sooner rather than later?

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

