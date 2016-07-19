From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/2] lpfc: call lpfc_sli_validate_fcp_iocb() with the
 hbalock held
Date: Tue, 19 Jul 2016 09:43:12 +0200
Message-ID: <20160719074312.2hg6lyblrjnioyul@c203.arch.suse.de>
References: <1468850763-72179-1-git-send-email-jthumshirn@suse.de>
 <1095600204.5575668.1468873737267.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51968 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477AbcGSHnd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jul 2016 03:43:33 -0400
Content-Disposition: inline
In-Reply-To: <1095600204.5575668.1468873737267.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>

On Mon, Jul 18, 2016 at 04:28:57PM -0400, Laurence Oberman wrote:
>=20
>=20
> ----- Original Message -----
> > From: "Johannes Thumshirn" <jthumshirn@suse.de>
> > To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James Bott=
omley" <jejb@linux.vnet.ibm.com>, "James Smart"
> > <james.smart@avagotech.com>, "Dick Kennedy" <dick.kennedy@avagotech=
=2Ecom>
> > Cc: "Linux SCSI Mailinglist" <linux-scsi@vger.kernel.org>, "Johanne=
s Thumshirn" <jthumshirn@suse.de>
> > Sent: Monday, July 18, 2016 10:06:03 AM
> > Subject: [PATCH 1/2] lpfc: call lpfc_sli_validate_fcp_iocb() with t=
he hbalock held
> >=20
> > Call lpfc_sli_validate_fcp_iocb() with the hbalock held, as the poi=
nter to
> > iocbq is not guaranteed to still be valid after looking it up.
> >=20
> > Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> > ---
> >  drivers/scsi/lpfc/lpfc_sli.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >=20
> > diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_=
sli.c
> > index 1a248a2..d58ec4c 100644
> > --- a/drivers/scsi/lpfc/lpfc_sli.c
> > +++ b/drivers/scsi/lpfc/lpfc_sli.c
> > @@ -9978,6 +9978,7 @@ lpfc_sli_sum_iocb(struct lpfc_vport *vport, u=
int16_t
> > tgt_id, uint64_t lun_id,
> >  	struct lpfc_iocbq *iocbq;
> >  	int sum, i;
> > =20
> > +	spin_lock_irq(&phba->hbalock);
> >  	for (i =3D 1, sum =3D 0; i <=3D phba->sli.last_iotag; i++) {
> >  		iocbq =3D phba->sli.iocbq_lookup[i];
> > =20
> > @@ -9985,6 +9986,7 @@ lpfc_sli_sum_iocb(struct lpfc_vport *vport, u=
int16_t
> > tgt_id, uint64_t lun_id,
> >  						ctx_cmd) =3D=3D 0)
> >  			sum++;
> >  	}
> > +	spin_unlock_irq(&phba->hbalock);
> > =20
> >  	return sum;
> >  }
> > --
> > 1.8.5.6
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scs=
i" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20
> Hi Johannes
>=20
> The code looks correct, but I would get a review from James Smart or =
Dick Kennedy at Emulex (now Broadcom :))

Sure, that's why they're on Cc ;-).

> Have you experienced an issue already due to this, can you share the =
stack trace of the issue if you have it.

We have had an issue at a customer's side. It's actually pretty hard to
trigger (it involves two separated SANs and several FC switches in betw=
een and
link bounces) but the core dumps show that in lpfc_sli_validate_fcp_ioc=
b() the
iocbq address in invalid. It actually _is_ a valid kernel pointer and _=
was_ a
valid 'struct lpfc_iocbq' but isn't anymore. So we suggest a use-after-=
free.
This patch is running OK withing one of our partner's QA sites for 3 we=
eks now
(we've been chasing it since October).

c.f this part of our partner's analysis:
crash> bt
PID: 62174  TASK: ffff880285fe40c0  CPU: 0   COMMAND: "kworker/0:1"
 #0 [ffff88027dfb7bc0] crash_kexec at ffffffff8008e4ca
 #1 [ffff88027dfb7c90] oops_end at ffffffff804129a8
 #2 [ffff88027dfb7cb0] general_protection at ffffffff80411d28
    [exception RIP: lpfc_sli_validate_fcp_iocb+148]
    RIP: ffffffffa0683114  RSP: ffff88027dfb7d60  RFLAGS: 00010246
    RAX: 2e362e322f6e6f68  RBX: 0000000000000000  RCX: 0000000000000000
    RDX: 0000000000000000  RSI: ffff8803c2417678  RDI: ffff88027d5a1a70
    RBP: ffff8803d8c28000   R8: 0000000000000001   R9: 0000000000000000
    R10: ffffffffa06f7898  R11: 0000000000000000  R12: 0000000000001340
    R13: ffff8803c2ac2000  R14: ffff8803c2417678  R15: 0000000000000000
    ORIG_RAX: ffffffffffffffff  CS: e030  SS: e02b
 #3 [ffff88027dfb7d68] lpfc_sli_abort_iocb at ffffffffa06831bb [lpfc]
 #4 [ffff88027dfb7dc8] fc_terminate_rport_io at ffffffffa0502aea [scsi_=
transport_fc]
 #5 [ffff88027dfb7de8] fc_timeout_deleted_rport at ffffffffa050338c [sc=
si_transport_fc]
 #6 [ffff88027dfb7e28] process_one_work at ffffffff80062ea8
 #7 [ffff88027dfb7e78] worker_thread at ffffffff800668aa
 #8 [ffff88027dfb7ee8] kthread at ffffffff8006a506
 #9 [ffff88027dfb7f48] kernel_thread_helper at ffffffff8041a244


crash> dis lpfc_sli_validate_fcp_iocb
=2E..
0xffffffffa068310f <lpfc_sli_validate_fcp_iocb+143>:    nop
0xffffffffa0683110 <lpfc_sli_validate_fcp_iocb+144>:    mov    -0x58(%r=
di),%rax
0xffffffffa0683114 <lpfc_sli_validate_fcp_iocb+148>:    mov    (%rax),%=
rax
0xffffffffa0683117 <lpfc_sli_validate_fcp_iocb+151>:    test   %rax,%ra=
x
=2E..

%RDI - 0x58  =3D=3D 0xFFFF88027D5A1A18

crash>  rd 0xFFFF88027D5A1A18 20
ffff88027d5a1a18:  2e362e322f6e6f68 32356266650a0d39   hon/2.6.9..efb52
ffff88027d5a1a28:  2f6563697665642f 2f302f7375623278   /device/x2bus/0/
ffff88027d5a1a38:  00646e656b636162 ffff88027aaa0000   backend....z....
ffff88027d5a1a48:  0000002143ee2000 ffff88027aaa1f40   . .C!...@..z....

>=20
> Reviewed-by Laurence Oberman <loberman@redhat.com>

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
