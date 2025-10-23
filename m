Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF894323414
	for <linux-scsi@vger.kernel.org>; Thu, 23 Oct 2025 13:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761227632; cv=none; b=gwyms+EV3/3glXx3K7CWDd2bwJBo0xf/Bs79CzQo+k/V+oW8/TXpWxf9vV50MMdrYPETbYJFZcj0LEfWAE+Ou33oD1Apgv82niFt/imahlUb/hBrxPgU4GGAeGKbQDFKGdlxYYogDybol0HRgfGc85wrDqC0NpsgDE6if9MJQ1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761227632; c=relaxed/simple;
	bh=Gy1upVPS1ozbAcwAJYibkyjlElOEZjYdHD4Exu+fm5U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ua+xyPvCNHhscjQZ8SMVZkBN7rp6hfmsCbYkyA6f6rqS7sJze1BsCVKx/W/G8pi8p/Y0wzVE9x+tt/e9vaDhWD01WwHX4IYWhztrNSuCvLyivrWPSvQrZAuUMOuX/Ql2wSZkRhA7e7Gv3a3SLSxdXB0RGdtuhZPLWj6+EsYVZRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pDNrBf7U; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pDNrBf7U"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-442003b80d0so350590b6e.1
        for <linux-scsi@vger.kernel.org>; Thu, 23 Oct 2025 06:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761227629; x=1761832429; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gWJ8sBup6T/CgTL9UDL0DGpvbdlI4z5XnB1lEfrG2NA=;
        b=pDNrBf7UdaN2xT0Jh/lD37EgPS2Q0xzg5YzxLZ7uPHr89KxBz4UnQqqEPFvjQ18Bbc
         H2QqSy/m65bk7uXxOeyNRourMXRfhxnaLEM5we7hEAYlFUKVx5fRkhhEY9nwMDZRNPvK
         uWrR+HEkqpr4/P6/LyuVF7V8dmQsikBwK/Nu2grZzGxpifhNkHAN0bbvTvxUvnsCsdoT
         rtd5rCoyENMx2SlVkkB/YH7t8XWPHDmD1SM0k+0P6VS/2/eqxtfMp5+MjZkziDjbpUNL
         fJnn1+GBAuWG0PiV/HmBcwwEDeP7DwL40g7KsnTLzZOKLNKPFyJz5ZjVZSm6K8/prL1a
         4CHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761227629; x=1761832429;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gWJ8sBup6T/CgTL9UDL0DGpvbdlI4z5XnB1lEfrG2NA=;
        b=hYK3z3pBnt5i2sVGQZrm+SOEozOTJ1+cXfdIf2Ut0KOh9XETtGDBO9s9JiENScDr6R
         YkAuLUL47Zc8sL0qITidBzonlHuHqh80hMIq1M83q/QjQNBL4fv/bpbQRT7NQ7C/8JZ3
         e0EOr3KJ3riv17r7CFpP4dOKB76BIjbTyB2N3OK7R9DgAuYiQsGZZpwpu7z3Nzs7CqNY
         3qoCKNYKviKwvwfof3L05zd1bmun4I1KDcsQvPZOHXZ9FLeNdPNuvnIdWYYb/mnPduJB
         DgG8SIDUQt/8vg6G/obS2SWF2TPKYBDx0Tzo7eomvM2YK704G857wc9fXdIXle2mtV6Q
         ywkQ==
X-Forwarded-Encrypted: i=1; AJvYcCW8z1nZ4ZmTHeDyftgstWgvz/vEX4dRCCrJjzs1i83v9aoTV5aHT+VvblMNVmK6cYakwuV2nPGr16oB@vger.kernel.org
X-Gm-Message-State: AOJu0YyOgvD7c/uE5iDhcpTI+ZrCOmLfXin+wDVFPpcgea7imyFtYRsv
	1RlJW+htaDZMCHhkJ1lNk8fRdjO5IcwEUJBNNOnwyV51hzKyucf0Mc1l2xRRbOw5t0xkx0g6Wr4
	8MWwlfFBRmfJP4WkqHGGthJmyp/2WU1jlYbbX0ZWiVg==
