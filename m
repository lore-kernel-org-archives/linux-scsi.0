From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 2/4] mpt3sas: Fix for Crusader to achieve product
 targets with SAS devices.
Date: Thu, 19 Jan 2017 16:05:38 +0000
Message-ID: <1484841924.2634.1.camel@sandisk.com>
References: <1484840950-13656-1-git-send-email-chaitra.basappa@broadcom.com>
         <1484840950-13656-3-git-send-email-chaitra.basappa@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484840950-13656-3-git-send-email-chaitra.basappa@broadcom.com>
Content-Language: en-US
Content-ID: <8C028A0066B5864A97AFD375A59EBD2C@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "jejb@kernel.org" <jejb@kernel.org>, "hch@infradead.org" <hch@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Sathya.Prakash@broadcom.com" <Sathya.Prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "krishnaraddi.mankani@broadcom.com" <krishnaraddi.mankani@broadcom.com>, "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>, "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2017-01-19 at 21:19 +0530, Chaitra P B wrote:
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/=
mpt3sas_scsih.c
> index 5ffbfb1..b3f9f7a 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -1096,6 +1096,27 @@ _scsih_scsi_lookup_get_clear(struct MPT3SAS_ADAPTE=
R *ioc, u16 smid)
>  }
> =20
>  /**
> + * _scsih_scsi_lookup_get_clear_without_lock - returns scmd entry withou=
t
> + *						holding any lock.
> + * @ioc: per adapter object
> + * @smid: system request message index
> + *
> + * Returns the smid stored scmd pointer.
> + * Then will derefrence the stored scmd pointer.
> + */
> +static inline struct scsi_cmnd *
> +_scsih_scsi_lookup_get_clear_without_lock(struct MPT3SAS_ADAPTER *ioc,
> +		u16 smid)
> +{
> +	struct scsi_cmnd *scmd;
> +
> +	scmd =3D ioc->scsi_lookup[smid - 1].scmd;
> +	ioc->scsi_lookup[smid - 1].scmd =3D NULL;
> +
> +	return scmd;
> +}

Please make the following changes in the above code:
* Use swap() instead of open-coding it.
* Call _scsih_scsi_lookup_get_clear_without_lock() from
  _scsih_scsi_lookup_get_clear() to avoid code duplication.
* Fix the spelling of "dereference".

Thanks,

Bart.=
