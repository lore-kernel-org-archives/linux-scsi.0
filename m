From: Vijaya Mohan Guvva <vmohan@Brocade.com>
Subject: RE: [PATCH] scsi: bfa: Use ARRAY_SIZE
Date: Thu, 5 Sep 2013 02:18:33 -0600
Message-ID: <51BD2AE8016AE441B63F5661159C9902207C299D1A@BRM-EXCH-3.corp.brocade.com>
References: <1377977692-28698-1-git-send-email-christophjaeger@linux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:57651 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762639Ab3IEIzf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Sep 2013 04:55:35 -0400
Received: from pps.filterd (m0000542 [127.0.0.1])
	by mx0a-000f0801.pphosted.com (8.14.5/8.14.5) with SMTP id r8582jh0022881
	for <linux-scsi@vger.kernel.org>; Thu, 5 Sep 2013 01:19:03 -0700
Received: from hq1wp-exchub01.corp.brocade.com ([144.49.131.13])
	by mx0a-000f0801.pphosted.com with ESMTP id 1enptqjjdk-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 05 Sep 2013 01:19:03 -0700
In-Reply-To: <1377977692-28698-1-git-send-email-christophjaeger@linux.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Jaeger <christophjaeger@linux.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Christoph Jaeger
> Sent: Sunday, September 01, 2013 1:05 AM
> To: James E.J. Bottomley
> Cc: linux-scsi@vger.kernel.org; Christoph Jaeger
> Subject: [PATCH] scsi: bfa: Use ARRAY_SIZE
> 
> Use ARRAY_SIZE to calculate the size of an array.
> 
> Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>
> ---
>  drivers/scsi/bfa/bfa_core.c |  2 +-
>  drivers/scsi/bfa/bfa_fcs.c  | 10 ++++------
>  2 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c index
> 520540a..4cc8763 100644
> --- a/drivers/scsi/bfa/bfa_core.c
> +++ b/drivers/scsi/bfa/bfa_core.c
> @@ -1941,7 +1941,7 @@ bfa_get_pciids(struct bfa_pciid_s **pciids, int
> *npciids)
>  		{BFA_PCI_VENDOR_ID_BROCADE,
> BFA_PCI_DEVICE_ID_CT_FC},
>  	};
> 
> -	*npciids = sizeof(__pciids) / sizeof(__pciids[0]);
> +	*npciids = ARRAY_SIZE(__pciids);
>  	*pciids = __pciids;
>  }
> 
> diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c index
> a3ab5cc..6a00008 100644
> --- a/drivers/scsi/bfa/bfa_fcs.c
> +++ b/drivers/scsi/bfa/bfa_fcs.c
> @@ -81,7 +81,7 @@ bfa_fcs_attach(struct bfa_fcs_s *fcs, struct bfa_s *bfa,
> struct bfad_s *bfad,
>  	bfa->fcs = BFA_TRUE;
>  	fcbuild_init();
> 
> -	for (i = 0; i < sizeof(fcs_modules) / sizeof(fcs_modules[0]); i++) {
> +	for (i = 0; i < ARRAY_SIZE(fcs_modules); i++) {
>  		mod = &fcs_modules[i];
>  		if (mod->attach)
>  			mod->attach(fcs);
> @@ -97,7 +97,7 @@ bfa_fcs_init(struct bfa_fcs_s *fcs)
>  	int	i;
>  	struct bfa_fcs_mod_s  *mod;
> 
> -	for (i = 0; i < sizeof(fcs_modules) / sizeof(fcs_modules[0]); i++) {
> +	for (i = 0; i < ARRAY_SIZE(fcs_modules); i++) {
>  		mod = &fcs_modules[i];
>  		if (mod->modinit)
>  			mod->modinit(fcs);
> @@ -180,13 +180,11 @@ void
>  bfa_fcs_exit(struct bfa_fcs_s *fcs)
>  {
>  	struct bfa_fcs_mod_s  *mod;
> -	int		nmods, i;
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
> --
> 1.8.3.1
> 
> --

Thanks for the patch Chris. Changes looks good.
Acked-by: Vijaya Mohan Guvva <vmohan@brocade.com>
