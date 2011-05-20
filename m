From: Rolf Eike Beer <eike@sf-mail.de>
Subject: Re: [PATCH]: be2iscsi: Fix MSIX interrupt names
Date: Fri, 20 May 2011 22:17:30 +0200
Message-ID: <2030549.qtzsKLDxZd@donald.sf-tec.de>
References: <4DD6AEB7.2090900@redhat.com> <50725EF61B96174EB1803401F1A2E37335099FC989@EXMAIL.ad.emulex.com> <4DD6B83B.5000703@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5957450.Po198Dm8QF"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:53462 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935756Ab1ETURu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 May 2011 16:17:50 -0400
In-Reply-To: <4DD6B83B.5000703@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Prarit Bhargava <prarit@redhat.com>
Cc: Jayamohan.Kallickal@emulex.com, linux-scsi@vger.kernel.org, mchristi@redhat.com


--nextPart5957450.Po198Dm8QF
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"

Prarit Bhargava wrote:
> On 05/20/2011 02:33 PM, Jayamohan.Kallickal@Emulex.Com wrote:
> > Thanks for the patch. Pl see my comments in line
> 
> np.
> 
> > diff --git a/drivers/scsi/be2iscsi/be_main.c
> > b/drivers/scsi/be2iscsi/be_main.c index 24e20ba..8d71e47 100644
> > --- a/drivers/scsi/be2iscsi/be_main.c
> > +++ b/drivers/scsi/be2iscsi/be_main.c
> > @@ -874,16 +874,20 @@ static int beiscsi_init_irqs(struct beiscsi_hba
> > *phba)
> > 
> >  	struct hwi_controller *phwi_ctrlr;
> >  	struct hwi_context_memory *phwi_context;
> >  	int ret, msix_vec, i, j;
> > 
> > -	char desc[32];
> > 
> >  	phwi_ctrlr = phba->phwi_ctrlr;
> >  	phwi_context = phwi_ctrlr->phwi_ctxt;
> >  	
> >  	if (phba->msix_enabled) {
> >  	
> >  		for (i = 0; i < phba->num_cpus; i++) {
> > 
> > -			sprintf(desc, "beiscsi_msix_%04x", i);
> > +			phba->msi_name[i] = kzalloc(BEISCSI_MSI_NAME,
> > +						    GFP_KERNEL);
> > +			if (!phba->msi_name[i])
> > +				goto free_msix_irqs;
> > We need to ensure i != 0 before jumping to free_msix_irqs
> 
> Will fix in next version ... I think I may have to do a bit more work
> here because I just realized that if we free_irq() on a non-allocated
> irq we'll get an angry message from the kernel ;)  Unfortunately this
> may complicate the code.... I'll rework this and see if I can come up
> with something better.

This could be simpler if you would use devres and devm_kzalloc() and 
devm_request_irq(). You simply need to return with error then and the driver 
core would free everything you already allocated.

Eike
--nextPart5957450.Po198Dm8QF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAk3WzGcACgkQXKSJPmm5/E5CfACggkOeo+y2dtRWjn+QnUWnfyrj
0iQAoKEyVx76/qH/L+hmeUVmAwjtsq01
=Q3Pz
-----END PGP SIGNATURE-----

--nextPart5957450.Po198Dm8QF--

