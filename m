From: Evan Green <evgreen@chromium.org>
Subject: Re: [PATCH V4 2/3] scsi: ufs: Add ufs provisioning support
Date: Mon, 2 Jul 2018 16:42:33 -0700
Message-ID: <CAE=gft4nUUVQABMDNi40g6q+pj4DT5=zXxdtpmcqoy2BcGY5Rg@mail.gmail.com>
References: <1529985829-18689-1-git-send-email-sayalil@codeaurora.org> <1529985829-18689-3-git-send-email-sayalil@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1529985829-18689-3-git-send-email-sayalil@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: sayalil@codeaurora.org
Cc: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, Rajendra Nayak <rnayak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, riteshh@codeaurora.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Sayali,

On Mon, Jun 25, 2018 at 9:04 PM Sayali Lokhande <sayalil@codeaurora.org> wrote:
>
> A new api ufshcd_do_config_device() is added in driver
> to support UFS provisioning at runtime. Configfs support
> is added to trigger provisioning.
> Device and Unit descriptor configurable parameters are
> parsed from vendor specific provisioning data or file and
> passed via configfs node at runtime to provision ufs device.
>
> Signed-off-by: Sayali Lokhande <sayalil@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufs.h    |  28 +++++++
>  drivers/scsi/ufs/ufshcd.c | 198 ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd.h |   2 +
>  3 files changed, 228 insertions(+)
>
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index e15deb0..1f99904 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -333,6 +333,7 @@ enum {
>         UFSHCD_AMP              = 3,
>  };
>
> +#define UFS_BLOCK_SIZE 4096

Is this not prescribed by UFS. You need to look at bMinAddrBlockSize,
whose minimum value is 8, representing 4k blocks. But you can't assume
they're all going to be that, the spec allows for larger block sizes.

>  #define POWER_DESC_MAX_SIZE                    0x62
>  #define POWER_DESC_MAX_ACTV_ICC_LVLS           16
>
> @@ -425,6 +426,33 @@ enum {
>         MASK_TM_SERVICE_RESP            = 0xFF,
>  };
>
> +struct ufs_unit_desc {
> +       u8     bLUEnable;              /* 1 for enabled LU */
> +       u8     bBootLunID;             /* 0 for using this LU for boot */
> +       u8     bLUWriteProtect;        /* 1 = power on WP, 2 = permanent WP */
> +       u8     bMemoryType;            /* 0 for enhanced memory type */
> +       u32    dNumAllocUnits;         /* Number of alloc unit for this LU */
> +       u8     bDataReliability;       /* 0 for reliable write support */
> +       u8     bLogicalBlockSize;      /* See section 13.2.3 of UFS standard */
> +       u8     bProvisioningType;      /* 0 for thin provisioning */
> +       u16    wContextCapabilities;   /* refer Unit Descriptor Description */
> +};
> +
> +struct ufs_config_descr {
> +       u8     bNumberLU;              /* Total number of active LUs */
> +       u8     bBootEnable;            /* enabling device for partial init */
> +       u8     bDescrAccessEn;         /* desc access during partial init */
> +       u8     bInitPowerMode;         /* Initial device power mode */
> +       u8     bHighPriorityLUN;       /* LUN of the high priority LU */
> +       u8     bSecureRemovalType;     /* Erase config for data removal */
> +       u8     bInitActiveICCLevel;    /* ICC level after reset */
> +       u16    wPeriodicRTCUpdate;     /* 0 to set a priodic RTC update rate */
> +       u32     bConfigDescrLock;      /* 1 to lock Configation Descriptor */
> +       u32    qVendorConfigCode;      /* Vendor specific configuration code */
> +       struct ufs_unit_desc unit[8];
> +       u8      lun_to_grow;
> +};

You've created a structure whose naming and members suggest that it
matches the hardware, but it does not. I think you should make this
structure match the hardware, and remove software members like
lun_to_grow. It's okay with me if 8 is hardcoded for now, but bear in
mind I think the spec allows for this to be a different number.

