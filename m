Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4DF2512F1
	for <linux-scsi@vger.kernel.org>; Wed,  1 Oct 2025 07:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759305022; cv=none; b=k8KUYmTepi4Tz6jZ7UTS71k4ARpeE84u7MfXKmH2HuOcM0j4eHcfD0NtvINX6EnZo/HEXIuyJM/Y5EYclcMoIyPnaiHZW5uaCrb+32EWb97rC/1jOVYnRqzobrFQsZusDkfWtTpgH+YyuCq7mIjPZFbkj44rktxh+WrWkfmfMHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759305022; c=relaxed/simple;
	bh=ZW+DpYMCSLLfyN6ca1YzSYbOA8h3qg/FV4Rt0HjLqTw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FnwI5LoiYokg9CjW5T8MtK7oQz96wxzNJuRxt4AmEqZccCa8n20lErYn4iyo3QuiqkHEAGQQT6hMVAgUCney+89M593U/D821PttrS1BuE1jNAYay582FUXTaQA7xvYdC9btS9NVcktl0HerfZjiuCyep3Boo2RSFwbcYAf6oKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=L7Igl4+P; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="L7Igl4+P"
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-30ccec59b4bso5850715fac.3
        for <linux-scsi@vger.kernel.org>; Wed, 01 Oct 2025 00:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759305020; x=1759909820; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TiEapQYr7qDytFdFW+yZQHhbiokHmKBnSosRcuh6oZ4=;
        b=L7Igl4+PdXqJ5W+moV4daxnYHUdH8JpXSlr9MPBFGGbSXpaeXiZ3Vv3iBKxnuakY5T
         3oHNp0QqZlOCVIS6z8aRSP/zeOnDO0V89wG/apbzsVQYpufsGXU7vm8i4NVdyQVf35BO
         us8Bfg32ASwyD57NGZ9Gu443uDpC1hmJENY+tKc2vJmiS9biGipME66esUVxQHX/fd7+
         29UOP4ggtiwJEamKPs4PmHDiACnatDLcUo2aIizUKR6EFGz6MbtW9X4hv3PzWrVOxEsW
         /od92rqA3sivo0FK+uxRwnHlAdY5NBSUe8+HzTQrwaY3QNzLEyJXlpmVU8kTN6ai1q9q
         LU7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759305020; x=1759909820;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TiEapQYr7qDytFdFW+yZQHhbiokHmKBnSosRcuh6oZ4=;
        b=ip/esdNAZRuw6Nq4n72qb0UX7djIjUBD4L+RbpKHfX650XbyEjnyC5gERcyuY7/wLL
         7Mmbb/ajXgK1LxSVSvuAeyaJa2FxizBYtY6O2zICQK3qd73h+O9yktdYpTJ/ttzAHPVQ
         ANtjnRSgh0I2yVBKIZ2Csx3eEVKTPO8Dgy4/ddtPpkbOiPNmit2c8K51mAi6WCT3wP4r
         S6givnZATMuD+xjHZw3Qr3fboEYy29FgpuUQ+c/Tm7YIGC++2qBTsTOc51AnLDbPNBjX
         UsWS0W7V6TM4K/wwVunqvJbshLhqmpx9n1l8yADjVDd8Tg0GAeOtq8KZ3/8nDW6Bgjmz
         zkKg==
X-Forwarded-Encrypted: i=1; AJvYcCVkyr5CuH6lNFgdIqul4G4vNAzYZjXCXi02Ugg32fPjsPFgtCClNQYfVLK2wNmtIuaoo6BW2DADsOOX@vger.kernel.org
X-Gm-Message-State: AOJu0YwPh15/9HuMaQL3MegnN1pB/hGpSIBYnTpPba5CbHtvZK84NJ8b
	DRNwiRyQjQ8j0+ZoSpYJlE7RLtkEM66APAKz3FoznNl5zwyHUFbPCbWZAS90wfVh+lhV9FSvt6m
	gh3gCgqYXRi/p+ACaK5mFYxUFRf+UaUmOV61WJw7jDg==
