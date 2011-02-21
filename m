From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/15] megaraid_sas: Fix probe_one to clear MSI-X flags
 in kdump
Date: Mon, 21 Feb 2011 09:04:19 +0100
Message-ID: <4D621C83.1090707@suse.de>
References: <AANLkTinMo1nnUhiYi=Rfnnts9zqqSf_UuaYUt_gyJW3B@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:48508 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516Ab1BUHzK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Feb 2011 02:55:10 -0500
In-Reply-To: <AANLkTinMo1nnUhiYi=Rfnnts9zqqSf_UuaYUt_gyJW3B@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

On 02/20/2011 03:22 AM, adam radford wrote:
> James/Linux-scsi,
>=20
> The following patch for megaraid_sas fixes megasas_probe_one() to
> clear MSI-X flags in kdump when the 'reset_devices' kernel parameter
> is passed in.
>=20
This is actually the one bit where I'm quite puzzled by.
Problem here is the pci_enable_msix() actually fails when MSI-X is
already enabled. Which is odd, given that MSI-X _is_ enabled
already, so taken at face value pci_enable_msix() shouldn't fail here.

I know that there are several stages to the MSI-X initialisation, so
this is the safe route here. But I also have seen _LOTS_ of failures
with kdump and raid HBAs, most of which point to the same problem here.

Can't we put in a 'force' parameter to pci_enable_msix() to avoid
having to code this one in each and every driver?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
