From: Sitsofe Wheeler <sitsofe@gmail.com>
Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Add blist flags
Date: Wed, 23 Jul 2014 15:10:28 +0100
Message-ID: <20140723141028.GA22724@sucs.org>
References: <1405983961-18782-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1405983961-18782-1-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org, jasowang@redhat.com, ohering@suse.com, jbottomley@parallels.com, linux-kernel@vger.kernel.org, hch@infradead.org, apw@canonical.com, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 21, 2014 at 04:06:01PM -0700, K. Y. Srinivasan wrote:
> Add blist flags to permit the reading of the VPD pages even when
> the target may claim SPC-2 compliance. MSFT targets currently
> claim SPC-2 compliance while they implement post SPC-2 features.
> With this patch we can correctly handle WRITE_SAME_16 issues.
> 
>  static void storvsc_on_channel_callback(void *context);
> @@ -1449,6 +1451,14 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
>  
>  	sdevice->no_write_same = 1;
>  
> +	/*
> +	 * Add blist flags to permit the reading of the VPD pages even when
> +	 * the target may claim SPC-2 compliance. MSFT targets currently
> +	 * claim SPC-2 compliance while they implement post SPC-2 features.
> +	 * With this patch we can correctly handle WRITE_SAME_16 issues.
> +	 */
> +	sdevice->sdev_bflags |= msft_blist_flags;
> +

I'm not sure this alone will work - won't sdev_bflags/bflags have
already been built at this point? If the setting of this has to stay in
this function why don't you (also) set sdevice->try_vpd_pages in a
similar way to no_write_same?

-- 
Sitsofe | http://sucs.org/~sits/
