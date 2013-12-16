From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 17/32] target: Don't use void* when passing dev in
 core_tpg_add_lun
Date: Mon, 16 Dec 2013 13:29:41 -0800
Message-ID: <1387229381.20247.231.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1386979160-6928-18-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1386979160-6928-18-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-12-13 at 15:59 -0800, Andy Grover wrote:
> Especially since it's actually a device.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/target_core_internal.h |    2 +-
>  drivers/target/target_core_tpg.c      |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 

Applied to target-pending/for-next.

--nab

> diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
> index 4093936..aabb730 100644
> --- a/drivers/target/target_core_internal.h
> +++ b/drivers/target/target_core_internal.h
> @@ -89,7 +89,7 @@ void	core_tpg_add_node_to_devs(struct se_node_acl *, struct se_portal_group *);
>  void	core_tpg_wait_for_nacl_pr_ref(struct se_node_acl *);
>  struct se_lun *core_tpg_alloc_lun(struct se_portal_group *, u32);
>  int	core_tpg_add_lun(struct se_portal_group *, struct se_lun *,
> -		u32, void *);
> +		u32, struct se_device *);
>  struct se_lun *core_tpg_pre_dellun(struct se_portal_group *, u32 unpacked_lun);
>  int	core_tpg_post_dellun(struct se_portal_group *, struct se_lun *);
>  
> diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
> index 55a9d38..da7febb 100644
> --- a/drivers/target/target_core_tpg.c
> +++ b/drivers/target/target_core_tpg.c
> @@ -819,7 +819,7 @@ int core_tpg_add_lun(
>  	struct se_portal_group *tpg,
>  	struct se_lun *lun,
>  	u32 lun_access,
> -	void *lun_ptr)
> +	struct se_device *dev)
>  {
>  	int ret;
>  
> @@ -827,7 +827,7 @@ int core_tpg_add_lun(
>  	if (ret < 0)
>  		return ret;
>  
> -	ret = core_dev_export(lun_ptr, tpg, lun);
> +	ret = core_dev_export(dev, tpg, lun);
>  	if (ret < 0) {
>  		percpu_ref_cancel_init(&lun->lun_ref);
>  		return ret;
