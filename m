From: Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: [PATCH v1.3 11/11] arcmsr: Adding support Areca
 ARC1214/1224/1264/1284 SATA 6Gb raid controllers
Date: Fri, 21 Feb 2014 23:09:53 +0100
Message-ID: <20140221220953.GA14729@electric-eye.fr.zoreil.com>
References: <CAKiknE-7TOGtN01xsXyay2gv69ruVvAEq22ozu=vTzh_R=SxuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKiknE-7TOGtN01xsXyay2gv69ruVvAEq22ozu=vTzh_R=SxuQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?utf-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>, fengguang.wu@intel.com, Tomas Henzl <thenzl@redhat.com>, =?utf-8?B?5ZCz56Kn5ra8?= <billion.wu@areca.com.tw>
List-Id: linux-scsi@vger.kernel.org

=E9=BB=83=E6=B8=85=E9=9A=86 <ching2048@areca.com.tw> :
[...]
> diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/a=
rcmsr_hba.c
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c  2014-02-20 19:11:05.000000000=
 +0800
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c  2014-02-21 01:47:26.000000000=
 +0800
[...]
> @@ -2894,6 +3372,89 @@ polling_hbc_ccb_retry:
>  }
>=20
>  static int
> +arcmsr_hbaD_polling_ccbdone(struct AdapterControlBlock *acb,
> +                               struct CommandControlBlock *poll_ccb)
> +{
> +       bool error;
> +       uint32_t poll_ccb_done =3D 0, poll_count =3D 0, flag_ccb, ccb=
_cdb_phy;
> +       int rtn, doneq_index, index_stripped, outbound_write_pointer;
> +       unsigned long flags;
> +       struct ARCMSR_CDB *arcmsr_cdb;
> +       struct CommandControlBlock *pCCB;
> +       struct MessageUnit_D *pmu =3D acb->pmuD;
> +
> +       spin_lock_irqsave(&acb->doneq_lock, flags);
> +polling_hbaD_ccb_retry:
> +       poll_count++;
> +       while (1) {
> +               outbound_write_pointer =3D pmu->done_qbuffer[0].addre=
ssLow + 1;
> +               doneq_index =3D pmu->doneq_index;
> +               if ((outbound_write_pointer & 0xFFF) =3D=3D (doneq_in=
dex & 0xFFF)) {
> +                       if (poll_ccb_done) {
> +                               rtn =3D SUCCESS;
> +                               break;
> +                       } else {
> +                               msleep(25);

msleep with spinlock held.

--=20
Ueimor
