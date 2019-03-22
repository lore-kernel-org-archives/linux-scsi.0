From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [RFC PATCH v2] scsi: fix oops in scsi_uninit_cmd()
Date: Fri, 22 Mar 2019 09:36:23 +0800
Message-ID: <CACVXFVOeh_H9R8G0W=WHT9aaOm2K60HhEPbg9Okd58dhQ4Pm8Q@mail.gmail.com>
References: <20190316020905.14962-1-yanaijie@huawei.com> <1553193542.65329.119.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1553193542.65329.119.camel@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jason Yan <yanaijie@huawei.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 22, 2019 at 2:39 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> On Sat, 2019-03-16 at 10:09 +0800, Jason Yan wrote:
> > If we remove the scsi disk when running io with fio, oops occured with
> > the following condition.
> >
> > [scsi_eh_0]                              [fio]
> > scsi_end_request
> >   ->blk_update_request
> >     ->end_bio(io returned to userspace)
> >                                          close
> >                                            ->sd_release
> >                                               ->scsi_disk_put
> >                                                  ->scsi_disk_release
> >                                                      ->disk->private_da=
ta =3D NULL;
> >
> >   ->scsi_mq_uninit_cmd
> >     ->scsi_uninit_cmd
> >       ->scsi_cmd_to_driver
> >     ->drv is NULL, Oops
> >
> > There is a small window between blk_update_request() and
> > scsi_mq_uninit_cmd() that scsi disk may have been released. This will
> > cause a oops like below:
> >
> > Unable to handle kernel NULL pointer dereference at virtual address
> > 0000000000000000
> > s/sync.c:67, func=3Dxfer, error=3DIn[11347.116050] Mem abort info:
> > put/output error
> > [11347.121598]   ESR =3D 0x96000006
> > [11347.126200]   Exception class =3D DABT (current EL), IL =3D 32 bits
> > [11347.132117]   SET =3D 0, FnV =3D 0
> > [11347.135170]   EA =3D 0, S1PTW =3D 0
> > [11347.138308] Data abort info:
> > [11347.141186]   ISV =3D 0, ISS =3D 0x00000006
> > [11347.145019]   CM =3D 0, WnR =3D 0
> > [11347.147977] user pgtable: 4k pages, 48-bit VAs, pgdp =3D
> > 00000000a67aece2
> > [11347.154591] [0000000000000000] pgd=3D0000002f90774003,
> > pud=3D0000002fab098003, pmd=3D0000000000000000
> > [11347.163304] Internal error: Oops: 96000006 [#1] PREEMPT SMP
> > [11347.168870] Modules linked in: hisi_sas_v3_hw hisi_sas_main libsas
> > [11347.175044] CPU: 56 PID: 4294 Comm: scsi_eh_2 Not tainted
> > 4.19.0-g8052059-dirty #2
> > [11347.182600] Hardware name: Huawei D06/D06, BIOS Hisilicon D06 UEFI
> > RC0 - B601 (V6.01) 11/08/2018
> > [11347.191370] pstate: a0c00009 (NzCv daif =E3=B0=83=E7=B9=90=CE=B5=ED=
=9D=BE=E3=AF=97
>
> Please verify whether the following patch is a valid alternative for your=
 patch:
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index ed34bfbc3844..745ffdda1bc1 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1408,6 +1408,7 @@ static void sd_release(struct gendisk *disk, fmode_=
t mode)
>  {
>         struct scsi_disk *sdkp =3D scsi_disk(disk);
>         struct scsi_device *sdev =3D sdkp->device;
> +       struct request_queue *q =3D sdkp->disk->queue;
>
>         SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_release\n"));
>
> @@ -1417,9 +1418,12 @@ static void sd_release(struct gendisk *disk, fmode=
_t mode)
>         }
>
>         /*
> -        * XXX and what if there are packets in flight and this close()
> -        * XXX is followed by a "rmmod sd_mod"?
> +        * Wait until any requests that are in progress have completed.
> +        * This is necessary to avoid that e.g. scsi_end_request() crashe=
s
> +        * due to scsi_disk_relase() clearing the disk->private_data poin=
ter.
>          */
> +       blk_mq_freeze_queue(q);
> +       blk_mq_unfreeze_queue(q);

It is over-kill to drain any requests here, what we want is to just
drain any in-flight
IO requests.

Thanks,
Ming Lei
