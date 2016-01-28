From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V2 1/2] scsi: storvsc: Install the storvsc specific
 timeout handler for FC devices
Date: Thu, 28 Jan 2016 09:28:40 +0100
Message-ID: <20160128082840.GD27565@c203.arch.suse.de>
References: <1453947739-28725-1-git-send-email-kys@microsoft.com>
 <1453947765-28764-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1453947765-28764-1-git-send-email-kys@microsoft.com>
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
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org, jasowang@redhat.com, ohering@suse.com, jbottomley@parallels.com, linux-kernel@vger.kernel.org, hch@infradead.org, hare@suse.de, apw@canonical.com, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 27, 2016 at 06:22:44PM -0800, K. Y. Srinivasan wrote:
> The default timeout routine used for FC transport is not
> suitable for FC devices managed by storvsc since FC devices
> managed by storvsc driver do not have an rport associated
> with them. Use the time out handler used for SCSI devices
> for FC devices as well.
> =

> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Alex Ng <alexng@microsoft.com>
> Tested-by: Vivek Yadav <vyadav@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> =

> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 41c115c..622f64a 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -42,6 +42,7 @@
>  #include <scsi/scsi_devinfo.h>
>  #include <scsi/scsi_dbg.h>
>  #include <scsi/scsi_transport_fc.h>
> +#include <scsi/scsi_transport.h>
>  =

>  /*
>   * All wire protocol details (storage protocol between the guest and the=
 host)
> @@ -1770,6 +1771,11 @@ static int __init storvsc_drv_init(void)
>  	fc_transport_template =3D fc_attach_transport(&fc_transport_functions);
>  	if (!fc_transport_template)
>  		return -ENODEV;
> +
> +	/*
> +	 * Install Hyper-V specific timeout handler.
> +	 */
> +	fc_transport_template->eh_timed_out =3D storvsc_eh_timed_out;
>  #endif
>  =

>  	ret =3D vmbus_driver_register(&storvsc_drv);
> -- =

> 1.7.4.1
> =

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
-- =

Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
