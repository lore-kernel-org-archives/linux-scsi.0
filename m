Received: from bsdbackstore.eu (128-116-240-228.dyn.eolo.it [128.116.240.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AFC225A24;
	Tue,  9 Sep 2025 15:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=128.116.240.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757432197; cv=none; b=j5bwoPXFDh264PqMSOSrJUvfTA79P33H99LrhUjjKqQHI2TlagxYKLXrAPS/DfmYCmeAceUufW1Eq4lMkVGMRfVGKr1h+N1a1B2B5Yr3ausmhaEtu/SJ3NiJARf78g+JFnvDK23VsciUUNJq388104Kb3el5dyb8EwbBM471v/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757432197; c=relaxed/simple;
	bh=Us2TImS5n8zsLC57pCSvx8XowpVsgExx6rKofhsxVhw=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:
	 References:In-Reply-To; b=e+Jno262UnkI2dOrsgJfp9Fq8y9h/dBVmHukQ7lzGbN6kVy8Nr+MmAKlzV1MoAR2jgp3nOELUNtfwZ+Xq0+K/c+PVgrM8qUskk5oQ+2+Mc/vA0k/Oswm4cQCK8Fi0T4HJRCBSLoopjyYwu2qtOh9iOVPmKjqKHAxlu3qHEZNNls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bsdbackstore.eu; spf=pass smtp.mailfrom=bsdbackstore.eu; arc=none smtp.client-ip=128.116.240.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bsdbackstore.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsdbackstore.eu
Received: from localhost (128-116-240-228.dyn.eolo.it [128.116.240.228])
	by bsdbackstore.eu (OpenSMTPD) with ESMTPSA id 54619179 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Tue, 9 Sep 2025 17:36:24 +0200 (CEST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 09 Sep 2025 17:36:24 +0200
Message-Id: <DCODPRWQNASG.2WN8KKSW05R13@bsdbackstore.eu>
Subject: Re: [PATCH v2 3/3] scsi: target: Move LUN stats to per CPU
From: "Maurizio Lombardi" <mlombard@bsdbackstore.eu>
To: "Mike Christie" <michael.christie@oracle.com>, <bvanassche@acm.org>,
 <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
 <target-devel@vger.kernel.org>
X-Mailer: aerc
References: <20250908231000.10777-1-michael.christie@oracle.com>
 <20250908231000.10777-4-michael.christie@oracle.com>
In-Reply-To: <20250908231000.10777-4-michael.christie@oracle.com>

On Tue Sep 9, 2025 at 1:05 AM CEST, Mike Christie wrote:
> The atomic use in the main I/O path is causing perf issues when using
> higher performance backend devices and multiple queues (more than
> 10 when using vhost-scsi) like with this fio workload:
>
> [global]
> bs=3D4K
> iodepth=3D128
> direct=3D1
> ioengine=3Dlibaio
> group_reporting
> time_based
> runtime=3D120
> name=3Dstandard-iops
> rw=3Drandread
> numjobs=3D16
> cpus_allowed=3D0-15
>
> To fix this issue, this moves the LUN stats to per CPU.
>
> Note: I forgot to include this patch with the delayed/ordered per CPU
> tracking and per device/device entry per CPU stats. With this patch you
> get the full 33% improvements when using fast backends, multiple queues
> and multiple IO submiters.
>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/target/target_core_device.c          |  1 +
>  drivers/target/target_core_fabric_configfs.c |  2 +-
>  drivers/target/target_core_internal.h        |  1 +
>  drivers/target/target_core_stat.c            | 67 +++++++-------------
>  drivers/target/target_core_tpg.c             | 25 +++++++-
>  drivers/target/target_core_transport.c       | 22 +++++--
>  include/target/target_core_base.h            |  8 +--
>  7 files changed, 67 insertions(+), 59 deletions(-)
>
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_=
core_device.c
> index 7bb711b24c0d..2d4a7c0c69ce 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -814,6 +814,7 @@ struct se_device *target_alloc_device(struct se_hba *=
hba, const char *name)
>  	dev->dev_attrib.max_write_same_len =3D DA_MAX_WRITE_SAME_LEN;
>  	dev->dev_attrib.submit_type =3D TARGET_FABRIC_DEFAULT_SUBMIT;
> =20
> +	/* Skip allocating lun_stats since we can't export them. */
>  	xcopy_lun =3D &dev->xcopy_lun;
>  	rcu_assign_pointer(xcopy_lun->lun_se_dev, dev);
>  	init_completion(&xcopy_lun->lun_shutdown_comp);
> diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/targe=
t/target_core_fabric_configfs.c
> index 7156a4dc1ca7..13159928e365 100644
> --- a/drivers/target/target_core_fabric_configfs.c
> +++ b/drivers/target/target_core_fabric_configfs.c
> @@ -697,7 +697,7 @@ static void target_fabric_port_release(struct config_=
item *item)
>  	struct se_lun *lun =3D container_of(to_config_group(item),
>  					  struct se_lun, lun_group);
> =20
> -	kfree_rcu(lun, rcu_head);
> +	call_rcu(&lun->rcu_head, target_tpg_free_lun);
>  }
> =20
>  static struct configfs_item_operations target_fabric_port_item_ops =3D {
> diff --git a/drivers/target/target_core_internal.h b/drivers/target/targe=
t_core_internal.h
> index 20aab1f50565..763e6d26e187 100644
> --- a/drivers/target/target_core_internal.h
> +++ b/drivers/target/target_core_internal.h
> @@ -125,6 +125,7 @@ void	core_tpg_add_node_to_devs(struct se_node_acl *, =
struct se_portal_group *,
>  				  struct se_lun *);
>  void	core_tpg_wait_for_nacl_pr_ref(struct se_node_acl *);
>  struct se_lun *core_tpg_alloc_lun(struct se_portal_group *, u64);
> +void	target_tpg_free_lun(struct rcu_head *head);
>  int	core_tpg_add_lun(struct se_portal_group *, struct se_lun *,
>  		bool, struct se_device *);
>  void core_tpg_remove_lun(struct se_portal_group *, struct se_lun *);
> diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_co=
re_stat.c
> index e29d43dacaf7..083205052be2 100644
> --- a/drivers/target/target_core_stat.c
> +++ b/drivers/target/target_core_stat.c
> @@ -606,53 +606,30 @@ static ssize_t target_stat_tgt_port_port_index_show=
(struct config_item *item,
>  	return ret;
>  }
> =20
> -static ssize_t target_stat_tgt_port_in_cmds_show(struct config_item *ite=
m,
> -		char *page)
> -{
> -	struct se_lun *lun =3D to_stat_tgt_port(item);
> -	struct se_device *dev;
> -	ssize_t ret =3D -ENODEV;
> -
> -	rcu_read_lock();
> -	dev =3D rcu_dereference(lun->lun_se_dev);
> -	if (dev)
> -		ret =3D snprintf(page, PAGE_SIZE, "%lu\n",
> -			       atomic_long_read(&lun->lun_stats.cmd_pdus));
> -	rcu_read_unlock();
> -	return ret;
> -}
> -
> -static ssize_t target_stat_tgt_port_write_mbytes_show(struct config_item=
 *item,
> -		char *page)
> -{
> -	struct se_lun *lun =3D to_stat_tgt_port(item);
> -	struct se_device *dev;
> -	ssize_t ret =3D -ENODEV;
> -
> -	rcu_read_lock();
> -	dev =3D rcu_dereference(lun->lun_se_dev);
> -	if (dev)
> -		ret =3D snprintf(page, PAGE_SIZE, "%u\n",
> -			(u32)(atomic_long_read(&lun->lun_stats.rx_data_octets) >> 20));
> -	rcu_read_unlock();
> -	return ret;
> +#define tgt_port_show_per_cpu_stat(prefix, field, shift)		\
> +per_cpu_stat_snprintf(scsi_port_stats, prefix, field, shift);		\
> +static ssize_t								\
> +target_stat_##prefix##_show(struct config_item *item, char *page)	\
> +{									\
> +	struct se_lun *lun =3D to_stat_tgt_port(item);			\
> +	struct se_device *dev;						\
> +	int ret;							\
> +									\
> +	rcu_read_lock();						\
> +	dev =3D rcu_dereference(lun->lun_se_dev);				\
> +	if (!dev) {							\
> +		rcu_read_unlock();					\
> +		return -ENODEV;						\
> +	}								\
> +									\
> +	ret =3D per_cpu_stat_##prefix##_snprintf(lun->lun_stats, page);	\
> +	rcu_read_unlock();						\
> +	return ret;							\
>  }
> =20
> -static ssize_t target_stat_tgt_port_read_mbytes_show(struct config_item =
*item,
> -		char *page)
> -{
> -	struct se_lun *lun =3D to_stat_tgt_port(item);
> -	struct se_device *dev;
> -	ssize_t ret =3D -ENODEV;
> -
> -	rcu_read_lock();
> -	dev =3D rcu_dereference(lun->lun_se_dev);
> -	if (dev)
> -		ret =3D snprintf(page, PAGE_SIZE, "%u\n",
> -				(u32)(atomic_long_read(&lun->lun_stats.tx_data_octets) >> 20));
> -	rcu_read_unlock();
> -	return ret;
> -}
> +tgt_port_show_per_cpu_stat(tgt_port_in_cmds, cmd_pdus, 0);
> +tgt_port_show_per_cpu_stat(tgt_port_write_mbytes, rx_data_octets, 20);
> +tgt_port_show_per_cpu_stat(tgt_port_read_mbytes, tx_data_octets, 20);
> =20
>  static ssize_t target_stat_tgt_port_hs_in_cmds_show(struct config_item *=
item,
>  		char *page)
> diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_cor=
e_tpg.c
> index c0e429e5ef31..540ff15882c9 100644
> --- a/drivers/target/target_core_tpg.c
> +++ b/drivers/target/target_core_tpg.c
> @@ -548,7 +548,7 @@ int core_tpg_register(
>  		ret =3D core_tpg_add_lun(se_tpg, se_tpg->tpg_virt_lun0,
>  				true, g_lun0_dev);
>  		if (ret < 0) {
> -			kfree(se_tpg->tpg_virt_lun0);
> +			target_tpg_free_lun(&se_tpg->tpg_virt_lun0->rcu_head);
>  			return ret;
>  		}
>  	}
> @@ -595,7 +595,7 @@ int core_tpg_deregister(struct se_portal_group *se_tp=
g)
> =20
>  	if (se_tpg->proto_id >=3D 0) {
>  		core_tpg_remove_lun(se_tpg, se_tpg->tpg_virt_lun0);
> -		kfree_rcu(se_tpg->tpg_virt_lun0, rcu_head);
> +		call_rcu(&se_tpg->tpg_virt_lun0->rcu_head, target_tpg_free_lun);
>  	}
> =20
>  	target_tpg_deregister_rtpi(se_tpg);
> @@ -609,12 +609,21 @@ struct se_lun *core_tpg_alloc_lun(
>  	u64 unpacked_lun)
>  {
>  	struct se_lun *lun;
> +	int ret;
> =20
>  	lun =3D kzalloc(sizeof(*lun), GFP_KERNEL);
>  	if (!lun) {
>  		pr_err("Unable to allocate se_lun memory\n");
>  		return ERR_PTR(-ENOMEM);
>  	}
> +
> +	lun->lun_stats =3D alloc_percpu(struct scsi_port_stats);
> +	if (!lun->lun_stats) {
> +		pr_err("Unable to allocate se_lun stats memory\n");
> +		ret =3D -ENOMEM;
> +		goto free_lun;
> +	}
> +
>  	lun->unpacked_lun =3D unpacked_lun;
>  	atomic_set(&lun->lun_acl_count, 0);
>  	init_completion(&lun->lun_shutdown_comp);
> @@ -628,6 +637,18 @@ struct se_lun *core_tpg_alloc_lun(
>  	lun->lun_tpg =3D tpg;
> =20
>  	return lun;
> +
> +free_lun:
> +	kfree(lun);
> +	return ERR_PTR(-ENOMEM);
> +}

nit: "ret" is set to -ENOMEM but never used, it can be removed.

Maurizio

