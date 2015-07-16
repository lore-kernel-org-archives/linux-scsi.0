From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] dm-mpath: always return reservation conflict
Date: Thu, 16 Jul 2015 05:07:03 +0000
Message-ID: <CABr-GncMR4y+Sv=cXnhbXyX+ko2d13hgsPg2xbWSp9Z-v8=nqQ@mail.gmail.com>
References: <1436959404-14035-1-git-send-email-hare@suse.de>
	<1436960108.31121.41.camel@HansenPartnership.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7046467599955971217=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1436960108.31121.41.camel@HansenPartnership.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
List-Id: linux-scsi@vger.kernel.org

--===============7046467599955971217==
Content-Type: multipart/alternative; boundary=089e0160b436585d4b051af70bfb

--089e0160b436585d4b051af70bfb
Content-Type: text/plain; charset=UTF-8

If your patch implement a direct path-to-multipath conflict error
propagation, won't the common scenario where admins add new (initialy
unregistered) paths to a reserved multipath result in application-visible
i/o errors ? If so, those admins might hold us a grudge :/

For reference the opensvc crm does use type 5 pr, and aims for all paths
registered. It still does not make use of the multipathd pr janitoring
features, and uses sg_persist directly for pr status and actions.

Best regards,
Christophe Varoqui
OpenSVC

Regards,

Christophe Varoqui

OpenSVC

On Wed, Jul 15, 2015 at 1:35 PM, James Bottomley <
James.Bottomley@hansenpartnership.com> wrote:

> On Wed, 2015-07-15 at 13:23 +0200, Hannes Reinecke wrote:
> > If dm-mpath encounters an reservation conflict it should not
> > fail the path (as communication with the target is not affected)
> > but should rather retry on another path.
> > However, in doing so we might be inducing a ping-pong between
> > paths, with no guarantee of any forward progress.
> > And arguably a reservation conflict is an unexpected error,
> > so we should be passing it upwards to allow the application
> > to take appropriate steps.
>
> If I interpret the code correctly, you've changed the behaviour from the
> current try all paths and fail them, ultimately passing the reservation
> conflict up if all paths fail to return reservation conflict
> immediately, keeping all paths running.  This assumes that the
> reservation isn't path specific because if we encounter a path specific
> reservation, you've altered the behaviour from route around to fail.
>
> The case I think the original code was for is SAN Volume controllers
> which use path specific SCSI-3 reservations effectively to do traffic
> control and allow favoured paths.  Have you verified that nothing we
> encounter in the enterprise uses path specific reservations for
> multipath shaping any more?
>
> James
>
> > Signed-off-by: Hannes Reinecke <hare@suse.de>
> > ---
> >  drivers/md/dm-mpath.c | 14 ++++++++++----
> >  1 file changed, 10 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> > index 5a67671..e65d266 100644
> > --- a/drivers/md/dm-mpath.c
> > +++ b/drivers/md/dm-mpath.c
> > @@ -1269,7 +1269,16 @@ static int do_end_io(struct multipath *m, struct
> request *clone,
> >       if (noretry_error(error))
> >               return error;
> >
> > -     if (mpio->pgpath)
> > +     /*
> > +      * EBADE signals an reservation conflict.
> > +      * We shouldn't fail the path here as we can communicate with
> > +      * the target. We should failover to the next path, but in
> > +      * doing so we might be causing a ping-pong between paths.
> > +      * So just return the reservation conflict error.
> > +      */
> > +     if (error == -EBADE)
> > +             r = error;
> > +     else if (mpio->pgpath)
> >               fail_path(mpio->pgpath);
> >
> >       spin_lock_irqsave(&m->lock, flags);
> > @@ -1277,9 +1286,6 @@ static int do_end_io(struct multipath *m, struct
> request *clone,
> >               if (!m->queue_if_no_path) {
> >                       if (!__must_push_back(m))
> >                               r = -EIO;
> > -             } else {
> > -                     if (error == -EBADE)
> > -                             r = error;
> >               }
> >       }
> >       spin_unlock_irqrestore(&m->lock, flags);
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--089e0160b436585d4b051af70bfb
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr">If your patch implement a direct path-to-multipath conflict =
error propagation, won&#39;t the common scenario where admins add new (init=
ialy unregistered) paths to a reserved multipath result in application-visi=
ble i/o errors ? If so, those admins might hold us a grudge :/</p>
<p dir=3D"ltr">For reference the opensvc crm does use type 5 pr, and aims f=
or all paths registered. It still does not make use of the multipathd pr ja=
nitoring features, and uses sg_persist directly for pr status and actions.<=
/p>
<p dir=3D"ltr">Best regards,<br>
Christophe Varoqui <br>
OpenSVC </p>
<p dir=3D"ltr">Regards,</p>
<p dir=3D"ltr">Christophe Varoqui</p>
<p dir=3D"ltr">OpenSVC</p>
<div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Wed, Jul 15, 2=
015 at 1:35 PM, James Bottomley <span dir=3D"ltr">&lt;<a href=3D"mailto:Jam=
es.Bottomley@hansenpartnership.com" target=3D"_blank">James.Bottomley@hanse=
npartnership.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote"=
 style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><s=
