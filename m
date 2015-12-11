From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 2/4] scsi: storvsc: Properly support Fibre Channel devices
Date: Fri, 11 Dec 2015 13:25:19 +0300
Message-ID: <20151211102519.GF5284@mwanda>
References: <1449792829-15406-1-git-send-email-kys@microsoft.com>
 <1449792860-15447-1-git-send-email-kys@microsoft.com>
 <1449792860-15447-2-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1449792860-15447-2-git-send-email-kys@microsoft.com>
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

On Thu, Dec 10, 2015 at 04:14:18PM -0800, K. Y. Srinivasan wrote:
> +	ret = vmbus_sendpacket(device->channel, vstor_packet,
> +			       (sizeof(struct vstor_packet) -
> +			       vmscsi_size_delta),
> +			       (unsigned long)request,
> +			       VM_PKT_DATA_INBAND,
> +			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
> +
> +	if (ret != 0)
> +		goto cleanup;
> +
> +	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
> +	if (t == 0) {
> +		ret = -ETIMEDOUT;
> +		goto cleanup;
> +	}
> +
> +	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
> +	    vstor_packet->status != 0)
> +		goto cleanup;

"cleanup" is a misleading name because it doesn't clean up anything.
Do nothing gotos are a pain in the butt and they always introduce bugs.
For example, you appear to have forgotten to set the error code.  But
because it's a do-nothing goto it's ambiguous so perhaps returning
success was intended.

Empirically this style of coding causes bugs.  It does not prevent them.
It is a bad style if you believe in measuring, evidence and science.

regards,
dan carpenter
