From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/2] scsi: storvsc: Use the specified target ID in device
 lookup
Date: Mon, 11 Jan 2016 08:09:52 +0100
Message-ID: <56935540.7060304@suse.de>
References: <1452318697-25451-1-git-send-email-kys@microsoft.com>
 <1452318719-25490-1-git-send-email-kys@microsoft.com>
 <1452318719-25490-2-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1452318719-25490-2-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

On 01/09/2016 06:51 AM, K. Y. Srinivasan wrote:
> The current code assumes that there is only one target in device lookup.
> Fix this bug. This will alow us to correctly handle hot reomoval of LUNs.
>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>   drivers/scsi/storvsc_drv.c |    6 ++++--
>   1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 622f64a..5faf357 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -479,6 +479,7 @@ struct storvsc_scan_work {
>   	struct work_struct work;
>   	struct Scsi_Host *host;
>   	uint lun;
> +	uint tgt_id;
>   };
>
>   static void storvsc_device_scan(struct work_struct *work)
> @@ -490,7 +491,7 @@ static void storvsc_device_scan(struct work_struct *w=
ork)
>   	wrk =3D container_of(work, struct storvsc_scan_work, work);
>   	lun =3D wrk->lun;
>
> -	sdev =3D scsi_device_lookup(wrk->host, 0, 0, lun);
> +	sdev =3D scsi_device_lookup(wrk->host, 0, wrk->tgt_id, lun);
>   	if (!sdev)
>   		goto done;
>   	scsi_rescan_device(&sdev->sdev_gendev);
> @@ -541,7 +542,7 @@ static void storvsc_remove_lun(struct work_struct *wo=
rk)
>   	if (!scsi_host_get(wrk->host))
>   		goto done;
>
> -	sdev =3D scsi_device_lookup(wrk->host, 0, 0, wrk->lun);
> +	sdev =3D scsi_device_lookup(wrk->host, 0, wrk->tgt_id, wrk->lun);
>
>   	if (sdev) {
>   		scsi_remove_device(sdev);
> @@ -941,6 +942,7 @@ static void storvsc_handle_error(struct vmscsi_reques=
t *vm_srb,
>
>   	wrk->host =3D host;
>   	wrk->lun =3D vm_srb->lun;
> +	wrk->tgt_id =3D vm_srb->target_id;
>   	INIT_WORK(&wrk->work, process_err_fn);
>   	schedule_work(&wrk->work);
>   }
>
As a side note, are these really 32-bit values?
Both the LUN and the target?

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
