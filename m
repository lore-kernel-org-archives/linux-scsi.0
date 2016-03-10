From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] megaraid_sas: Don't issue kill adapter for MFI
 controllers in case of PD list DCMD failure
Date: Thu, 10 Mar 2016 14:06:14 +0100
Message-ID: <56E17146.6020404@suse.de>
References: <1457604877-5280-1-git-send-email-sumit.saxena@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41159 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbcCJNGQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Mar 2016 08:06:16 -0500
In-Reply-To: <1457604877-5280-1-git-send-email-sumit.saxena@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>, thenzl@redhat.com, jbottomley@parallels.com, martin.petersen@oracle.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com

On 03/10/2016 11:14 AM, Sumit Saxena wrote:
> There are few MFI adapters which do not support MR_DCMD_PD_LIST_QUERY=
 so
> if MFI adapters fail this DCMD, it should not be considered as FATAL =
and
> driver should not issue kill adapter and set per controller's instanc=
e
> variable- pd_list_not_supported so that same variable can be used ins=
ide
> functions- slave_alloc and slave_configure to allow firmware scan.
>=20
> Killing adapter because of DCMD failure when this DCMD is not support=
ed
> causes driver's probe getting failed. This issue got introduced becau=
se
> of below commit when MFI IO timeout handling was introduced-
>=20
> 6d40afb megaraid_sas: MFI IO timeout handling
>=20
> Killing adapter in case of this DCMD failure should be limited to Fus=
ion
> adapters only. Per controller's instance variable allow_fw_scan is re=
moved
> as pd_list_not_supported better reflect the purpose.
>=20
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h      |  2 +-
>  drivers/scsi/megaraid/megaraid_sas_base.c | 14 ++++++++++----
>  2 files changed, 11 insertions(+), 5 deletions(-)
>=20
Took you a while to figure that one out :-)
This was actually the main issue why I started with the DCMD timeout
stuff.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
