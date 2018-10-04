From: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH 6/7] mpt3sas: Convert logging uses with MPT3SAS_FMT
 without logging levels
Date: Thu, 4 Oct 2018 16:00:21 +0530
Message-ID: <CA+RiK67Yg01QB+aFVdRqZ-cEg+RHO-9qGd2n-NxZWcwGfQFvzw@mail.gmail.com>
References: <cover.1537183087.git.joe@perches.com> <f2eb641cb919f46a16871593d35e4a83c9d13324.1537183088.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f2eb641cb919f46a16871593d35e4a83c9d13324.1537183088.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: joe@perches.com
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,
Please consider this patch as Acked-by: Suganath Prabu
<suganath-prabu.subramani@broadcom.com>

Thanks.
On Mon, Sep 17, 2018 at 8:33 PM Joe Perches <joe@perches.com> wrote:
>
> Convert these uses to ioc_<level> where appropriate.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c      | 41 +++++++++++++++-----------------
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 12 +++++-----
>  drivers/scsi/mpt3sas/mpt3sas_transport.c |  6 ++---
>  3 files changed, 28 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 386af6739867..cf5a21717a6f 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -2819,9 +2819,8 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
>         ioc->reply_queue_count = min_t(int, ioc->cpu_count,
>                 ioc->msix_vector_count);
>
> -       printk(MPT3SAS_FMT "MSI-X vectors supported: %d, no of cores"
> -         ": %d, max_msix_vectors: %d\n", ioc->name, ioc->msix_vector_count,
> -         ioc->cpu_count, max_msix_vectors);
> +       ioc_info(ioc, "MSI-X vectors supported: %d, no of cores: %d, max_msix_vectors: %d\n",
> +                ioc->msix_vector_count, ioc->cpu_count, max_msix_vectors);
>
>         if (!ioc->rdpq_array_enable && max_msix_vectors == -1)
>                 local_max_msix_vectors = (reset_devices) ? 1 : 8;
> @@ -2886,8 +2885,7 @@ mpt3sas_base_unmap_resources(struct MPT3SAS_ADAPTER *ioc)
>  {
>         struct pci_dev *pdev = ioc->pdev;
>
> -       dexitprintk(ioc, printk(MPT3SAS_FMT "%s\n",
> -               ioc->name, __func__));
> +       dexitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
>
>         _base_free_irq(ioc);
>         _base_disable_msix(ioc);
> @@ -3007,9 +3005,8 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
>                      ioc->combined_reply_index_count,
>                      sizeof(resource_size_t *), GFP_KERNEL);
>                 if (!ioc->replyPostRegisterIndex) {
> -                       dfailprintk(ioc, printk(MPT3SAS_FMT
> -                       "allocation for reply Post Register Index failed!!!\n",
> -                                                                  ioc->name));
> +                       dfailprintk(ioc,
> +                                   ioc_warn(ioc, "allocation for reply Post Register Index failed!!!\n"));
>                         r = -ENOMEM;
>                         goto out_fail;
>                 }
> @@ -5438,26 +5435,26 @@ _base_wait_for_iocstate(struct MPT3SAS_ADAPTER *ioc, int timeout)
>         u32 ioc_state;
>         int rc;
>
> -       dinitprintk(ioc, printk(MPT3SAS_FMT "%s\n", ioc->name,
> -           __func__));
> +       dinitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
>
>         if (ioc->pci_error_recovery) {
> -               dfailprintk(ioc, printk(MPT3SAS_FMT
> -                   "%s: host in pci error recovery\n", ioc->name, __func__));
> +               dfailprintk(ioc,
> +                           ioc_info(ioc, "%s: host in pci error recovery\n",
> +                                    __func__));
>                 return -EFAULT;
>         }
>
>         ioc_state = mpt3sas_base_get_iocstate(ioc, 0);
> -       dhsprintk(ioc, printk(MPT3SAS_FMT "%s: ioc_state(0x%08x)\n",
> -           ioc->name, __func__, ioc_state));
> +       dhsprintk(ioc,
> +                 ioc_info(ioc, "%s: ioc_state(0x%08x)\n",
> +                          __func__, ioc_state));
>
>         if (((ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_READY) ||
>             (ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_OPERATIONAL)
>                 return 0;
>
>         if (ioc_state & MPI2_DOORBELL_USED) {
> -               dhsprintk(ioc, printk(MPT3SAS_FMT
> -                   "unexpected doorbell active!\n", ioc->name));
> +               dhsprintk(ioc, ioc_info(ioc, "unexpected doorbell active!\n"));
>                 goto issue_diag_reset;
>         }
>
> @@ -5469,9 +5466,9 @@ _base_wait_for_iocstate(struct MPT3SAS_ADAPTER *ioc, int timeout)
>
>         ioc_state = _base_wait_on_iocstate(ioc, MPI2_IOC_STATE_READY, timeout);
>         if (ioc_state) {
> -               dfailprintk(ioc, printk(MPT3SAS_FMT
> -                   "%s: failed going to ready state (ioc_state=0x%x)\n",
> -                   ioc->name, __func__, ioc_state));
> +               dfailprintk(ioc,
> +                           ioc_info(ioc, "%s: failed going to ready state (ioc_state=0x%x)\n",
> +                                    __func__, ioc_state));
>                 return -EFAULT;
>         }
>
> @@ -5498,9 +5495,9 @@ _base_get_ioc_facts(struct MPT3SAS_ADAPTER *ioc)
>
>         r = _base_wait_for_iocstate(ioc, 10);
>         if (r) {
> -               dfailprintk(ioc, printk(MPT3SAS_FMT
> -                   "%s: failed getting to correct state\n",
> -                   ioc->name, __func__));
> +               dfailprintk(ioc,
> +                           ioc_info(ioc, "%s: failed getting to correct state\n",
> +                                    __func__));
>                 return r;
>         }
>         mpi_reply_sz = sizeof(Mpi2IOCFactsReply_t);
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index 8089be381c72..4d73b5e6e2fc 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -4999,16 +4999,16 @@ _scsih_turn_off_pfa_led(struct MPT3SAS_ADAPTER *ioc,
>         mpi_request.Flags = MPI2_SEP_REQ_FLAGS_ENCLOSURE_SLOT_ADDRESS;
>         if ((mpt3sas_base_scsi_enclosure_processor(ioc, &mpi_reply,
>                 &mpi_request)) != 0) {
> -               printk(MPT3SAS_FMT "failure at %s:%d/%s()!\n", ioc->name,
> -               __FILE__, __LINE__, __func__);
> +               ioc_err(ioc, "failure at %s:%d/%s()!\n",
> +                       __FILE__, __LINE__, __func__);
>                 return;
>         }
>
>         if (mpi_reply.IOCStatus || mpi_reply.IOCLogInfo) {
> -               dewtprintk(ioc, printk(MPT3SAS_FMT
> -                "enclosure_processor: ioc_status (0x%04x), loginfo(0x%08x)\n",
> -                ioc->name, le16_to_cpu(mpi_reply.IOCStatus),
> -                le32_to_cpu(mpi_reply.IOCLogInfo)));
> +               dewtprintk(ioc,
> +                          ioc_info(ioc, "enclosure_processor: ioc_status (0x%04x), loginfo(0x%08x)\n",
> +                                   le16_to_cpu(mpi_reply.IOCStatus),
> +                                   le32_to_cpu(mpi_reply.IOCLogInfo)));
>                 return;
>         }
>  }
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
> index 09034a3fba2c..031b420f4d40 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
> @@ -717,9 +717,9 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
>                 sas_device = mpt3sas_get_sdev_by_addr(ioc,
>                                     mpt3sas_port->remote_identify.sas_address);
>                 if (!sas_device) {
> -                       dfailprintk(ioc, printk(MPT3SAS_FMT
> -                               "failure at %s:%d/%s()!\n",
> -                               ioc->name, __FILE__, __LINE__, __func__));
> +                       dfailprintk(ioc,
> +                                   ioc_info(ioc, "failure at %s:%d/%s()!\n",
> +                                            __FILE__, __LINE__, __func__));
>                         goto out_fail;
>                 }
>                 sas_device->pend_sas_rphy_add = 1;
> --
> 2.15.0
>
