From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 24/32] target: Remove tpg from core_dev_export/unexport
 params
Date: Mon, 16 Dec 2013 13:46:14 -0800
Message-ID: <1387230374.20247.244.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1386979160-6928-25-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1386979160-6928-25-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-12-13 at 15:59 -0800, Andy Grover wrote:
> lun->lun_tpg should always be set.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/target_core_device.c   |   17 +++++++----------
>  drivers/target/target_core_internal.h |    6 ++----
>  drivers/target/target_core_tpg.c      |    4 ++--
>  3 files changed, 11 insertions(+), 16 deletions(-)
> 

Ditto here, skipping..

--nab

> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index 753e7ca..a432d7b 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -583,7 +583,6 @@ static void core_release_port(struct se_device *dev, struct se_port *port)
>  
>  int core_dev_export(
>  	struct se_device *dev,
> -	struct se_portal_group *tpg,
>  	struct se_lun *lun)
>  {
>  	struct se_hba *hba = dev->se_hba;
> @@ -599,17 +598,13 @@ int core_dev_export(
>  	dev->export_count++;
>  	spin_unlock(&hba->device_lock);
>  
> -	core_export_port(dev, tpg, port, lun);
> +	core_export_port(dev, lun->lun_tpg, port, lun);
>  	return 0;
>  }
>  
> -void core_dev_unexport(
> -	struct se_device *dev,
> -	struct se_portal_group *tpg,
> -	struct se_lun *lun)
> +void core_dev_unexport(struct se_lun *lun)
>  {
> -	struct se_hba *hba = dev->se_hba;
> -	struct se_port *port = lun->lun_sep;
> +	struct se_hba *hba;
>  
>  	spin_lock(&lun->lun_sep_lock);
>  	if (lun->lun_se_dev == NULL) {
> @@ -618,10 +613,12 @@ void core_dev_unexport(
>  	}
>  	spin_unlock(&lun->lun_sep_lock);
>  
> -	core_release_port(dev, port);
> +	core_release_port(lun->lun_se_dev, lun->lun_sep);
> +
> +	hba = lun->lun_se_dev->se_hba;
>  
>  	spin_lock(&hba->device_lock);
> -	dev->export_count--;
> +	lun->lun_se_dev->export_count--;
>  	spin_unlock(&hba->device_lock);
>  
>  	lun->lun_se_dev = NULL;
> diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
> index 4d3b559..5b232a7 100644
> --- a/drivers/target/target_core_internal.h
> +++ b/drivers/target/target_core_internal.h
> @@ -16,10 +16,8 @@ int	core_enable_device_list_for_node(struct se_lun *, struct se_lun_acl *,
>  void	core_disable_device_list_for_node(struct se_lun *, struct se_dev_entry *,
>  		u32, struct se_node_acl *, struct se_portal_group *);
>  void	core_clear_lun_from_tpg(struct se_lun *, struct se_portal_group *);
> -int	core_dev_export(struct se_device *, struct se_portal_group *,
> -		struct se_lun *);
> -void	core_dev_unexport(struct se_device *, struct se_portal_group *,
> -		struct se_lun *);
> +int	core_dev_export(struct se_device *, struct se_lun *);
> +void	core_dev_unexport(struct se_lun *);
>  int	se_dev_set_task_timeout(struct se_device *, u32);
>  int	se_dev_set_max_unmap_lba_count(struct se_device *, u32);
>  int	se_dev_set_max_unmap_block_desc_count(struct se_device *, u32);
> diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
> index c63f6cd..d9fbdd0 100644
> --- a/drivers/target/target_core_tpg.c
> +++ b/drivers/target/target_core_tpg.c
> @@ -765,7 +765,7 @@ int core_tpg_add_lun(
>  {
>  	int ret;
>  
> -	ret = core_dev_export(dev, tpg, lun);
> +	ret = core_dev_export(dev, lun);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -803,6 +803,6 @@ void core_tpg_remove_lun(
>  	struct se_lun *lun)
>  {
>  	core_clear_lun_from_tpg(lun, tpg);
> -	core_dev_unexport(lun->lun_se_dev, tpg, lun);
> +	core_dev_unexport(lun);
>  	put_lun(lun);
>  }
