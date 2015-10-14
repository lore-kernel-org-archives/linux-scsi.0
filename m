From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] SCSI: Rework list handling in scsi_target_remove
Date: Wed, 14 Oct 2015 16:18:21 +0200
Message-ID: <561E642D.8080407@suse.de>
References: <cover.1444829611.git.jthumshirn@suse.de> <b43bba6ec61bae1166bd4f9677450117bf5cde0e.1444829611.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b43bba6ec61bae1166bd4f9677450117bf5cde0e.1444829611.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/14/2015 03:50 PM, Johannes Thumshirn wrote:
> Rework the list handling in scsi_target_remove(). The new version int=
roduces a
> reap list for targets. Targets that shall be removed are placed on th=
e reap
> list and can then be reaped later on.
>=20
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/scsi_sysfs.c | 19 ++++++++-----------
>  1 file changed, 8 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index d7afea9..b41dcb3 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1156,31 +1156,28 @@ static void __scsi_remove_target(struct scsi_=
target *starget)
>  void scsi_remove_target(struct device *dev)
>  {
>  	struct Scsi_Host *shost =3D dev_to_shost(dev->parent);
> -	struct scsi_target *starget, *last =3D NULL;
> +	struct scsi_target *starget, *tmp;
>  	unsigned long flags;
> +	LIST_HEAD(reap_list);
> =20
>  	/* remove targets being careful to lookup next entry before
>  	 * deleting the last
>  	 */
>  	spin_lock_irqsave(&shost->target_lock, flags);
> -	list_for_each_entry(starget, &shost->__targets, siblings) {
> +	list_for_each_entry_safe(starget, tmp, &shost->__targets, siblings)=
 {
>  		if (starget->state =3D=3D STARGET_DEL)
>  			continue;
Hmm. This can even be converted into a WARN_ON(), as with this patch
there should _never_ be an deleted target on the list.

Other than that:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
