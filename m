From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: [PATCH] megaraid_sas: fix memory leak if SGL has zero length entries
Date: Sat, 29 Jun 2013 16:15:22 +0200
Message-ID: <87ppv5xath.fsf@nemi.mork.no>
References: <1353488088-10684-1-git-send-email-bjorn@mork.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1353488088-10684-1-git-send-email-bjorn@mork.no>
 (=?utf-8?Q?=22Bj=C3=B8rn?= Mork"'s
	message of "Wed, 21 Nov 2012 09:54:48 +0100")
Sender: stable-owner@vger.kernel.org
To: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Adam Radford <aradford@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Bj=C3=B8rn Mork <bjorn@mork.no> writes:

> commit 98cb7e44 ([SCSI] megaraid_sas: Sanity check user
> supplied length before passing it to dma_alloc_coherent())
> introduced a memory leak.  Memory allocated for entries
> following zero length SGL entries will not be freed.
>
> Reference: http://bugs.debian.org/688198
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Bj=C3=B8rn Mork <bjorn@mork.no>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi=
/megaraid/megaraid_sas_base.c
> index d2c5366..12b6be4 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -4854,10 +4854,12 @@ megasas_mgmt_fw_ioctl(struct megasas_instance=
 *instance,
>  				    sense, sense_handle);
>  	}
> =20
> -	for (i =3D 0; i < ioc->sge_count && kbuff_arr[i]; i++) {
> -		dma_free_coherent(&instance->pdev->dev,
> -				    kern_sge32[i].length,
> -				    kbuff_arr[i], kern_sge32[i].phys_addr);
> +	for (i =3D 0; i < ioc->sge_count; i++) {
> +		if (kbuff_arr[i])
> +			dma_free_coherent(&instance->pdev->dev,
> +					  kern_sge32[i].length,
> +					  kbuff_arr[i],
> +					  kern_sge32[i].phys_addr);
>  	}
> =20
>  	megasas_return_cmd(instance, cmd);


This patch was acked by Adam Radford 4 Dec 2012:
http://permalink.gmane.org/gmane.linux.kernel.stable/36537
but it looks like it got lost somewhere after that.

Please let me know asap if it should be resent.  I'm otherwise going to
clean it out of my todo queue.


Bj=C3=B8rn
