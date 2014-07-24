From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 2/3] [SCSI] storvsc: Add Hyper-V logical block
 provisioning tests
Date: Thu, 24 Jul 2014 14:09:11 +0000
Message-ID: <1406210951.2040.5.camel@jarvis.lan>
References: <1405983961-18782-1-git-send-email-kys@microsoft.com>
 <20140723141028.GA22724@sucs.org> <20140723141558.GA9705@infradead.org>
 <20140723201341.GA10292@sucs.org> <20140724074739.GA15127@sucs.org>
 <20140724075653.GC15127@sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20140724075653.GC15127@sucs.org>
Content-Language: en-US
Content-ID: <4C0405326331634AB54A917409251B18@sw.swsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: "sitsofe@gmail.com" <sitsofe@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ohering@suse.com" <ohering@suse.com>, "hch@infradead.org" <hch@infradead.org>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2014-07-24 at 08:56 +0100, Sitsofe Wheeler wrote:
> Microsoft Hyper-V targets currently only claim SPC-2 compliance / no
> compliance indicated even though they implement post SPC-2 features
> which means those features are not tested for. Add a blacklist flag to
> Hyper-V devices that forces said testing.

This description is misleading: you don't force the test now, you force
the driver to send unmap commands down to the device.

> See https://lkml.org/lkml/2014/7/21/627 for the previous version of this
> patch and https://lkml.org/lkml/2014/7/23/615 for example devices.
> 
> Original-patch-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Sitsofe Wheeler <sitsofe@yahoo.com>
> ---
>  drivers/scsi/storvsc_drv.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 5ad2810..88b7173 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -326,8 +326,6 @@ MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
>   */
>  static int storvsc_timeout = 180;
>  
> -static int msft_blist_flags = BLIST_TRY_VPD_PAGES;
> -
>  #define STORVSC_MAX_IO_REQUESTS				200
>  
>  static void storvsc_on_channel_callback(void *context);
> @@ -1444,12 +1442,10 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
>  	sdevice->no_write_same = 1;
>  
>  	/*
> -	 * Add blist flags to permit the reading of the VPD pages even when
> -	 * the target may claim SPC-2 compliance. MSFT targets currently
> -	 * claim SPC-2 compliance while they implement post SPC-2 features.
> -	 * With this patch we can correctly handle WRITE_SAME_16 issues.
> +	 * Forcefully enable logical block provisioning testing.
>  	 */
> -	sdevice->sdev_bflags |= msft_blist_flags;
> +	sdevice->sdev_bflags |= BLIST_TRY_LBP;
> +	sdevice->try_lbp = 1;

Really no way to this one.  You're forcing unmap support on every
hyper-v device; including spinning rust pass through ones which won't
support it.  The hyper-v storage interface has proven to be somewhat
fragile, so it may explode when the device tries to send illegal command
sense back.

If you have a specific IDENTITY string for a faulty SSD that fails to
report unmap support correctly, then we could quirk for that, but not
everything attached to the hyper-v driver.

James
