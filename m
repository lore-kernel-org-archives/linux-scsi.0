From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] SCSI: Introduce device_lock and target_lock in Scsi_Host
Date: Wed, 14 Oct 2015 16:14:04 +0200
Message-ID: <561E632C.1030504@suse.de>
References: <cover.1444829611.git.jthumshirn@suse.de> <f2ff8b554116663d7acf35fa84c23886bf486ffb.1444829611.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f2ff8b554116663d7acf35fa84c23886bf486ffb.1444829611.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/14/2015 03:50 PM, Johannes Thumshirn wrote:
> Introduce target_lock and device_lock to untangle the __devices and _=
_targets
> lists from the host_lock.
>=20
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/53c700.c     |  3 +++
>  drivers/scsi/hosts.c      |  2 ++
>  drivers/scsi/scsi.c       |  8 ++++----
>  drivers/scsi/scsi_scan.c  | 10 +++++-----
>  drivers/scsi/scsi_sysfs.c | 18 ++++++++----------
>  include/scsi/scsi_host.h  |  2 ++
>  6 files changed, 24 insertions(+), 19 deletions(-)
>=20
> diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
> index a209c34..e2b4d04 100644
> --- a/drivers/scsi/53c700.c
> +++ b/drivers/scsi/53c700.c
> @@ -1093,6 +1093,7 @@ process_script_interrupt(__u32 dsps, __u32 dsp,=
 struct scsi_cmnd *SCp,
>  		struct NCR_700_command_slot *slot;
>  		__u8 reselection_id =3D hostdata->reselection_id;
>  		struct scsi_device *SDp;
> +		unsigned long flags;
> =20
>  		lun =3D hostdata->msgin[0] & 0x1f;
> =20
> @@ -1100,7 +1101,9 @@ process_script_interrupt(__u32 dsps, __u32 dsp,=
 struct scsi_cmnd *SCp,
>  		DEBUG(("scsi%d: (%d:%d) RESELECTED!\n",
>  		       host->host_no, reselection_id, lun));
>  		/* clear the reselection indicator */
> +		spin_lock_irqsave(host->device_lock, flags);
>  		SDp =3D __scsi_device_lookup(host, 0, reselection_id, lun);
> +		spin_unlock_irqrestore(host->device_lock, flags);
>  		if(unlikely(SDp =3D=3D NULL)) {
>  			printk(KERN_ERR "scsi%d: (%d:%d) HAS NO device\n",
>  			       host->host_no, reselection_id, lun);

Hmm. Unfortunate.

Can't we get rid of the underscore version altogether, seeing that
we have our own lock now?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