X-Gm-Gg: ASbGncsqavl1MhIitaT9PvozSO8smpPcDYlHUpuWkR27eOldkj8mYkwRtlBpe1E89dC
	AvFlaPktFxpKQdegaTMWd2XR+8lN91b5Dnyz4LKQm/aLGecIDcqc4x7F2JaExw1j+hodfzigQEz
	NJcRjkoV/B/bTTrprUIQVAFGi/V4VUHCDzIIdeTx8JhZTFQOqJiXG+hKXjP1QBp/wH8zUkPL/+X
	dKjGA/BWrNAZkaQFpx53FNxPMjtwoxu
X-Google-Smtp-Source: AGHT+IFtwGRldIBVDl/5Z0XL3Us/zaWAc8Ka1F2WEsdDx7dw6/DnkDxSjbnho1yIfueR7MCZ8BAflSDOFtBbGyYwlgE=
X-Received: by 2002:a05:6870:948e:b0:31d:8964:b4aa with SMTP id
 586e51a60fabf-39b8fbbb6a8mr1469816fac.6.1759305019516; Wed, 01 Oct 2025
 00:50:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251001060805.26462-1-beanhuo@iokpp.de> <20251001060805.26462-4-beanhuo@iokpp.de>
In-Reply-To: <20251001060805.26462-4-beanhuo@iokpp.de>
From: Jens Wiklander <jens.wiklander@linaro.org>
Date: Wed, 1 Oct 2025 09:50:08 +0200
X-Gm-Features: AS18NWCsLvPQjUitmh3IeT0eAwVCPtnPUatK-fEXiKL3fpBD4-ziUtMvREB6Bwo
Message-ID: <CAHUa44HA0uoXbkKgyvF4Rb9OJa1Qj-Wh7QAmQxXYAf3grLdktw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] scsi: ufs: core: Add OP-TEE based RPMB driver for
 UFS devices
To: Bean Huo <beanhuo@iokpp.de>
Cc: avri.altman@wdc.com, bvanassche@acm.org, alim.akhtar@samsung.com, 
	jejb@linux.ibm.com, martin.petersen@oracle.com, can.guo@oss.qualcomm.com, 
	ulf.hansson@linaro.org, beanhuo@micron.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Bean,

On Wed, Oct 1, 2025 at 8:08=E2=80=AFAM Bean Huo <beanhuo@iokpp.de> wrote:
>
> From: Bean Huo <beanhuo@micron.com>
>
> This patch adds OP-TEE based RPMB support for UFS devices. This enables s=
ecure RPMB operations on
> UFS devices through OP-TEE, providing the same functionality available fo=
r eMMC devices and
> extending kernel-based secure storage support to UFS-based systems.
>
> Benefits of OP-TEE based RPMB implementation:
> - Eliminates dependency on userspace supplicant for RPMB access
> - Enables early boot secure storage access (e.g., fTPM, secure UEFI varia=
bles)
> - Provides kernel-level RPMB access as soon as UFS driver is initialized
> - Removes complex initramfs dependencies and boot ordering requirements
> - Ensures reliable and deterministic secure storage operations
> - Supports both built-in and modular fTPM configurations
>
> Co-developed-by: Can Guo <can.guo@oss.qualcomm.com>
> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/misc/Kconfig           |   2 +-
>  drivers/ufs/core/Makefile      |   1 +
>  drivers/ufs/core/ufs-rpmb.c    | 253 +++++++++++++++++++++++++++++++++
>  drivers/ufs/core/ufshcd-priv.h |  13 ++
>  drivers/ufs/core/ufshcd.c      |  30 +++-
>  include/ufs/ufs.h              |   4 +
>  include/ufs/ufshcd.h           |   3 +
>  7 files changed, 301 insertions(+), 5 deletions(-)
>  create mode 100644 drivers/ufs/core/ufs-rpmb.c
>
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index b9ca56930003..46ffa62eac6e 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -106,7 +106,7 @@ config PHANTOM
>
>  config RPMB
>         tristate "RPMB partition interface"
> -       depends on MMC
> +       depends on MMC || SCSI_UFSHCD
>         help
>           Unified RPMB unit interface for RPMB capable devices such as eM=
MC and
>           UFS. Provides interface for in-kernel security controllers to a=
ccess
> diff --git a/drivers/ufs/core/Makefile b/drivers/ufs/core/Makefile
> index cf820fa09a04..51e1867e524e 100644
> --- a/drivers/ufs/core/Makefile
> +++ b/drivers/ufs/core/Makefile
> @@ -2,6 +2,7 @@
>
>  obj-$(CONFIG_SCSI_UFSHCD)              +=3D ufshcd-core.o
>  ufshcd-core-y                          +=3D ufshcd.o ufs-sysfs.o ufs-mcq=
.o
> +ufshcd-core-$(CONFIG_RPMB)             +=3D ufs-rpmb.o

