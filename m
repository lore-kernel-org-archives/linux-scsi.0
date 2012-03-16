From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [isci PATCH v3 3/4] libsas: suspend / resume support
Date: Fri, 16 Mar 2012 17:18:50 +0800
Message-ID: <F0261F814D3E413599630A3442934059@usish.com.cn>
References: <CABE8wwvmCnVEhW8yKVua9Zt+jPCK6kzyjm7poE_7D4ihDhZrHg@mail.gmail.com><Pine.LNX.4.44L0.1203151544450.1366-100000@iolanthe.rowland.org> <CABE8wwuuM8XoTUy_+1nXMt9WvieWgmt-NHS=ybN_ndOdwk+gjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CABE8wwuuM8XoTUy_+1nXMt9WvieWgmt-NHS=ybN_ndOdwk+gjQ@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: "'Williams, Dan J'" <dan.j.williams@intel.com>, 'Alan Stern' <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, 'Jacek Danecki' <jacek.danecki@intel.com>, 'lindar_liu' <lindar_liu@usish.com>, =?UTF-8?B?J+S6jueIseWNjic=?= <crystal_yu@usish.com>
List-Id: linux-scsi@vger.kernel.org

Dan,

I found problem about SATA error handle and this also led to panic when=
 run suspend/resume test. Thanks again for your share debug method and =
patch of testing suspend/resume problem.

The problem is:

When probe libata probe sata will try to reset device and send IDENTIFY=
 DEVICE.. commands when 3 times fail will give up but never tell libsas=
 and lldd to clean up the resource. And if some time later the device c=
ame up report BROADCAST CHANGE and libsas found device try to  tell lld=
d, but lldd is not forget the original one will reject this.=20
Should we export sas_unregister_devs_sas_addr let ata call this when gi=
ve up.


=46or suspend/resume here I've seen Hard LOCKUP when this kind of thing=
s happen.
Will look into the problem deeper to see the root cause.

***********************************************************************=
*

Jack Wang =E7=8E=8B=E9=87=91=E6=B5=A6 Software Engineer

RD2 (Storage)=20

Department of Storage Products R&D, SCS

Universal Scientific Industrial (Shanghai) Co., Ltd

421 Lishizhen Rd, Pudong New Area, Shanghai,=20

P.R. China, 201203

=E4=B8=8A=E6=B5=B7=E5=B8=82=E6=B5=A6=E4=B8=9C=E6=96=B0=E5=8C=BA=E6=9D=8E=
=E6=97=B6=E7=8F=8D=E8=B7=AF421=E5=8F=B7    =E9=82=AE=E7=BC=96: 201203

Tel :  +86 -21-5896 6996  ext. 81526

=46ax : +86 -21-5080 4268

http://www.usi.com.tw  MAIL: jack_wang@usish.com

***********************************************************************=
*

=20
> -----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
> =E5=8F=91=E4=BB=B6=E4=BA=BA: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org] =E4=BB=A3=E8=A1=A8 Williams=
, Dan J
> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2012=E5=B9=B43=E6=9C=8816=E6=97=
=A5 6:16
> =E6=94=B6=E4=BB=B6=E4=BA=BA: Alan Stern
> =E6=8A=84=E9=80=81: linux-scsi@vger.kernel.org; linux-ide@vger.kernel=
=2Eorg; Jacek Danecki
> =E4=B8=BB=E9=A2=98: Re: [isci PATCH v3 3/4] libsas: suspend / resume =
support
>=20
> On Thu, Mar 15, 2012 at 12:54 PM, Alan Stern <stern@rowland.harvard.e=
du> wrote:
> > On Thu, 15 Mar 2012, Williams, Dan J wrote:
> >
> >> > Hmm... I was wondering why we needed a kernel global sync.  If t=
his is
> >> > just for probe work what about just doing something like the fol=
lowing?
> >> > Keep the sync operation local to probe-work and not entangle wit=
h the
> >> > resume-work?  I'll give this a shot when I get back to my test s=
ystem.
> >> >
> >> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> >> > index bd17cf8..ec69e35 100644
> >> > --- a/drivers/scsi/sd.c
> >> > +++ b/drivers/scsi/sd.c
> >> > @@ -2629,6 +2629,8 @@ static void sd_probe_async(void *data,
> async_cookie_t cookie)
> >> >        put_device(&sdkp->dev);
> >> >  }
> >> >
> >> > +static LIST_HEAD(sd_probe_domain);
> >
> > Take a look at fea6d607e154cf96ab22254ccb48addfd43d4cb5; it might b=
e a
> > good idea to make this domain available to scsi_bus_prepare().  For
> > example, it could made into a SCSI-wide domain, defined in the SCSI
> > core and exported for use by sd.
>=20
> Nice, thanks for the pointer.  Yes, I'll up-level this.
>=20
> >
> >> This works fine for me for resolving the deadlock, but I found I a=
lso
> >> needed the following to fix a spurious:
> >>
> >>    scsi 6:0:1:0: Illegal state transition deleted->running
> >>
> >> ...in the resume path.
> >>
> >> @@ -2348,10 +2349,11 @@ EXPORT_SYMBOL(scsi_device_quiesce);
> >>   *
> >>   *     Must be called with user context, may sleep.
> >>   */
> >> -void
> >> -scsi_device_resume(struct scsi_device *sdev)
> >> +void scsi_device_resume(struct scsi_device *sdev)
> >>  {
> >> -       if(scsi_device_set_state(sdev, SDEV_RUNNING))
> >> +       /* check if the device was deleted during suspend */
> >> +       if (sdev->sdev_state =3D=3D SDEV_DEL ||
> >> +           scsi_device_set_state(sdev, SDEV_RUNNING))
> >>                 return;
> >>         scsi_run_queue(sdev->request_queue);
> >>  }
> >>
> >> Unless someone can point out something I'm missing I'll go ahead a=
nd
> >> roll this into it's own patch and rebase/drop the hack out of the
> >> libsas resume code.
> >
> > The device might be in some other state.  Perhaps it would be bette=
r to
> > do
> >
> >        if (sdev->sdev_state !=3D SDEV_QUIESCE ||
> >                        scsi_device_set_state(sdev, SDEV_RUNNING))
> >
> > I'm not sure what guarantees this function is supposed to provide, =
but
> > the comment indicates that it's meant just to handle quiesced devic=
es.
> >
>=20
> I'm not sure either, but I can get on board with this change to say
> "the world changed when you weren't looking, assume whomever changed
> the state is taking care of the device".
>=20
> --
> Dan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

