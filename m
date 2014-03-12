From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] Scsi: lpfc: lpfc_init: Remove useless casting value
Date: Wed, 12 Mar 2014 14:35:37 -0700
Message-ID: <1394660137.3915.58.camel@joe-AO722>
References: <1394659247-20037-1-git-send-email-eu@opreamatei.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1394659247-20037-1-git-send-email-eu@opreamatei.ro>
Sender: linux-kernel-owner@vger.kernel.org
To: Matei Oprea <eu@opreamatei.ro>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ROSEdu Kernel Community <firefly@lists.rosedu.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-03-12 at 23:20 +0200, Matei Oprea wrote:
> Remove useless casting value returned by k[cmz]alloc
> to (struct lpfc_sli_ring *).
> 
> Found using coccinelle

trivial note:

> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
[]
> @@ -4731,8 +4731,7 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
[]
> -		phba->sli.ring = (struct lpfc_sli_ring *)
> -			kzalloc(LPFC_SLI3_MAX_RING *
> +		phba->sli.ring = kzalloc(LPFC_SLI3_MAX_RING *
>  			sizeof(struct lpfc_sli_ring), GFP_KERNEL);

Using kcalloc would have been even nicer too

		phba->sli.ring = kcalloc(LPFC_SLI3_MAX_RING,
					 sizeof(struct lpfc_sli_ring),
					 GFP_KERNEL);
