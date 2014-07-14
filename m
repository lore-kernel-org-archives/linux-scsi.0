From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V3 3/7] Drivers: scsi: storvsc: Filter commands based
 on the storage protocol version
Date: Mon, 14 Jul 2014 08:16:12 +0200
Message-ID: <53C375AC.7070609@suse.de>
References: <1405183684-23928-1-git-send-email-kys@microsoft.com> <1405183712-23967-1-git-send-email-kys@microsoft.com> <1405183712-23967-3-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1405183712-23967-3-git-send-email-kys@microsoft.com>
Sender: stable-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>, jasowang@redhat.com, apw@canonical.com, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/12/2014 06:48 PM, K. Y. Srinivasan wrote:
> Going forward it is possible that some of the commands that are not c=
urrently
> implemented will be implemented on future Windows hosts. Even if they=
 are not
> implemented, we are told the host will corrrectly handle unsupported
> commands (by returning appropriate return code and sense information)=
=2E
> Make command filtering depend on the host version.
>
> In this version of the patch I have addressed comments from
> Christoph Hellwig <hch@infradead.org>
>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Cc: <stable@vger.kernel.org>
> ---
>   drivers/scsi/storvsc_drv.c |   16 +++++++++++++---
>   1 files changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index cebcef7..8f8847e 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1553,9 +1553,19 @@ static int storvsc_queuecommand(struct Scsi_Ho=
st *host, struct scsi_cmnd *scmnd)
>   	struct vmscsi_request *vm_srb;
>   	struct stor_mem_pools *memp =3D scmnd->device->hostdata;
>
> -	if (!storvsc_scsi_cmd_ok(scmnd)) {
> -		scmnd->scsi_done(scmnd);
> -		return 0;
> +	if (vmstor_current_major <=3D VMSTOR_WIN8_MAJOR) {
> +		/*
> +		 * On legacy hosts filter unimplemented commands.
> +		 * Future hosts are expected to correctly handle
> +		 * unsupported commands. Furthermore, it is
> +		 * possible that some of the currently
> +		 * unsupported commands maybe supported in
> +		 * future versions of the host.
> +		 */
> +		if (!storvsc_scsi_cmd_ok(scmnd)) {
> +			scmnd->scsi_done(scmnd);
> +			return 0;
> +		}
>   	}
>
>   	request_size =3D sizeof(struct storvsc_cmd_request);
>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
