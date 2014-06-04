From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] scsi: mpt2sas: mpt2sas_base.c:  Cleaning up missing
 null-terminate after strncpy call
Date: Wed, 04 Jun 2014 15:01:23 -0700
Message-ID: <1401919283.26329.7.camel@joe-AO725>
References: <1401917775-3222-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1401917775-3222-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, "James E.J. Bottomley" <JBottomley@parallels.com>, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-06-04 at 23:36 +0200, Rickard Strandqvist wrote:
> Added a guaranteed null-terminate after call to strncpy.

Next time you submit a patch series like this
can you please use a cover letter?

That way I can reply to the cover letter with
a comment about the series instead of multiple
replies to various patches.

I think all of these should be using strlcpy not
strncpy.

> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
[]
> @@ -2097,7 +2097,8 @@ _base_display_ioc_capabilities(struct MPT2SAS_ADAPTER *ioc)
>  	u32 bios_version;
>  
>  	bios_version = le32_to_cpu(ioc->bios_pg3.BiosVersion);
> -	strncpy(desc, ioc->manu_pg0.ChipName, 16);
> +	strncpy(desc, ioc->manu_pg0.ChipName, sizeof(desc));
> +	desc[sizeof(desc) - 1] = '\0';
