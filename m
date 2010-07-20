From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 07/16] trivial: use ARRAY_SIZE
Date: Tue, 20 Jul 2010 17:13:21 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1007201713040.4741@pobox.suse.cz>
References: <1277726109-24633-1-git-send-email-segooon@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41447 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761305Ab0GTPNX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 11:13:23 -0400
In-Reply-To: <1277726109-24633-1-git-send-email-segooon@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>, Jing Huang <huangj@brocade.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Krishna Gudipati <kgudipat@brocade.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 28 Jun 2010, Kulikov Vasiliy wrote:

> Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  drivers/scsi/bfa/bfa_fcs.c |   10 ++++------
>  1 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
> index 3516172..153cb2a 100644
> --- a/drivers/scsi/bfa/bfa_fcs.c
> +++ b/drivers/scsi/bfa/bfa_fcs.c
> @@ -86,7 +86,7 @@ bfa_fcs_attach(struct bfa_fcs_s *fcs, struct bfa_s *bfa, struct bfad_s *bfad,
>  	bfa_attach_fcs(bfa);
>  	fcbuild_init();
>  
> -	for (i = 0; i < sizeof(fcs_modules) / sizeof(fcs_modules[0]); i++) {
> +	for (i = 0; i < ARRAY_SIZE(fcs_modules); i++) {
>  		mod = &fcs_modules[i];
>  		if (mod->attach)
>  			mod->attach(fcs);
> @@ -102,7 +102,7 @@ bfa_fcs_init(struct bfa_fcs_s *fcs)
>  	int             i;
>  	struct bfa_fcs_mod_s  *mod;
>  
> -	for (i = 0; i < sizeof(fcs_modules) / sizeof(fcs_modules[0]); i++) {
> +	for (i = 0; i < ARRAY_SIZE(fcs_modules); i++) {
>  		mod = &fcs_modules[i];
>  		if (mod->modinit)
>  			mod->modinit(fcs);
> @@ -163,13 +163,11 @@ void
>  bfa_fcs_exit(struct bfa_fcs_s *fcs)
>  {
>  	struct bfa_fcs_mod_s  *mod;
> -	int             nmods, i;
> +	int i;
>  
>  	bfa_wc_init(&fcs->wc, bfa_fcs_exit_comp, fcs);
>  
> -	nmods = sizeof(fcs_modules) / sizeof(fcs_modules[0]);
> -
> -	for (i = 0; i < nmods; i++) {
> +	for (i = 0; i < ARRAY_SIZE(fcs_modules); i++) {
>  
>  		mod = &fcs_modules[i];
>  		if (mod->modexit) {

I have folded this patch into the other bfa change you made, and applied. 
Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
