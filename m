From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 05/18] target_core_alua: Make supported states
 configurable
Date: Wed, 20 Nov 2013 11:36:53 -0800
Message-ID: <1384976213.4307.69.camel@haakon3.risingtidesystems.com>
References: <1384848483-3771-1-git-send-email-hare@suse.de>
	 <1384848483-3771-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:60127 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab3KTThB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Nov 2013 14:37:01 -0500
In-Reply-To: <1384848483-3771-6-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 2013-11-19 at 09:07 +0100, Hannes Reinecke wrote:
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---

Applied, with two minor changes below..

>  drivers/target/target_core_configfs.c | 50 +++++++++++++++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index 3a964fb..1e4ea28 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -2131,6 +2131,55 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_type(
>  SE_DEV_ALUA_TG_PT_ATTR(alua_access_type, S_IRUGO | S_IWUSR);
>  
>  /*
> + * alua_supported_states
> + */
> +static ssize_t target_core_alua_tg_pt_gp_show_attr_alua_supported_states(
> +	struct t10_alua_tg_pt_gp *tg_pt_gp,
> +	char *page)
> +{
> +	return sprintf(page, "%02x\n",
> +		tg_pt_gp->tg_pt_gp_alua_supported_states);
> +}
> +
> +static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_supported_states(
> +	struct t10_alua_tg_pt_gp *tg_pt_gp,
> +	const char *page,
> +	size_t count)
> +{
> +	unsigned long tmp;
> +	int new_states, valid_states, ret;
> +
> +	if (!tg_pt_gp->tg_pt_gp_valid_id) {
> +		pr_err("Unable to do set supported ALUA states on non"
> +			" valid tg_pt_gp ID: %hu\n",
> +			tg_pt_gp->tg_pt_gp_valid_id);
> +		return -EINVAL;
> +	}
> +
> +	ret = strict_strtoul(page, 0, &tmp);
> +	if (ret < 0) {
> +		pr_err("Unable to extract new supported ALUA states"
> +				" from %s\n", page);
> +		return -EINVAL;
> +	}

Changed strict_strtoul() -> kstrtoul()

> +	new_states = (int)tmp;
> +	valid_states = ALUA_T_SUP | ALUA_O_SUP | ALUA_LBD_SUP | \
> +	    ALUA_U_SUP | ALUA_S_SUP | ALUA_AN_SUP | ALUA_AO_SUP;
> +

Dropping the unnecessary line continuation here..

--nab

