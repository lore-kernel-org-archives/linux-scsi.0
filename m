From: Stanley Chu <stanley.chu@mediatek.com>
Subject: Re: [PATCH v1] scsi: ufs: change msleep to usleep_range
Date: Tue, 16 Jul 2019 08:56:44 +0800
Message-ID: <1563238604.7235.5.camel@mtkswgap22>
References: <BN7PR08MB5684BBB44FD0E43501558A20DBCF0@BN7PR08MB5684.namprd08.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BN7PR08MB5684BBB44FD0E43501558A20DBCF0@BN7PR08MB5684.namprd08.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Bean Huo (beanhuo)" <beanhuo@micron.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Evan Green <evgreen@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Bean,

On Mon, 2019-07-15 at 11:21 +0000, Bean Huo (beanhuo) wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> This patch is to change msleep() to usleep_range() based on
> Documentation/timers/timers-howto.txt. It suggests using
> usleep_range() for small msec(1ms - 20ms) since msleep()
> will often sleep longer than desired value.
> 
> After changing, booting time will be 5ms-10ms faster than before.
> I tested this change on two different platforms, one has 5ms faster,
> another one is about 10ms. I think this is different on different
> platform.
> 
> Actually, from UFS host side, 1ms-5ms delay is already sufficient for
> its initialization of the local UIC layer.
> 
> Fixes: 7a3e97b0dc4b ([SCSI] ufshcd: UFS Host controller driver)
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index a208589426b1..21f7b3b8026c 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4213,12 +4213,6 @@ static int ufshcd_hba_execute_hce(struct ufs_hba *hba)
>  {
>  	int retry;
>  
> -	/*
> -	 * msleep of 1 and 5 used in this function might result in msleep(20),
> -	 * but it was necessary to send the UFS FPGA to reset mode during
> -	 * development and testing of this driver. msleep can be changed to
> -	 * mdelay and retry count can be reduced based on the controller.
> -	 */
>  	if (!ufshcd_is_hba_active(hba))
>  		/* change controller state to "reset state" */
>  		ufshcd_hba_stop(hba, true);
> @@ -4241,7 +4235,7 @@ static int ufshcd_hba_execute_hce(struct ufs_hba *hba)
>  	 * instruction might be read back.
>  	 * This delay can be changed based on the controller.
>  	 */
> -	msleep(1);
> +	usleep_range(1000, 1100);
>  
>  	/* wait for the host controller to complete initialization */
>  	retry = 10;
> @@ -4253,7 +4247,7 @@ static int ufshcd_hba_execute_hce(struct ufs_hba *hba)
>  				"Controller enable failed\n");
>  			return -EIO;
>  		}
> -		msleep(5);
> +		usleep_range(5000, 5100);
>  	}
>  
>  	/* enable UIC related interrupts */

Acked-by: Stanley Chu <stanley.chu@mediatek.com>

Thanks,
Stanley
