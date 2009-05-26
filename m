From: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH -tip][SCSI] scsi: scsi_transport_iscsi.c initialize the
 variable before it get used
Date: Tue, 26 May 2009 21:30:05 +0530
Message-ID: <1243353605.31783.25.camel@localhost.localdomain>
References: <1243351161.31783.5.camel@localhost.localdomain>
	 <1243351709.2815.33.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:48609 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770AbZEZQAV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 May 2009 12:00:21 -0400
In-Reply-To: <1243351709.2815.33.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>

Hello James,

On Tue, 2009-05-26 at 10:28 -0500, James Bottomley wrote:
> On Tue, 2009-05-26 at 20:49 +0530, Jaswinder Singh Rajput wrote:
> > I am watching this problem from long time in -tip.
> >=20
> > Subject: [PATCH] scsi: scsi_transport_iscsi.c initialize the variab=
le before it get used
> >=20
> > In some cases, err will be used uninitialized.
>=20
> What cases?  A simple theoretical analysis shows that this variable i=
s
> always set.
>=20

Ok lets takes your tree:

http://git.kernel.org/?p=3Dlinux/kernel/git/jejb/scsi-misc-2.6.git;a=3D=
blob;f=3Ddrivers/scsi/scsi_transport_iscsi.c;hb=3D10eb0f013c63c71c82ede=
77945a5f390c10cfda6


672 int iscsi_add_session(struct iscsi_cls_session *session, unsigned i=
nt target_id)
673 {
674         struct Scsi_Host *shost =3D iscsi_session_to_shost(session)=
;
675         struct iscsi_cls_host *ihost;
676         unsigned long flags;
677         unsigned int id =3D target_id;
678         int err;
679
680         ihost =3D shost->shost_data;
681         session->sid =3D atomic_add_return(1, &iscsi_session_nr);
682
683         if (id =3D=3D ISCSI_MAX_TARGET) {
684                 for (id =3D 0; id < ISCSI_MAX_TARGET; id++) {
685                         err =3D device_for_each_child(&shost->shost=
_gendev, &id,
686                                                     iscsi_get_next_=
target_id);
687                         if (!err)
688                                 break;
689                 }
690
691                 if (id =3D=3D ISCSI_MAX_TARGET) {
692                         iscsi_cls_session_printk(KERN_ERR, session,
693                                                  "Too many iscsi ta=
rgets. Max "
694                                                  "number of targets=
 is %d.\n",
695                                                  ISCSI_MAX_TARGET -=
 1);
696                         goto release_host;
697                 }
698         }
699         session->target_id =3D id;
700
701         dev_set_name(&session->dev, "session%u", session->sid);
702         err =3D device_add(&session->dev);
703         if (err) {
704                 iscsi_cls_session_printk(KERN_ERR, session,
705                                          "could not register sessio=
n's dev\n");
706                 goto release_host;
707         }
708         transport_register_device(&session->dev);
709
710         spin_lock_irqsave(&sesslock, flags);
711         list_add(&session->sess_list, &sesslist);
712         spin_unlock_irqrestore(&sesslock, flags);
713
714         iscsi_session_event(session, ISCSI_KEVENT_CREATE_SESSION);
715         return 0;
716
717 release_host:
718         scsi_host_put(shost);
719         return err;
720 }

You are right but compiler is confused and giving warning like this :

1. do not go inside :
684                 for (id =3D 0; id < ISCSI_MAX_TARGET; id++) {

2. and then choose path :
696                         goto release_host;

then we return err uninitialized ;-)

> >  CC      drivers/scsi/scsi_transport_iscsi.o
> > drivers/scsi/scsi_transport_iscsi.c: In function =E2=80=98iscsi_add=
_session=E2=80=99:
> > drivers/scsi/scsi_transport_iscsi.c:678: warning: =E2=80=98err=E2=80=
=99 may be used
> > uninitialized in this function
>=20
> My version of gcc (4.3.3) correctly sees that the variable cannot be
> uninitialised ... what version are you using?
>=20
> If it's a popular version, we can always do the uninitialised_var()
> thing, but if it's just a non-standard compiler, I'd rather not mess =
up
> the source code to please gcc.
>=20

gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC)=20

--
JSR

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
