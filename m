From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [RFC PATCH v2 6/8] scsi: ufs: Add inline encryption
 support to UFS
Date: Thu, 13 Jun 2019 10:22:23 -0700
Message-ID: <20190613172223.GC686@sol.localdomain>
References: <20190605232837.31545-1-satyat@google.com>
 <20190605232837.31545-7-satyat@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20190605232837.31545-7-satyat@google.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Satya Tangirala <satyat@google.com>
Cc: Ladvine D Almeida <ladvine.dalmeida@synopsys.com>, linux-scsi@vger.kernel.org, Parshuram Raju Thombare <pthombar@cadence.com>, Kuohong Wang <kuohong.wang@mediatek.com>, Barani Muthukumaran <bmuthuku@qti.qualcomm.com>, linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 05, 2019 at 04:28:35PM -0700, Satya Tangirala wrote:
> +static inline int ufshcd_prepare_lrbp_crypto(struct ufs_hba *hba,
> +					     struct scsi_cmnd *cmd,
> +					     struct ufshcd_lrb *lrbp)
> +{
> +	int key_slot;
> +
> +	if (!bio_crypt_should_process(cmd->request->bio,
> +					cmd->request->q)) {
> +		lrbp->crypto_enable = false;
> +		return 0;
> +	}

Nit: this 'if' expression fits on one line.

>  static int ufshcd_slave_configure(struct scsi_device *sdev)
>  {
>  	struct request_queue *q = sdev->request_queue;
> +	struct ufs_hba *hba = shost_priv(sdev->host);
>  
>  	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
>  	blk_queue_max_segment_size(q, PRDT_DATA_BYTE_COUNT_MAX);
>  
> +	ufshcd_crypto_setup_rq_keyslot_manager(hba, q);
> +
>  	return 0;
>  }
>  
> @@ -4598,6 +4660,7 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
>  static void ufshcd_slave_destroy(struct scsi_device *sdev)
>  {
>  	struct ufs_hba *hba;
> +	struct request_queue *q = sdev->request_queue;
>  
>  	hba = shost_priv(sdev->host);
>  	/* Drop the reference as it won't be needed anymore */
> @@ -4608,6 +4671,8 @@ static void ufshcd_slave_destroy(struct scsi_device *sdev)
>  		hba->sdev_ufs_device = NULL;
>  		spin_unlock_irqrestore(hba->host->host_lock, flags);
>  	}
> +
> +	ufshcd_crypto_destroy_rq_keyslot_manager(q);
>  }

Each scsi_device is still getting its own keyslot manager.  As discussed before,
this is wrong because the keyslots are per-host controller, not per-device.

So the keyslot manager needs to be a property of the ufs_hba instead, and each
device's request_queue needs to reference that same keyslot manager.

> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index d3b6a6b57a37..283014e0924f 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -167,6 +167,9 @@ struct ufs_pm_lvl_states {
>   * @intr_cmd: Interrupt command (doesn't participate in interrupt aggregation)
>   * @issue_time_stamp: time stamp for debug purposes
>   * @compl_time_stamp: time stamp for statistics
> + * @crypto_enable: whether or not the request needs inline crypto operations
> + * @crypto_key_slot: the key slot to use for inline crypto
> + * @data_unit_num: the data unit number for the first block for inline crypto
>   * @req_abort_skip: skip request abort task flag
>   */
>  struct ufshcd_lrb {
> @@ -191,6 +194,9 @@ struct ufshcd_lrb {
>  	bool intr_cmd;
>  	ktime_t issue_time_stamp;
>  	ktime_t compl_time_stamp;
> +	bool crypto_enable;
> +	u8 crypto_key_slot;
> +	u64 data_unit_num;

Maybe these fields should be conditional on CONFIG_SCSI_UFS_CRYPTO too?

>  
>  	bool req_abort_skip;
>  };
> @@ -501,6 +507,10 @@ struct ufs_stats {
>   * @is_urgent_bkops_lvl_checked: keeps track if the urgent bkops level for
>   *  device is known or not.
>   * @scsi_block_reqs_cnt: reference counting for scsi block requests
> + * @crypto_capabilities: Content of crypto capabilities register (0x100)
> + * @crypto_cap_array: Array of crypto capabilities
> + * @crypto_cfg_register: Start of the crypto cfg array
> + * @crypto_cfgs: Array of crypto configurations (i.e. config for each slot)
>   */
>  struct ufs_hba {
>  	void __iomem *mmio_base;
> @@ -711,6 +721,14 @@ struct ufs_hba {
>  
>  	struct device		bsg_dev;
>  	struct request_queue	*bsg_queue;
> +
> +#ifdef CONFIG_SCSI_UFS_CRYPTO
> +	/* crypto */
> +	union ufs_crypto_capabilities crypto_capabilities;
> +	union ufs_crypto_cap_entry *crypto_cap_array;
> +	u32 crypto_cfg_register;
> +	union ufs_crypto_cfg_entry *crypto_cfgs;
> +#endif /* CONFIG_SCSI_UFS_CRYPTO */
>  };
>  
>  /* Returns true if clocks can be gated. Otherwise false */
> -- 
> 2.22.0.rc1.311.g5d7573a151-goog
> 

- Eric
