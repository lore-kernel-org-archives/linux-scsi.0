From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 04/18] target_core_alua: Store supported ALUA states
Date: Wed, 20 Nov 2013 11:31:36 -0800
Message-ID: <1384975896.4307.68.camel@haakon3.risingtidesystems.com>
References: <1384848483-3771-1-git-send-email-hare@suse.de>
	 <1384848483-3771-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:34471 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab3KTTbn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Nov 2013 14:31:43 -0500
In-Reply-To: <1384848483-3771-5-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 2013-11-19 at 09:07 +0100, Hannes Reinecke wrote:
> The supported ALUA states might be different for individual
> devices, so store it in a separate field.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Applied, with one minor change below..

> ---
>  drivers/target/target_core_alua.c | 14 ++++++++------
>  drivers/target/target_core_alua.h | 11 +++++++++++
>  include/target/target_core_base.h |  1 +
>  3 files changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
> index 08e41e3..a16115e 100644
> --- a/drivers/target/target_core_alua.c
> +++ b/drivers/target/target_core_alua.c
> @@ -117,12 +117,7 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
>  		/*
>  		 * Set supported ASYMMETRIC ACCESS State bits
>  		 */
> -		buf[off] = 0x80; /* T_SUP */
> -		buf[off] |= 0x40; /* O_SUP */
> -		buf[off] |= 0x8; /* U_SUP */
> -		buf[off] |= 0x4; /* S_SUP */
> -		buf[off] |= 0x2; /* AN_SUP */
> -		buf[off++] |= 0x1; /* AO_SUP */
> +		buf[off++] |= tg_pt_gp->tg_pt_gp_alua_supported_states;
>  		/*
>  		 * TARGET PORT GROUP
>  		 */
> @@ -1367,6 +1362,13 @@ struct t10_alua_tg_pt_gp *core_alua_allocate_tg_pt_gp(struct se_device *dev,
>  	tg_pt_gp->tg_pt_gp_trans_delay_msecs = ALUA_DEFAULT_TRANS_DELAY_MSECS;
>  	tg_pt_gp->tg_pt_gp_implicit_trans_secs = ALUA_DEFAULT_IMPLICIT_TRANS_SECS;
>  
> +	/*
> +	 * Enable all supported states
> +	 */
> +	tg_pt_gp->tg_pt_gp_alua_supported_states =
> +	    ALUA_T_SUP | ALUA_O_SUP | \
> +	    ALUA_U_SUP | ALUA_S_SUP | ALUA_AN_SUP | ALUA_AO_SUP;
> +

Dropping the unnecessary line continuation here..

--nab

