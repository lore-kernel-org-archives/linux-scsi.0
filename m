From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target/cxgbit: add INET dependency
Date: Mon, 29 Feb 2016 21:28:28 -0800
Message-ID: <1456810108.19657.187.camel@haakon3.risingtidesystems.com>
References: <1456744504-3011977-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:33790 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbcCAF2b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2016 00:28:31 -0500
In-Reply-To: <1456744504-3011977-1-git-send-email-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Varun Prakash <varun@chelsio.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Arnd,

On Mon, 2016-02-29 at 12:14 +0100, Arnd Bergmann wrote:
> The newly added cxgbit driver directly calls functions of the
> IPv4 network stack, which fails if that is disabled:
> 
> ERROR: "ip_route_output_flow" [drivers/target/iscsi/cxgbit/cxgbit.ko] undefined!
> ERROR: "__ip_dev_find" [drivers/target/iscsi/cxgbit/cxgbit.ko] undefined!
> 
> This adds a Kconfig dependency to ensure we can't enable this
> driver without the complete network stack it needs.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: b7ca3321e114 ("cxgbit: add Kconfig and Makefile")
> ---
>  drivers/target/iscsi/cxgbit/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/target/iscsi/cxgbit/Kconfig b/drivers/target/iscsi/cxgbit/Kconfig
> index cf335b4dbb4e..ce6f5cca315d 100644
> --- a/drivers/target/iscsi/cxgbit/Kconfig
> +++ b/drivers/target/iscsi/cxgbit/Kconfig
> @@ -1,6 +1,7 @@
>  config ISCSI_TARGET_CXGB4
>  	tristate "Chelsio iSCSI target offload driver"
>  	depends on ISCSI_TARGET && CHELSIO_T4
> +	depends on INET
>  	select CHELSIO_T4_UWIRE
>  	---help---
>  	To compile this driver as module, choose M here: the module

Odd, ISCSI_TARGET already depends on NET, but I guess that's not enough
for cxgbit..  ;)

Varun, please pick this up and fold it into the original commit, with
proper credit to Arnd for finding this in the commit log.

