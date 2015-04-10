From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 02/14] qla2xxx: Fix crash due to wrong casting of reg
 for ISP27XX.
Date: Fri, 10 Apr 2015 07:59:45 +0200
Message-ID: <552766D1.1040902@sandisk.com>
References: <1428606008-14976-1-git-send-email-himanshu.madhani@qlogic.com>
 <1428606008-14976-3-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0075.outbound.protection.outlook.com ([157.56.110.75]:32200
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753945AbbDJF7w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Apr 2015 01:59:52 -0400
In-Reply-To: <1428606008-14976-3-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

On 04/09/15 20:59, Himanshu Madhani wrote:
> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> ---
>   drivers/scsi/qla2xxx/qla_tmpl.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
> index a8c0c73..7a92f60 100644
> --- a/drivers/scsi/qla2xxx/qla_tmpl.c
> +++ b/drivers/scsi/qla2xxx/qla_tmpl.c
> @@ -190,7 +190,7 @@ static inline void
>   qla27xx_write_reg(__iomem struct device_reg_24xx *reg,
>   	uint offset, uint32_t data, void *buf)
>   {
> -	__iomem void *window = reg + offset;
> +	__iomem void *window = (void *)reg + offset;
>
>   	if (buf) {
>   		WRT_REG_DWORD(window, data);
>

Hello Himanshu,

The above patch introduces a new sparse warning since an __iomem 
annotation is missing from the cast. Had you noticed that I had already 
posted a fix for this crash in January that does not introduce a new 
sparse warning ? See also http://thread.gmane.org/gmane.linux.scsi/98426.

Bart.
