From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 03/11] target_core_alua: Make supported states
 configurable
Date: Wed, 16 Oct 2013 14:38:31 -0700
Message-ID: <1381959511.19256.650.camel@haakon3.risingtidesystems.com>
References: <1381908048-82014-1-git-send-email-hare@suse.de>
	 <1381908048-82014-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1381908048-82014-4-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2013-10-16 at 09:20 +0200, Hannes Reinecke wrote:
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/target/target_core_configfs.c | 50 +++++++++++++++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index d4c28a3..53e9e00 100644
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
> +	new_states = (int)tmp;
> +	valid_states = ALUA_T_SUP | ALUA_O_SUP | ALUA_LBD_SUP | \
> +	    ALUA_U_SUP | ALUA_S_SUP | ALUA_AN_SUP | ALUA_AO_SUP;
> +
> +
> +	if (new_states & ~valid_states) {
> +		pr_err("Illegal supported ALUA states: 0x%02x\n",
> +				new_states);
> +		return -EINVAL;
> +	}
> +
> +	tg_pt_gp->tg_pt_gp_alua_supported_states = new_states;
> +	return count;
> +}
> +
> +SE_DEV_ALUA_TG_PT_ATTR(alua_supported_states, S_IRUGO | S_IWUSR);
> +
> +/*
>   * alua_write_metadata
>   */
>  static ssize_t target_core_alua_tg_pt_gp_show_attr_alua_write_metadata(
> @@ -2350,6 +2399,7 @@ static struct configfs_attribute *target_core_alua_tg_pt_gp_attrs[] = {
>  	&target_core_alua_tg_pt_gp_alua_access_state.attr,
>  	&target_core_alua_tg_pt_gp_alua_access_status.attr,
>  	&target_core_alua_tg_pt_gp_alua_access_type.attr,
> +	&target_core_alua_tg_pt_gp_alua_supported_states.attr,
>  	&target_core_alua_tg_pt_gp_alua_write_metadata.attr,
>  	&target_core_alua_tg_pt_gp_nonop_delay_msecs.attr,
>  	&target_core_alua_tg_pt_gp_trans_delay_msecs.attr,

I'm thinking this might be better served by individual attributes
representing the seven supported ALUA states, instead of a single
attribute representing them all..

That would certainly make it easier for userspace to manipulate..

--nab
