From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [RFC PATCH v2 1/8] block: Keyslot Manager for Inline
 Encryption
Date: Wed, 12 Jun 2019 11:26:44 -0700
Message-ID: <20190612182642.GB18795@gmail.com>
References: <20190605232837.31545-1-satyat@google.com>
 <20190605232837.31545-2-satyat@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20190605232837.31545-2-satyat@google.com>
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

On Wed, Jun 05, 2019 at 04:28:30PM -0700, Satya Tangirala wrote:
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 592669bcc536..f76d5dff27fe 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -385,6 +385,10 @@ static inline int blkdev_reset_zones_ioctl(struct block_device *bdev,
>  
>  #endif /* CONFIG_BLK_DEV_ZONED */
>  
> +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
> +struct keyslot_manager;
> +#endif
> +

This should be placed with the other forward declarations at the beginning of
the file.  It also doesn't need to be behind an #ifdef.  See e.g. struct
blkcg_gq which is another conditional field in struct request_queue.

> diff --git a/include/linux/keyslot-manager.h b/include/linux/keyslot-manager.h
> new file mode 100644
> index 000000000000..76a9c255cb7e
> --- /dev/null
> +++ b/include/linux/keyslot-manager.h
[...]
> +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
> +struct keyslot_manager;
> +
> +extern struct keyslot_manager *keyslot_manager_create(unsigned int num_slots,
> +				const struct keyslot_mgmt_ll_ops *ksm_ops,
> +				void *ll_priv_data);
> +
> +extern int
> +keyslot_manager_get_slot_for_key(struct keyslot_manager *ksm,
> +				 const u8 *key,
> +				 enum blk_crypt_mode_num crypt_mode,
> +				 unsigned int data_unit_size);
> +
> +extern void keyslot_manager_get_slot(struct keyslot_manager *ksm,
> +				     unsigned int slot);
> +
> +extern void keyslot_manager_put_slot(struct keyslot_manager *ksm,
> +				     unsigned int slot);
> +
> +extern int keyslot_manager_evict_key(struct keyslot_manager *ksm,
> +				     const u8 *key,
> +				     enum blk_crypt_mode_num crypt_mode,
> +				     unsigned int data_unit_size);
> +
> +extern void keyslot_manager_destroy(struct keyslot_manager *ksm);
> +
> +#else /* CONFIG_BLK_INLINE_ENCRYPTION */
> +struct keyslot_manager {};

This is actually a struct definition, not a declaration.  This doesn't make
sense, since the CONFIG_BLK_INLINE_ENCRYPTION case only needs a forward
declaration here.  Both cases should just use a forward declaration.

> +
> +static inline struct keyslot_manager *
> +keyslot_manager_create(unsigned int num_slots,
> +		       const struct keyslot_mgmt_ll_ops *ksm_ops,
> +		       void *ll_priv_data)
> +{
> +	return NULL;
> +}
> +
> +static inline int
> +keyslot_manager_get_slot_for_key(struct keyslot_manager *ksm,
> +				 const u8 *key,
> +				 enum blk_crypt_mode_num crypt_mode,
> +				 unsigned int data_unit_size)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static inline void keyslot_manager_get_slot(struct keyslot_manager *ksm,
> +					    unsigned int slot) { }
> +
> +static inline int keyslot_manager_put_slot(struct keyslot_manager *ksm,
> +					   unsigned int slot)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static inline int keyslot_manager_evict_key(struct keyslot_manager *ksm,
> +				     const u8 *key,
> +				     enum blk_crypt_mode_num crypt_mode,
> +				     unsigned int data_unit_size)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static inline void keyslot_manager_destroy(struct keyslot_manager *ksm)
> +{ }
> +
> +#endif /* CONFIG_BLK_INLINE_ENCRYPTION */

However, it seems we don't actually need these stub functions, since the
keyslot_manager_ functions are only called from .c files that are only compiled
when CONFIG_BLK_INLINE_ENCRYPTION, except for the call to
keyslot_manager_evict_key() in fscrypt_evict_crypt_key().  But it would make
more sense to stub out fscrypt_evict_crypt_key() instead.

So I suggest removing the keyslot_manager_* stubs for now.

- Eric
