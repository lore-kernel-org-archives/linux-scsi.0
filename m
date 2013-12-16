From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 04/32] target: Fix sizeof in kmalloc for some
 default_groups arrays
Date: Mon, 16 Dec 2013 12:43:34 -0800
Message-ID: <1387226614.20247.195.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1386979160-6928-5-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1386979160-6928-5-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-12-13 at 15:58 -0800, Andy Grover wrote:
> Allocating an array of pointers, not the objects themselves. These two
> sites now match all the other sites.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/target_core_configfs.c        |    2 +-
>  drivers/target/target_core_fabric_configfs.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 

Applied to for-next.

--nab

> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index 272755d..a1c23d1 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -2937,7 +2937,7 @@ static int __init target_core_init_configfs(void)
>  	 * and ALUA Logical Unit Group and Target Port Group infrastructure.
>  	 */
>  	target_cg = &subsys->su_group;
> -	target_cg->default_groups = kmalloc(sizeof(struct config_group) * 2,
> +	target_cg->default_groups = kmalloc(sizeof(struct config_group *) * 2,
>  				GFP_KERNEL);
>  	if (!target_cg->default_groups) {
>  		pr_err("Unable to allocate target_cg->default_groups\n");
> diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
> index fdadc4d..7de9f04 100644
> --- a/drivers/target/target_core_fabric_configfs.c
> +++ b/drivers/target/target_core_fabric_configfs.c
> @@ -906,7 +906,7 @@ static struct config_group *target_fabric_make_lun(
>  	lun_cg->default_groups[1] = NULL;
>  
>  	port_stat_grp = &lun->port_stat_grps.stat_group;
> -	port_stat_grp->default_groups =  kzalloc(sizeof(struct config_group) * 4,
> +	port_stat_grp->default_groups =  kzalloc(sizeof(struct config_group *) * 4,
>  				GFP_KERNEL);
>  	if (!port_stat_grp->default_groups) {
>  		pr_err("Unable to allocate port_stat_grp->default_groups\n");
