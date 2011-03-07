From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] [SCSI] target: Add __init/__exit annotation for
	target_core_init_configfs/target_core_exit_configfs
Date: Sun, 06 Mar 2011 22:44:33 -0800
Message-ID: <1299480273.19683.201.camel@haakon2.linux-iscsi.org>
References: <1299467950.4791.1.camel@mola>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:49230 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab1CGGvT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2011 01:51:19 -0500
In-Reply-To: <1299467950.4791.1.camel@mola>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2011-03-07 at 11:19 +0800, Axel Lin wrote:
> This patch fixes below section mismatch warning.
> WARNING: vmlinux.o(.text+0x21617a): Section mismatch in reference from the function target_core_init_configfs() to the function .init.text:rd_module_init()
> The function target_core_init_configfs() references
> the function __init rd_module_init().
> This is often because target_core_init_configfs lacks a __init
> annotation or the annotation of rd_module_init is wrong.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/target/target_core_configfs.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 

Hi Axel,

I have committed this patch with a few minor commit-log cleanups into
lio-core-2.6.git/lio-4.1 here:

Created commit dbb7295:: target: Add __init/__exit annotation for target_core_[init,exit]_configfs
 1 files changed, 2 insertions(+), 2 deletions(-)

This will get cherry-picked into lio v4.0 branches shortly, and I will
queue up as a for-39 mainline fix.

Thanks for your patch!

--nab

> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index caf8dc1..378835e 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -3044,7 +3044,7 @@ static struct config_item_type target_core_cit = {
>  
>  /* Stop functions for struct config_item_type target_core_hba_cit */
>  
> -static int target_core_init_configfs(void)
> +static int __init target_core_init_configfs(void)
>  {
>  	struct config_group *target_cg, *hba_cg = NULL, *alua_cg = NULL;
>  	struct config_group *lu_gp_cg = NULL;
> @@ -3176,7 +3176,7 @@ out_global:
>  	return -1;
>  }
>  
> -static void target_core_exit_configfs(void)
> +static void __exit target_core_exit_configfs(void)
>  {
>  	struct configfs_subsystem *subsys;
>  	struct config_group *hba_cg, *alua_cg, *lu_gp_cg;

