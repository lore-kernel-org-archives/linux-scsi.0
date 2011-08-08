From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 7/9] drivers/target/iscsi/iscsi_target_parameters.c:
	add missing kfree
Date: Mon, 08 Aug 2011 14:11:54 -0700
Message-ID: <1312837914.12502.92.camel@haakon2.linux-iscsi.org>
References: <1312802283-9107-7-git-send-email-julia@diku.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1312802283-9107-7-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <julia@diku.dk>
Cc: kernel-janitors@vger.kernel.org, Andy Grover <agrover@redhat.com>, Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-08-08 at 13:18 +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> At this point, the new_param that has just been allocated has not been
> stored in the list, so it and new_param->name, once it is defined, have to
> be freed separately.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @exists@
> local idexpression x;
> statement S,S1;
> expression E;
> identifier fl;
> expression *ptr != NULL;
> @@
> 
> x = \(kmalloc\|kzalloc\|kcalloc\)(...);
> ...
> if (x == NULL) S
> <... when != x
>      when != if (...) { <+...kfree(x)...+> }
>      when any
>      when != true x == NULL
> x->fl
> ...>
> (
> if (x == NULL) S1
> |
> if (...) { ... when != x
>                when forall
> (
>  return \(0\|<+...x...+>\|ptr\);
> |
> * return ...;
> )
> }
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/target/iscsi/iscsi_target_parameters.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
> index 252e246..b8dbe44 100644
> --- a/drivers/target/iscsi/iscsi_target_parameters.c
> +++ b/drivers/target/iscsi/iscsi_target_parameters.c
> @@ -584,6 +584,7 @@ int iscsi_copy_param_list(
>  		if (!new_param->name) {
>  			pr_err("Unable to allocate memory for"
>  				" parameter name.\n");
> +			kfree(new_param);
>  			goto err_out;
>  		}
>  
> @@ -592,6 +593,8 @@ int iscsi_copy_param_list(
>  		if (!new_param->value) {
>  			pr_err("Unable to allocate memory for"
>  				" parameter value.\n");
> +			kfree(new_param->name);
> +			kfree(new_param);
>  			goto err_out;
>  		}
>  
> 

Hi Julia,

Jesper and Dan already caught this one last week, and has been resolved
with the following patch in lio-core-2.6.git:

commit 83f8b803171751082174162cd1fa058c67d579ab
Author: Jesper Juhl <jj@chaosbits.net>
Date:   Tue Aug 2 10:26:36 2011 +0200

    iscsi-target: Fix leak on failure in iscsi_copy_param_list()

This one is being queued for the next round of target fixes for
mainline.

Thanks for reporting!

--nab
