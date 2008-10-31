From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: i/o error due to all path failure with rdac
Date: Fri, 31 Oct 2008 10:05:29 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF45BD9D2E2@cosmail01.lsi.com>
References: <49022078.6010700@datadirectnet.com>
	<E463DF2B2E584B4A82673F53D62C2EF45BD3B893@cosmail01.lsi.com>
	<20081030173453.GB23948@linux.vnet.ibm.com>
	<E463DF2B2E584B4A82673F53D62C2EF45BD9D049@cosmail01.lsi.com>
	<1225396981.14830.990.camel@chandra-ubuntu>
	<E463DF2B2E584B4A82673F53D62C2EF45BD9D0AD@cosmail01.lsi.com>
	<1225405417.14830.1001.camel@chandra-ubuntu>
	<E463DF2B2E584B4A82673F53D62C2EF45BD9D16B@cosmail01.lsi.com>
	<1225409729.14830.1005.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1225409729.14830.1005.camel@chandra-ubuntu>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "sekharan@us.ibm.com" <sekharan@us.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Yes, It is working fine with this patch. Now my online/offline test is ru=
nning fine. Thank you very much. That was really a quick fix.

I am still learning the device mapper. Hopefully I will be some help in t=
he future.

Thanks
Babu Moger

-----Original Message-----
From: Chandra Seetharaman [mailto:sekharan@us.ibm.com]
Sent: Thursday, October 30, 2008 6:35 PM
To: Moger, Babu
Cc: device-mapper development; linux-scsi@vger.kernel.org
Subject: RE: [dm-devel] i/o error due to all path failure with rdac

Can you try this patch.
---------
Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

Index: linux-2.6.27/drivers/scsi/device_handler/scsi_dh_rdac.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.27.orig/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ linux-2.6.27/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -386,6 +386,7 @@ static int check_ownership(struct scsi_d
        struct c9_inquiry *inqp;

        h->lun_state =3D RDAC_LUN_UNOWNED;
+       h->state =3D RDAC_STATE_ACTIVE;
        err =3D submit_inquiry(sdev, 0xC9, sizeof(struct c9_inquiry), h);
        if (err =3D=3D SCSI_DH_OK) {
                inqp =3D &h->inq.c9;
---

On Thu, 2008-10-30 at 17:21 -0600, Moger, Babu wrote:
> Looks like eventually we get rport failure after the controller offline=
.
>
>
> I have attached the messages file.  I am running raw IO.
>
> Also, please note that I have added following lines in check_sense. Thi=
s condition (quiescence) should be retried.
>
>
> case UNIT_ATTENTION:
>                 if ((sense_hdr->asc =3D=3D 0x29 && sense_hdr->ascq =3D=3D=
 0x00) ||
>                     (sense_hdr->asc =3D=3D 0x8b && sense_hdr->ascq =3D=3D=
 0x02))
>                         /*
>                          * Power On, Reset, or Bus Device Reset, just r=
etry.
>                          */
>                         return ADD_TO_MLQUEUE;
>
>
>
> Thanks
> Babu Moger
>
