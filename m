From: "Michael Kelley (EOSG)" <Michael.H.Kelley@microsoft.com>
Subject: RE: [PATCH] storvsc: Set up correct queue depth values for IDE devices
Date: Fri, 16 Mar 2018 15:54:00 +0000
Message-ID: <DM5PR2101MB103058D9867D0A84E79A682CDCD70@DM5PR2101MB1030.namprd21.prod.outlook.com>
References: <20180315235223.19844-1-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20180315235223.19844-1-longli@exchange.microsoft.com>
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
To: Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, "James E . J . Bottomley" <JBottomley@odin.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org <linux-kernel-owner@vger.kernel.org> On Behalf
> Of Long Li
> Sent: Thursday, March 15, 2018 4:52 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>; Stephen
> Hemminger <sthemmin@microsoft.com>; James E . J . Bottomley <JBottomley@odin.com>;
> Martin K . Petersen <martin.petersen@oracle.com>; devel@linuxdriverproject.org; linux-
> scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: Long Li <longli@microsoft.com>
> Subject: [PATCH] storvsc: Set up correct queue depth values for IDE devices
> 
> From: Long Li <longli@microsoft.com>
> 
> Unlike SCSI and FC, we don't use multiple channels for IDE. So set queue depth
> correctly for IDE.
> 
> Also set the correct cmd_per_lun for all devices.
> 
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 8c51d628b52e..fba170640e9c 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1722,15 +1722,19 @@ static int storvsc_probe(struct hv_device *device,
>  		max_targets = STORVSC_MAX_TARGETS;
>  		max_channels = STORVSC_MAX_CHANNELS;
>  		/*
> -		 * On Windows8 and above, we support sub-channels for storage.
> +		 * On Windows8 and above, we support sub-channels for storage
> +		 * on SCSI and FC controllers.
>  		 * The number of sub-channels offerred is based on the number of
>  		 * VCPUs in the guest.
>  		 */
> -		max_sub_channels = (num_cpus / storvsc_vcpus_per_sub_channel);
> +		if (!dev_is_ide)
> +			max_sub_channels =
> +				num_cpus / storvsc_vcpus_per_sub_channel;

This calculation of the # of sub-channels doesn't get the right answer (and it
didn't before this patch either).  storvsc_vcpus_per_sub_channel defaults to 4.
If num_cpus is 8, max_sub_channels will be 2, but it should be 1.  The
sub-channel count should not include the main channel since we add 1 to the
sub-channel count below when calculating can_queue.

Furthermore, this is calculation is just a guess, in the sense that we're
replicating the algorithm we think Hyper-V is using to determine the number
of sub-channels to offer.   It turns out Hyper-V is changing that algorithm for
particular devices in an upcoming new Azure VM size.  But the only use of
max_sub_channels is in the calculation of can_queue below, so the impact
is minimal.

>  	}
> 
>  	scsi_driver.can_queue = (max_outstanding_req_per_channel *
>  				 (max_sub_channels + 1));
> +	scsi_driver.cmd_per_lun = scsi_driver.can_queue;

can_queue is defined as "int", while cmd_per_lun is defined as "short".
The calculated value of can_queue could easily be over 32,767 with
15 sub-channels and max_outstanding_req_per_channel being 3036
for the default 1 Mbyte ring buffer.  So the assignment to cmd_per_lun
could produce truncation and even a negative number.

More broadly, since max_outstanding_req_per_channel is based on
the ring buffer size, these calculations imply that Hyper-V storvsp's
queuing capacity is based on the ring buffer size.  I don't think that's
the case.  From conversations with the storvsp folks, I think Hyper-V
always removes entries from the guest->host ring buffer and then
lets storvsp queue them separately.   So we don't want to be linking
cmd_per_lun (or even can_queue, for that matter) to the ring buffer
size.  The current default ring buffer size of 1 Mbyte is probably 10x
bigger than needed, and we want to be able to adjust that without
ending up with can_queue and cmd_per_lun values that are too
small.

We would probably do better to set can_queue to a constant, and
leave cmd_per_lun at its current value of 2048.   The can_queue
value is already capped at 10240 in the blk-mq layer, so maybe
that's a reasonable constant to use.

Thoughts?

> 
>  	host = scsi_host_alloc(&scsi_driver,
>  			       sizeof(struct hv_host_device));
> --
> 2.14.1
