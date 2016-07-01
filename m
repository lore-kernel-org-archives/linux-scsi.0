From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v2] libfc: sanity check cpu number extracted
	from xid
Date: Fri, 1 Jul 2016 10:09:49 +0200
Message-ID: <20160701080949.dqfit6qit4grtjjg@c203.arch.suse.de>
References: <20160630070925.ptbgkeq57txs55gf@c203.arch.suse.de>
 <1467300756-7949-1-git-send-email-cleech@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1467300756-7949-1-git-send-email-cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel/>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: "fcoe-devel" <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
To: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, Johannes Thumshirn <jth-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 30, 2016 at 08:32:36AM -0700, Chris Leech wrote:
> In the receive path libfc extracts a cpu number from the ox_id in the
> fiber channel header and uses that to do a per_cpu_ptr conversion.
> If, for some reason, a frame is received with an invalid ox_id,
> per_cpu_ptr will return an invalid pointer and the libfc receive path
> will panic the system trying to use it.
> =

> I'm currently looking at such a case, and I don't yet know why a
> cpu number > nr_cpu_ids is appearing in an exchange id.  But adding a
> sanity check in libfc prevents a system panic, and seems like good idea
> when dealing with frames coming in from the network.
> =

> Signed-off-by: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/scsi/libfc/fc_exch.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> =

> diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
> index 30f9ef0..e72673b 100644
> --- a/drivers/scsi/libfc/fc_exch.c
> +++ b/drivers/scsi/libfc/fc_exch.c
> @@ -908,9 +908,17 @@ static struct fc_exch *fc_exch_find(struct fc_exch_m=
gr *mp, u16 xid)
>  {
>  	struct fc_exch_pool *pool;
>  	struct fc_exch *ep =3D NULL;
> +	u16 cpu =3D xid & fc_cpu_mask;
> +
> +	if (cpu >=3D nr_cpu_ids || !cpu_possible(cpu)) {
> +		printk_ratelimited(KERN_ERR
> +			"libfc: lookup request for XID =3D %d, "
> +			"indicates invalid CPU %d\n", xid, cpu);
> +		return NULL;
> +	}
>  =

>  	if ((xid >=3D mp->min_xid) && (xid <=3D mp->max_xid)) {
> -		pool =3D per_cpu_ptr(mp->pool, xid & fc_cpu_mask);
> +		pool =3D per_cpu_ptr(mp->pool, cpu);
>  		spin_lock_bh(&pool->lock);
>  		ep =3D fc_exch_ptr_get(pool, (xid - mp->min_xid) >> fc_cpu_order);
>  		if (ep) {


Acked-by: Johannes Thumshirn <jth-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

@Martin, do you queue the libfc patches as well?

-- =

Johannes Thumshirn                                          Storage
jthumshirn-l3A5Bk7waGM@public.gmane.org                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
