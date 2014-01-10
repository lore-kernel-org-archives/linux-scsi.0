From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 1/1] aacraid: kdump fix
Date: Fri, 10 Jan 2014 14:03:48 +0100
Message-ID: <52CFEFB4.9040601@redhat.com>
References: <1387793273-7284-1-git-send-email-Mahesh.Rajashekhara@pmcs.com> <B539A9786201A44A91E34268415A2B1A1E275A99@BBYEXM01.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbaAJND4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jan 2014 08:03:56 -0500
In-Reply-To: <B539A9786201A44A91E34268415A2B1A1E275A99@BBYEXM01.pmc-sierra.internal>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Harry Yang <Harry.Yang@pmcs.com>, Achim Leubner <Achim.Leubner@pmcs.com>, Rich Bono <Rich.Bono@pmcs.com>

On 01/08/2014 07:34 AM, Mahesh Rajashekhara wrote:
> Hi James,
>
> Can you please let me know the status of this patch which I submitted sometime back.
>
> Thanks & Regards,
> Mahesh
>
> -----Original Message-----
> From: Mahesh Rajashekhara 
> Sent: Monday, December 23, 2013 3:38 PM
> To: JBottomley@Parallels.com; linux-scsi@vger.kernel.org
> Cc: aacraid@pmc-sierra.com; Harry Yang; Achim Leubner; Rich Bono; Mahesh Rajashekhara
> Subject: [PATCH 1/1] aacraid: kdump fix
>
> This patch fixes kernel panic issue while booting into the kdump kernel.
>
> We have triggered crash and kdump vmcore was successful. No issues seen while booting into the OS.
>
> Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
> ---
>  drivers/scsi/aacraid/aacraid.h |    2 +-
>  drivers/scsi/aacraid/rx.c      |    5 +++--
>  2 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h index 9323d05..eaaf870 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -12,7 +12,7 @@
>   *----------------------------------------------------------------------------*/
>  
>  #ifndef AAC_DRIVER_BUILD
> -# define AAC_DRIVER_BUILD 30200
> +# define AAC_DRIVER_BUILD 30300
>  # define AAC_DRIVER_BRANCH "-ms"
>  #endif
>  #define MAXIMUM_NUM_CONTAINERS	32
> diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c index dada38a..9f2d88f 100644
> --- a/drivers/scsi/aacraid/rx.c
> +++ b/drivers/scsi/aacraid/rx.c
> @@ -500,13 +500,14 @@ static int aac_rx_restart_adapter(struct aac_dev *dev, int bled)
>  		if (bled && (bled != -ETIMEDOUT))
>  			return -EINVAL;
>  	}
> -	if (bled || (var == 0x3803000F)) { /* USE_OTHER_METHOD */
> +	if (bled && (var == 0x3803000F)) { /* USE_OTHER_METHOD */

Hi Mahesh, 
it looks to me that we could arrive here with 'var' not yet initialised
if I'm right please fix this too.
Thanks,
Tomas

>  		rx_writel(dev, MUnit.reserved2, 3);
>  		msleep(5000); /* Delay 5 seconds */
>  		var = 0x00000001;
>  	}
> -	if (var != 0x00000001)
> +	if (bled && (var != 0x00000001))
>  		return -EINVAL;
> +	ssleep(5);
>  	if (rx_readl(dev, MUnit.OMRx[0]) & KERNEL_PANIC)
>  		return -ENODEV;
>  	if (startup_timeout < 300)
> --
> 1.7.7.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