> +
>  /* Task management service response */
>  enum {
>         UPIU_TASK_MANAGEMENT_FUNC_COMPL         = 0x00,
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 351f874..370a7c6 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -42,6 +42,7 @@
>  #include <linux/nls.h>
>  #include <linux/of.h>
>  #include <linux/bitfield.h>
> +#include <asm/unaligned.h>

Alphabetize includes, though I think if you follow my other
suggestions this will go away.

>  #include "ufshcd.h"
>  #include "ufs_quirks.h"
>  #include "unipro.h"
> @@ -3063,6 +3064,14 @@ static inline int ufshcd_read_power_desc(struct ufs_hba *hba,
>         return ufshcd_read_desc(hba, QUERY_DESC_IDN_POWER, 0, buf, size);
>  }
>
> +static inline int ufshcd_read_geometry_desc(struct ufs_hba *hba,
> +                                        u8 *buf,
> +                                        u32 size)
> +{
> +       return ufshcd_read_desc(hba, QUERY_DESC_IDN_GEOMETRY, 0, buf, size);
> +}
> +
> +

Remove extra blank line.

>  static int ufshcd_read_device_desc(struct ufs_hba *hba, u8 *buf, u32 size)
>  {
>         return ufshcd_read_desc(hba, QUERY_DESC_IDN_DEVICE, 0, buf, size);
> @@ -6363,6 +6372,195 @@ static int ufshcd_set_dev_ref_clk(struct ufs_hba *hba)
>  }
>
>  /**
> + * ufshcd_do_config_device - API function for UFS provisioning
> + * hba: per-adapter instance
> + * Returns 0 for success, non-zero in case of failure.
> + */
> +int ufshcd_do_config_device(struct ufs_hba *hba)
> +{
> +       struct ufs_config_descr *cfg = &hba->cfgs;
> +       int buff_len = QUERY_DESC_CONFIGURATION_DEF_SIZE;
> +       u8 desc_buf[QUERY_DESC_CONFIGURATION_DEF_SIZE] = {0};
> +       int i, ret = 0;
> +       int lun_to_grow = -1;
> +       u64 qTotalRawDeviceCapacity;
> +       u16 wEnhanced1CapAdjFac, wEnhanced2CapAdjFac;
> +       u32 dEnhanced1MaxNAllocU, dEnhanced2MaxNAllocU;
> +       size_t alloc_units, units_to_create = 0;
> +       size_t capacity_to_alloc_factor;
> +       size_t enhanced1_units = 0, enhanced2_units = 0;
> +       size_t conversion_ratio = 1;
> +       u8 *pt;
> +       u32 blocks_per_alloc_unit = 1024;

Is this really hardcoded by the spec? I think it probably isn't, but
if it is, make it a define.

> +       int geo_len = hba->desc_size.geom_desc;
> +       u8 geo_buf[hba->desc_size.geom_desc];
> +       unsigned int max_partitions = 8;

Magic value. Perhaps a define here as well.

> +
> +       WARN_ON(!hba || !cfg);
> +
> +       pm_runtime_get_sync(hba->dev);
> +       scsi_block_requests(hba->host);

Is this needed? Why is it bad to have requests going through during
this function, given that you re-enable them at the end of this
function?

> +       if (ufshcd_wait_for_doorbell_clr(hba, U64_MAX)) {

Why is this needed?

> +               dev_err(hba->dev, "%s: Timed out waitig for DB to clear\n",
> +                       __func__);
> +               ret = -EBUSY;
> +               goto out;
> +       }
> +
> +       ret = ufshcd_read_geometry_desc(hba, geo_buf, geo_len);
> +       if (ret) {
> +               dev_err(hba->dev, "%s: Failed getting geometry_desc %d\n",
> +                       __func__, ret);
> +               goto out;
> +       }
> +
> +       /*
> +        * Get Geomtric parameters like total configurable memory
> +        * quantity (Offset 0x04 to 0x0b), Capacity Adjustment
> +        * Factors (Offset 0x30, 0x31, 0x36, 0x37), Max allocation
> +        * units (Offset 0x2c to 0x2f, 0x32 to 0x35) used to configure
> +        * the device logical units.
> +        */
> +       qTotalRawDeviceCapacity = get_unaligned_be64(&geo_buf[0x04]);
> +       wEnhanced1CapAdjFac = get_unaligned_be16(&geo_buf[0x30]);
> +       wEnhanced2CapAdjFac = get_unaligned_be16(&geo_buf[0x36]);
> +       dEnhanced1MaxNAllocU = get_unaligned_be32(&geo_buf[0x2c]);
> +       dEnhanced2MaxNAllocU = get_unaligned_be32(&geo_buf[0x32]);

Magic values, these should be done as other descriptors do it (see
enum device_desc_param).

> +
> +       capacity_to_alloc_factor =
> +               (blocks_per_alloc_unit * UFS_BLOCK_SIZE) / 512;
> +
> +       if (qTotalRawDeviceCapacity % capacity_to_alloc_factor != 0) {
> +               dev_err(hba->dev,
> +                       "%s: Raw capacity(%llu) not multiple of alloc factor(%zu)\n",
> +                       __func__, qTotalRawDeviceCapacity,
> +                       capacity_to_alloc_factor);
> +               ret = -EINVAL;
> +               goto out;
> +       }
> +       alloc_units = (qTotalRawDeviceCapacity / capacity_to_alloc_factor);
> +       units_to_create = 0;
> +       enhanced1_units = enhanced2_units = 0;
> +
> +       /*
> +        * Calculate number of allocation units to be assigned to a logical unit
> +        * considering the capacity adjustment factor of respective memory type.
> +        */
> +       for (i = 0; i < (max_partitions - 1) &&
> +               units_to_create <= alloc_units; i++) {
> +               if ((cfg->unit[i].dNumAllocUnits % blocks_per_alloc_unit) == 0)
> +                       cfg->unit[i].dNumAllocUnits /= blocks_per_alloc_unit;
> +               else
> +                       cfg->unit[i].dNumAllocUnits =
> +                       cfg->unit[i].dNumAllocUnits / blocks_per_alloc_unit + 1;
> +
> +               if (cfg->unit[i].bMemoryType == 0)
> +                       units_to_create += cfg->unit[i].dNumAllocUnits;
> +               else if (cfg->unit[i].bMemoryType == 3) {
> +                       enhanced1_units += cfg->unit[i].dNumAllocUnits;
> +                       cfg->unit[i].dNumAllocUnits *=
> +                               (wEnhanced1CapAdjFac / 0x100);
> +                       units_to_create += cfg->unit[i].dNumAllocUnits;
> +               } else if (cfg->unit[i].bMemoryType == 4) {
> +                       enhanced2_units += cfg->unit[i].dNumAllocUnits;
> +                       cfg->unit[i].dNumAllocUnits *=
> +                               (wEnhanced1CapAdjFac / 0x100);
> +                       units_to_create += cfg->unit[i].dNumAllocUnits;
> +               } else {
> +                       dev_err(hba->dev, "%s: Unsupported memory type %d\n",
> +                               __func__, cfg->unit[i].bMemoryType);
> +                       ret = -EINVAL;
> +                       goto out;
> +               }
> +       }
> +       if (enhanced1_units > dEnhanced1MaxNAllocU) {
> +               dev_err(hba->dev, "%s: size %zu exceeds max enhanced1 area size %u\n",
> +                       __func__, enhanced1_units, dEnhanced1MaxNAllocU);
> +               ret = -ERANGE;
> +               goto out;
> +       }
> +       if (enhanced2_units > dEnhanced2MaxNAllocU) {
> +               dev_err(hba->dev, "%s: size %zu exceeds max enhanced2 area size %u\n",
> +                       __func__, enhanced2_units, dEnhanced2MaxNAllocU);
> +               ret = -ERANGE;
> +               goto out;
> +       }
> +       if (units_to_create > alloc_units) {
> +               dev_err(hba->dev, "%s: Specified size %zu exceeds device size %zu\n",
> +                       __func__, units_to_create, alloc_units);
> +               ret = -ERANGE;
> +               goto out;
> +       }
> +       lun_to_grow = cfg->lun_to_grow;
> +       if (lun_to_grow != -1) {
> +               if (cfg->unit[i].bMemoryType == 0)
> +                       conversion_ratio = 1;
> +               else if (cfg->unit[i].bMemoryType == 3)
> +                       conversion_ratio = (wEnhanced1CapAdjFac / 0x100);
> +               else if (cfg->unit[i].bMemoryType == 4)
> +                       conversion_ratio = (wEnhanced2CapAdjFac / 0x100);
> +
> +               cfg->unit[lun_to_grow].dNumAllocUnits +=
> +               ((alloc_units - units_to_create) / conversion_ratio);
> +               dev_dbg(hba->dev, "%s: conversion_ratio %zu for lun %d\n",
> +                       __func__, conversion_ratio, i);
> +       }

I really don't like all this wizardry in here. I think the kernel
should just accept config descriptor bytes through configfs that it
more or less passes along. These calculations could all be done in
user mode.

> +
> +       /* Fill in the buffer with configuration data */
> +       pt = desc_buf;
> +       *pt++ = 0x90;        // bLength
> +       *pt++ = 0x01;        // bDescriptorType
> +       *pt++ = 0;           // Reserved in UFS2.0 and onward
> +       *pt++ = cfg->bBootEnable;
> +       *pt++ = cfg->bDescrAccessEn;
> +       *pt++ = cfg->bInitPowerMode;
> +       *pt++ = cfg->bHighPriorityLUN;
> +       *pt++ = cfg->bSecureRemovalType;
> +       *pt++ = cfg->bInitActiveICCLevel;
> +       put_unaligned_be16(cfg->wPeriodicRTCUpdate, pt);
> +       pt = pt + 7; // Reserved fields set to 0
> +
> +       /* Fill in the buffer with per logical unit data */
> +       for (i = 0; i < UFS_UPIU_MAX_GENERAL_LUN; i++) {
> +               *pt++ = cfg->unit[i].bLUEnable;
> +               *pt++ = cfg->unit[i].bBootLunID;
> +               *pt++ = cfg->unit[i].bLUWriteProtect;
> +               *pt++ = cfg->unit[i].bMemoryType;
> +               put_unaligned_be32(cfg->unit[i].dNumAllocUnits, pt);
> +               pt = pt + 4;
> +               *pt++ = cfg->unit[i].bDataReliability;
> +               *pt++ = cfg->unit[i].bLogicalBlockSize;
> +               *pt++ = cfg->unit[i].bProvisioningType;
> +               put_unaligned_be16(cfg->unit[i].wContextCapabilities, pt);
> +               pt = pt + 5; // Reserved fields set to 0
> +       }

Yikes. If your structure reflected the hardware, then you could use
actual members. Barring that, you could create and use enum values for
the descriptor members. The way it stands this is very brittle and
full of magic values and offsets.

> +
> +       ret = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_WRITE_DESC,
> +               QUERY_DESC_IDN_CONFIGURATION, 0, 0, desc_buf, &buff_len);

I'm not sure this works out of the box, especially if what you're
writing isn't exactly the descriptor size (which it might be in your
tests, but might suddenly start failing later). Please consider
absorbing my change [1] which properly refactors the function for
reading and writing.

