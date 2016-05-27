From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH 1/2] mpt3sas - set num_phys after allocating phy[] space
Date: Fri, 27 May 2016 13:48:04 +0530
Message-ID: <CAK=zhgqsbOme4TEfcFn5DGunpTYDsCLwQ8UqCQFUjY--L=B9PQ@mail.gmail.com>
References: <1464203669-31974-1-git-send-email-joe.lawrence@stratus.com>
	<1464203669-31974-2-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:33950 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077AbcE0ISF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 May 2016 04:18:05 -0400
Received: by mail-oi0-f52.google.com with SMTP id b65so163139616oia.1
        for <linux-scsi@vger.kernel.org>; Fri, 27 May 2016 01:18:04 -0700 (PDT)
In-Reply-To: <1464203669-31974-2-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>

Hi,

This patch looks good. Please consider this patch as Ack-by: Sreekanth Reddy
<sreekanth.reddy@broadcom.com>

Thanks,
Sreekanth

On Thu, May 26, 2016 at 12:44 AM, Joe Lawrence <joe.lawrence@stratus.com> wrote:
> In _scsih_sas_host_add, the number of HBA phys are determined and then
> later used to allocate an array of struct  _sas_phy's.  If the routine
> sets ioc->sas_hba.num_phys, but then fails to allocate the
> ioc->sas_hba.phy array (by kcalloc error or other intermediate
> error/exit path), ioc->sas_hba is left in a dangerous state: all readers
> of ioc->sas_hba.phy[] do so by indexing it from 0..ioc->sas_hba.num_phys
> without checking that the space was ever allocated.
>
> Modify _scsih_sas_host_add to set ioc->sas_hba.num_phys only after
> successfully allocating ioc->sas_hba.phy[].
>
> Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index f2139e5604a3..6e36d20c9e0b 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -4893,13 +4893,22 @@ _scsih_sas_host_add(struct MPT3SAS_ADAPTER *ioc)
>         u16 ioc_status;
>         u16 sz;
>         u8 device_missing_delay;
> +       u8 num_phys;
>
> -       mpt3sas_config_get_number_hba_phys(ioc, &ioc->sas_hba.num_phys);
> -       if (!ioc->sas_hba.num_phys) {
> +       mpt3sas_config_get_number_hba_phys(ioc, &num_phys);
> +       if (!num_phys) {
>                 pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
>                     ioc->name, __FILE__, __LINE__, __func__);
>                 return;
>         }
> +       ioc->sas_hba.phy = kcalloc(num_phys,
> +           sizeof(struct _sas_phy), GFP_KERNEL);
> +       if (!ioc->sas_hba.phy) {
> +               pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
> +                   ioc->name, __FILE__, __LINE__, __func__);
> +               goto out;
> +       }
> +       ioc->sas_hba.num_phys = num_phys;
>
>         /* sas_iounit page 0 */
>         sz = offsetof(Mpi2SasIOUnitPage0_t, PhyData) + (ioc->sas_hba.num_phys *
> @@ -4959,13 +4968,6 @@ _scsih_sas_host_add(struct MPT3SAS_ADAPTER *ioc)
>                     MPI2_SASIOUNIT1_REPORT_MISSING_TIMEOUT_MASK;
>
>         ioc->sas_hba.parent_dev = &ioc->shost->shost_gendev;
> -       ioc->sas_hba.phy = kcalloc(ioc->sas_hba.num_phys,
> -           sizeof(struct _sas_phy), GFP_KERNEL);
> -       if (!ioc->sas_hba.phy) {
> -               pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
> -                   ioc->name, __FILE__, __LINE__, __func__);
> -               goto out;
> -       }
>         for (i = 0; i < ioc->sas_hba.num_phys ; i++) {
>                 if ((mpt3sas_config_get_phy_pg0(ioc, &mpi_reply, &phy_pg0,
>                     i))) {
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
