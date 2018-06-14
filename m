From: Zhouyang Jia <jiazhouyang09@gmail.com>
Subject: Re: [PATCH] scsi: xen-scsifront: add error handling for
 xenbus_printf
Date: Thu, 14 Jun 2018 16:13:21 +0800
Message-ID: <CABb2TxJCd9Q0KUeeqZ_CZ-HwmkAVoktDLxq0TrThM2rFe4jePQ@mail.gmail.com>
References: <1528774962-39173-1-git-send-email-jiazhouyang09@gmail.com>
 <alpine.LNX.2.21.1806132002180.45@nippy.intranet>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0657474434808553686=="
Return-path: <xen-devel-bounces@lists.xenproject.org>
In-Reply-To: <alpine.LNX.2.21.1806132002180.45@nippy.intranet>
List-Unsubscribe: <https://lists.xenproject.org/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xenproject.org>
List-Help: <mailto:xen-devel-request@lists.xenproject.org?subject=help>
List-Subscribe: <https://lists.xenproject.org/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xenproject.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xenproject.org>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Juergen Gross <jgross@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xen-devel@lists.xenproject.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>
List-Id: linux-scsi@vger.kernel.org

--===============0657474434808553686==
Content-Type: multipart/alternative; boundary="0000000000002de995056e95ac24"

--0000000000002de995056e95ac24
Content-Type: text/plain; charset="UTF-8"

Hi,

Sorry for the mistakes, I'll fix this in v2.

Best,
Zhouyang

2018-06-13 18:09 GMT+08:00 Finn Thain <fthain@telegraphics.com.au>:

