From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [Patch V2 7/9] [SCSI] aacraid: Unblock IOCTLs to controller once
 system resumed from suspend
Date: Tue, 16 Jun 2015 13:41:26 +0200
Message-ID: <20150616114126.GE2883@c203.arch.suse.de>
References: <1433986951-9033-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
 <1433986951-9033-9-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37724 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbbFPLla (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Jun 2015 07:41:30 -0400
Content-Disposition: inline
In-Reply-To: <1433986951-9033-9-git-send-email-rajinikanth.pandurangan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rajinikanth.pandurangan@pmcs.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, aacraid@pmc-sierra.com, harry.yang@pmcs.com, mahesh.rajashekhara@pmcs.com, rich.bono@pmcs.com, achim.leubner@pmcs.com, murthy.bhat@pmcs.com

On Wed, Jun 10, 2015 at 06:42:29PM -0700, rajinikanth.pandurangan@pmcs.=
com wrote:
> From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
>=20
> Description:
> 	Driver blocks ioctls once it received shutdown/suspend request durin=
g
> 	suspend/hybernation. This patch unblocks ioctls on resume path.
>=20
> Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.=
com>
> ---
>  drivers/scsi/aacraid/linit.c | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/lini=
t.c
> index 8020348..1142c28 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -1448,6 +1448,11 @@ static int aac_resume(struct pci_dev *pdev)
>  	pci_set_master(pdev);
>  	if (aac_acquire_resources(aac))
>  		goto fail_device;
> +	/*
> +	* reset this flag to unblock ioctl() as it was set at
> +	* aac_send_shutdown() to block ioctls from upperlayer
> +	*/
> +	aac->adapter_shutdown =3D 0;
>  	scsi_unblock_requests(shost);
> =20
>  	return 0;
> --=20
> 1.9.3
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                       Storage
jthumshirn@suse.de                             +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
