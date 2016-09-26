From: "lindar_liu" <lindar_liu@usish.com>
Subject: RE: [PATCH] pm8001: mark symbols static where possible
Date: Mon, 26 Sep 2016 09:20:07 +0800
Message-ID: <002f01d21794$30ead260$92c07720$@com>
References: <1474638862-22595-1-git-send-email-baoyou.xie@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1474638862-22595-1-git-send-email-baoyou.xie@linaro.org>
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
To: 'Baoyou Xie' <baoyou.xie@linaro.org>, jinpu.wang@profitbricks.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: pmchba@pmcs.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, xie.baoyou@zte.com.cn
List-Id: linux-scsi@vger.kernel.org

Thanks for fix.
Acked-by: Lindar Liu <lindar_liu@usish.com>

> -----Original Message-----
> From: Baoyou Xie [mailto:baoyou.xie@linaro.org]
> Sent: Friday, September 23, 2016 9:54 PM
> To: jinpu.wang@profitbricks.com; lindar_liu@usish.com;
> jejb@linux.vnet.ibm.com; martin.petersen@oracle.com
> Cc: pmchba@pmcs.com; linux-scsi@vger.kernel.org;
> linux-kernel@vger.kernel.org; arnd@arndb.de; baoyou.xie@linaro.org;
> xie.baoyou@zte.com.cn
> Subject: [PATCH] pm8001: mark symbols static where possible
> 
> We get 2 warnings when building kernel with W=1:
> drivers/scsi/pm8001/pm8001_sas.c:530:23: warning: no previous prototype
> for 'pm8001_alloc_dev' [-Wmissing-prototypes]
> drivers/scsi/pm8001/pm8001_hwi.c:4495:5: warning: no previous prototype
> for 'pm8001_chip_phy_stop_req' [-Wmissing-prototypes]
> 
> In fact, these functions are only used in the file in which they are
declared and
> don't need a declaration, but can be made static.
> so this patch marks these functions with 'static'.
> 
> Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 4 ++--
> drivers/scsi/pm8001/pm8001_sas.c | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c
> b/drivers/scsi/pm8001/pm8001_hwi.c
> index 04e67a1..10546fa 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -4492,8 +4492,8 @@ pm8001_chip_phy_start_req(struct
> pm8001_hba_info *pm8001_ha, u8 phy_id)
>   * @num: the inbound queue number
>   * @phy_id: the phy id which we wanted to start up.
>   */
> -int pm8001_chip_phy_stop_req(struct pm8001_hba_info *pm8001_ha,
> -	u8 phy_id)
> +static int pm8001_chip_phy_stop_req(struct pm8001_hba_info
> *pm8001_ha,
> +				    u8 phy_id)
>  {
>  	struct phy_stop_req payload;
>  	struct inbound_queue_table *circularQ; diff --git
> a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index dc33dfa..ce584c3 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -527,7 +527,7 @@ void pm8001_ccb_task_free(struct pm8001_hba_info
> *pm8001_ha,
>    * pm8001_alloc_dev - find a empty pm8001_device
>    * @pm8001_ha: our hba card information
>    */
> -struct pm8001_device *pm8001_alloc_dev(struct pm8001_hba_info
> *pm8001_ha)
> +static struct pm8001_device *pm8001_alloc_dev(struct pm8001_hba_info
> +*pm8001_ha)
>  {
>  	u32 dev;
>  	for (dev = 0; dev < PM8001_MAX_DEVICES; dev++) {
> --
> 2.7.4