X-Gm-Gg: ASbGnctxks6DHzZmBaZ5I/PpAi4xcVV6rKNZFvOKnGqnmlMX9zDH2J0bHQh5OpRA4sv
	Oe1b8eWLeJ+CjczYGdxgywra9P78JQKtRgg2KcSOe37XPETePmTt7ETiPshstnD1G3NDHofOwwl
	/rpqul8AXYvKGDFscRBoZ7U9/LQm/OvC5qVGLhx1PT1XWtKFP1c/raj8IvpK1SZQoYcIQBln/3r
	ughxVwGc3DVx7exdAQPggegCYlNcDW4I4Y2hhAH+dXwDe/U3WRVuHm3DkecEy4A8irxMA==
X-Google-Smtp-Source: AGHT+IGUx1xLcyAc5CYTbRx2xHqgJQzrbezZsFK1pF/CIWEWAXeFDsw4GbOlqbF6EnZ2EoPnpz7ahACmVdCyy0yB/xU=
X-Received: by 2002:a05:6808:22e1:b0:441:8260:d097 with SMTP id
 5614622812f47-44963d809a3mr2478138b6e.11.1761227628788; Thu, 23 Oct 2025
 06:53:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251021124254.1120214-1-beanhuo@iokpp.de> <20251021124254.1120214-4-beanhuo@iokpp.de>
In-Reply-To: <20251021124254.1120214-4-beanhuo@iokpp.de>
From: Jens Wiklander <jens.wiklander@linaro.org>
Date: Thu, 23 Oct 2025 15:53:37 +0200
X-Gm-Features: AS18NWBusS87WrnvQx429gOutWfdxSXb6OuP58gy1bmEkaWSr7LyTSPA0Gl3Xv4
Message-ID: <CAHUa44FfQAPWGgVbfrCnZfF9HkGwW=fgUhV-y9RKrUQf1V6yNg@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] scsi: ufs: core: Add OP-TEE based RPMB driver for
 UFS devices
To: Bean Huo <beanhuo@iokpp.de>
Cc: avri.altman@wdc.com, avri.altman@sandisk.com, bvanassche@acm.org, 
	alim.akhtar@samsung.com, jejb@linux.ibm.com, martin.petersen@oracle.com, 
	can.guo@oss.qualcomm.com, ulf.hansson@linaro.org, beanhuo@micron.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Bean,

