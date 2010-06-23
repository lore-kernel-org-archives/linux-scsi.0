From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] megaraid: fix fw/bios version output (sparse shift
 warnings)
Date: Wed, 23 Jun 2010 14:59:11 -0700
Message-ID: <20100623145911.cb98043f.randy.dunlap@oracle.com>
References: <20100607170855.b38191ab.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:58861 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab0FWV7W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jun 2010 17:59:22 -0400
In-Reply-To: <20100607170855.b38191ab.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejbscsi <james.bottomley@suse.de>, Neela Syam Kolli <megaraidlinux@lsi.com>

On Mon, 7 Jun 2010 17:08:55 -0700 Randy Dunlap wrote:

ping??

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix fw_version and bios_version output strings.
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
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Al Viro <viro@ZenIV.linux.org.uk>
> Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
> ---
>  drivers/scsi/megaraid.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> --- linux-2.6.35-rc2.orig/drivers/scsi/megaraid.c
> +++ linux-2.6.35-rc2/drivers/scsi/megaraid.c
> @@ -308,15 +308,15 @@ mega_query_adapter(adapter_t *adapter)
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
> --

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
