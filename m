From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2] storvsc: use default I/O timeout handler for FC
 devices
Date: Wed, 14 Jun 2017 10:24:38 +0200
Message-ID: <5d983dac-69b6-ff89-d1ef-e0ea9b8136b1@suse.de>
References: <1497389645-8912-1-git-send-email-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1497389645-8912-1-git-send-email-longli@exchange.microsoft.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Long Li <longli@exchange.microsoft.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, KY Srinivasan <kys@microsoft.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, Stephen Hemminger <sthemmin@microsoft.com>
Cc: Long Li <longli@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

On 06/13/2017 11:34 PM, Long Li wrote:
> From: Long Li <longli@microsoft.com>
> 
> FC disks issue I/O directly to the host storage port driver, this is
> diffirent to VHD disks where I/O is virtualized and timeout is handled
> by the host VSP (Virtualization Service Provider).
> 
> FC disks are usually setup in a multipath system, and they don't want to
> reset timer on I/O timeout. Timeout is detected by multipath as a good 
> time to failover and recover.
> 
> Patch v2 includes suggestions from Bart Van Assche
> <Bart.VanAssche@sandisk.com>
> 
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 8d955db..3cc8d67 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1495,6 +1495,10 @@ static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
>   */
>  static enum blk_eh_timer_return storvsc_eh_timed_out(struct scsi_cmnd *scmnd)
>  {
> +#if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
> +	if (scmnd->device->host->transportt == fc_transport_template)
> +		return fc_eh_timed_out(scmnd);
> +#endif

Can you please change the #if IS_ENABLED() to
if(IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
	&& scmnd->device->host->transportt == fc_transport_template)

That way we have better compiler coverage.

Thanks,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