> On Tue, 12 Jun 2018, Zhouyang Jia wrote:
>
> > When xenbus_printf fails, the lack of error-handling code may
> > cause unexpected results.
> >
> > This patch adds error-handling code after calling xenbus_printf.
> >
> > Signed-off-by: Zhouyang Jia <jiazhouyang09@gmail.com>
> > ---
> >  drivers/scsi/xen-scsifront.c | 31 ++++++++++++++++++++++++-------
> >  1 file changed, 24 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
> > index 36f59a1..3d858ac 100644
> > --- a/drivers/scsi/xen-scsifront.c
> > +++ b/drivers/scsi/xen-scsifront.c
> > @@ -654,10 +654,17 @@ static int scsifront_dev_reset_handler(struct
> scsi_cmnd *sc)
> >  static int scsifront_sdev_configure(struct scsi_device *sdev)
> >  {
> >       struct vscsifrnt_info *info = shost_priv(sdev->host);
> > +     struct xenbus_device *dev = info->dev;
> > +     int err;
> >
> > -     if (info && current == info->curr)
> > -             xenbus_printf(XBT_NIL, info->dev->nodename,
> > +     if (info && current == info->curr) {
> > +             err = xenbus_printf(XBT_NIL, info->dev->nodename,
> >                             info->dev_state_path, "%d",
> XenbusStateConnected);
>
> The existing code checks whether 'info' is NULL before dereferencing it.
> But your patch checks for NULL after dereferencing.
>
> > +             if (err) {
> > +                     dev_err(&dev->dev, "writing dev_state_path\n");
> > +                     return err;
> > +             }
> > +     }
> >
> >       return 0;
> >  }
> > @@ -665,10 +672,15 @@ static int scsifront_sdev_configure(struct
> scsi_device *sdev)
> >  static void scsifront_sdev_destroy(struct scsi_device *sdev)
> >  {
> >       struct vscsifrnt_info *info = shost_priv(sdev->host);
> > +     struct xenbus_device *dev = info->dev;
> > +     int err;
> >
> > -     if (info && current == info->curr)
> > -             xenbus_printf(XBT_NIL, info->dev->nodename,
> > +     if (info && current == info->curr) {
> > +             err = xenbus_printf(XBT_NIL, info->dev->nodename,
> >                             info->dev_state_path, "%d",
> XenbusStateClosed);
>
> Same here.
>
> > +             if (err)
> > +                     dev_err(&dev->dev, "writing dev_state_path\n");
> > +     }
> >  }
> >
> >  static struct scsi_host_template scsifront_sht = {
>
> --
>

--0000000000002de995056e95ac24
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>Sorry for the mistakes, I&#39;ll fi=
x this in v2.</div><div><br></div><div>Best,</div><div>Zhouyang</div></div>=
<div class=3D"gmail_extra"><br><div class=3D"gmail_quote">2018-06-13 18:09 =
GMT+08:00 Finn Thain <span dir=3D"ltr">&lt;<a href=3D"mailto:fthain@telegra=
phics.com.au" target=3D"_blank">fthain@telegraphics.com.au</a>&gt;</span>:<=
br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left=
:1px #ccc solid;padding-left:1ex"><span class=3D"">On Tue, 12 Jun 2018, Zho=
uyang Jia wrote:<br>
<br>
&gt; When xenbus_printf fails, the lack of error-handling code may<br>
&gt; cause unexpected results.<br>
&gt; <br>
&gt; This patch adds error-handling code after calling xenbus_printf.<br>
&gt; <br>
&gt; Signed-off-by: Zhouyang Jia &lt;<a href=3D"mailto:jiazhouyang09@gmail.=
com">jiazhouyang09@gmail.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 drivers/scsi/xen-scsifront.c | 31 ++++++++++++++++++++++++------=
<wbr>-<br>
&gt;=C2=A0 1 file changed, 24 insertions(+), 7 deletions(-)<br>
&gt; <br>
&gt; diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront=
.c<br>
&gt; index 36f59a1..3d858ac 100644<br>
&gt; --- a/drivers/scsi/xen-scsifront.c<br>
&gt; +++ b/drivers/scsi/xen-scsifront.c<br>
&gt; @@ -654,10 +654,17 @@ static int scsifront_dev_reset_handler(<wbr>stru=
ct scsi_cmnd *sc)<br>
&gt;=C2=A0 static int scsifront_sdev_configure(<wbr>struct scsi_device *sde=
v)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct vscsifrnt_info *info =3D shost_priv(s=
dev-&gt;host);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct xenbus_device *dev =3D info-&gt;dev;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int err;<br>
&gt;=C2=A0 <br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (info &amp;&amp; current =3D=3D info-&gt;curr)=
<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0xenbus_printf(XBT_NIL=
, info-&gt;dev-&gt;nodename,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (info &amp;&amp; current =3D=3D info-&gt;curr)=
 {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D xenbus_printf=
(XBT_NIL, info-&gt;dev-&gt;nodename,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0info-&gt;dev_state_path, &quot;%d&quot;, =
XenbusStateConnected);<br>
<br>
</span>The existing code checks whether &#39;info&#39; is NULL before deref=
erencing it. <br>
But your patch checks for NULL after dereferencing.<br>
<span class=3D""><br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (err) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0dev_err(&amp;dev-&gt;dev, &quot;writing dev_state_path\n&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0return err;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt;=C2=A0 }<br>
&gt; @@ -665,10 +672,15 @@ static int scsifront_sdev_configure(<wbr>struct =
scsi_device *sdev)<br>
&gt;=C2=A0 static void scsifront_sdev_destroy(struct scsi_device *sdev)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct vscsifrnt_info *info =3D shost_priv(s=
dev-&gt;host);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct xenbus_device *dev =3D info-&gt;dev;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int err;<br>
&gt;=C2=A0 <br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (info &amp;&amp; current =3D=3D info-&gt;curr)=
<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0xenbus_printf(XBT_NIL=
, info-&gt;dev-&gt;nodename,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (info &amp;&amp; current =3D=3D info-&gt;curr)=
 {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D xenbus_printf=
(XBT_NIL, info-&gt;dev-&gt;nodename,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0info-&gt;dev_state_path, &quot;%d&quot;, =
XenbusStateClosed);<br>
<br>
</span>Same here.<br>
<span class=3D""><br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (err)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0dev_err(&amp;dev-&gt;dev, &quot;writing dev_state_path\n&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 }<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 static struct scsi_host_template scsifront_sht =3D {<br>
<br>
</span>-- <br>
</blockquote></div><br></div>

--0000000000002de995056e95ac24--


--===============0657474434808553686==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KWGVuLWRldmVs
IG1haWxpbmcgbGlzdApYZW4tZGV2ZWxAbGlzdHMueGVucHJvamVjdC5vcmcKaHR0cHM6Ly9saXN0
cy54ZW5wcm9qZWN0Lm9yZy9tYWlsbWFuL2xpc3RpbmZvL3hlbi1kZXZlbA==

--===============0657474434808553686==--
