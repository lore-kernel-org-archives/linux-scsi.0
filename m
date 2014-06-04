From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: mpt2sas: mpt2sas_base.c:  Cleaning up missing
 null-terminate after strncpy call
Date: Wed, 04 Jun 2014 15:28:25 -0700
Message-ID: <1401920905.17510.42.camel@dabdike>
References: <1401917775-3222-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37790 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751693AbaFDW22 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jun 2014 18:28:28 -0400
In-Reply-To: <1401917775-3222-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 2014-06-04 at 23:36 +0200, Rickard Strandqvist wrote:
> Added a guaranteed null-terminate after call to strncpy.
> 
> This was partly found using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/scsi/mpt2sas/mpt2sas_base.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
> index bde63f7..4c3eceb 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> @@ -2097,7 +2097,8 @@ _base_display_ioc_capabilities(struct MPT2SAS_ADAPTER *ioc)
>  	u32 bios_version;
>  
>  	bios_version = le32_to_cpu(ioc->bios_pg3.BiosVersion);
> -	strncpy(desc, ioc->manu_pg0.ChipName, 16);
> +	strncpy(desc, ioc->manu_pg0.ChipName, sizeof(desc));
> +	desc[sizeof(desc) - 1] = '\0';

There's no bug here because the specs define the ChipName field of the
manufacturing page 0 to be 16 bytes and null terminated.  The nasty part
is the way this driver is littered with magic numbers.

James


