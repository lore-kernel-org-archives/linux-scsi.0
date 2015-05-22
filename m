From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/4] target: Drop lun_sep_lock for se_lun->lun_se_dev
 RCU usage
Date: Fri, 22 May 2015 09:57:25 +0200
Message-ID: <555EE165.3090709@suse.de>
References: <1432278417-29994-1-git-send-email-nab@daterainc.com> <1432278417-29994-3-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1432278417-29994-3-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 05/22/2015 09:06 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>=20
> With se_port and t10_alua_tg_pt_gp_member being absored into se_lun,
> there is no need for an extra lock to protect se_lun->lun_se_dev
> assignment.
>=20
> Also, convert se_lun->lun_stats to use atomic_long_t within the
> target_complete_ok_work() completion callback.
>=20
> Reported-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/target_core_device.c    |  1 -
>  drivers/target/target_core_stat.c      | 65 +++++++++++++++++-------=
----------
>  drivers/target/target_core_tpg.c       |  8 ++---
>  drivers/target/target_core_transport.c | 22 ++++--------
>  include/target/target_core_base.h      |  9 +++--
>  5 files changed, 46 insertions(+), 59 deletions(-)
>=20

[ .. ]

> diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target=
_core_tpg.c
> index 8764f1c..f60b74e 100644
> --- a/drivers/target/target_core_tpg.c
> +++ b/drivers/target/target_core_tpg.c
> @@ -601,7 +601,6 @@ struct se_lun *core_tpg_alloc_lun(
>  	lun->lun_link_magic =3D SE_LUN_LINK_MAGIC;
>  	lun->lun_status =3D TRANSPORT_LUN_STATUS_FREE;
>  	atomic_set(&lun->lun_acl_count, 0);
> -	spin_lock_init(&lun->lun_sep_lock);
>  	init_completion(&lun->lun_ref_comp);
>  	INIT_LIST_HEAD(&lun->lun_deve_list);
>  	INIT_LIST_HEAD(&lun->lun_dev_link);
> @@ -638,10 +637,7 @@ int core_tpg_add_lun(
>  		target_attach_tg_pt_gp(lun, dev->t10_alua.default_tg_pt_gp);
> =20
>  	mutex_lock(&tpg->tpg_lun_mutex);
> -
> -	spin_lock(&lun->lun_sep_lock);
> -	lun->lun_se_dev =3D dev;
> -	spin_unlock(&lun->lun_sep_lock);
> +	rcu_assign_pointer(lun->lun_se_dev, dev);
> =20
>  	spin_lock(&dev->se_port_lock);
>  	dev->export_count++;
> @@ -683,7 +679,7 @@ void core_tpg_remove_lun(
>  		dev->export_count--;
>  		spin_unlock(&dev->se_port_lock);
> =20
> -		lun->lun_se_dev =3D NULL;
> +		rcu_assign_pointer(lun->lun_se_dev, NULL);
>  	}
> =20
>  	lun->lun_status =3D TRANSPORT_LUN_STATUS_FREE;
Doesn't this need to go under 'dev->se_port_lock' like in
core_tgp_add_lun() ?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
