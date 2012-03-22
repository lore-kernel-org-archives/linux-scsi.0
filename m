From: Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [PATCH] [SCSI] scsi_lib: use correct DMA device in __scsi_alloc_queue
Date: Thu, 22 Mar 2012 15:24:23 +0400
Message-ID: <4F6B0BE7.8050707@mvista.com>
References: <1332395550.3793.58.camel@minggr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1332395550.3793.58.camel@minggr>
Sender: linux-ide-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, =?UTF-8?B?SsO2cmcg?= =?UTF-8?B?U29tbWVy?= <joerg@alea.gnuu.de>, Jeff Garzik <jgarzik@redhat.com>, Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello.

On 22-03-2012 9:52, Lin Ming wrote:

> Currently, __scsi_alloc_queue uses SCSI host's parent device
> as DMA device to set segment boundary. But the parent device may not
> refer to the DMA device. For example, for ATA disk, SCSI host's paren=
t
> device now refers to ATA port.

> Since commit d139b9b([SCSI] scsi_lib_dma: fix bug with dma maps on
> nested scsi objects), a new field Scsi_Host->dma_device was introduce=
d

    Only the field is named 'dma_dev', isn't it?

> to refer to the real DMA device.

> Use ->dma_device in __scsi_alloc_queue to correctly set segment
> boundary.

> And use scsi_add_host_with_dma in ata_scsi_add_hosts to pass in the
> correct DMA device.

    Perhaps this should be split into two patches.

> Bug report: http://marc.info/?l=3Dlinux-ide&m=3D133177818318187&w=3D2

> Reported-and-tested-by: J=C3=B6rg Sommer<joerg@alea.gnuu.de>
> Signed-off-by: Lin Ming<ming.m.lin@intel.com>
[...]

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index f85cfa6..486088b 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1642,7 +1642,7 @@ struct request_queue *__scsi_alloc_queue(struct=
 Scsi_Host *shost,
>   					 request_fn_proc *request_fn)
>   {
>   	struct request_queue *q;
> -	struct device *dev =3D shost->shost_gendev.parent;
> +	struct device *dev =3D shost->dma_dev;
>
>   	q =3D blk_init_queue(request_fn, NULL);
>   	if (!q)

WBR, Sergei