On Tue, Oct 21, 2025 at 2:43=E2=80=AFPM Bean Huo <beanhuo@iokpp.de> wrote:
>
> From: Bean Huo <beanhuo@micron.com>
>
> This patch adds OP-TEE based RPMB support for UFS devices. This enables s=
ecure
> RPMB operations on UFS devices through OP-TEE, providing the same functio=
nality
> available for eMMC devices and extending kernel-based secure storage supp=
ort to
> UFS-based systems.
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
> Reviewed-by: Avri Altman <avri.altman@sandisk.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/misc/Kconfig           |   2 +-
>  drivers/ufs/core/Makefile      |   1 +
>  drivers/ufs/core/ufs-rpmb.c    | 254 +++++++++++++++++++++++++++++++++
>  drivers/ufs/core/ufshcd-priv.h |  13 ++
>  drivers/ufs/core/ufshcd.c      |  82 ++++++++++-
>  include/ufs/ufs.h              |   5 +
>  include/ufs/ufshcd.h           |   8 +-
>  7 files changed, 358 insertions(+), 7 deletions(-)
>  create mode 100644 drivers/ufs/core/ufs-rpmb.c
>
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index b9c11f67315f..9d1de68dee27 100644
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
>  ufshcd-core-$(CONFIG_DEBUG_FS)         +=3D ufs-debugfs.o
>  ufshcd-core-$(CONFIG_SCSI_UFS_BSG)     +=3D ufs_bsg.o
>  ufshcd-core-$(CONFIG_SCSI_UFS_CRYPTO)  +=3D ufshcd-crypto.o
> diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
> new file mode 100644
> index 000000000000..ffad049872b9
> --- /dev/null
> +++ b/drivers/ufs/core/ufs-rpmb.c
> @@ -0,0 +1,254 @@
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
> +       rpmb_dev_unregister(ufs_rpmb->rdev);
> +}
> +
> +/* UFS RPMB device registration */
> +int ufs_rpmb_probe(struct ufs_hba *hba)
> +{
> +       struct ufs_rpmb_dev *ufs_rpmb, *it, *tmp;
> +       struct rpmb_dev *rdev;
> +       char *cid =3D NULL;
> +       int region;
> +       u32 cap;
> +       int ret;
> +
> +       if (!hba->ufs_rpmb_wlun || hba->dev_info.b_advanced_rpmb_en) {
> +               dev_info(hba->dev, "Skip OP-TEE RPMB registration\n");
> +               return -ENODEV;
> +       }
> +
> +       /* Check if device_id is available */
> +       if (!hba->dev_info.device_id) {
> +               dev_err(hba->dev, "UFS Device ID not available\n");
> +               return -EINVAL;
> +       }
> +
> +       INIT_LIST_HEAD(&hba->rpmbs);
> +
> +       struct rpmb_descr descr =3D {
> +               .type =3D RPMB_TYPE_UFS,
> +               .route_frames =3D ufs_rpmb_route_frames,
> +               .reliable_wr_count =3D hba->dev_info.rpmb_io_size,
> +       };
> +
> +       for (region =3D 0; region < ARRAY_SIZE(hba->dev_info.rpmb_region_=
size); region++) {
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
> +               /* Create unique ID by appending region number to device_=
id */
> +               cid =3D kasprintf(GFP_KERNEL, "%s-R%d", hba->dev_info.dev=
ice_id, region);
> +               if (!cid) {
> +                       device_unregister(&ufs_rpmb->dev);
> +                       ret =3D -ENOMEM;
> +                       goto err_out;
> +               }
> +
> +               descr.dev_id =3D cid;
> +               descr.dev_id_len =3D strlen(cid);
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
> +               kfree(cid);
> +               cid =3D NULL;
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
> +       kfree(cid);
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
> +MODULE_DESCRIPTION("OP-TEE UFS RPMB driver");
> diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-pri=
v.h
> index d74742a855b2..e63b0e9075e0 100644
> --- a/drivers/ufs/core/ufshcd-priv.h
> +++ b/drivers/ufs/core/ufshcd-priv.h
> @@ -417,4 +417,17 @@ static inline u32 ufshcd_mcq_get_sq_head_slot(struct=
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
> index af7f87f27630..4e0ba344dbea 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5254,10 +5254,15 @@ static void ufshcd_lu_init(struct ufs_hba *hba, s=
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
> @@ -8187,8 +8192,11 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba *hb=
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
> @@ -8456,6 +8464,63 @@ static void ufs_init_rtc(struct ufs_hba *hba, u8 *=
desc_buf)
>         dev_info->rtc_update_period =3D 0;
>  }
>
> +/**
> + * ufshcd_create_device_id - Generate unique device identifier string
> + * @hba: per-adapter instance
> + * @desc_buf: device descriptor buffer
> + *
> + * Creates a unique device ID string combining manufacturer ID, spec ver=
sion,
> + * model name, serial number (as hex), device version, and manufacture d=
ate.
> + *
> + * Returns: Allocated device ID string on success, NULL on failure
> + */
> +static char *ufshcd_create_device_id(struct ufs_hba *hba, u8 *desc_buf)
> +{
> +       struct ufs_dev_info *dev_info =3D &hba->dev_info;
> +       u8 *serial_number;
> +       char *serial_hex;
> +       char *device_id;
> +       u8 serial_index;
> +       u16 device_version;
> +       u16 manufacture_date;
> +       int serial_len;
> +       int ret;
> +
> +       serial_index =3D desc_buf[DEVICE_DESC_PARAM_SN];
> +
> +       ret =3D ufshcd_read_string_desc(hba, serial_index, &serial_number=
, SD_RAW);
> +       if (ret < 0) {
> +               dev_err(hba->dev, "Failed reading Serial Number. err =3D =
%d\n", ret);
> +               return NULL;
> +       }
> +
> +       device_version =3D get_unaligned_be16(&desc_buf[DEVICE_DESC_PARAM=
_DEV_VER]);
> +       manufacture_date =3D get_unaligned_be16(&desc_buf[DEVICE_DESC_PAR=
AM_MANF_DATE]);
> +
> +       serial_len =3D ret;
> +       /* Allocate buffer for hex string: 2 chars per byte + null termin=
ator */
> +       serial_hex =3D kzalloc(serial_len * 2 + 1, GFP_KERNEL);
> +       if (!serial_hex) {
> +               kfree(serial_number);
> +               return NULL;
> +       }
> +
> +       bin2hex(serial_hex, serial_number, serial_len);
> +
> +       device_id =3D kasprintf(GFP_KERNEL, "%04X-%04X-%s-%s-%04X-%04X",
> +                             dev_info->wmanufacturerid, dev_info->wspecv=
ersion,
> +                             dev_info->model, serial_hex, device_version=
,
> +                             manufacture_date);


The device ID is part of the ABI with the secure world or the firmware
we're serving. It might be worth adding a comment so the format isn't
changed without understanding the consequences.

Cheers,
Jens

> +
> +       kfree(serial_hex);
> +       kfree(serial_number);
> +
> +       if (!device_id)
> +               dev_warn(hba->dev, "Failed to allocate unique device ID\n=
");
> +
> +       return device_id;
> +}
> +
>  static int ufs_get_device_desc(struct ufs_hba *hba)
>  {
>         int err;
> @@ -8507,6 +8572,9 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
>                 goto out;
>         }
>
> +       /* Generate unique device ID */
> +       dev_info->device_id =3D ufshcd_create_device_id(hba, desc_buf);
> +
>         hba->luns_avail =3D desc_buf[DEVICE_DESC_PARAM_NUM_LU] +
>                 desc_buf[DEVICE_DESC_PARAM_NUM_WLU];
>
> @@ -8542,6 +8610,8 @@ static void ufs_put_device_desc(struct ufs_hba *hba=
)
>
>         kfree(dev_info->model);
>         dev_info->model =3D NULL;
> +       kfree(dev_info->device_id);
> +       dev_info->device_id =3D NULL;
>  }
>
>  /**
> @@ -8685,6 +8755,8 @@ static int ufshcd_device_geo_params_init(struct ufs=
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
> @@ -8871,6 +8943,7 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
>
>         ufs_bsg_probe(hba);
>         scsi_scan_host(hba->host);
> +       ufs_rpmb_probe(hba);
>
>  out:
>         return ret;
> @@ -10425,6 +10498,7 @@ void ufshcd_remove(struct ufs_hba *hba)
>                 ufshcd_rpm_get_sync(hba);
>         ufs_hwmon_remove(hba);
>         ufs_bsg_remove(hba);
> +       ufs_rpmb_remove(hba);
>         ufs_sysfs_remove_nodes(hba->dev);
>         cancel_delayed_work_sync(&hba->ufs_rtc_update_work);
>         blk_mq_destroy_queue(hba->tmf_queue);
> diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
> index 245a6a829ce9..ab8f6c07b5a2 100644
> --- a/include/ufs/ufs.h
> +++ b/include/ufs/ufs.h
> @@ -651,6 +651,11 @@ struct ufs_dev_info {
>         u8 rtt_cap; /* bDeviceRTTCap */
>
>         bool hid_sup;
> +
> +       /* Unique device ID string (manufacturer+model+serial+version+dat=
e) */
> +       char *device_id;
> +       u8 rpmb_io_size;
> +       u8 rpmb_region_size[4];
>  };
>
>  #endif /* End of Header */
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index b4eb2fa58552..959d42d9b1c8 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -826,6 +826,7 @@ enum ufshcd_mcq_opr {
>   * @host: Scsi_Host instance of the driver
>   * @dev: device handle
>   * @ufs_device_wlun: WLUN that controls the entire UFS device.
> + * @ufs_rpmb_wlun: RPMB WLUN SCSI device
>   * @hwmon_device: device instance registered with the hwmon core.
>   * @curr_dev_pwr_mode: active UFS device power mode.
>   * @uic_link_state: active state of the link to the UFS device.
> @@ -941,8 +942,8 @@ enum ufshcd_mcq_opr {
>   * @pm_qos_mutex: synchronizes PM QoS request and status updates
>   * @critical_health_count: count of critical health exceptions
>   * @dev_lvl_exception_count: count of device level exceptions since last=
 reset
> - * @dev_lvl_exception_id: vendor specific information about the
> - * device level exception event.
> + * @dev_lvl_exception_id: vendor specific information about the device l=
evel exception event.
> + * @rpmbs: list of OP-TEE RPMB devices (one per RPMB region)
>   */
>  struct ufs_hba {
>         void __iomem *mmio_base;
> @@ -960,6 +961,7 @@ struct ufs_hba {
>         struct Scsi_Host *host;
>         struct device *dev;
>         struct scsi_device *ufs_device_wlun;
> +       struct scsi_device *ufs_rpmb_wlun;
>
>  #ifdef CONFIG_SCSI_UFS_HWMON
>         struct device *hwmon_device;
> @@ -1117,6 +1119,8 @@ struct ufs_hba {
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