> +
> +       if (ret) {
> +               dev_err(hba->dev, "%s: Failed writing descriptor. desc_idn %d, opcode %x ret %d\n",
> +               __func__, QUERY_DESC_IDN_CONFIGURATION,
> +               UPIU_QUERY_OPCODE_WRITE_DESC, ret);
> +               goto out;
> +       }
> +
> +       if (cfg->bConfigDescrLock == 1) {
> +               ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
> +               QUERY_ATTR_IDN_CONF_DESC_LOCK, 0, 0, &cfg->bConfigDescrLock);
> +               if (ret)
> +                       dev_err(hba->dev, "%s: Failed writing bConfigDescrLock %d\n",
> +                               __func__, ret);
> +       }

It might be better not to merge this functionality in with the act of
writing provisioning data, and instead make the sysfs attributes
writable like [2].

> +
> +out:
> +       scsi_unblock_requests(hba->host);
> +       pm_runtime_put_sync(hba->dev);
> +
> +       return ret;
> +}
> +
> +/**
>   * ufshcd_probe_hba - probe hba to detect device and initialize
>   * @hba: per-adapter instance
>   *
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 101a75c..0e6bf30 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -549,6 +549,7 @@ struct ufs_hba {
>         unsigned int irq;
>         bool is_irq_enabled;
>         u32 dev_ref_clk_freq;
> +       struct ufs_config_descr cfgs;

How come you store this here, rather than as a local in
ufshcd_do_config_device()?

>
>         /* Interrupt aggregation support is broken */
>         #define UFSHCD_QUIRK_BROKEN_INTR_AGGR                   0x1
> @@ -867,6 +868,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, int desc_index,
>
>  int ufshcd_hold(struct ufs_hba *hba, bool async);
>  void ufshcd_release(struct ufs_hba *hba);
> +int ufshcd_do_config_device(struct ufs_hba *hba);
>
>  int ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn desc_id,
>         int *desc_length);
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
>

[1] https://patchwork.kernel.org/patch/10467669/
[2] https://patchwork.kernel.org/patch/10467665/
