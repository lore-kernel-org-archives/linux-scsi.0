From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: Fix 16-bit target ports for SET TARGET PORT
 GROUPS emulation
Date: Fri, 24 Feb 2012 17:12:52 -0800
Message-ID: <1330132372.4528.143.camel@haakon2.linux-iscsi.org>
References: <1330046532-3484-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:39710 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757074Ab2BYBMy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Feb 2012 20:12:54 -0500
In-Reply-To: <1330046532-3484-1-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On Thu, 2012-02-23 at 17:22 -0800, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> The old code did (MSB << 8) & 0xff, which always evaluates to 0.  Just use
> get_unaligned_be16() so we don't have to worry about whether our open-coded
> version is correct or not.
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---
>  drivers/target/target_core_alua.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
> index 01a2691..c7746a3 100644
> --- a/drivers/target/target_core_alua.c
> +++ b/drivers/target/target_core_alua.c
> @@ -30,6 +30,7 @@
>  #include <linux/export.h>
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_cmnd.h>
> +#include <asm/unaligned.h>
>  
>  #include <target/target_core_base.h>
>  #include <target/target_core_backend.h>
> @@ -267,8 +268,7 @@ int target_emulate_set_target_port_groups(struct se_task *task)
>  		 * changed.
>  		 */
>  		if (primary) {
> -			tg_pt_id = ((ptr[2] << 8) & 0xff);
> -			tg_pt_id |= (ptr[3] & 0xff);
> +			tg_pt_id = get_unaligned_be16(ptr + 2);
>  			/*
>  			 * Locate the matching target port group ID from
>  			 * the global tg_pt_gp list
> @@ -312,8 +312,7 @@ int target_emulate_set_target_port_groups(struct se_task *task)
>  			 * the Target Port in question for the the incoming
>  			 * SET_TARGET_PORT_GROUPS op.
>  			 */
> -			rtpi = ((ptr[2] << 8) & 0xff);
> -			rtpi |= (ptr[3] & 0xff);
> +			rtpi = get_unaligned_be16(ptr + 2);
>  			/*
>  			 * Locate the matching relative target port identifer
>  			 * for the struct se_device storage object.

Applied.  Thanks Roland!

--nab

