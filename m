From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 4/7] iscsi-target: Make a variable initialisation a bit
 more obvious in iscsi_create_default_params()
Date: Sat, 12 Dec 2015 15:45:55 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1512121545230.2512@hadrien>
References: <566ABCD9.1060404@users.sourceforge.net> <566C2F7B.6030704@users.sourceforge.net> <566C3225.4070100@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <566C3225.4070100@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On Sat, 12 Dec 2015, SF Markus Elfring wrote:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 12 Dec 2015 13:44:06 +0100
>
> The variable "pl" was declared and immediately assigned a return value
> from a function call in a separate statement.
>
> * Let us express the desired variable initialisation directly.
>
> * Avoid the repetition of the data type specification for the
>   involved memory allocation according to the Linux coding
>   style convention.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/target/iscsi/iscsi_target_parameters.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
> index e0b173d..3f3842f 100644
> --- a/drivers/target/iscsi/iscsi_target_parameters.c
> +++ b/drivers/target/iscsi/iscsi_target_parameters.c
> @@ -200,9 +200,8 @@ free_param:
>  int iscsi_create_default_params(struct iscsi_param_list **param_list_ptr)
>  {
>  	struct iscsi_param *param;
> -	struct iscsi_param_list *pl;
> +	struct iscsi_param_list *pl = kzalloc(sizeof(*pl), GFP_KERNEL);
>
> -	pl = kzalloc(sizeof(struct iscsi_param_list), GFP_KERNEL);

I don't see the benefit of this change, and the pattern assignment ->
failure test becomes more obscure.

julia

>  	if (!pl) {
>  		pr_err("Unable to allocate memory for"
>  				" struct iscsi_param_list.\n");
> --
> 2.6.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
