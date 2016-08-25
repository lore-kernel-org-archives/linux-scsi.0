From: Bradley Grove <bgrove@attotech.com>
Subject: Re: [PATCH] scsi: not need to alloc zero buffer for local_atto_ioctl
Date: Thu, 25 Aug 2016 14:45:36 -0400
Message-ID: <3abcfebd-8267-e0dd-6594-00ef2f18471a@attotech.com>
References: <1471746809-31218-1-git-send-email-shawn.lin@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471746809-31218-1-git-send-email-shawn.lin@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shawn Lin <shawn.lin@rock-chips.com>, Bradley Grove <linuxdrivers@attotech.com>, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Acked-by: Bradley Grove <bgrove@attotech.com>

On 08/20/2016 10:33 PM, Shawn Lin wrote:
> We don't need to use kzalloc as we will always memset the
> local_atto_ioctl later.
>
> Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
> ---
>
>  drivers/scsi/esas2r/esas2r_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
> index 2aca4d1..5092c82 100644
> --- a/drivers/scsi/esas2r/esas2r_main.c
> +++ b/drivers/scsi/esas2r/esas2r_main.c
> @@ -194,7 +194,7 @@ static ssize_t write_hw(struct file *file, struct kobject *kobj,
>  	int length = min(sizeof(struct atto_ioctl), count);
>
>  	if (!a->local_atto_ioctl) {
> -		a->local_atto_ioctl = kzalloc(sizeof(struct atto_ioctl),
> +		a->local_atto_ioctl = kmalloc(sizeof(struct atto_ioctl),
>  					      GFP_KERNEL);
>  		if (a->local_atto_ioctl == NULL) {
>  			esas2r_log(ESAS2R_LOG_WARN,
>



This electronic transmission and any attachments hereto are intended only for the use of the individual or entity to which it is addressed and may contain confidential information belonging to ATTO Technology, Inc. If you have reason to believe that you are not the intended recipient, you are hereby notified that any disclosure, copying, distribution or the taking of any action in reliance on the contents of this electronic transmission is strictly prohibited. If you have reason to believe that you have received this transmission in error, please notify ATTO immediately by return e-mail and delete and destroy this communication.   
