From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH 1/2] [SCSI] scsi_lib: use correct DMA device in __scsi_alloc_queue
Date: Tue, 27 Mar 2012 12:56:18 +0800
Message-ID: <CAF1ivSaCcfJqoQFOcDhL3qNrm5S7_rhuwxkZxPH26+5t=W+9TA@mail.gmail.com>
References: <1332433926-9132-1-git-send-email-mlin@ss.pku.edu.cn>
	<1332433926-9132-2-git-send-email-mlin@ss.pku.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1332433926-9132-2-git-send-email-mlin@ss.pku.edu.cn>
Sender: linux-ide-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: =?ISO-8859-1?Q?J=F6rg_Sommer?= <joerg@alea.gnuu.de>, Jeff Garzik <jgarzik@redhat.com>, Tejun Heo <tj@kernel.org>, Sergei Shtylyov <sshtylyov@mvista.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 23, 2012 at 12:32 AM, Lin Ming <mlin@ss.pku.edu.cn> wrote:
> From: Lin Ming <ming.m.lin@intel.com>
>
> Currently, __scsi_alloc_queue uses SCSI host's parent device
> as DMA device to set segment boundary. But the parent device may not
> refer to the DMA device. For example, for ATA disk, SCSI host's paren=
t
> device now refers to ATA port.
>
> Since commit d139b9b([SCSI] scsi_lib_dma: fix bug with dma maps on
> nested scsi objects), a new field Scsi_Host->dma_dev was introduced
> to refer to the real DMA device.
>
> Use ->dma_dev in __scsi_alloc_queue to correctly set segment
> boundary.
>
> Bug report: http://marc.info/?l=3Dlinux-ide&m=3D133177818318187&w=3D2
>
> Reported-and-tested-by: J=F6rg Sommer <joerg@alea.gnuu.de>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>

Hi James,

Jeff has acked patch 2.

Will you apply these 2 patches?

Thanks,
Lin Ming

> ---
> =A0drivers/scsi/scsi_lib.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index a33b2b6..fa2636e2 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1637,7 +1637,7 @@ struct request_queue *__scsi_alloc_queue(struct=
 Scsi_Host *shost,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 request_fn_proc *request_fn)
> =A0{
> =A0 =A0 =A0 =A0struct request_queue *q;
> - =A0 =A0 =A0 struct device *dev =3D shost->shost_gendev.parent;
> + =A0 =A0 =A0 struct device *dev =3D shost->dma_dev;
>
> =A0 =A0 =A0 =A0q =3D blk_init_queue(request_fn, NULL);
> =A0 =A0 =A0 =A0if (!q)
> --
> 1.7.2.5
