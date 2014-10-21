From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH] scsi: storvsc: Force SPC-3 for Win8 Hosts or Later
Date: Tue, 21 Oct 2014 18:46:43 +0000
Message-ID: <84a680528eb44a38824175118f9c561e@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1413869964-38940-1-git-send-email-jleung@v10networks.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1413869964-38940-1-git-send-email-jleung@v10networks.ca>
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
To: Jeff Leung <jleung@v10networks.ca>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Jeff Leung [mailto:jleung@v10networks.ca]
> Sent: Monday, October 20, 2014 10:39 PM
> To: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org
> Cc: KY Srinivasan; James.Bottomley@HansenPartnership.com; Jeff Leung
> Subject: [PATCH] scsi: storvsc: Force SPC-3 for Win8 Hosts or Later
> 
> This patch forces SPC-3 for Hyper-V disks on the VMBus. As Windows 10's
> virtual SAS bus is SPC-3 compliant and there are no negative side effects on
> forcing SPC-3 compliance for Win8 hosts, this patch enables SPC-3 compliance
> by forcing it on for hosts with versions later than Win8.
> 
> Forcing SPC-3 compliance for hosts earlier than Win10 also enables TRIM
> support.
> 
> Suggested by: James Bottomley
> <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Jeff Leung <jleung@v10networks.ca>
> ---
>  drivers/scsi/storvsc_drv.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c index
> ed0f899..afcc68e 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1449,6 +1449,15 @@ static int storvsc_device_configure(struct
> scsi_device *sdevice)
> 
>  	sdevice->no_write_same = 1;
> 
> +	/*
> +	 * If the host is Win2k12 or later, we pretend to be SPC-3 compliant
> +	 * and send RC16 which activates TRIM. We will only enable this on a
> +	 * host with levels greater than VERSION_WIN8
> +	 */
> +	if (vmbus_proto_version >= VERSION_WIN8) {

I would want this hack not to be in Windows 10. We can have this hack if the host is either
Ws2012 or ws2012 r2 (VERSION_WIN8 or VERSION_WIN8_1). Also this hack should apply only 
to VHD's being presented and not pass through devices.

K. Y
> +		sdevice->scsi_level = SCSI_SPC_3;
> +	}
> +
>  	return 0;
>  }
> 
> --
> 1.7.2.5