pan>On Wed, 2015-07-15 at 13:23 +0200, Hannes Reinecke wrote:<br>
&gt; If dm-mpath encounters an reservation conflict it should not<br>
&gt; fail the path (as communication with the target is not affected)<br>
&gt; but should rather retry on another path.<br>
&gt; However, in doing so we might be inducing a ping-pong between<br>
&gt; paths, with no guarantee of any forward progress.<br>
&gt; And arguably a reservation conflict is an unexpected error,<br>
&gt; so we should be passing it upwards to allow the application<br>
&gt; to take appropriate steps.<br>
<br>
</span>If I interpret the code correctly, you&#39;ve changed the behaviour =
from the<br>
current try all paths and fail them, ultimately passing the reservation<br>
conflict up if all paths fail to return reservation conflict<br>
immediately, keeping all paths running.=C2=A0 This assumes that the<br>
reservation isn&#39;t path specific because if we encounter a path specific=
<br>
reservation, you&#39;ve altered the behaviour from route around to fail.<br=
>
<br>
The case I think the original code was for is SAN Volume controllers<br>
which use path specific SCSI-3 reservations effectively to do traffic<br>
control and allow favoured paths.=C2=A0 Have you verified that nothing we<b=
r>
encounter in the enterprise uses path specific reservations for<br>
multipath shaping any more?<br>
<span><font color=3D"#888888"><br>
James<br>
</font></span><div><div><br>
&gt; Signed-off-by: Hannes Reinecke &lt;<a href=3D"mailto:hare@suse.de" tar=
get=3D"_blank">hare@suse.de</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 drivers/md/dm-mpath.c | 14 ++++++++++----<br>
&gt;=C2=A0 1 file changed, 10 insertions(+), 4 deletions(-)<br>
&gt;<br>
&gt; diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c<br>
&gt; index 5a67671..e65d266 100644<br>
&gt; --- a/drivers/md/dm-mpath.c<br>
&gt; +++ b/drivers/md/dm-mpath.c<br>
&gt; @@ -1269,7 +1269,16 @@ static int do_end_io(struct multipath *m, struc=
t request *clone,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (noretry_error(error))<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return error;<br=
>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (mpio-&gt;pgpath)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/*<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * EBADE signals an reservation conflict.<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * We shouldn&#39;t fail the path here as we can =
communicate with<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * the target. We should failover to the next pat=
h, but in<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * doing so we might be causing a ping-pong betwe=
en paths.<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * So just return the reservation conflict error.=
<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (error =3D=3D -EBADE)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0r =3D error;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0else if (mpio-&gt;pgpath)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fail_path(mpio-&=
gt;pgpath);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock_irqsave(&amp;m-&gt;lock, flags);<b=
r>
&gt; @@ -1277,9 +1286,6 @@ static int do_end_io(struct multipath *m, struct=
 request *clone,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!m-&gt;queue=
_if_no_path) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0if (!__must_push_back(m))<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0r =3D -EIO;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0if (error =3D=3D -EBADE)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0r =3D error;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock_irqrestore(&amp;m-&gt;lock, flag=
s);<br>
<br>
<br>
<br>
--<br>
</div></div><div><div>dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br>
</div></div></blockquote></div><br></div>

--089e0160b436585d4b051af70bfb--


--===============7046467599955971217==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7046467599955971217==--