SCSI_UFSHCD might need the same trick ("depends on RPMB || !RPMB") in
Kconfig as we have for MMC_BLOCK.

>  ufshcd-core-$(CONFIG_DEBUG_FS)         +=3D ufs-debugfs.o
>  ufshcd-core-$(CONFIG_SCSI_UFS_BSG)     +=3D ufs_bsg.o
>  ufshcd-core-$(CONFIG_SCSI_UFS_CRYPTO)  +=3D ufshcd-crypto.o
> diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
> new file mode 100644
> index 000000000000..84cdcf8efeb3
> --- /dev/null
> +++ b/drivers/ufs/core/ufs-rpmb.c
> @@ -0,0 +1,253 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * UFS OP-TEE based RPMB Driver
> + *
> + * Copyright (C) 2025 Micron Technology, Inc.
> + * Copyright (C) 2025 Qualcomm Technologies, Inc.
> + *
> + * Authors:
> + *     Bean Huo <beanhuo@micron.com>
> + *     Can Guo <can.guo@oss.qualcomm.com>
> + */
> +
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/kernel.h>
> +#include <linux/types.h>
> +#include <linux/rpmb.h>
> +#include <linux/string.h>
> +#include <linux/list.h>
> +#include <ufs/ufshcd.h>
> +#include <linux/unaligned.h>
> +#include "ufshcd-priv.h"
> +
> +#define UFS_RPMB_SEC_PROTOCOL          0xEC    /* JEDEC UFS application =
*/
> +#define UFS_RPMB_SEC_PROTOCOL_ID       0x01    /* JEDEC UFS RPMB protoco=
l ID, CDB byte3 */
> +
> +static const struct bus_type ufs_rpmb_bus_type =3D {
> +       .name =3D "ufs_rpmb",
> +};
> +
> +/* UFS RPMB device structure */
> +struct ufs_rpmb_dev {
> +       u8 region_id;
> +       struct device dev;
> +       struct rpmb_dev *rdev;
> +       struct ufs_hba *hba;
> +       struct list_head node;
> +};
> +
> +static int ufs_sec_submit(struct ufs_hba *hba, u16 spsp, void *buffer, s=
ize_t len, bool send)
> +{
> +       struct scsi_device *sdev =3D hba->ufs_rpmb_wlun;
> +       u8 cdb[12] =3D { };
> +
> +       cdb[0] =3D send ? SECURITY_PROTOCOL_OUT : SECURITY_PROTOCOL_IN;
> +       cdb[1] =3D UFS_RPMB_SEC_PROTOCOL;
> +       put_unaligned_be16(spsp, &cdb[2]);
> +       put_unaligned_be32(len, &cdb[6]);
> +
> +       return scsi_execute_cmd(sdev, cdb, send ? REQ_OP_DRV_OUT : REQ_OP=
_DRV_IN,
> +                               buffer, len, /*timeout=3D*/30 * HZ, 0, NU=
LL);
> +}
> +
> +/* UFS RPMB route frames implementation */
> +static int ufs_rpmb_route_frames(struct device *dev, u8 *req, unsigned i=
nt req_len, u8 *resp,
> +                                       unsigned int resp_len)
> +{
> +       struct ufs_rpmb_dev *ufs_rpmb =3D dev_get_drvdata(dev);
> +       struct rpmb_frame *frm_out =3D (struct rpmb_frame *)req;
> +       bool need_result_read =3D true;
> +       u16 req_type, protocol_id;
> +       struct ufs_hba *hba;
> +       int ret;
> +
> +       if (!ufs_rpmb) {
> +               dev_err(dev, "Missing driver data\n");
> +               return -ENODEV;
> +       }
> +
> +       if (!req || !req_len || !resp || !resp_len)
> +               return -EINVAL;

This function is only called indirectly from rpmb_route_frames(),
where this is already checked.

> +
> +       hba =3D ufs_rpmb->hba;
> +
> +       req_type =3D be16_to_cpu(frm_out->req_resp);
> +
> +       switch (req_type) {
> +       case RPMB_PROGRAM_KEY:
> +               if (req_len !=3D sizeof(struct rpmb_frame) || resp_len !=
=3D sizeof(struct rpmb_frame))
> +                       return -EINVAL;
> +               break;
> +       case RPMB_GET_WRITE_COUNTER:
> +               if (req_len !=3D sizeof(struct rpmb_frame) || resp_len !=
=3D sizeof(struct rpmb_frame))
> +                       return -EINVAL;
> +               need_result_read =3D false;
> +               break;
> +       case RPMB_WRITE_DATA:
> +               if (req_len % sizeof(struct rpmb_frame) || resp_len !=3D =
sizeof(struct rpmb_frame))
> +                       return -EINVAL;
> +               break;
> +       case RPMB_READ_DATA:
> +               if (req_len !=3D sizeof(struct rpmb_frame) || resp_len % =
sizeof(struct rpmb_frame))
> +                       return -EINVAL;
> +               need_result_read =3D false;
> +               break;
> +       default:
> +               dev_err(dev, "Unknown request type=3D0x%04x\n", req_type)=
;
> +               return -EINVAL;
> +       }
> +
> +       protocol_id =3D ufs_rpmb->region_id << 8 | UFS_RPMB_SEC_PROTOCOL_=
ID;
> +
> +       ret =3D ufs_sec_submit(hba, protocol_id, req, req_len, true);
> +       if (ret) {
> +               dev_err(dev, "Command failed with ret=3D%d\n", ret);
> +               return ret;
> +       }
> +
> +       if (need_result_read) {
> +               struct rpmb_frame *frm_resp =3D (struct rpmb_frame *)resp=
;
> +
> +               memset(frm_resp, 0, sizeof(*frm_resp));
> +               frm_resp->req_resp =3D cpu_to_be16(RPMB_RESULT_READ);
> +               ret =3D ufs_sec_submit(hba, protocol_id, resp, resp_len, =
true);
> +               if (ret) {
> +                       dev_err(dev, "Result read request failed with ret=
=3D%d\n", ret);
> +                       return ret;
> +               }
> +       }
> +
> +       if (!ret) {
> +               ret =3D ufs_sec_submit(hba, protocol_id, resp, resp_len, =
false);
> +               if (ret)
> +                       dev_err(dev, "Response read failed with ret=3D%d\=
n", ret);
> +       }
> +
> +       return ret;
> +}
> +
> +static void ufs_rpmb_device_release(struct device *dev)
> +{
> +       struct ufs_rpmb_dev *ufs_rpmb =3D dev_get_drvdata(dev);
> +
> +       if (ufs_rpmb->rdev)

rpmb_dev_unregister() already checks rdev for NULL.

> +               rpmb_dev_unregister(ufs_rpmb->rdev);
> +}
> +
> +/* UFS RPMB device registration */
> +int ufs_rpmb_probe(struct ufs_hba *hba)
> +{
> +       struct ufs_rpmb_dev *ufs_rpmb, *it, *tmp;
> +       struct rpmb_dev *rdev;
> +       u8 cid[16] =3D { };
> +       int region;
> +       u8 *sn;
> +       u32 cap;
> +       int ret;
> +
> +       if (!hba->ufs_rpmb_wlun) {
> +               dev_info(hba->dev, "No RPMB LUN, skip RPMB registration\n=
");
> +               return -ENODEV;
> +       }
> +
> +       /* Get the UNICODE serial number data */
> +       sn =3D hba->dev_info.serial_number;
> +       if (!sn) {
> +               dev_err(hba->dev, "Serial number not available\n");
> +               return -EINVAL;
> +       }
> +
> +       INIT_LIST_HEAD(&hba->rpmbs);
> +
> +       /* Copy serial number into device ID (max 15 chars + NUL). */
> +       strscpy(cid, sn, sizeof(cid));

strscpy(cid, sn) is enough; strscpy() can determine the size itself
since cid is an array.

> +
> +       struct rpmb_descr descr =3D {
> +               .type =3D RPMB_TYPE_UFS,

We'll need another type if the device uses the extended RPMB frame
format. How about you clarify this, where RPMB_TYPE_UFS is defined to
avoid confusion?

> +               .route_frames =3D ufs_rpmb_route_frames,
> +               .dev_id_len =3D sizeof(cid),
> +               .reliable_wr_count =3D hba->dev_info.rpmb_io_size,
> +       };
> +
> +       for (region =3D 0; region < 4; region++) {

Would it make sense to use ARRAY_SIZE(hba->dev_info.rpmb_region_size)
to avoid another magic number?

> +               cap =3D hba->dev_info.rpmb_region_size[region];
> +               if (!cap)
> +                       continue;
> +
> +               ufs_rpmb =3D devm_kzalloc(hba->dev, sizeof(*ufs_rpmb), GF=
P_KERNEL);
> +               if (!ufs_rpmb) {
> +                       ret =3D -ENOMEM;
> +                       goto err_out;
> +               }
> +
> +               ufs_rpmb->hba =3D hba;
> +               ufs_rpmb->dev.parent =3D &hba->ufs_rpmb_wlun->sdev_gendev=
;
> +               ufs_rpmb->dev.bus =3D &ufs_rpmb_bus_type;
> +               ufs_rpmb->dev.release =3D ufs_rpmb_device_release;
> +               dev_set_name(&ufs_rpmb->dev, "ufs_rpmb%d", region);
> +
> +               /* Set driver data BEFORE device_register */
> +               dev_set_drvdata(&ufs_rpmb->dev, ufs_rpmb);
> +
> +               ret =3D device_register(&ufs_rpmb->dev);
> +               if (ret) {
> +                       dev_err(hba->dev, "Failed to register UFS RPMB de=
vice %d\n", region);
> +                       put_device(&ufs_rpmb->dev);
> +                       goto err_out;
> +               }
> +
> +               /* Make CID unique for this region by appending region nu=
mbe */
> +               cid[sizeof(cid) - 1] =3D region;
> +               descr.dev_id =3D (void *)cid;

Casting isn't needed; descr.dev_id has the same type as cid.

Cheers,
Jens

> +               descr.capacity =3D cap;
> +
> +               /* Register RPMB device */
> +               rdev =3D rpmb_dev_register(&ufs_rpmb->dev, &descr);
> +               if (IS_ERR(rdev)) {
> +                       dev_err(hba->dev, "Failed to register UFS RPMB de=
vice.\n");
> +                       device_unregister(&ufs_rpmb->dev);
> +                       ret =3D PTR_ERR(rdev);
> +                       goto err_out;
> +               }
> +
> +               ufs_rpmb->rdev =3D rdev;
> +               ufs_rpmb->region_id =3D region;
> +
> +               list_add_tail(&ufs_rpmb->node, &hba->rpmbs);
> +
> +               dev_info(hba->dev, "UFS RPMB region %d registered (capaci=
ty=3D%u)\n", region, cap);
> +       }
> +
> +       return 0;
> +err_out:
> +       list_for_each_entry_safe(it, tmp, &hba->rpmbs, node) {
> +               list_del(&it->node);
> +               device_unregister(&it->dev);
> +       }
> +
> +       return ret;
> +}
> +
> +/* UFS RPMB remove handler */
> +void ufs_rpmb_remove(struct ufs_hba *hba)
> +{
> +       struct ufs_rpmb_dev *ufs_rpmb, *tmp;
> +
> +       if (list_empty(&hba->rpmbs))
> +               return;
> +
> +       /* Remove all registered RPMB devices */
> +       list_for_each_entry_safe(ufs_rpmb, tmp, &hba->rpmbs, node) {
> +               dev_info(hba->dev, "Removing UFS RPMB region %d\n", ufs_r=
pmb->region_id);
> +               /* Remove from list first */
> +               list_del(&ufs_rpmb->node);
> +               /* Unregister device */
> +               device_unregister(&ufs_rpmb->dev);
> +       }
> +
> +       dev_info(hba->dev, "All UFS RPMB devices unregistered\n");
> +}
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("OP-TEE RPMB subsystem based UFS RPMB driver");
> diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-pri=
v.h
> index d0a2c963a27d..523828d6b1d5 100644
> --- a/drivers/ufs/core/ufshcd-priv.h
> +++ b/drivers/ufs/core/ufshcd-priv.h
> @@ -411,4 +411,17 @@ static inline u32 ufshcd_mcq_get_sq_head_slot(struct=
 ufs_hw_queue *q)
>         return val / sizeof(struct utp_transfer_req_desc);
>  }
>
> +#ifdef CONFIG_RPMB
> +int ufs_rpmb_probe(struct ufs_hba *hba);
> +void ufs_rpmb_remove(struct ufs_hba *hba);
> +#else
> +static inline int ufs_rpmb_probe(struct ufs_hba *hba)
> +{
> +       return 0;
> +}
> +static inline void ufs_rpmb_remove(struct ufs_hba *hba)
> +{
> +}
> +#endif
> +
>  #endif /* _UFSHCD_PRIV_H_ */
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 79c7588be28a..ec1670d94946 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5240,10 +5240,15 @@ static void ufshcd_lu_init(struct ufs_hba *hba, s=
truct scsi_device *sdev)
>             desc_buf[UNIT_DESC_PARAM_LU_WR_PROTECT] =3D=3D UFS_LU_POWER_O=
N_WP)
>                 hba->dev_info.is_lu_power_on_wp =3D true;
>
> -       /* In case of RPMB LU, check if advanced RPMB mode is enabled */
> -       if (desc_buf[UNIT_DESC_PARAM_UNIT_INDEX] =3D=3D UFS_UPIU_RPMB_WLU=
N &&
> -           desc_buf[RPMB_UNIT_DESC_PARAM_REGION_EN] & BIT(4))
> -               hba->dev_info.b_advanced_rpmb_en =3D true;
> +       /* In case of RPMB LU, check if advanced RPMB mode is enabled, an=
d get region size */
> +       if (desc_buf[UNIT_DESC_PARAM_UNIT_INDEX] =3D=3D UFS_UPIU_RPMB_WLU=
N) {
> +               if (desc_buf[RPMB_UNIT_DESC_PARAM_REGION_EN] & BIT(4))
> +                       hba->dev_info.b_advanced_rpmb_en =3D true;

Does this indicate that the other RPMB frame format is used?

> +               hba->dev_info.rpmb_region_size[0] =3D desc_buf[RPMB_UNIT_=
DESC_PARAM_REGION0_SIZE];
> +               hba->dev_info.rpmb_region_size[1] =3D desc_buf[RPMB_UNIT_=
DESC_PARAM_REGION1_SIZE];
> +               hba->dev_info.rpmb_region_size[2] =3D desc_buf[RPMB_UNIT_=
DESC_PARAM_REGION2_SIZE];
> +               hba->dev_info.rpmb_region_size[3] =3D desc_buf[RPMB_UNIT_=
DESC_PARAM_REGION3_SIZE];
> +       }
>
>
>         kfree(desc_buf);
> @@ -8151,8 +8156,11 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba *hb=
a)
>                 ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_RPMB_WLUN), NULL);
>         if (IS_ERR(sdev_rpmb)) {
>                 ret =3D PTR_ERR(sdev_rpmb);
> +               hba->ufs_rpmb_wlun =3D NULL;
> +               dev_err(hba->dev, "%s: RPMB WLUN not found\n", __func__);
>                 goto remove_ufs_device_wlun;
>         }
> +       hba->ufs_rpmb_wlun =3D sdev_rpmb;
>         ufshcd_blk_pm_runtime_init(sdev_rpmb);
>         scsi_device_put(sdev_rpmb);
>
> @@ -8425,6 +8433,7 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
>         int err;
>         u8 model_index;
>         u8 *desc_buf;
> +       u8 serial_index;
>         struct ufs_dev_info *dev_info =3D &hba->dev_info;
>
>         desc_buf =3D kzalloc(QUERY_DESC_MAX_SIZE, GFP_KERNEL);
> @@ -8460,6 +8469,7 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
>                                 UFS_DEV_HID_SUPPORT;
>
>         model_index =3D desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
> +       serial_index =3D desc_buf[DEVICE_DESC_PARAM_SN];
>
>         err =3D ufshcd_read_string_desc(hba, model_index,
>                                       &dev_info->model, SD_ASCII_STD);
> @@ -8469,6 +8479,12 @@ static int ufs_get_device_desc(struct ufs_hba *hba=
)
>                 goto out;
>         }
>
> +       err =3D ufshcd_read_string_desc(hba, serial_index, &dev_info->ser=
ial_number, SD_RAW);
> +       if (err < 0) {
> +               dev_err(hba->dev, "%s: Failed reading Serial Number. err =
=3D %d\n", __func__, err);
> +               goto out;
> +       }
> +
>         hba->luns_avail =3D desc_buf[DEVICE_DESC_PARAM_NUM_LU] +
>                 desc_buf[DEVICE_DESC_PARAM_NUM_WLU];
>
> @@ -8504,6 +8520,8 @@ static void ufs_put_device_desc(struct ufs_hba *hba=
)
>
>         kfree(dev_info->model);
>         dev_info->model =3D NULL;
> +       kfree(dev_info->serial_number);
> +       dev_info->serial_number =3D NULL;
>  }
>
>  /**
> @@ -8647,6 +8665,8 @@ static int ufshcd_device_geo_params_init(struct ufs=
_hba *hba)
>         else if (desc_buf[GEOMETRY_DESC_PARAM_MAX_NUM_LUN] =3D=3D 0)
>                 hba->dev_info.max_lu_supported =3D 8;
>
> +       hba->dev_info.rpmb_io_size =3D desc_buf[GEOMETRY_DESC_PARAM_RPMB_=
RW_SIZE];
> +
>  out:
>         kfree(desc_buf);
>         return err;
> @@ -8832,6 +8852,7 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
>
>         ufs_bsg_probe(hba);
>         scsi_scan_host(hba->host);
> +       ufs_rpmb_probe(hba);
>
>  out:
>         return ret;
> @@ -10391,6 +10412,7 @@ void ufshcd_remove(struct ufs_hba *hba)
>                 ufshcd_rpm_get_sync(hba);
>         ufs_hwmon_remove(hba);
>         ufs_bsg_remove(hba);
> +       ufs_rpmb_remove(hba);
>         ufs_sysfs_remove_nodes(hba->dev);
>         cancel_delayed_work_sync(&hba->ufs_rtc_update_work);
>         blk_mq_destroy_queue(hba->tmf_queue);
> diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
> index 72fd385037a6..1d44e2b32253 100644
> --- a/include/ufs/ufs.h
> +++ b/include/ufs/ufs.h
> @@ -651,6 +651,10 @@ struct ufs_dev_info {
>         u8 rtt_cap; /* bDeviceRTTCap */
>
>         bool hid_sup;
> +
> +       u8 *serial_number;
> +       u8 rpmb_io_size;
> +       u8 rpmb_region_size[4];
>  };
>
>  /*
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index 1d3943777584..17e97a45ef71 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -984,6 +984,7 @@ struct ufs_hba {
>         struct Scsi_Host *host;
>         struct device *dev;
>         struct scsi_device *ufs_device_wlun;
> +       struct scsi_device *ufs_rpmb_wlun;
>
>  #ifdef CONFIG_SCSI_UFS_HWMON
>         struct device *hwmon_device;
> @@ -1140,6 +1141,8 @@ struct ufs_hba {
>         int critical_health_count;
>         atomic_t dev_lvl_exception_count;
>         u64 dev_lvl_exception_id;
> +
> +       struct list_head rpmbs;
>  };
>
>  /**
> --
> 2.34.1
>
