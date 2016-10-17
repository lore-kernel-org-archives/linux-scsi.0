From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] lpfc: use %zd format string for size_t
Date: Mon, 17 Oct 2016 08:53:33 -0700
Message-ID: <ee349244-b2d2-1124-54b7-c8cdd91818cb@broadcom.com>
References: <20161017123605.2217411-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161017123605.2217411-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.com>, James Bottomley <JBottomley@Odin.com>, Sebastian Herbszt <herbszt@gmx.de>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Thanks

Signed-off-by: James Smart <james.smart@broadcom.com>

-- james


On 10/17/2016 5:35 AM, Arnd Bergmann wrote:
> A recent bugfix introduced a harmless warning in the lpfc driver:
>
> drivers/scsi/lpfc/lpfc_init.c: In function 'lpfc_write_firmware':
> drivers/scsi/lpfc/lpfc_logmsg.h:56:45: error: format '%ld' expects argument of type 'long int', but argument 9 has type 'size_t {aka const unsigned int}' [-Werror=format=]
>
> 'size_t' is always the same width as 'long' in the kernel, but the compiler
> doesn't know that. The %z modifier is what the standard expects to be
> used here, and this shuts up the warning.
>
> Fixes: 679053c651fb ("scsi: lpfc: Fix fw download on SLI-4 FC adapters")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/scsi/lpfc/lpfc_init.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 7be9b8a7bb19..4776fd85514f 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -10332,7 +10332,7 @@ lpfc_write_firmware(const struct firmware *fw, void *context)
>   	    ftype != LPFC_FILE_TYPE_GROUP || fsize != fw->size) {
>   		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
>   				"3022 Invalid FW image found. "
> -				"Magic:%x Type:%x ID:%x Size %d %ld\n",
> +				"Magic:%x Type:%x ID:%x Size %d %zd\n",
>   				magic_number, ftype, fid, fsize, fw->size);
>   		rc = -EINVAL;
>   		goto release_out;
