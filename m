From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/1] scsi: storvsc: Filter out storvsc messages CD-ROM
 medium not present
Date: Fri, 3 Jun 2016 21:34:26 +0000
Message-ID: <CY1PR0301MB0777F8777B4F906C8610D852A0590@CY1PR0301MB0777.namprd03.prod.outlook.com>
References: <1464013757-30357-1-git-send-email-cavery@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1464013757-30357-1-git-send-email-cavery@redhat.com>
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
To: Cathy Avery <cavery@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, Haiyang Zhang <haiyangz@microsoft.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Cathy Avery [mailto:cavery@redhat.com]
> Sent: Monday, May 23, 2016 7:29 AM
> To: linux-scsi@vger.kernel.org
> Cc: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; martin.petersen@oracle.com;
> jejb@linux.vnet.ibm.com; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH 1/1] scsi: storvsc: Filter out storvsc messages CD-ROM medium
> not present
> 
> When a virtual scsi DVD device is present with no image file
> attached the storvsc driver logs all resulting unnecessary sense errors
> whenever IO is issued to the device.
> 
> [storvsc] Sense Key : Not Ready [current]
> [storvsc] Add. Sense: Medium not present - tray closed
> 
> Signed-off-by: Cathy Avery <cavery@redhat.com>

Thanks Cathy.

Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

> ---
>  drivers/scsi/storvsc_drv.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 3ddcabb..f0efa07 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -966,7 +966,9 @@ static void storvsc_command_completion(struct
> storvsc_cmd_request *cmd_request,
>  	if (scmnd->result) {
>  		if (scsi_normalize_sense(scmnd->sense_buffer,
>  				SCSI_SENSE_BUFFERSIZE, &sense_hdr) &&
> -		    do_logging(STORVSC_LOGGING_ERROR))
> +		    !(sense_hdr.sense_key == NOT_READY &&
> +				 sense_hdr.asc == 0x03A) &&
> +		    do_logging(STORVSC_LOGGING_ERROR))
>  			scsi_print_sense_hdr(scmnd->device, "storvsc",
>  					     &sense_hdr);
>  	}
> --
> 2.5.0
