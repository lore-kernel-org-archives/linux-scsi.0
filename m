From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi_scan: move 'INQUIRY result too short' message to
 debug level
Date: Tue, 01 Sep 2015 07:49:21 -0600
Message-ID: <1441115361.2682.2.camel@HansenPartnership.com>
References: <1441025401-30044-1-git-send-email-vkuznets@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441025401-30044-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>, Long Li <longli@microsoft.com>, Dexuan Cui <decui@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2015-08-31 at 14:50 +0200, Vitaly Kuznetsov wrote:
> Some Hyper-V hosts are known for ignoring SPC-2/3/4 requirement
> for 'INQUIRY data (see table ...) shall contain at least 36 bytes'. As a
> result we get tons on 'scsi 0:7:1:1: scsi scan: INQUIRY result too short
> (5), using 36' messages on console. As Hyper-V is also known for its
> serial port being extremely slow multi-VCPU guests we get CPU blocked
> putting these (useless) messages on console (e.g. happens when we add
> multiple disks). Move them to debug level.

This isn't an ignorable debug message.  It means the inquiry information
the system relies on will be false, so it's fairly essential for bug
reports.  It could be made a once per device print, but I don't think we
can eliminate it.

James

> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  drivers/scsi/scsi_scan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index f9f3f82..cb5c50a 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -701,7 +701,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
>  	 * strings.
>  	 */
>  	if (sdev->inquiry_len < 36) {
> -		sdev_printk(KERN_INFO, sdev,
> +		sdev_printk(KERN_DEBUG, sdev,
>  			    "scsi scan: INQUIRY result too short (%d),"
>  			    " using 36\n", sdev->inquiry_len);
>  		sdev->inquiry_len = 36;
