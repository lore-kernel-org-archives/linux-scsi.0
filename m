From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v4 1/2] scsi: Add intermediate STARGET_REMOVE state to scsi_target_state
Date: Wed, 13 Apr 2016 10:19:48 +0200
Message-ID: <1550969.mvAXU2aY35@c203>
References: <cover.1459848136.git.jthumshirn@suse.de> <95ae7ee32dca23bb7f3ab432046fb7016b341049.1459848136.git.jthumshirn@suse.de> <CADJHv_uHL0=ebUio3j5ysnaU9gDus+HQi4=pQznTy0B=6+NWAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CADJHv_uHL0=ebUio3j5ysnaU9gDus+HQi4=pQznTy0B=6+NWAg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Xiong Zhou <jencce.kernel@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Ewan D. Milne" <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Xiong
Sorry for the late reply

On Dienstag, 12. April 2016 21:01:53 CEST Xiong Zhou wrote:
> How about this?
>=20
> drivers/scsi/scsi_scan: mark STARGET_REMOVE state before destroy
>=20
> Signed-off-by: Xiong Zhou <jencce.kernel@gmail.com>
> ---
>  drivers/scsi/scsi_scan.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 27df7e7..21092e5 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -395,6 +395,8 @@ static void scsi_target_reap_ref_release(struct k=
ref *kref)
>   transport_remove_device(&starget->dev);
>   device_del(&starget->dev);
>   }
> +
> + starget->state =3D STARGET_REMOVE;
>   scsi_target_destroy(starget);
>  }

The only scsi_target_reap_ref_release() caller is scsi_target_reap_ref_=
put(),=20
which in turn is only called by scsi_target_reap(). scsi_target_reap()'=
s only=20
callers are scsi_remove_target()/__scsi_remove_target(), which set the=20
STARGET_REMOVE state and=20

__scsi_add_device()
scsi_get_host_dev()
__scsi_scan_target()

Which I'm currently investiganting (in parallel to reproducing the bug)=
=2E

>=20
> @@ -465,6 +467,7 @@ static struct scsi_target
> *scsi_alloc_target(struct device *parent,
>   dev_printk(KERN_ERR, dev, "target allocation failed, error %d\n", e=
rror);
>   /* don't want scsi_target_reap to do the final
>   * put because it will be under the host lock */
> + starget->state =3D STARGET_REMOVE;
>   scsi_target_destroy(starget);
>   return NULL;
>   }

Here starget->state is STARGET_CREATED and the assertion is already awa=
re of=20
this state transitoin. IOTW this /shouldn't/ be needed.


--=20
Johannes Thumshirn                                                     =
                           Storage
jthumshirn@suse.de                                                     =
        +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
