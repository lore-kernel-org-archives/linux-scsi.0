From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 1/6] lpfc 8.1.7 : Adding statistics reset callback for FC transport
Date: Tue, 1 Aug 2006 14:14:51 +0200
Message-ID: <200608011414.51998.eike-kernel@sf-tec.de>
References: <1154432009.18162.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1675512.5Ut8NKgF3m";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:21450 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S1751265AbWHAMTY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2006 08:19:24 -0400
In-Reply-To: <1154432009.18162.12.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@emulex.com
Cc: linux-scsi@vger.kernel.org

--nextPart1675512.5Ut8NKgF3m
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

James Smart wrote:
> Adding statistics reset callback for FC transport
>
> Signed-off-by: James Smart <James.Smart@emulex.com>

> -/* FIX ME */
> -	/*hs->SecondsSinceLastReset = (jiffies - lpfc_loadtime) / HZ;*/
> +	hs->seconds_since_last_reset = (jiffies - psli->stats_start) / HZ;

Wraparound?

> +void  lpfc_reset_stats(struct Scsi_Host *shost)
> +{
> +	struct lpfc_hba *phba = (struct lpfc_hba *)shost->hostdata;
> +	struct lpfc_sli *psli = &phba->sli;
> +	struct lpfc_lnk_stat * lso = &psli->lnk_stat_offsets;
> +	LPFC_MBOXQ_t *pmboxq;
> +	MAILBOX_t *pmb;
> +	int rc = 0;
> +
> +	pmboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
> +	if (!pmboxq)
> +		return;
> +	memset(pmboxq, 0, sizeof (LPFC_MBOXQ_t));
                                ^

No space here.

[...]
> +	memset(pmboxq, 0, sizeof (LPFC_MBOXQ_t));

Again.

Eike

--nextPart1675512.5Ut8NKgF3m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBEz0W7XKSJPmm5/E4RAgBZAJ986qQW7w4Yb0QLJTRHdFTvpyuMCwCfaD2u
BK/dDz6mj1e9dwlzvFJRPO8=
=8jkW
-----END PGP SIGNATURE-----

--nextPart1675512.5Ut8NKgF3m--
