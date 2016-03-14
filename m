From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/3] megaraid_sas: add missing curly braces in ioctl
 handler
Date: Mon, 14 Mar 2016 16:20:29 +0100
Message-ID: <56E6D6BD.4020805@suse.de>
References: <1457965789-3373916-1-git-send-email-arnd@arndb.de>
 <1457965789-3373916-4-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37880 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934381AbcCNPUb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2016 11:20:31 -0400
In-Reply-To: <1457965789-3373916-4-git-send-email-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tomas Henzl <thenzl@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, megaraidlinux.pdl@avagotech.com

On 03/14/2016 03:29 PM, Arnd Bergmann wrote:
> gcc-6 found a dubious indentation in the megasas_mgmt_fw_ioctl
> function:
>=20
> drivers/scsi/megaraid/megaraid_sas_base.c: In function 'megasas_mgmt_=
fw_ioctl':
> drivers/scsi/megaraid/megaraid_sas_base.c:6658:4: warning: statement =
is indented as if it were guarded by... [-Wmisleading-indentation]
>     kbuff_arr[i] =3D NULL;
>     ^~~~~~~~~
> drivers/scsi/megaraid/megaraid_sas_base.c:6653:3: note: ...this 'if' =
clause, but it is not
>    if (kbuff_arr[i])
>    ^~
>=20
> The code is actually correct, as there is no downside in clearing a N=
ULL
> pointer again.
>=20
> This clarifies the code and avoids the warning by adding extra curly
> braces.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 90dc9d98f01b ("megaraid_sas : MFI MPT linked list corruption f=
ix")
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi=
/megaraid/megaraid_sas_base.c
> index 5c08568ccfbf..2627200d4f82 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -6650,12 +6650,13 @@ out:
>  	}
> =20
>  	for (i =3D 0; i < ioc->sge_count; i++) {
> -		if (kbuff_arr[i])
> +		if (kbuff_arr[i]) {
>  			dma_free_coherent(&instance->pdev->dev,
>  					  le32_to_cpu(kern_sge32[i].length),
>  					  kbuff_arr[i],
>  					  le32_to_cpu(kern_sge32[i].phys_addr));
>  			kbuff_arr[i] =3D NULL;
> +		}
>  	}
> =20
>  	megasas_return_cmd(instance, cmd);
>=20
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
