From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 02/11] target_core_alua: Store supported ALUA states
Date: Wed, 16 Oct 2013 14:19:07 -0700
Message-ID: <1381958347.19256.646.camel@haakon3.risingtidesystems.com>
References: <1381908048-82014-1-git-send-email-hare@suse.de>
	 <1381908048-82014-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:50422 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab3JPVKX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Oct 2013 17:10:23 -0400
In-Reply-To: <1381908048-82014-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2013-10-16 at 09:20 +0200, Hannes Reinecke wrote:
> The supported ALUA states might be different for individual
> devices, so store it in a separate field.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/target/target_core_alua.c | 14 ++++++++------
>  drivers/target/target_core_alua.h | 11 +++++++++++
>  include/target/target_core_base.h |  1 +
>  3 files changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
> index 8297d37..255e83c 100644
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
>  	if (def_group) {
>  		spin_lock(&dev->t10_alua.tg_pt_gps_lock);
>  		tg_pt_gp->tg_pt_gp_id =
> diff --git a/drivers/target/target_core_alua.h b/drivers/target/target_core_alua.h
> index 74cf0c0..e826a65 100644
> --- a/drivers/target/target_core_alua.h
> +++ b/drivers/target/target_core_alua.h
> @@ -23,6 +23,17 @@
>  #define ALUA_ACCESS_STATE_TRANSITION		0xf
>  
>  /*
> + * from spc4r36j section 6.37 Table 306
> + */
> +#define ALUA_T_SUP		0x80
> +#define ALUA_O_SUP		0x40
> +#define ALUA_LBD_SUP		0x10
> +#define ALUA_U_SUP		0x08
> +#define ALUA_S_SUP		0x04
> +#define ALUA_AN_SUP		0x02
> +#define ALUA_AO_SUP		0x01
> +
> +/*

How about making these the supported bits, TPGS mode, and ALUA access
state definitions common between target_core_alua.c and
scsi_dh_alua.c..?

--nab

