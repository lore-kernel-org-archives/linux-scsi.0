From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] libata-scsi: fix read-only bits checking in
 ata_mselect_*()
Date: Wed, 20 Jul 2016 13:20:07 -0400
Message-ID: <20160720172007.GH4574@htj.duckdns.org>
References: <578eaead.0198620a.7cf53.28c1@mx.google.com>
 <578eb0d1.e9b9420a.8694b.fc4c@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <578eb0d1.e9b9420a.8694b.fc4c@mx.google.com>
Sender: linux-ide-owner@vger.kernel.org
To: tom.ty89@gmail.com
Cc: hare@suse.de, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

So, just reverted this patch.

On Wed, Jul 20, 2016 at 06:59:23AM +0800, tom.ty89@gmail.com wrote:
> From: Tom Yan <tom.ty89@gmail.com>
> 
> Commit 7780081c1f04 ("libata-scsi: Set information sense field for
> invalid parameter") changed how ata_mselect_*() make sure read-only
> bits are not modified. The new implementation introduced a bug that
> the read-only bits in the byte that has a changeable bit will not
> be checked.
> 
> Added the necessary check, with comments explaining the heuristic.
> 
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 06afe63..b47c3ce 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -3617,8 +3617,18 @@ static int ata_mselect_caching(struct ata_queued_cmd *qc,
>  	 */
>  	ata_msense_caching(dev->id, mpage, false);
>  	for (i = 0; i < CACHE_MPAGE_LEN - 2; i++) {
> -		if (i == 0)
> -			continue;
> +		/* Check the first byte */
> +		if (i == 0) {
> +			/* except the WCE bit */
> +			if (mpage[i + 2] & 0xfb != buf[i] & 0xfb) {

This not only triggered compiler warning but is actually wrong.  The
above is

	mpage[i + 1] & (0xfb != buf[i]) & 0xfb

which is non-sensical.  So, this patch wasn't tested at all.  Not even
compile test.  Please don't do this.

Thanks.

-- 
tejun
