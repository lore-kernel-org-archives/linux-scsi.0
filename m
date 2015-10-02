From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 3/5] block: nvme-core: simplify ida usage
Date: Fri, 02 Oct 2015 12:15:45 +0200
Message-ID: <mqdsi5t7ezy.fsf@c203.arch.suse.de>
References: <cover.1443723136.git.lduncan@suse.com>
	<cover.1443723136.git.lduncan@suse.com>
	<cb1a4e9a77ed39c98072c70a0bebc9b98067852a.1443723136.git.lduncan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51504 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbbJBKPq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2015 06:15:46 -0400
In-Reply-To: <cb1a4e9a77ed39c98072c70a0bebc9b98067852a.1443723136.git.lduncan@suse.com>
	(Lee Duncan's message of "Thu, 1 Oct 2015 11:59:07 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <willy@linux.intel.com>, linux-nvme@lists.infradead.org

Lee Duncan <lduncan@suse.com> writes:

> Simplify ida index allocation and removal by
> using the ida_simple_* helper functions.
>
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> ---
>  drivers/block/nvme-core.c | 16 ++++------------
>  1 file changed, 4 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
> index d1d6141920d3..d354a3391e4a 100644
> --- a/drivers/block/nvme-core.c
> +++ b/drivers/block/nvme-core.c
> @@ -2713,18 +2713,10 @@ static DEFINE_IDA(nvme_instance_ida);
> =20
>  static int nvme_set_instance(struct nvme_dev *dev)
>  {
> -	int instance, error;
> +	int instance;
> =20
> -	do {
> -		if (!ida_pre_get(&nvme_instance_ida, GFP_KERNEL))
> -			return -ENODEV;
> -
> -		spin_lock(&dev_list_lock);
> -		error =3D ida_get_new(&nvme_instance_ida, &instance);
> -		spin_unlock(&dev_list_lock);
> -	} while (error =3D=3D -EAGAIN);
> -
> -	if (error)
> +	instance =3D ida_simple_get(&nvme_instance_ida, 0, 0, GFP_KERNEL);
> +	if (instance < 0)
>  		return -ENODEV;
> =20
>  	dev->instance =3D instance;
> @@ -2734,7 +2726,7 @@ static int nvme_set_instance(struct nvme_dev *d=
ev)
>  static void nvme_release_instance(struct nvme_dev *dev)
>  {
>  	spin_lock(&dev_list_lock);
> -	ida_remove(&nvme_instance_ida, dev->instance);
> +	ida_simple_remove(&nvme_instance_ida, dev->instance);
>  	spin_unlock(&dev_list_lock);
>  }

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
