From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 8/8] pm80xx: avoid a panic if MSI(X) interrupts are
 disabled
Date: Mon, 2 Nov 2015 09:01:29 +0100
Message-ID: <56371859.7000707@suse.de>
References: <1446216811-2248-1-git-send-email-brood@attotech.com>
 <1446216811-2248-9-git-send-email-brood@attotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbbKBIBb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Nov 2015 03:01:31 -0500
In-Reply-To: <1446216811-2248-9-git-send-email-brood@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Rood <benjaminjrood@gmail.com>, linux-scsi@vger.kernel.org, xjtuwjp@gmail.com, James.Bottomley@HansenPartnership.com
Cc: Benjamin Rood <brood@attotech.com>

On 10/30/2015 03:53 PM, Benjamin Rood wrote:
> If MSI(X) interrupts are disabled via the kernel command line
> (pci=3Dnomsi), the pm8001 driver will kernel panic because it does no=
t
> detect that MSI interrupts are disabled and will soldier on and attem=
pt to
> configure MSI interrupts anyways.  This leads to a kernel panic, most
> likely because a required data structure is not available down the
> line.  Using the pci_msi_enabled() function in order to detect if MSI
> interrupts are enabled before configuring them resolves this issue an=
d
> avoids a kernel panic when the module is loaded.  Additionally, the
> irq_vector structure must be initialized when legacy interrupts are
> being used otherwise legacy interrupts will simply not function and
> result in another panic.
>=20
> Signed-off-by: Benjamin Rood <brood@attotech.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
