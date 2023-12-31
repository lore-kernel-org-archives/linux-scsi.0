Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880B8C8C8
	for <linux-scsi@vger.kernel.org>; Sun, 31 Dec 2023 17:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IMXWbv59"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a27e323fdd3so45296666b.2
        for <linux-scsi@vger.kernel.org>; Sun, 31 Dec 2023 09:58:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1704045495; x=1704650295; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lkhcyDgSoQFyhu0aJZqLCDxXmPXrgRS4HF1/Xyf01QU=;
        b=IMXWbv59gtNclhUz+WQBfT450rQZImRJYjb7CgoLrvNgV31f+14UeRgrTbNG/YHx4E
         5+1WgYdFGpWdEyUmqpILH9AzGjWV0RGDHtykx3sN1jaOqfjoj4ndTr1Jvr9CPTk24o8r
         gB4BvmEaTpWpqohmH/+PFSE9J71ihY1tYLz9do2c+/8l1Dr7ZqNYJMYRrXjYCjMo2YW1
         2URpN+NgokNLk/2T7v5v3uiba2fvb5kpAZry9krw/PNSGI5qygU35T1POY4dZZPFDiC8
         IUYFrDgWbqUFej2Nw71VtiDFJWZvzEvZsZX0cstwWblXGK4bdsceIMtQp8ciPQhuhbb/
         p3Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704045495; x=1704650295;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lkhcyDgSoQFyhu0aJZqLCDxXmPXrgRS4HF1/Xyf01QU=;
        b=gvgV2hX+VUXPLsUAb1VuNGL3Zad14oYU2IWLnhV0tVLa4lXLO3qejmHC0shHW5hl3t
         psJD6ErXyAXaW2rXPrei97n2Cn4yaFY9p+pXA42WACg98NgHCzeBTKScGQTzS9UdG+0o
         78jAldPHM4onWBqUn8NNmu8uRxDKaWjIJxYiKvhAIxi/4H8/FL217y3Vd1zJz7qznNRW
         v3zA2h8LQ314VWyU8PndpLLqRG43Tf1+n6UVJnuEJLP0n1eGoUVfums6fRqMfIPclW80
         rACte8/R5n1cj5nwBInQKkmhdeLx0oCpv3ZcaZxr5n/AQPIiZdCdOaR96P+91RBydvKd
         /edA==
X-Gm-Message-State: AOJu0Yw+YuSCyVbLFhQ7+TqX5cOqZWGYPX3RLJk7SbX9hxU4to9qqrGr
	626yltwn4ukA1I99NFqA/3V0zeQFCcwFLuZqABbkAmuaJJJz8g==
X-Google-Smtp-Source: AGHT+IEUFINRTu5AAT8okIyArIkIwVo6sJcxrMhk5gZgDw5NBqUoB3oLxlNRRVcyiPQVJPk5UQXUVIpzIQEtnRDBo5E=
X-Received: by 2002:a17:907:3202:b0:a27:a164:c579 with SMTP id
 xg2-20020a170907320200b00a27a164c579mr1719239ejb.22.1704045494910; Sun, 31
 Dec 2023 09:58:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231229040331.52518-1-kanie@linux.alibaba.com>
In-Reply-To: <20231229040331.52518-1-kanie@linux.alibaba.com>
From: Lee Duncan <lduncan@suse.com>
Date: Sun, 31 Dec 2023 09:58:03 -0800
Message-ID: <CAPj3X_XMK9v-N4N86hrMBBWKKMLohH4DTsepa+Fyha80paci1g@mail.gmail.com>
Subject: Re: [PATCH V2] scsi: mpi3mr: use ida to manage mrioc's id
To: Guixin Liu <kanie@linux.alibaba.com>
Cc: sathya.prakash@broadcom.com, kashyap.desai@broadcom.com, 
	sumit.saxena@broadcom.com, sreekanth.reddy@broadcom.com, jejb@linux.ibm.com, 
	martin.petersen@oracle.com, mpi3mr-linuxdrv.pdl@broadcom.com, 
	linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Lee Duncan <lduncan@suse.com>

On Thu, Dec 28, 2023 at 8:03=E2=80=AFPM Guixin Liu <kanie@linux.alibaba.com=
> wrote:
>
> To ensure that the same id is not obtained during concurrent
> execution of the probe, an ida is used to manage the mrioc's
> id.
>
> Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
> ---
> Changes from v1 to v2:
> - change id from int to u8, and use ida_alloc_range instead of ida_alloc.
>
>  drivers/scsi/mpi3mr/mpi3mr_os.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 040031eb0c12..36c4ab679094 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -8,11 +8,12 @@
>   */
>
>  #include "mpi3mr.h"
> +#include <linux/idr.h>
>
>  /* global driver scop variables */
>  LIST_HEAD(mrioc_list);
>  DEFINE_SPINLOCK(mrioc_list_lock);
> -static int mrioc_ids;
> +static DEFINE_IDA(mrioc_ida);
>  static int warn_non_secure_ctlr;
>  atomic64_t event_counter;
>
> @@ -5060,7 +5061,10 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pc=
i_device_id *id)
>         }
>
>         mrioc =3D shost_priv(shost);
> -       mrioc->id =3D mrioc_ids++;
> +       retval =3D ida_alloc_range(&mrioc_ida, 1, U8_MAX, GFP_KERNEL);
> +       if (retval < 0)
> +               goto id_alloc_failed;
> +       mrioc->id =3D (u8)retval;
>         sprintf(mrioc->driver_name, "%s", MPI3MR_DRIVER_NAME);
>         sprintf(mrioc->name, "%s%d", mrioc->driver_name, mrioc->id);
>         INIT_LIST_HEAD(&mrioc->list);
> @@ -5207,9 +5211,11 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pc=
i_device_id *id)
>  resource_alloc_failed:
>         destroy_workqueue(mrioc->fwevt_worker_thread);
>  fwevtthread_failed:
> +       ida_free(&mrioc_ida, mrioc->id);
>         spin_lock(&mrioc_list_lock);
>         list_del(&mrioc->list);
>         spin_unlock(&mrioc_list_lock);
> +id_alloc_failed:
>         scsi_host_put(shost);
>  shost_failed:
>         return retval;
> @@ -5295,6 +5301,7 @@ static void mpi3mr_remove(struct pci_dev *pdev)
>                 mrioc->sas_hba.num_phys =3D 0;
>         }
>
> +       ida_free(&mrioc_ida, mrioc->id);
>         spin_lock(&mrioc_list_lock);
>         list_del(&mrioc->list);
>         spin_unlock(&mrioc_list_lock);
> @@ -5502,6 +5509,7 @@ static void __exit mpi3mr_exit(void)
>                            &driver_attr_event_counter);
>         pci_unregister_driver(&mpi3mr_pci_driver);
>         sas_release_transport(mpi3mr_transport_template);
> +       ida_destroy(&mrioc_ida);
>  }
>
>  module_init(mpi3mr_init);
> --
> 2.43.0
>
>
