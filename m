From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v3] Fix leak in
	drivers/target/iscsi/iscsi_target_parameters.c::iscsi_copy_param_list()
Date: Thu, 04 Aug 2011 11:04:12 -0700
Message-ID: <1312481052.22234.10.camel@haakon2.linux-iscsi.org>
References: <alpine.LNX.2.00.1108010017030.28695@swampdragon.chaosbits.net>
	 <1312152274.11635.8.camel@Joe-Laptop>
	 <alpine.LNX.2.00.1108012230080.31999@swampdragon.chaosbits.net>
	 <1312241542.11635.21.camel@Joe-Laptop>
	 <alpine.LNX.2.00.1108021023530.1692@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:54409 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab1HDSNq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2011 14:13:46 -0400
In-Reply-To: <alpine.LNX.2.00.1108021023530.1692@swampdragon.chaosbits.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Cc: Joe Perches <joe@perches.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, target-devel <target-devel@vger.kernel.org>

On Tue, 2011-08-02 at 10:26 +0200, Jesper Juhl wrote:
> On Mon, 1 Aug 2011, Joe Perches wrote:
> 
> > On Mon, 2011-08-01 at 22:32 +0200, Jesper Juhl wrote:
> > > diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
> > []
> > > @@ -572,6 +572,17 @@ int iscsi_copy_param_list(
> > []
> > > +		if (!new_param->name || !new_param->value) {
> > []
> > > +			pr_err("Unable to allocate memory for parameter "
> > > +				"name/value.\n");
> > 
> > I know you didn't change these lines, but could you please
> > remember to coalesce formats to a single line next time?
> > 
> 
> Ok, let me try once more. I hope this is now acceptable.
> 
> 
> From: Jesper Juhl <jj@chaosbits.net>
> Subject: [PATCH v3] Fix leak in drivers/target/iscsi/iscsi_target_parameters.c::iscsi_copy_param_list()
> 
> We leak memory if the allocations for 'new_param->name' or
> 'new_param->value' fail.
> 
> We also do a lot of variable assignments that are completely pointless
> if the allocations fail.
> 
> So, let's move the allocations before the assignments and also make
> sure that we free whatever was allocated to one if the allocation fail.
> 
> There's also some small CodingStyle fixups in there (curly braces on
> both branches of if statement, only one variable per line) since I was
> in the area anyway. And finally, error messages in the function are
> put on a single line for easy grep'abillity.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Hi Jesper,

This patch has been committed as 83f8b803171 into
lio-core-2.6.git/master, and will be queued into the next set of target
updates.

Thanks!

--nab

> ---
>  drivers/target/iscsi/iscsi_target_parameters.c |   43 +++++++++---------------
>  1 files changed, 16 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
> index 252e246..497b2e7 100644
> --- a/drivers/target/iscsi/iscsi_target_parameters.c
> +++ b/drivers/target/iscsi/iscsi_target_parameters.c
> @@ -545,13 +545,13 @@ int iscsi_copy_param_list(
>  	struct iscsi_param_list *src_param_list,
>  	int leading)
>  {
> -	struct iscsi_param *new_param = NULL, *param = NULL;
> +	struct iscsi_param *param = NULL;
> +	struct iscsi_param *new_param = NULL;
>  	struct iscsi_param_list *param_list = NULL;
>  
>  	param_list = kzalloc(sizeof(struct iscsi_param_list), GFP_KERNEL);
>  	if (!param_list) {
> -		pr_err("Unable to allocate memory for"
> -				" struct iscsi_param_list.\n");
> +		pr_err("Unable to allocate memory for struct iscsi_param_list.\n");
>  		goto err_out;
>  	}
>  	INIT_LIST_HEAD(&param_list->param_list);
> @@ -567,8 +567,17 @@ int iscsi_copy_param_list(
>  
>  		new_param = kzalloc(sizeof(struct iscsi_param), GFP_KERNEL);
>  		if (!new_param) {
> -			pr_err("Unable to allocate memory for"
> -				" struct iscsi_param.\n");
> +			pr_err("Unable to allocate memory for struct iscsi_param.\n");
> +			goto err_out;
> +		}
> +
> +		new_param->name = kstrdup(param->name, GFP_KERNEL);
> +		new_param->value = kstrdup(param->value, GFP_KERNEL);
> +		if (!new_param->value || !new_param->name) {
> +			kfree(new_param->value);
> +			kfree(new_param->name);
> +			kfree(new_param);
> +			pr_err("Unable to allocate memory for parameter name/value.\n");
>  			goto err_out;
>  		}
>  
> @@ -580,32 +589,12 @@ int iscsi_copy_param_list(
>  		new_param->use = param->use;
>  		new_param->type_range = param->type_range;
>  
> -		new_param->name = kzalloc(strlen(param->name) + 1, GFP_KERNEL);
> -		if (!new_param->name) {
> -			pr_err("Unable to allocate memory for"
> -				" parameter name.\n");
> -			goto err_out;
> -		}
> -
> -		new_param->value = kzalloc(strlen(param->value) + 1,
> -				GFP_KERNEL);
> -		if (!new_param->value) {
> -			pr_err("Unable to allocate memory for"
> -				" parameter value.\n");
> -			goto err_out;
> -		}
> -
> -		memcpy(new_param->name, param->name, strlen(param->name));
> -		new_param->name[strlen(param->name)] = '\0';
> -		memcpy(new_param->value, param->value, strlen(param->value));
> -		new_param->value[strlen(param->value)] = '\0';
> -
>  		list_add_tail(&new_param->p_list, &param_list->param_list);
>  	}
>  
> -	if (!list_empty(&param_list->param_list))
> +	if (!list_empty(&param_list->param_list)) {
>  		*dst_param_list = param_list;
> -	else {
> +	} else {
>  		pr_err("No parameters allocated.\n");
>  		goto err_out;
>  	}
> -- 
> 1.7.6
> 
> 
> -- 
> Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

