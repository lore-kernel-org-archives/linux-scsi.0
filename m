From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 2/5] block: rsxx: core: simplify ida usage
Date: Fri, 02 Oct 2015 12:15:26 +0200
Message-ID: <mqdy4fl7f0h.fsf@c203.arch.suse.de>
References: <cover.1443723136.git.lduncan@suse.com>
	<cover.1443723136.git.lduncan@suse.com>
	<8d2f1dca7162a499d82de53be88110695334d8ef.1443723136.git.lduncan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8d2f1dca7162a499d82de53be88110695334d8ef.1443723136.git.lduncan@suse.com>
	(Lee Duncan's message of "Thu, 1 Oct 2015 11:59:06 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@infradead.org>, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Lee Duncan <lduncan@suse.com> writes:

> Simplify ida index allocation and removal by
> using the ida_simple_* helper functions.
>
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> ---
>  drivers/block/rsxx/core.c | 20 ++++----------------
>  1 file changed, 4 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/block/rsxx/core.c b/drivers/block/rsxx/core.c
> index d8b2488aaade..d2279a759b2e 100644
> --- a/drivers/block/rsxx/core.c
> +++ b/drivers/block/rsxx/core.c
> @@ -58,7 +58,6 @@ MODULE_PARM_DESC(sync_start, "On by Default: Driver=
 load will not complete "
>  			     "until the card startup has completed.");
> =20
>  static DEFINE_IDA(rsxx_disk_ida);
> -static DEFINE_SPINLOCK(rsxx_ida_lock);
> =20
>  /* --------------------Debugfs Setup ------------------- */
> =20
> @@ -774,19 +773,10 @@ static int rsxx_pci_probe(struct pci_dev *dev,
>  	card->dev =3D dev;
>  	pci_set_drvdata(dev, card);
> =20
> -	do {
> -		if (!ida_pre_get(&rsxx_disk_ida, GFP_KERNEL)) {
> -			st =3D -ENOMEM;
> -			goto failed_ida_get;
> -		}
> -
> -		spin_lock(&rsxx_ida_lock);
> -		st =3D ida_get_new(&rsxx_disk_ida, &card->disk_id);
> -		spin_unlock(&rsxx_ida_lock);
> -	} while (st =3D=3D -EAGAIN);
> -
> -	if (st)
> +	st =3D ida_simple_get(&rsxx_disk_ida, 0, 0, GFP_KERNEL);
> +	if (st < 0)
>  		goto failed_ida_get;
> +	card->disk_id =3D st;
> =20
>  	st =3D pci_enable_device(dev);
>  	if (st)
> @@ -987,9 +977,7 @@ failed_request_regions:
>  failed_dma_mask:
>  	pci_disable_device(dev);
>  failed_enable:
> -	spin_lock(&rsxx_ida_lock);
> -	ida_remove(&rsxx_disk_ida, card->disk_id);
> -	spin_unlock(&rsxx_ida_lock);
> +	ida_simple_remove(&rsxx_disk_ida, card->disk_id);
>  failed_ida_get:
>  	kfree(card);

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
