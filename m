From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC PATCH 3/4] dm mpath: move trigger_event member to the end of
 'struct multipath'
Date: Thu, 7 Apr 2016 17:03:06 +0200
Message-ID: <570676AA.7040204@suse.de>
References: <1459454666-76428-1-git-send-email-snitzer@redhat.com>
 <1459454666-76428-4-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33705 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756508AbcDGPDI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Apr 2016 11:03:08 -0400
In-Reply-To: <1459454666-76428-4-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: jmoyer@redhat.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, j-nomura@ce.jp.nec.com, sagig@dev.mellanox.co.il

On 03/31/2016 10:04 PM, Mike Snitzer wrote:
> Allows the 'work_mutex' member to no longer cross a cacheline.
>=20
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm-mpath.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 780e5d0..54daf96 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -89,8 +89,6 @@ struct multipath {
>  	atomic_t pg_init_in_progress;	/* Only one pg_init allowed at once *=
/
>  	atomic_t pg_init_count;		/* Number of times pg_init called */
> =20
> -	struct work_struct trigger_event;
> -
>  	/*
>  	 * We must use a mempool of dm_mpath_io structs so that we
>  	 * can resubmit bios on error.
> @@ -98,6 +96,7 @@ struct multipath {
>  	mempool_t *mpio_pool;
> =20
>  	struct mutex work_mutex;
> +	struct work_struct trigger_event;
>  };
> =20
>  /*
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
