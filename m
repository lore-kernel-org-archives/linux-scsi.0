From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 28/45] target: use bio op accessors
Date: Mon, 6 Jun 2016 08:46:47 +0200
Message-ID: <57551C57.5090507@suse.de>
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
 <1465155145-10812-29-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1465155145-10812-29-git-send-email-mchristi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mchristi@redhat.com, linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
List-Id: linux-scsi@vger.kernel.org

On 06/05/2016 09:32 PM, mchristi@redhat.com wrote:
> From: Mike Christie <mchristi@redhat.com>
>=20
> Separate the op from the rq_flag_bits and have the target layer
> set/get the bio using bio_set_op_attrs/bio_op.
>=20
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>  drivers/target/target_core_iblock.c | 29 ++++++++++++++-------------=
--
>  drivers/target/target_core_pscsi.c  |  2 +-
>  2 files changed, 15 insertions(+), 16 deletions(-)
>=20
> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/tar=
get_core_iblock.c
> index c25109c..22af12f 100644
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
[ .. ]
> @@ -689,18 +690,15 @@ iblock_execute_rw(struct se_cmd *cmd, struct sc=
atterlist *sgl, u32 sgl_nents,
>  		 * Force writethrough using WRITE_FUA if a volatile write cache
>  		 * is not enabled, or if initiator set the Force Unit Access bit.
>  		 */
> +		op =3D REQ_OP_WRITE;
>  		if (test_bit(QUEUE_FLAG_FUA, &q->queue_flags)) {
>  			if (cmd->se_cmd_flags & SCF_FUA)
> -				rw =3D WRITE_FUA;
> +				op_flags =3D WRITE_FUA;
>  			else if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags))
> -				rw =3D WRITE_FUA;
> -			else
> -				rw =3D WRITE;
> -		} else {
> -			rw =3D WRITE;
> +				op_flags =3D WRITE_FUA;
>  		}
Wrong intendation.

>  	} else {
> -		rw =3D READ;
> +		op =3D REQ_OP_READ;
>  	}
> =20
>  	ibr =3D kzalloc(sizeof(struct iblock_req), GFP_KERNEL);
> @@ -714,7 +712,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scat=
terlist *sgl, u32 sgl_nents,
>  		return 0;
>  	}
> =20
> -	bio =3D iblock_get_bio(cmd, block_lba, sgl_nents, rw);
> +	bio =3D iblock_get_bio(cmd, block_lba, sgl_nents, op, op_flags);
>  	if (!bio)
>  		goto fail_free_ibr;
> =20
> @@ -738,7 +736,8 @@ iblock_execute_rw(struct se_cmd *cmd, struct scat=
terlist *sgl, u32 sgl_nents,
>  				bio_cnt =3D 0;
>  			}
> =20
> -			bio =3D iblock_get_bio(cmd, block_lba, sg_num, rw);
> +			bio =3D iblock_get_bio(cmd, block_lba, sg_num, op,
> +					     op_flags);
>  			if (!bio)
>  				goto fail_put_bios;
> =20
> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/targ=
et_core_pscsi.c
> index de18790..81564c8 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -922,7 +922,7 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterli=
st *sgl, u32 sgl_nents,
>  					goto fail;
> =20
>  				if (rw)
> -					bio->bi_rw |=3D REQ_WRITE;
> +					bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
> =20
>  				pr_debug("PSCSI: Allocated bio: %p,"
>  					" dir: %s nr_vecs: %d\n", bio,
>=20
Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
