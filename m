From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V3 4/7] Drivers: scsi: storvsc: Fix a bug in handling
 VMBUS protocol version
Date: Mon, 14 Jul 2014 08:16:38 +0200
Message-ID: <53C375C6.8060703@suse.de>
References: <1405183684-23928-1-git-send-email-kys@microsoft.com>
 <1405183712-23967-1-git-send-email-kys@microsoft.com>
 <1405183712-23967-4-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1405183712-23967-4-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: "K. Y. Srinivasan" <kys@microsoft.com>, jasowang@redhat.com, apw@canonical.com, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/12/2014 06:48 PM, K. Y. Srinivasan wrote:
> Based on the negotiated VMBUS protocol version, we adjust the size of the=
 storage
> protocol messages. The two sizes we currently handle are pre-win8 and pos=
t-win8.
> In WS2012 R2, we are negotiating higher VMBUS protocol version than the w=
in8
> version. Make adjustments to correctly handle this.
>
> In this version of the patch I have addressed comments from
> Christoph Hellwig <hch@infradead.org>
>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Cc: <stable@vger.kernel.org>
> ---
>   drivers/scsi/storvsc_drv.c |   17 ++++++++++-------
>   1 files changed, 10 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 8f8847e..7e8a642 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1752,19 +1752,22 @@ static int storvsc_probe(struct hv_device *device,
>   	 * set state to properly communicate with the host.
>   	 */
>
> -	if (vmbus_proto_version =3D=3D VERSION_WIN8) {
> -		sense_buffer_size =3D POST_WIN7_STORVSC_SENSE_BUFFER_SIZE;
> -		vmscsi_size_delta =3D 0;
> -		vmstor_current_major =3D VMSTOR_WIN8_MAJOR;
> -		vmstor_current_minor =3D VMSTOR_WIN8_MINOR;
> -	} else {
> +	switch (vmbus_proto_version) {
> +	case VERSION_WS2008:
> +	case VERSION_WIN7:
>   		sense_buffer_size =3D PRE_WIN8_STORVSC_SENSE_BUFFER_SIZE;
>   		vmscsi_size_delta =3D sizeof(struct vmscsi_win8_extension);
>   		vmstor_current_major =3D VMSTOR_WIN7_MAJOR;
>   		vmstor_current_minor =3D VMSTOR_WIN7_MINOR;
> +		break;
> +	default:
> +		sense_buffer_size =3D POST_WIN7_STORVSC_SENSE_BUFFER_SIZE;
> +		vmscsi_size_delta =3D 0;
> +		vmstor_current_major =3D VMSTOR_WIN8_MAJOR;
> +		vmstor_current_minor =3D VMSTOR_WIN8_MINOR;
> +		break;
>   	}
>
> -
>   	if (dev_id->driver_data =3D=3D SFC_GUID)
>   		scsi_driver.can_queue =3D (STORVSC_MAX_IO_REQUESTS *
>   					 STORVSC_FC_MAX_TARGETS);
>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
