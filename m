From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Add blist flags
Date: Thu, 24 Jul 2014 07:40:36 +0200
Message-ID: <53D09C54.1000206@suse.de>
References: <1405983961-18782-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
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
To: "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, apw@canonical.com, jasowang@redhat.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/22/2014 01:06 AM, K. Y. Srinivasan wrote:
> Add blist flags to permit the reading of the VPD pages even when
> the target may claim SPC-2 compliance. MSFT targets currently
> claim SPC-2 compliance while they implement post SPC-2 features.
> With this patch we can correctly handle WRITE_SAME_16 issues.
>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>   drivers/scsi/storvsc_drv.c |   10 ++++++++++
>   1 files changed, 10 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 29d0329..15ba695 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -327,6 +327,8 @@ MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffe=
r size (bytes)");
>    */
>   static int storvsc_timeout =3D 180;
>
> +static int msft_blist_flags =3D BLIST_TRY_VPD_PAGES;
> +
>   #define STORVSC_MAX_IO_REQUESTS				200
>
>   static void storvsc_on_channel_callback(void *context);
> @@ -1449,6 +1451,14 @@ static int storvsc_device_configure(struct scsi_de=
vice *sdevice)
>
>   	sdevice->no_write_same =3D 1;
>
> +	/*
> +	 * Add blist flags to permit the reading of the VPD pages even when
> +	 * the target may claim SPC-2 compliance. MSFT targets currently
> +	 * claim SPC-2 compliance while they implement post SPC-2 features.
> +	 * With this patch we can correctly handle WRITE_SAME_16 issues.
> +	 */
> +	sdevice->sdev_bflags |=3D msft_blist_flags;
> +
>   	return 0;
>   }
>
>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
