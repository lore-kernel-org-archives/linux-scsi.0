From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] megaraid_sas: Don't issue kill adapter for MFI
 controllers in case of PD list DCMD failure
Date: Thu, 10 Mar 2016 11:40:57 +0100
Message-ID: <20160310104057.GE16624@c203.arch.suse.de>
References: <1457604877-5280-1-git-send-email-sumit.saxena@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57391 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935185AbcCJKlA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Mar 2016 05:41:00 -0500
Content-Disposition: inline
In-Reply-To: <1457604877-5280-1-git-send-email-sumit.saxena@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: thenzl@redhat.com, jbottomley@parallels.com, martin.petersen@oracle.com, hch@infradead.org, linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com

On Thu, Mar 10, 2016 at 02:14:37AM -0800, Sumit Saxena wrote:
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

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
