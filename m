From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH] scsi: storvsc: Prefer kcalloc over kzalloc with multiply
Date: Thu, 13 Apr 2017 23:27:38 +0000
Message-ID: <DM5PR03MB2490C9112A2481143193F5EFA0020@DM5PR03MB2490.namprd03.prod.outlook.com>
References: <20170316065823.13319-1-miguel.bernal.marin@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20170316065823.13319-1-miguel.bernal.marin@linux.intel.com>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Miguel Bernal Marin <miguel.bernal.marin@linux.intel.com>, "Martin K.
 Petersen" <martin.petersen@oracle.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James
 E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Haiyang Zhang <haiyangz@microsoft.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Miguel Bernal Marin [mailto:miguel.bernal.marin@linux.intel.com]
> Sent: Wednesday, March 15, 2017 11:58 PM
> To: KY Srinivasan <kys@microsoft.com>; Martin K. Petersen
> <martin.petersen@oracle.com>
> Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org;
> devel@linuxdriverproject.org; Haiyang Zhang <haiyangz@microsoft.com>;
> Stephen Hemminger <sthemmin@microsoft.com>; James E.J. Bottomley
> <jejb@linux.vnet.ibm.com>
> Subject: [PATCH] scsi: storvsc: Prefer kcalloc over kzalloc with multiply
> 
> Use kcalloc for allocating an array instead of kzalloc with multiply,
> kcalloc is the preferred API.
> 
> Found with checkpatch.
> 
> Signed-off-by: Miguel Bernal Marin <miguel.bernal.marin@linux.intel.com>
Reviewed-by:  K. Y. Srinivasan <kys@microsoft.com>


> ---
>  drivers/scsi/storvsc_drv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 638e5f427c90..3d70d1cf49a3 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -866,7 +866,7 @@ static int storvsc_channel_init(struct hv_device
> *device, bool is_fc)
>  	 * We will however populate all the slots to evenly distribute
>  	 * the load.
>  	 */
> -	stor_device->stor_chns = kzalloc(sizeof(void *) *
> num_possible_cpus(),
> +	stor_device->stor_chns = kcalloc(num_possible_cpus(), sizeof(void
> *),
>  					 GFP_KERNEL);
>  	if (stor_device->stor_chns == NULL)
>  		return -ENOMEM;
> --
> 2.12.0
