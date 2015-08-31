From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH] scsi_scan: move 'INQUIRY result too short' message to
 debug level
Date: Mon, 31 Aug 2015 13:21:26 +0000
Message-ID: <BY2PR0301MB1654D30E1FBE69F83F97F172A06B0@BY2PR0301MB1654.namprd03.prod.outlook.com>
References: <1441025401-30044-1-git-send-email-vkuznets@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441025401-30044-1-git-send-email-vkuznets@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Vitaly Kuznetsov <vkuznets@redhat.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Long Li <longli@microsoft.com>, Dexuan Cui <decui@microsoft.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Monday, August 31, 2015 5:50 AM
> To: James E.J. Bottomley <JBottomley@odin.com>
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; KY Srinivasan
> <kys@microsoft.com>; Long Li <longli@microsoft.com>; Dexuan Cui
> <decui@microsoft.com>
> Subject: [PATCH] scsi_scan: move 'INQUIRY result too short' message to
> debug level
> 
> Some Hyper-V hosts are known for ignoring SPC-2/3/4 requirement
> for 'INQUIRY data (see table ...) shall contain at least 36 bytes'. As a
> result we get tons on 'scsi 0:7:1:1: scsi scan: INQUIRY result too short
> (5), using 36' messages on console. As Hyper-V is also known for its
> serial port being extremely slow multi-VCPU guests we get CPU blocked
> putting these (useless) messages on console (e.g. happens when we add
> multiple disks). Move them to debug level.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/scsi/scsi_scan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index f9f3f82..cb5c50a 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -701,7 +701,7 @@ static int scsi_probe_lun(struct scsi_device *sdev,
> unsigned char *inq_result,
>  	 * strings.
>  	 */
>  	if (sdev->inquiry_len < 36) {
> -		sdev_printk(KERN_INFO, sdev,
> +		sdev_printk(KERN_DEBUG, sdev,
>  			    "scsi scan: INQUIRY result too short (%d),"
>  			    " using 36\n", sdev->inquiry_len);
>  		sdev->inquiry_len = 36;
> --
> 2.4.3
