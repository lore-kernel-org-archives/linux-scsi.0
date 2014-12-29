From: Dimitri Sivanich <sivanich@sgi.com>
Subject: Re: [PATCH] cleanup on stack DECLARE_COMPLETIONs
Date: Mon, 29 Dec 2014 09:38:56 -0600
Message-ID: <20141229153856.GA5661@sgi.com>
References: <1419356048-22405-1-git-send-email-der.herr@hofr.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:33560 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751440AbaL2Pi7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Dec 2014 10:38:59 -0500
Content-Disposition: inline
In-Reply-To: <1419356048-22405-1-git-send-email-der.herr@hofr.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, "Juergen E. Fischer" <fischer@norbit.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, Felipe Balbi <balbi@ti.com>, linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Tue, Dec 23, 2014 at 06:34:08PM +0100, Nicholas Mc Guire wrote:
> fixups for incorrect use of DECLARE_COMPLETION. see also commit
> 6e9a4738 ("completions: lockdep annotate on stack completions")
> The only somewhat special case being
> drivers/misc/sgi-gru/grukservices.c:quicktest2
> which had a static qualifier in the original DECLARE_COMPLETION()
> but that seems to be wrong (why should the completion persisted between
> successive calls ?) so the conversion to DECLARE_COMPLETION_ONSTACK
> was also applied and the static qualifier removed.
> 
> Not sure if this is suitable in this form or if it should go out as
> 5 seperate patches ? 
> 
> This was only code reviewed and compile tested

Acking just the drivers/misc/sgi-gru/grukservices.c patch of this set.

Acked-by: Dimitri Sivanich <sivanich@sgi.com>

> 
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> ---
>  drivers/macintosh/ams/ams-pmu.c       |    4 ++--
>  drivers/misc/sgi-gru/grukservices.c   |    2 +-
>  drivers/scsi/aha152x.c                |    2 +-
>  drivers/usb/gadget/udc/fsl_qe_udc.c   |    2 +-
>  drivers/usb/gadget/udc/fsl_udc_core.c |    2 +-
>  5 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/macintosh/ams/ams-pmu.c b/drivers/macintosh/ams/ams-pmu.c
> index 4f61b3e..c2b178f 100644
> --- a/drivers/macintosh/ams/ams-pmu.c
> +++ b/drivers/macintosh/ams/ams-pmu.c
> @@ -52,7 +52,7 @@ static void ams_pmu_req_complete(struct adb_request *req)
>  static void ams_pmu_set_register(u8 reg, u8 value)
>  {
>  	static struct adb_request req;
> -	DECLARE_COMPLETION(req_complete);
> +	DECLARE_COMPLETION_ONSTACK(req_complete);
> 
>  	req.arg = &req_complete;
>  	if (pmu_request(&req, ams_pmu_req_complete, 4, ams_pmu_cmd, 0x00, reg, value))
> @@ -65,7 +65,7 @@ static void ams_pmu_set_register(u8 reg, u8 value)
>  static u8 ams_pmu_get_register(u8 reg)
>  {
>  	static struct adb_request req;
> -	DECLARE_COMPLETION(req_complete);
> +	DECLARE_COMPLETION_ONSTACK(req_complete);
> 
>  	req.arg = &req_complete;
>  	if (pmu_request(&req, ams_pmu_req_complete, 3, ams_pmu_cmd, 0x01, reg))
> diff --git a/drivers/misc/sgi-gru/grukservices.c b/drivers/misc/sgi-gru/grukservices.c
> index 913de07..4e412fe 100644
> --- a/drivers/misc/sgi-gru/grukservices.c
> +++ b/drivers/misc/sgi-gru/grukservices.c
> @@ -1044,7 +1044,7 @@ done:
> 
>  static int quicktest2(unsigned long arg)
>  {
> -	static DECLARE_COMPLETION(cmp);
> +	DECLARE_COMPLETION_ONSTACK(cmp);
>  	unsigned long han;
>  	int blade_id = 0;
>  	int numcb = 4;
> diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
> index 2b960b3..b16afb9 100644
> --- a/drivers/scsi/aha152x.c
> +++ b/drivers/scsi/aha152x.c
> @@ -1055,7 +1055,7 @@ static int aha152x_abort(Scsi_Cmnd *SCpnt)
>  static int aha152x_device_reset(Scsi_Cmnd * SCpnt)
>  {
>  	struct Scsi_Host *shpnt = SCpnt->device->host;
> -	DECLARE_COMPLETION(done);
> +	DECLARE_COMPLETION_ONSTACK(done);
>  	int ret, issued, disconnected;
>  	unsigned char old_cmd_len = SCpnt->cmd_len;
>  	unsigned long flags;
> diff --git a/drivers/usb/gadget/udc/fsl_qe_udc.c b/drivers/usb/gadget/udc/fsl_qe_udc.c
> index 795c99c..e0822f1 100644
> --- a/drivers/usb/gadget/udc/fsl_qe_udc.c
> +++ b/drivers/usb/gadget/udc/fsl_qe_udc.c
> @@ -2630,7 +2630,7 @@ static int qe_udc_remove(struct platform_device *ofdev)
>  	struct qe_udc *udc = platform_get_drvdata(ofdev);
>  	struct qe_ep *ep;
>  	unsigned int size;
> -	DECLARE_COMPLETION(done);
> +	DECLARE_COMPLETION_ONSTACK(done);
> 
>  	usb_del_gadget_udc(&udc->gadget);
> 
> diff --git a/drivers/usb/gadget/udc/fsl_udc_core.c b/drivers/usb/gadget/udc/fsl_udc_core.c
> index 2df8074..c3830ad 100644
> --- a/drivers/usb/gadget/udc/fsl_udc_core.c
> +++ b/drivers/usb/gadget/udc/fsl_udc_core.c
> @@ -2529,7 +2529,7 @@ static int __exit fsl_udc_remove(struct platform_device *pdev)
>  	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	struct fsl_usb2_platform_data *pdata = dev_get_platdata(&pdev->dev);
> 
> -	DECLARE_COMPLETION(done);
> +	DECLARE_COMPLETION_ONSTACK(done);
> 
>  	if (!udc_controller)
>  		return -ENODEV;
> --
> 1.7.10.4
