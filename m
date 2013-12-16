From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 27/32] target: Move call to remove_lun to the release
 function from drop_link
Date: Mon, 16 Dec 2013 13:51:39 -0800
Message-ID: <1387230699.20247.250.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1386979160-6928-28-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1386979160-6928-28-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-12-13 at 15:59 -0800, Andy Grover wrote:
> Configfs is still using the memory until release() is called, so it's not
> safe to free it in drop_link().
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/target_core_fabric_configfs.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 

No longer is applicable, given the previous NAKs.

--nab

> diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
> index 45a1763..1e584fa 100644
> --- a/drivers/target/target_core_fabric_configfs.c
> +++ b/drivers/target/target_core_fabric_configfs.c
> @@ -809,11 +809,19 @@ static int target_fabric_port_unlink(
>  		tf->tf_ops.fabric_pre_unlink(se_tpg, lun);
>  	}
>  
> -	core_tpg_remove_lun(se_tpg, lun);
>  	return 0;
>  }
>  
> +static void target_fabric_release_lun(struct config_item *item)
> +{
> +	struct se_lun *lun = container_of(to_config_group(item),
> +				struct se_lun, lun_group);
> +
> +	core_tpg_remove_lun(lun->lun_tpg, lun);
> +}
> +
>  static struct configfs_item_operations target_fabric_port_item_ops = {
> +	.release		= target_fabric_release_lun,
>  	.show_attribute		= target_fabric_port_attr_show,
>  	.store_attribute	= target_fabric_port_attr_store,
>  	.allow_link		= target_fabric_port_link,
