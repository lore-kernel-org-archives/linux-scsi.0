From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v0 1/3] ata: Fix the watermark threshold for the APM X-Gene
 SATA host controller driver.
Date: Fri, 20 Jun 2014 19:24:16 +0400
Message-ID: <53A45220.1030406@cogentembedded.com>
References: <1403253147-14341-1-git-send-email-stripathi@apm.com> <1403253147-14341-2-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:51493 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbaFTPYI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jun 2014 11:24:08 -0400
Received: by mail-lb0-f169.google.com with SMTP id l4so2492686lbv.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Jun 2014 08:24:06 -0700 (PDT)
In-Reply-To: <1403253147-14341-2-git-send-email-stripathi@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>, olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>

Hello.

On 06/20/2014 12:32 PM, Suman Tripathi wrote:

> This patch fixes the watermark threshold of the receive FIFO for the
> APM X-Gene SATA host controller driver.

> Signed-off-by: Loc Ho <lho@apm.com>
> Signed-off-by: Suman Tripathi <stripathi@apm.com>
> ---
>   drivers/ata/ahci_xgene.c | 8 ++++++++
>   1 file changed, 8 insertions(+)

> diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
> index 77c89bf..5f0f750 100644
> --- a/drivers/ata/ahci_xgene.c
> +++ b/drivers/ata/ahci_xgene.c
> @@ -68,6 +68,10 @@
>   #define PORTAXICFG_OUTTRANS_SET(dst, src) \
>   		(((dst) & ~0x00f00000) | (((u32)(src) << 0x14) & 0x00f00000))
>
> +#define PORTRANSCFG				0xc8
> +#define PORTRANSCFG_RXWM_SET(dst, src)		\
> +		(((dst) & ~0x0000007f) | (((u32) (src) << 0) & 0x0000007f))

    Please renmove space after (u32) for consistency with the above macro. And 
why shift by 0 bits?

WBR, Sergei

