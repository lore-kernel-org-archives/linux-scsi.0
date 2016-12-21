From: "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>
Subject: Re: [PATCH] snic: Return error code on memory allocation failure
Date: Wed, 21 Dec 2016 15:07:33 +0000
Message-ID: <D4809831.79AA7%nmusini@cisco.com>
References: <1482327953-4140-1-git-send-email-burak-kernel@bur0k.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1482327953-4140-1-git-send-email-burak-kernel@bur0k.de>
Content-Language: en-US
Content-ID: <E32A1F419932EB42B82787BFCBD70DFB@emea.cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Burak Ok <burak-kernel@bur0k.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Martin K Petersen <martin.petersen@oracle.com>, James E J Bottomley <jejb@linux.vnet.ibm.com>, "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>, "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>, "linux-kernel@i4.cs.fau.de" <linux-kernel@i4.cs.fau.de>, Andreas Schaertl <andreas.schaertl@fau.de>
List-Id: linux-scsi@vger.kernel.org


On 21/12/16 7:15 pm, "Burak Ok" <burak-kernel@bur0k.de> wrote:

>If a call to mempool_create_slab_pool() in snic_probe() returns NULL,
>return -ENOMEM to indicate failure. mempool_creat_slab_pool() only fails
>if
>it cannot allocate memory.
>
>https://bugzilla.kernel.org/show_bug.cgi?id=3D189061
>
>Reported-by: bianpan2010@ruc.edu.cn
>Signed-off-by: Burak Ok <burak-kernel@bur0k.de>
>Signed-off-by: Andreas Schaertl <andreas.schaertl@fau.de>
Acked-by: Narsimhulu Musini <nmusini@cisco.com>
>---
> drivers/scsi/snic/snic_main.c | 3 +++
> 1 file changed, 3 insertions(+)
>
>diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
>index 396b32d..7cf70aa 100644
>--- a/drivers/scsi/snic/snic_main.c
>+++ b/drivers/scsi/snic/snic_main.c
>@@ -591,6 +591,7 @@ snic_probe(struct pci_dev *pdev, const struct
>pci_device_id *ent)
> 	if (!pool) {
> 		SNIC_HOST_ERR(shost, "dflt sgl pool creation failed\n");
>=20
>+		ret =3D -ENOMEM;
> 		goto err_free_res;
> 	}
>=20
>@@ -601,6 +602,7 @@ snic_probe(struct pci_dev *pdev, const struct
>pci_device_id *ent)
> 	if (!pool) {
> 		SNIC_HOST_ERR(shost, "max sgl pool creation failed\n");
>=20
>+		ret =3D -ENOMEM;
> 		goto err_free_dflt_sgl_pool;
> 	}
>=20
>@@ -611,6 +613,7 @@ snic_probe(struct pci_dev *pdev, const struct
>pci_device_id *ent)
> 	if (!pool) {
> 		SNIC_HOST_ERR(shost, "snic tmreq info pool creation failed.\n");
>=20
>+		ret =3D -ENOMEM;
> 		goto err_free_max_sgl_pool;
> 	}
>=20
>--=20
>2.7.4
>
