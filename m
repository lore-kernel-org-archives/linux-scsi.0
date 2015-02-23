From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [scsi 1/2] scsi_debug: schedule_resp fix input variable check
Date: Mon, 23 Feb 2015 09:49:17 -0500
Message-ID: <54EB3DED.8080103@interlog.com>
References: <1424690001-2482-1-git-send-email-tomas.winkler@intel.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:48771 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbbBWOtf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2015 09:49:35 -0500
In-Reply-To: <1424690001-2482-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>, "James E.J. Bottomley\"" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org

On 15-02-23 06:13 AM, Tomas Winkler wrote:
> The function should never be called with cmnd NULL so
> put a fat WARN there.
> Fix also smatch wraning:
> schedule_resp() warn: variable dereferenced before check 'cmnd'
>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>   drivers/scsi/scsi_debug.c | 11 +++++++++--
>   1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index ccbe1282e975..f032aac75997 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -3947,11 +3947,18 @@ schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
>   	struct sdebug_queued_cmd *sqcp = NULL;
>   	struct scsi_device *sdp = cmnd->device;

This patch seems incorrect because it still dereferences
cmnd (in the above line) before it checks it for NULL.

> -	if (NULL == cmnd || NULL == devip) {
> -		pr_warn("called with NULL cmnd or devip pointer\n");
> +	/* this should never happend */

happen?

The scsi_debug driver was written by Eric Youngdale to test
the original Linux SCSI subsystem (or a subsequent rewrite
of same). Remnants of its "trust nobody" style remain and
may have been of use to more recent tinkerers.

> +	if (WARN_ON(!cmnd))
> +		return SCSI_MLQUEUE_HOST_BUSY;
> +
> +	if (NULL == devip) {

if (unlikely(NULL == devip)) {

> +		pr_warn("called devip == NULL\n");
>   		/* no particularly good error to report back */
>   		return SCSI_MLQUEUE_HOST_BUSY;
>   	}
> +
> +	sdp = cmnd->device;
> +
>   	if ((scsi_result) && (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts))
>   		sdev_printk(KERN_INFO, sdp, "%s: non-zero result=0x%x\n",
>   			    __func__, scsi_result);
>

