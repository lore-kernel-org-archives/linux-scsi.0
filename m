From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] ibmvscsis: Fix max transfer length
Date: Wed, 11 Jan 2017 18:57:04 +0000
Message-ID: <1484161010.2619.16.camel@sandisk.com>
References: <1484157759-61200-1-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1484157759-61200-1-git-send-email-bryantly@linux.vnet.ibm.com>
Content-Language: en-US
Content-ID: <B06AF291DC39914EAE049F9B7E0653DF@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: "bryantly@linux.vnet.ibm.com" <bryantly@linux.vnet.ibm.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-01-11 at 12:02 -0600, Bryant G. Ly wrote:
> Current code incorrectly calculates the max transfer length, since
> it is assuming a 4k page table, but ppc64 all run on 64k page tables.
>=20
> Cc: stable@vger.kernel.org
> Reported-by: Steven Royer <seroyer@linux.vnet.ibm.com>
> Tested-by: Steven Royer <seroyer@linux.vnet.ibm.com>
> Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
> ---
> =A0drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 2 +-
> =A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> index 8fb5c54..792a8bd 100644
> --- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> +++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> @@ -1443,7 +1443,7 @@ static long ibmvscsis_adapter_info(struct scsi_info
> *vscsi,
> =A0	info->mad_version =3D cpu_to_be32(MAD_VERSION_1);
> =A0	info->os_type =3D cpu_to_be32(LINUX);
> =A0	memset(&info->port_max_txu[0], 0, sizeof(info->port_max_txu));
> -	info->port_max_txu[0] =3D cpu_to_be32(128 * PAGE_SIZE);
> +	info->port_max_txu[0] =3D cpu_to_be32(16 * PAGE_SIZE);
> =A0
> =A0	dma_wmb();
> =A0	rc =3D h_copy_rdma(sizeof(*info), vscsi->dds.window[LOCAL].liobn,

Hello Bryant,

The old limit was intended to be 128 * 4 KB =3D 512 KB. The new limit is 16=
 *
64 KB =3D 1024 KB. Is that intended?

Do I understand correctly that the max_txu value is independent of the page
size? If so, have you considered to introduce a #define for the max_mtu
value that specifies max_mtu as a number instead of as a multiple of the
page size? At least in the SLES 10 SP3 ibmvscsis.c code max_mtu was not
defined as a multiple of the page size.

Thanks,

Bart.=
