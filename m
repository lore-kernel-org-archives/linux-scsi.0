From: David C Somayajulu <david.somayajulu@qlogic.com>
Subject: Re: [PATCH] qla4xxx: allow hba to be online when initiator
	ip	address is uninitialized
Date: Thu, 14 Jun 2007 10:27:13 -0700
Message-ID: <1181842033.3423.3.camel@q-iscsi-upstream.site>
References: <1181348961.8711.4.camel@q-iscsi-upstream.site>
	 <1181349436.8711.8.camel@q-iscsi-upstream.site>
	 <4670D80C.2090708@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:58738 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbXFNR16 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jun 2007 13:27:58 -0400
In-Reply-To: <4670D80C.2090708@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, David Wagner <david.wagner@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>

On Thu, 2007-06-14 at 01:54 -0400, Mike Christie wrote:
> David C Somayajulu wrote:
> > On Fri, 2007-06-08 at 17:29 -0700, David C Somayajulu wrote:
> >> This patch provides the following:
> >> 1. remove warning ignoring the return value of pci_set_mwi()
> >> 2. allows HBA to be online when the initiator ip address is uninit=
ialized.
> > Including=20
> >=20
> > Signed-off-by: David Somayajulu <david.somayajulu@qlogic.com>
> >=20
> >  drivers/scsi/qla4xxx/ql4_init.c |   23 +++++++++++------------
> >  1 files changed, 11 insertions(+), 12 deletions(-)
> >=20
> > diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx=
/ql4_init.c
> > index d8c064c..1e29f51 100644
> > --- a/drivers/scsi/qla4xxx/ql4_init.c
> > +++ b/drivers/scsi/qla4xxx/ql4_init.c
> > @@ -883,11 +883,12 @@ static int qla4xxx_config_nvram(struct s
> >  static void qla4x00_pci_config(struct scsi_qla_host *ha)
> >  {
> >  	uint16_t w;
> > +	int status;
> > =20
> >  	dev_info(&ha->pdev->dev, "Configuring PCI space...\n");
> > =20
> >  	pci_set_master(ha->pdev);
> > -	pci_set_mwi(ha->pdev);
> > +	status =3D pci_set_mwi(ha->pdev);
>=20
>=20
> It looks ok, but creating the status variable and setting it like thi=
s,
> just to quiet the compile warning, and never doing anything else with=
 it
> doesn't seem nice.
I don't like it either. I tried with=20
(void)pci_set_mwi(ha->pdev);=20
and this is what I see

  CC [M]  drivers/scsi/qla4xxx/ql4_init.o
drivers/scsi/qla4xxx/ql4_init.c: In function =E2=80=98qla4x00_pci_confi=
g=E2=80=99:
drivers/scsi/qla4xxx/ql4_init.c:890: warning: ignoring return value of =
=E2=80=98pci_set_mwi=E2=80=99, declared with attribute warn_unused_resu=
lt
  LD [M]  drivers/scsi/qla4xxx/qla4xxx.o


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
