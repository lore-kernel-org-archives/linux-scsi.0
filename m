From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] aacraid: don't assign cpu_to_le32(constant) to u8
Date: Wed, 31 Oct 2007 09:53:42 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01F956F5@otce2k301.adaptec.com>
References: <20071031150216.88cecc21.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:55000 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbXJaNyE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2007 09:54:04 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20071031150216.88cecc21.sfr@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

ACK

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au] 
> Sent: Wednesday, October 31, 2007 12:02 AM
> To: AACRAID
> Cc: linux-scsi@vger.kernel.org; LKML
> Subject: [PATCH] aacraid: don't assign cpu_to_le32(constant) to u8
> 
> Noticed on PowerPC allmod config build:
> 
> drivers/scsi/aacraid/commsup.c:1342: warning: large integer 
> implicitly truncated to unsigned type
> drivers/scsi/aacraid/commsup.c:1343: warning: large integer 
> implicitly truncated to unsigned type
> drivers/scsi/aacraid/commsup.c:1344: warning: large integer 
> implicitly truncated to unsigned type
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/scsi/aacraid/commsup.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --git a/drivers/scsi/aacraid/commsup.c 
> b/drivers/scsi/aacraid/commsup.c
> index 240a0bb..b9682a8 100644
> --- a/drivers/scsi/aacraid/commsup.c
> +++ b/drivers/scsi/aacraid/commsup.c
> @@ -1339,9 +1339,9 @@ int aac_check_health(struct aac_dev * aac)
>  			aif = (struct aac_aifcmd *)hw_fib->data;
>  			aif->command = cpu_to_le32(AifCmdEventNotify);
>  		 	aif->seqnum = cpu_to_le32(0xFFFFFFFF);
> -		 	aif->data[0] = cpu_to_le32(AifEnExpEvent);
> -			aif->data[1] = cpu_to_le32(AifExeFirmwarePanic);
> -		 	aif->data[2] = cpu_to_le32(AifHighPriority);
> +		 	aif->data[0] = AifEnExpEvent;
> +			aif->data[1] = AifExeFirmwarePanic;
> +		 	aif->data[2] = AifHighPriority;
>  			aif->data[3] = cpu_to_le32(BlinkLED);
>  
>  			/*
> -- 
> 1.5.3.4
> 
