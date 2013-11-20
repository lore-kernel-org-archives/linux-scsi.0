From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 06/18] target_core_configfs: split up ALUA supported
 states
Date: Wed, 20 Nov 2013 11:39:30 -0800
Message-ID: <1384976370.4307.70.camel@haakon3.risingtidesystems.com>
References: <1384848483-3771-1-git-send-email-hare@suse.de>
	 <1384848483-3771-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1384848483-3771-7-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2013-11-19 at 09:07 +0100, Hannes Reinecke wrote:
> Split up the various ALUA states into individual attributes to
> make parsing easier and adhere to the one value per attribute
> sysfs principle.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---

Applied with one minor change below..

>  drivers/target/target_core_configfs.c | 127 ++++++++++++++++++++++------------
>  1 file changed, 84 insertions(+), 43 deletions(-)
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index 1e4ea28..8476f48 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c

<SNIP>

> -SE_DEV_ALUA_TG_PT_ATTR(alua_supported_states, S_IRUGO | S_IWUSR);
> +#define SE_DEV_ALUA_SUPPORT_STATE_STORE(_name, _var, _bit)		\
> +static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_support_##_name(\
> +	struct t10_alua_tg_pt_gp *t, const char *p, size_t c)		\
> +{									\
> +	unsigned long tmp;						\
> +	int ret;							\
> +									\
> +	if (!t->tg_pt_gp_valid_id) {					\
> +		pr_err("Unable to do set ##_name ALUA state on non"	\
> +		       " valid tg_pt_gp ID: %hu\n",			\
> +		       t->tg_pt_gp_valid_id);				\
> +		return -EINVAL;						\
> +	}								\
> +									\
> +	ret = strict_strtoul(p, 0, &tmp);				\

Converted to kstrtoul()

--nab
