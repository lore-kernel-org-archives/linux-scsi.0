From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFT][PATCH] aic79xx: remove busyq
Date: Mon, 13 Jun 2005 15:56:25 +0200
Message-ID: <42AD9089.5080006@suse.de>
References: <20050529074620.GA26151@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:2779 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S261575AbVFMN40 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jun 2005 09:56:26 -0400
In-Reply-To: <20050529074620.GA26151@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Can anyone with aic79xx hardware give me a simple "it works"
> or "this breaks things" answer, for the patch below?
>=20
> This changes the aic79xx driver to use the standard Linux SCSI queuei=
ng
> code, rather than its own.  After applying this patch, NO behavior
> changes should be seen.
>=20
> The patch is against 2.6.12-rc5, but probably applies OK to recent 2.=
6.x
> kernels.
>=20
Hmm. Does not quite work here:

scsi0: Starting DV
scsi0 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 1.3.11
        <Adaptec 29320 Ultra320 SCSI adapter>
        aic7902: Ultra320 Wide Channel A, SCSI Id=3D7, PCI 33 or 66Mhz,
512 SCBs

In DV Thread
scsi0: Beginning Domain Validation
scsi0:A:0:0: Performing DV
scsi0:2223: Going from state 0 to state 1
scsi0:A:0:0: Sending INQ
scsi0: Timeout while doing DV command 12.

And from there all hell breaks loose.

It looks as if it simply refuses to send any commands ...
Investigating.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux AG				S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
