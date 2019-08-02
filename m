From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 3/8] block: blk-crypto for Inline Encryption
Date: Fri, 2 Aug 2019 13:51:42 -0700
Message-ID: <c5bffc1e-ce6a-0060-cf55-e3dc446d7049@kernel.dk>
References: <20190710225609.192252-1-satyat@google.com>
 <20190710225609.192252-4-satyat@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20190710225609.192252-4-satyat@google.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Satya Tangirala <satyat@google.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Cc: Kuohong Wang <kuohong.wang@mediatek.com>, Ladvine D Almeida <ladvine.dalmeida@synopsys.com>, Barani Muthukumaran <bmuthuku@qti.qualcomm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Parshuram Raju Thombare <pthombar@cadence.com>
List-Id: linux-scsi@vger.kernel.org

On 7/10/19 4:56 PM, Satya Tangirala wrote:
> We introduce blk-crypto, which manages programming keyslots for struct
> bios. With blk-crypto, filesystems only need to call bio_crypt_set_ctx with
> the encryption key, algorithm and data_unit_num; they don't have to worry
> about getting a keyslot for each encryption context, as blk-crypto handles
> that. Blk-crypto also makes it possible for layered devices like device
> mapper to make use of inline encryption hardware.
> 
> Blk-crypto delegates crypto operations to inline encryption hardware when
> available, and also contains a software fallback to the kernel crypto API.
> For more details, refer to Documentation/block/blk-crypto.txt.
> 
> Known issues:
> 1) We're allocating crypto_skcipher in blk_crypto_keyslot_program, which
> uses GFP_KERNEL to allocate memory, but this function is on the write
> path for IO - we need to add support for specifying a different flags
> to the crypto API.

That's a must-fix before merging, btw.

> @@ -1018,7 +1019,9 @@ blk_qc_t generic_make_request(struct bio *bio)
>   			/* Create a fresh bio_list for all subordinate requests */
>   			bio_list_on_stack[1] = bio_list_on_stack[0];
>   			bio_list_init(&bio_list_on_stack[0]);
> -			ret = q->make_request_fn(q, bio);
> +
> +			if (!blk_crypto_submit_bio(&bio))
> +				ret = q->make_request_fn(q, bio);
>   
>   			blk_queue_exit(q);

Why isn't this just stacking the ->make_request_fn() instead? Then we
could get this out of the hot path.

-- 
Jens Axboe
