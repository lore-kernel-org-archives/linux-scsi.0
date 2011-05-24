From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 5/6] drivers/scsi/megaraid.c: fix sparse warnings
Date: Tue, 24 May 2011 13:12:18 -0400
Message-ID: <1306257138.10201.15.camel@mulgrave.site>
References: <201105232229.p4NMTEmw016158@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36747 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757259Ab1EXVc1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2011 17:32:27 -0400
In-Reply-To: <201105232229.p4NMTEmw016158@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, randy.dunlap@oracle.com, megaraidlinux@lsi.com, viro@ZenIV.linux.org.uk, adam radford <aradford@gmail.com>

On Mon, 2011-05-23 at 15:29 -0700, akpm@linux-foundation.org wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix sparse warnings of right shift bigger than source value size:
> 
> drivers/scsi/megaraid.c:311:65: warning: right shift by bigger than source value
> drivers/scsi/megaraid.c:313:65: warning: right shift by bigger than source value
> drivers/scsi/megaraid.c:317:67: warning: right shift by bigger than source value
> drivers/scsi/megaraid.c:319:67: warning: right shift by bigger than source value
> 
> Patch suggestion from email by Al Viro:
> 
> "Since both are claimed to be strings, I really suspect that this >> 8 is
> misspelled >> 4 and they have a character followed by pair of two-digit
> packed decimals in there..."

This looks completely reasonable.  Since it alters the way we print the
firmware version, could I have an ack from LSI people that nothing will
break if we do this?

James


> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Al Viro <viro@ZenIV.linux.org.uk>
> Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/scsi/megaraid.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff -puN drivers/scsi/megaraid.c~drivers-scsi-megaraidc-fix-sparse-warnings drivers/scsi/megaraid.c
> --- a/drivers/scsi/megaraid.c~drivers-scsi-megaraidc-fix-sparse-warnings
> +++ a/drivers/scsi/megaraid.c
> @@ -310,15 +310,15 @@ mega_query_adapter(adapter_t *adapter)
>  	if (adapter->product_info.subsysvid == HP_SUBSYS_VID) {
>  		sprintf (adapter->fw_version, "%c%d%d.%d%d",
>  			 adapter->product_info.fw_version[2],
> -			 adapter->product_info.fw_version[1] >> 8,
> +			 adapter->product_info.fw_version[1] >> 4,
>  			 adapter->product_info.fw_version[1] & 0x0f,
> -			 adapter->product_info.fw_version[0] >> 8,
> +			 adapter->product_info.fw_version[0] >> 4,
>  			 adapter->product_info.fw_version[0] & 0x0f);
>  		sprintf (adapter->bios_version, "%c%d%d.%d%d",
>  			 adapter->product_info.bios_version[2],
> -			 adapter->product_info.bios_version[1] >> 8,
> +			 adapter->product_info.bios_version[1] >> 4,
>  			 adapter->product_info.bios_version[1] & 0x0f,
> -			 adapter->product_info.bios_version[0] >> 8,
> +			 adapter->product_info.bios_version[0] >> 4,
>  			 adapter->product_info.bios_version[0] & 0x0f);
>  	} else {
>  		memcpy(adapter->fw_version,
> _
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


