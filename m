From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH 2/4] blk-timeout: add BLK_EH_SCHEDULED return code
Date: Thu, 6 Jun 2013 12:24:35 -0400
Message-ID: <20130606162433.GD16616@logfs.org>
References: <1370511835-50072-1-git-send-email-hare@suse.de>
 <1370511835-50072-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59422 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab3FFRxq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jun 2013 13:53:46 -0400
Content-Disposition: inline
In-Reply-To: <1370511835-50072-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>

On Thu, 6 June 2013 11:43:53 +0200, Hannes Reinecke wrote:
>=20
> Add a 'BLK_EH_SCHEDULED' return code for blk-timeout to indicate
> that a delayed error recovery has been initiated.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Since the patch I tested diverged from your patches 2-4, this is only
Acked-by: Joern Enge <joern@logfs.org>

> ---
>  drivers/scsi/scsi_error.c | 3 +++
>  include/linux/blkdev.h    | 1 +
>  2 files changed, 4 insertions(+)
>=20
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index f43de1e..96b4bb6 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -146,6 +146,9 @@ enum blk_eh_timer_return scsi_times_out(struct re=
quest *req)
>  		rtn =3D host->hostt->eh_timed_out(scmd);
> =20
>  	scmd->result |=3D DID_TIME_OUT << 16;
> +	/* Check for delayed EH scheduling */
> +	if (rtn =3D=3D BLK_EH_SCHEDULED)
> +		return BLK_EH_NOT_HANDLED;
> =20
>  	if (unlikely(rtn =3D=3D BLK_EH_NOT_HANDLED &&
>  		     !scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD)))
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 2fdb4a4..d846e2b 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -238,6 +238,7 @@ enum blk_eh_timer_return {
>  	BLK_EH_NOT_HANDLED,
>  	BLK_EH_HANDLED,
>  	BLK_EH_RESET_TIMER,
> +	BLK_EH_SCHEDULED,
>  };
> =20
>  typedef enum blk_eh_timer_return (rq_timed_out_fn)(struct request *)=
;
> --=20
> 1.7.12.4
>=20

J=C3=B6rn

--
Geld macht nicht gl=C3=BCcklich.
Gl=C3=BCck macht nicht satt.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
