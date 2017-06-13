From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [Possible Phish Fraud][PATCH] storvsc: use default I/O timeout
 handler for FC devices
Date: Tue, 13 Jun 2017 15:38:06 +0000
Message-ID: <1497368284.2804.5.camel@wdc.com>
References: <1497313417-14815-1-git-send-email-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1497313417-14815-1-git-send-email-longli@exchange.microsoft.com>
Content-Language: en-US
Content-ID: <9BBCA72B0E716848B9E338A33774AAB2@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kys@microsoft.com" <kys@microsoft.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sthemmin@microsoft.com" <sthemmin@microsoft.com>, "longli@exchange.microsoft.com" <longli@exchange.microsoft.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "haiyangz@microsoft.com" <haiyangz@microsoft.com>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, "longli@microsoft.com" <longli@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2017-06-12 at 17:23 -0700, Long Li wrote:
> From: Long Li <longli@microsoft.com>
>=20
> FC disks are usually setup in a multipath system, and they don't want to=
=20
> unconditionaly reset I/O on timeout. I/O timeout is detected by multipath=
=20
> as a good time to failover and recover.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 8d955db..d60b5ea 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -486,6 +486,7 @@ struct hv_host_device {
>  	unsigned int port;
>  	unsigned char path;
>  	unsigned char target;
> +	bool is_fc;
>  };
> =20
>  struct storvsc_scan_work {
> @@ -1495,6 +1496,11 @@ static int storvsc_host_reset_handler(struct scsi_=
cmnd *scmnd)
>   */
>  static enum blk_eh_timer_return storvsc_eh_timed_out(struct scsi_cmnd *s=
cmnd)
>  {
> +	struct hv_host_device *host_dev =3D shost_priv(scmnd->device->host);
> +
> +	if (host_dev->is_fc)
> +		return BLK_EH_NOT_HANDLED;
> +
>  	return BLK_EH_RESET_TIMER;
>  }
> =20
> @@ -1738,6 +1744,7 @@ static int storvsc_probe(struct hv_device *device,
> =20
>  	host_dev->port =3D host->host_no;
>  	host_dev->dev =3D device;
> +	host_dev->is_fc =3D is_fc;
> =20
> =20
>  	stor_device =3D kzalloc(sizeof(struct storvsc_device), GFP_KERNEL);

Hello Long,

As far as I know there is no other SCSI driver nor block driver in the Linu=
x
kernel tree that returns BLK_EH_RESET_TIMER unconditionally. Would a valid
alternative fix be to remove storvsc_eh_timed_out() entirely? If not, what
would break if that function would be removed entirely?

Additionally, for FC, shouldn't that timeout handler handle the "port block=
ed"
state? Shouldn't fc_eh_timed_out() be used for FC instead of just returning
BLK_EH_NOT_HANDLED?

Thanks,

Bart.=
