From: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH 7/8] mpt3sas: set an unlimited max_segment_size for SAS
 3.0 HBAs
Date: Thu, 20 Jun 2019 12:38:52 +0530
Message-ID: <CA+RiK64_31h+UHA7r3BdPo7AjUTyfEKYfskEquqbCZ84d4pbKw@mail.gmail.com>
References: <20190617122000.22181-1-hch@lst.de> <20190617122000.22181-8-hch@lst.de>
 <CACVXFVObpdjN6V9qS-C9NG5xcrPqmx-X22qVamOSZf81Vog6zw@mail.gmail.com> <CA+RiK64sFfY79i7q2YbN5HcZ4wzVOcLWgDJnPbf6=ycdcmC-Mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+RiK64sFfY79i7q2YbN5HcZ4wzVOcLWgDJnPbf6=ycdcmC-Mg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <maxg@mellanox.com>, Bart Van Assche <bvanassche@acm.org>, linux-rdma <linux-rdma@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, megaraidlinux.pdl@broadcom.com, PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>, linux-hyperv@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Acked-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>

On Thu, Jun 20, 2019 at 12:34 PM Suganath Prabu Subramani
<suganath-prabu.subramani@broadcom.com> wrote:
>
> Please consider this as Acked-by: Suganath Prabu
> <suganath-prabu.subramani@broadcom.com>
>
>
> On Tue, Jun 18, 2019 at 6:16 AM Ming Lei <tom.leiming@gmail.com> wrote:
> >
> > On Mon, Jun 17, 2019 at 8:21 PM Christoph Hellwig <hch@lst.de> wrote:
> > >
> > > When using a virt_boundary_mask, as done for NVMe devices attached to
> > > mpt3sas controllers we require an unlimited max_segment_size, as the
> > > virt boundary merging code assumes that.  But we also need to propagate
> > > that to the DMA mapping layer to make dma-debug happy.  The SCSI layer
> > > takes care of that when using the per-host virt_boundary setting, but
> > > given that mpt3sas only wants to set the virt_boundary for actual
> > > NVMe devices we can't rely on that.  The DMA layer maximum segment
> > > is global to the HBA however, so we have to set it explicitly.  This
> > > patch assumes that mpt3sas does not have a segment size limitation,
> > > which seems true based on the SGL format, but will need to be verified.
> > >
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > > index 1ccfbc7eebe0..c719b807f6d8 100644
> > > --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > > +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > > @@ -10222,6 +10222,7 @@ static struct scsi_host_template mpt3sas_driver_template = {
> > >         .this_id                        = -1,
> > >         .sg_tablesize                   = MPT3SAS_SG_DEPTH,
> > >         .max_sectors                    = 32767,
> > > +       .max_segment_size               = 0xffffffff,
> >
> > .max_segment_size should be aligned, either setting it here correctly or
> > forcing to make it aligned in scsi-core.
> >
> > Thanks,
> > Ming Lei
