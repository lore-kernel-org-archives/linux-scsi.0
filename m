From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] scsi: lpfc: Switch memcpy_fromio() to __read32_copy()
Date: Mon, 5 Mar 2018 07:37:00 -0800
Message-ID: <b8699e17-bab9-f977-8034-05897c2812f4@broadcom.com>
References: <1516971186-20372-1-git-send-email-chenhc@lemote.com>
 <tencent_3B2D19AE6395B45001767B9B@qq.com>
 <tencent_75DC38C65689608F38146CF0@qq.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <tencent_75DC38C65689608F38146CF0@qq.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: =?UTF-8?B?6ZmI5Y2O5omN?= <chenhc@lemote.com>, Dick Kennedy <dick.kennedy@broadcom.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Fuxin Zhang <zhangfx@lemote.com>, linux-scsi <linux-scsi@vger.kernel.org>, stable <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On 3/4/2018 10:56 PM, 陈华才 wrote:
> No one has the same problem? Or this patch need improve?
>
> Huacai
>   
> ------------------ Original ------------------
> From:  "陈华才"<chenhc@lemote.com>;
> Date:  Thu, Mar 1, 2018 01:59 PM
> To:  "James Smart"<james.smart@broadcom.com>; "Dick Kennedy"<dick.kennedy@broadcom.com>;
> Cc:  "James E . J . Bottomley"<jejb@linux.vnet.ibm.com>; "Martin K . Petersen"<martin.petersen@oracle.com>; "Fuxin Zhang"<zhangfx@lemote.com>; "linux-scsi"<linux-scsi@vger.kernel.org>; "stable"<stable@vger.kernel.org>;
> Subject:  Re:[PATCH] scsi: lpfc: Switch memcpy_fromio() to __read32_copy()
>   
> Ping?
>   
> ------------------ Original ------------------
> From:  "Huacai Chen"<chenhc@lemote.com>;
> Date:  Fri, Jan 26, 2018 08:53 PM
> To:  "James Smart"<james.smart@broadcom.com>; "Dick Kennedy"<dick.kennedy@broadcom.com>;
> Cc:  "James E . J . Bottomley"<jejb@linux.vnet.ibm.com>; "Martin K . Petersen"<martin.petersen@oracle.com>; "Fuxin Zhang"<zhangfx@lemote.com>; "linux-scsi"<linux-scsi@vger.kernel.org>; "Huacai Chen"<chenhc@lemote.com>; "stable"<stable@vger.kernel.org>;
> Subject:  [PATCH] scsi: lpfc: Switch memcpy_fromio() to __read32_copy()
>   
> In commit bc73905abf770192 ("[SCSI] lpfc 8.3.16: SLI Additions, updates,
> and code cleanup"), lpfc_memcpy_to_slim() have switched memcpy_toio() to
> __write32_copy() in order to prevent unaligned 64 bit copy. Recently, we
> found that lpfc_memcpy_from_slim() have similar issues, so let it switch
> memcpy_fromio() to __read32_copy().
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> ---
>   drivers/scsi/lpfc/lpfc_compat.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_compat.h b/drivers/scsi/lpfc/lpfc_compat.h
> index 6b32b0a..47d4fad 100644
> --- a/drivers/scsi/lpfc/lpfc_compat.h
> +++ b/drivers/scsi/lpfc/lpfc_compat.h
> @@ -91,8 +91,8 @@ lpfc_memcpy_to_slim( void __iomem *dest, void *src, unsigned int bytes)
>   static inline void
>   lpfc_memcpy_from_slim( void *dest, void __iomem *src, unsigned int bytes)
>   {
> -	/* actually returns 1 byte past dest */
> -	memcpy_fromio( dest, src, bytes);
> +	/* convert bytes in argument list to word count for copy function */
> +	__ioread32_copy(dest, src, bytes / sizeof(uint32_t));
>   }
>   
>   #endif	/* __BIG_ENDIAN */

Huacai,

Note: the original change was 7 yrs ago and we've had no reports of 
issues. but....

This change didn't look necessary as the memcpy_XXXio() should allow 
byte alignments and byte-based lengths. Which means the original patch 
also wasn't necessary, which implies that the platform that had the 
issues has an api restriction not normally found on the other platforms.

I have no problem with the change though.

-- james

Signed-off-by: James Smart  <james.smart@broadcom.com>
