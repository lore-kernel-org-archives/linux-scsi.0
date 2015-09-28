From: Daniel Axtens <dja@axtens.net>
Subject: Re: [PATCH v4 06/32] cxlflash: Fix to avoid sizeof(bool)
Date: Tue, 29 Sep 2015 08:35:30 +1000
Message-ID: <87oagmuq8d.fsf@gamma.ozlabs.ibm.com>
References: <1443222593-8828-1-git-send-email-mrochs@linux.vnet.ibm.com> <1443222841-9152-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:32966 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbbI1Wfy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2015 18:35:54 -0400
Received: by pacex6 with SMTP id ex6so185971630pac.0
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2015 15:35:54 -0700 (PDT)
In-Reply-To: <1443222841-9152-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512


Looks good to me.

Reviewed-by: Daniel Axtens <dja@axtens.net>

Regards,
Daniel

"Matthew R. Ochs" <mrochs@linux.vnet.ibm.com> writes:

> Using sizeof(bool) is considered poor form for various reasons and
> sparse warns us of that. Correct by changing type from bool to u8.
>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
> ---
>  drivers/scsi/cxlflash/superpipe.c | 2 +-
>  drivers/scsi/cxlflash/superpipe.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
> index ffa68cc..28aa9d9 100644
> --- a/drivers/scsi/cxlflash/superpipe.c
> +++ b/drivers/scsi/cxlflash/superpipe.c
> @@ -737,7 +737,7 @@ static struct ctx_info *create_context(struct cxlflash_cfg *cfg,
>  	struct afu *afu = cfg->afu;
>  	struct ctx_info *ctxi = NULL;
>  	struct llun_info **lli = NULL;
> -	bool *ws = NULL;
> +	u8 *ws = NULL;
>  	struct sisl_rht_entry *rhte;
>  
>  	ctxi = kzalloc(sizeof(*ctxi), GFP_KERNEL);
> diff --git a/drivers/scsi/cxlflash/superpipe.h b/drivers/scsi/cxlflash/superpipe.h
> index fffb179..72d53cf 100644
> --- a/drivers/scsi/cxlflash/superpipe.h
> +++ b/drivers/scsi/cxlflash/superpipe.h
> @@ -97,7 +97,7 @@ struct ctx_info {
>  	u32 rht_out;		/* Number of checked out RHT entries */
>  	u32 rht_perms;		/* User-defined permissions for RHT entries */
>  	struct llun_info **rht_lun;       /* Mapping of RHT entries to LUNs */
> -	bool *rht_needs_ws;	/* User-desired write-same function per RHTE */
> +	u8 *rht_needs_ws;	/* User-desired write-same function per RHTE */
>  
>  	struct cxl_ioctl_start_work work;
>  	u64 ctxid;
> -- 
> 2.1.0
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJWCcCzAAoJEPC3R3P2I92FisQP/1Gd443NSLYkye19i4D7qlA/
3tfNTBBSYL68A1L1ssgRxtpOkqb80hjOSXZhR2SDLRGNXDoC5+8fwti/sF8wxewF
rxIsliMN2WnqgyYpw4qt7T6AMZtSyP1yXQkPWZcVQi5a9p1w3YmLdvwr9hnyKx8n
TRjEe3OoDS/dde8l+4C1YKCL/U4oDuGdH7DLT+vhn49TfxQL4aNiV52Wu5l3Sptw
f4/VVXAklNkU6yHJiRonjf/GJggfcgKUmsy4y8ayvkNuMu2V+ffP9AbdwdZXrplK
CempBE0AvQdjLS0b8oIErOHfyWJcagHhMZicblLT5xp4kR0mDsIybEI433cGjESI
4ECg2AjKRoBEu6s8fR3WFR82nZo97o0ck2pAD4RVJTA/aY7h1DlZ45kg2cYEatRW
OVnQqd//bHKyWljWzl7qXuwpXF8G92iP4CFQ4d8aruUFp9vwFlR8GuIpsq69kb5X
FM6EuTzcbD+GkT+P9lw2T/6LHrb+2kTANHJgWKalfugJxAwcDps6X7tKxQ9mvqps
HyVVfOtNkK2yvAV8iEqPdT9ltXIhJ/g9c9ZtQ7F2Qg7pxnB15M5ykOIeVVsRIEof
F1HAG8xzPNY0Q7MBHDixqQ7IbHDnbkM+SI9outZu5C0ECjc3UwdfOaegm+A6eWs9
3bv8aFdbQlHfjSFUIhqY
=RI1B
-----END PGP SIGNATURE-----
