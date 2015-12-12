From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 1/7] iscsi-target: Use a variable initialisation in
 iscsi_set_default_param() directly
Date: Sat, 12 Dec 2015 22:49:40 +0300
Message-ID: <20151212194939.GQ5284@mwanda>
References: <566ABCD9.1060404@users.sourceforge.net>
 <566C2F7B.6030704@users.sourceforge.net>
 <566C308A.6000109@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <566C308A.6000109@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

On Sat, Dec 12, 2015 at 03:34:50PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 12 Dec 2015 11:36:02 +0100
> 
> Omit the unnecessary setting to a null pointer for the variable "param"
> at the beginning of the function "iscsi_set_default_param"
> because it can be directly initialized with the return value
> from the function "kzalloc".
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/target/iscsi/iscsi_target_parameters.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
> index 3a1f9a7..0a8bd3f 100644
> --- a/drivers/target/iscsi/iscsi_target_parameters.c
> +++ b/drivers/target/iscsi/iscsi_target_parameters.c
> @@ -127,9 +127,8 @@ static struct iscsi_param *iscsi_set_default_param(struct iscsi_param_list *para
>  		char *name, char *value, u8 phase, u8 scope, u8 sender,
>  		u16 type_range, u8 use)
>  {
> -	struct iscsi_param *param = NULL;
> +	struct iscsi_param *param = kzalloc(sizeof(*param), GFP_KERNEL);
>  
> -	param = kzalloc(sizeof(struct iscsi_param), GFP_KERNEL);
>  	if (!param) {
>  		pr_err("Unable to allocate memory for parameter.\n");
>  		goto out;

It's better to just get rid of the initialization but leave the
kzalloc() as-is for two reasons.

1)  Initializer code normally contains more bugs per line than other
    code.  I am thinking about dereferencing pointers before checking
    for NULL or not checking the allocation for failure.

2)  It puts a blank line between the allocation and the check for
    failure.  It's like a new paragraph.  The allocation and the check
    should be next to each other.

regards,
dan carpenter
