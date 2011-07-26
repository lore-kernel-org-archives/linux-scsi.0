From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 3/8] hwmon: ibmaem: convert idr to ida and use
	ida_simple_get
Date: Tue, 26 Jul 2011 11:04:15 -0700
Message-ID: <20110726180415.GT20579@tux1.beaverton.ibm.com>
References: <1311352886-4047-1-git-send-email-jic23@cam.ac.uk> <1311352886-4047-4-git-send-email-jic23@cam.ac.uk>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:36565 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab1GZSEd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2011 14:04:33 -0400
Content-Disposition: inline
In-Reply-To: <1311352886-4047-4-git-send-email-jic23@cam.ac.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org, rtc-linux@googlegroups.com, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org, jkosina@suse.cz, naota@elisp.net, rusty@rustcorp.com.au, paulmck@linux.vnet.ibm.com, namhyung@gmail.com, randy.dunlap@oracle.com, tj@kernel.org, cabarnes@indesign-llc.com, akpm@linux-foundation.org, airlied@redhat.com, thellstrom@vmware.com, johnpol@2ka.mipt.ru, JBottomley@parallels.com, bhalevy@panasas.com, bharrosh@panasas.com, a.zummo@towertech.it, guenter.roeck@ericsson.com, khali@linux-fr.org, airlied@linux.ie

On Fri, Jul 22, 2011 at 05:41:12PM +0100, Jonathan Cameron wrote:
> A straightforward looking use of idr for a device id.
> 
> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
> Note I have even build tested this one so will definitely
> want an Ack from someone who has.

Looks ok and seems to build and run ok, so:

Acked-by: Darrick J. Wong <djwong@us.ibm.com>
> 
>  drivers/hwmon/ibmaem.c |   47 ++++++++---------------------------------------
>  1 files changed, 8 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/hwmon/ibmaem.c b/drivers/hwmon/ibmaem.c
> index 1a409c5..058e0ae 100644
> --- a/drivers/hwmon/ibmaem.c
> +++ b/drivers/hwmon/ibmaem.c
> @@ -88,8 +88,7 @@
>  #define AEM_MIN_POWER_INTERVAL	200
>  #define UJ_PER_MJ		1000L
> 
> -static DEFINE_IDR(aem_idr);
> -static DEFINE_SPINLOCK(aem_idr_lock);
> +static DEFINE_IDA(aem_ida);
> 
>  static struct platform_driver aem_driver = {
>  	.driver = {
> @@ -356,38 +355,6 @@ static void aem_msg_handler(struct ipmi_recv_msg *msg, void *user_msg_data)
>  	complete(&data->read_complete);
>  }
> 
> -/* ID functions */
> -
> -/* Obtain an id */
> -static int aem_idr_get(int *id)
> -{
> -	int i, err;
> -
> -again:
> -	if (unlikely(!idr_pre_get(&aem_idr, GFP_KERNEL)))
> -		return -ENOMEM;
> -
> -	spin_lock(&aem_idr_lock);
> -	err = idr_get_new(&aem_idr, NULL, &i);
> -	spin_unlock(&aem_idr_lock);
> -
> -	if (unlikely(err == -EAGAIN))
> -		goto again;
> -	else if (unlikely(err))
> -		return err;
> -
> -	*id = i & MAX_ID_MASK;
> -	return 0;
> -}
> -
> -/* Release an object ID */
> -static void aem_idr_put(int id)
> -{
> -	spin_lock(&aem_idr_lock);
> -	idr_remove(&aem_idr, id);
> -	spin_unlock(&aem_idr_lock);
> -}
> -
>  /* Sensor support functions */
> 
>  /* Read a sensor value */
> @@ -525,7 +492,7 @@ static void aem_delete(struct aem_data *data)
>  	ipmi_destroy_user(data->ipmi.user);
>  	platform_set_drvdata(data->pdev, NULL);
>  	platform_device_unregister(data->pdev);
> -	aem_idr_put(data->id);
> +	ida_simple_remove(&aem_ida, data->id);
>  	kfree(data);
>  }
> 
> @@ -582,7 +549,8 @@ static int aem_init_aem1_inst(struct aem_ipmi_data *probe, u8 module_handle)
>  		data->power_period[i] = AEM_DEFAULT_POWER_INTERVAL;
> 
>  	/* Create sub-device for this fw instance */
> -	if (aem_idr_get(&data->id))
> +	data->id = ida_simple_get(&aem_ida, 0, 0, GFP_KERNEL);
> +	if (data->id < 0)
>  		goto id_err;
> 
>  	data->pdev = platform_device_alloc(DRVNAME, data->id);
> @@ -633,7 +601,7 @@ ipmi_err:
>  	platform_set_drvdata(data->pdev, NULL);
>  	platform_device_unregister(data->pdev);
>  dev_err:
> -	aem_idr_put(data->id);
> +	ida_simple_remove(&aem_ida, data->id);
>  id_err:
>  	kfree(data);
> 
> @@ -715,7 +683,8 @@ static int aem_init_aem2_inst(struct aem_ipmi_data *probe,
>  		data->power_period[i] = AEM_DEFAULT_POWER_INTERVAL;
> 
>  	/* Create sub-device for this fw instance */
> -	if (aem_idr_get(&data->id))
> +	data->id = ida_simple_get(&aem_ida, 0, 0, GFP_KERNEL);
> +	if (data->id < 0)
>  		goto id_err;
> 
>  	data->pdev = platform_device_alloc(DRVNAME, data->id);
> @@ -766,7 +735,7 @@ ipmi_err:
>  	platform_set_drvdata(data->pdev, NULL);
>  	platform_device_unregister(data->pdev);
>  dev_err:
> -	aem_idr_put(data->id);
> +	ida_simple_remove(&aem_ida, data->id);
>  id_err:
>  	kfree(data);
> 
> -- 
> 1.7.3.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
