From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 3/4] scsi: storvsc: Refactor the code in
 storvsc_channel_init()
Date: Fri, 11 Dec 2015 13:40:47 +0300
Message-ID: <20151211104047.GG5284@mwanda>
References: <1449792829-15406-1-git-send-email-kys@microsoft.com>
 <1449792860-15447-1-git-send-email-kys@microsoft.com>
 <1449792860-15447-3-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1449792860-15447-3-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org, jasowang@redhat.com, ohering@suse.com, jbottomley@parallels.com, linux-kernel@vger.kernel.org, hch@infradead.org, apw@canonical.com, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 10, 2015 at 04:14:19PM -0800, K. Y. Srinivasan wrote:
> @@ -753,27 +740,62 @@ static int storvsc_channel_init(struct hv_device *device, bool is_fc)
>  			       VM_PKT_DATA_INBAND,
>  			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
>  	if (ret != 0)
> -		goto cleanup;
> +		goto done;
>  
>  	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
>  	if (t == 0) {
>  		ret = -ETIMEDOUT;
> -		goto cleanup;
> +		goto done;
>  	}
>  
> +	if (!status_check)
> +		goto done;

See?  This goto looks exactly the same as the earlier buggy goto but
it's actually correct.  Meanwhile if you just used an explicit
"return 0;" then it would be easy to understand.

I rant about this all the time but it's because it's bad deliberately.
It's normal to have bugs, but this deliberate stuff really I can't
understand it...

> +
>  	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
>  	    vstor_packet->status != 0) {
>  		ret = -EINVAL;
> -		goto cleanup;
> +		goto done;
>  	}
>  
> +done:
> +	return ret;
> +}
> +
> +static int storvsc_channel_init(struct hv_device *device, bool is_fc)
> +{
> +	struct storvsc_device *stor_device;
> +	struct storvsc_cmd_request *request;
> +	struct vstor_packet *vstor_packet;
> +	int ret, i;
> +	int max_chns;
> +	bool process_sub_channels = false;
> +
> +	stor_device = get_out_stor_device(device);
> +	if (!stor_device)
> +		return -ENODEV;
> +
> +	request = &stor_device->init_request;
> +	vstor_packet = &request->vstor_packet;
> +
> +	/*
> +	 * Now, initiate the vsc/vsp initialization protocol on the open
> +	 * channel
> +	 */
> +	memset(request, 0, sizeof(struct storvsc_cmd_request));
> +	vstor_packet->operation = VSTOR_OPERATION_BEGIN_INITIALIZATION;
> +	ret = storvsc_execute_vstor_op(device, request, true);
> +	if (ret)
> +		goto cleanup;

10 lines earlier there is an explicit "return -ENODEV" so it's not as if
writing explicit returns will kill you.

regards,
dan carpenter
