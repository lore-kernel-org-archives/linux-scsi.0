From: Eddie Williams <Eddie.Williams@us.sios.com>
Subject: Re: [PATCH 1/1] RFC: scsi/dm-mpath: return -EACCES on
	reservation conflict
Date: Fri, 25 Feb 2011 13:40:14 -0500
Message-ID: <AANLkTin+LqQBbdf6z0foVStsBpr1bwLeK4jrOKmhx2M4@mail.gmail.com>
References: <1255406553-7054-1-git-send-email-michaelc@cs.wisc.edu>
	<20101217165957.GB1934@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4654634149433631585=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20101217165957.GB1934@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--===============4654634149433631585==
Content-Type: multipart/alternative; boundary=20cf304340da30a907049d1fa947

--20cf304340da30a907049d1fa947
Content-Type: text/plain; charset=ISO-8859-1

I did not see a resolution on this and don't see any changes in
linux-2.6.38-rc4...

I would like to disagree that it is not useful or appropriate to retry an IO
that gets a RESERVATION CONFLICT on different paths to the storage.  The
issue is a possible window when a path is hot added to the system and before
a registration is added for the new path.  OK, this window is for SCSI-3
reservations not SCSI-2...

If an IO is sent down the new path in this window then it will get a
reservation conflict.  If the IO is retried on another path (that is
registered) then it will work.

So I think the reservation conflict should be retried on each path and then
failed if none work.  The key issue being we don't want to get into an
infinite loop here where we retry forever especially when another IO comes
does (like a read if the lock is a write lock or for many devices a test
unit ready) that will look like the path is fine so mark the path good
again.

The alternative to retrying would be to make sure that before an IO is
allowed down a new path that the path is registered.  This would mean that
instead of registering/reserving the paths by an application outside of
device mapper multipath that it would need to be done inside device mapper
so it knows what/when to register.

Eddie Williams
On Fri, Dec 17, 2010 at 11:59 AM, Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, Oct 13 2009 at 12:02am -0400,
> michaelc@cs.wisc.edu <michaelc@cs.wisc.edu> wrote:
>
> > From: Mike Christie <michaelc@cs.wisc.edu>
> >
> > This patch was made over this patch
> > http://marc.info/?l=linux-scsi&m=125417106125449&w=2
> >
> > The basic problem is that we do not want dm-multipath to retry
> > this error, but the scsi layer returns -EIO or -EILSEQ, so
> > dm-multipath cannot distinguish between a reservation conflict
> > and other errors.
> >
> > This problem was originally discussed here
> >
> http://www.linux-archive.org/device-mapper-development/180290-dm-mpath-scsi-persistent-reservation.html
> >
> > I have considered adding new blk error values (I have sent pactches
> > for this before and can send updated ones if we want to go this route),
> > and even just using more -EXYZ values for scsi errors, but in the end I
> am
> > just not sure it ended up being worth it, so this patch just
> > handles the one error.
> >
> > The problem with adding new blk errors is that it seems only dm-multipath
> > knows what it wants (have not seen anything from the FS or RAID people),
> > and I also do not know what every device is sending so I cannot
> completely
> > clean up cases like where a device returns a error (check condition
> > and sense) indicating a controller port is temporarily unavialable.
> > For example, I do not know if I am getting a ILLEGAL request for some
> > non retryable device error vs the controller is getting its FW updated
> > (for a non retryable device error case we do not want to fail the path
> > and just want to fail the IO, but for FW update we just want to fail
> > the path), so I have to treat those device errors like a transport error
> > and just fail the path.
> >
> > So, I did another take just using lots of different -EXYZ values. See
> > this patch
> >
> > for an example. The problem is still that the transport error
> > and generic error cases are the same so all I bought was the handling
> > of the reservation conflict.
> >
> > And, that is how I ended up here where I am only handling the one
> > error I know for sure will cause problems with the infrastructure we
> have.
> > I am  not in love with this patch, so please give me any other
> > suggestions.
> >
> > Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> > ---
> >  drivers/md/dm-mpath.c   |    2 +-
> >  drivers/scsi/scsi_lib.c |    4 ++++
> >  2 files changed, 5 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> > index 32d0b87..93e6ce5 100644
> > --- a/drivers/md/dm-mpath.c
> > +++ b/drivers/md/dm-mpath.c
> > @@ -1214,7 +1214,7 @@ static int do_end_io(struct multipath *m, struct
> request *clone,
> >       if (!error && !clone->errors)
> >               return 0;       /* I/O complete */
> >
> > -     if (error == -EOPNOTSUPP)
> > +     if (error == -EOPNOTSUPP || error == -EACCES)
> >               return error;
> >
> >       if (mpio->pgpath)
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 1086552..5635035 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -797,6 +797,10 @@ void scsi_io_completion(struct scsi_cmnd *cmd,
> unsigned int good_bytes)
> >                * happens.
> >                */
> >               action = ACTION_RETRY;
> > +     else if (status_byte(cmd->result) == RESERVATION_CONFLICT) {
> > +             error = -EACCES;
> > +             description = "Could not access device";
> > +             action = ACTION_FAIL;
> >       } else if (sense_valid && !sense_deferred) {
> >               switch (sshdr.sense_key) {
> >               case UNIT_ATTENTION:
> > --
> > 1.6.2.2
>
> Hi Mike,
>
> Just a reminder that Hannes has proposed a slightly different approach
> (returning -EREMOTEIO instead of -EACCES).  Here is the version of
> Hannes' patch that I reviewed/rebased/tweaked last week:
> https://patchwork.kernel.org/patch/384612/
>
> (NOTE: the scsi_decide_disposition() change relative to
> RESERVATION_CONFLICT).
>
> And here is the corresponding DM mpath change:
> https://patchwork.kernel.org/patch/384602/
>
> If you agree with this approach your ack would be appreciated.
>
> Thanks,
> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--20cf304340da30a907049d1fa947
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I did not see a resolution on this and don&#39;t see any changes in linux-2=
.6.38-rc4...<br><br>I would like to disagree that it is not useful or appro=
priate to retry an IO that gets a RESERVATION CONFLICT on different paths t=
o the storage.=A0 The issue is a possible window when a path is hot added t=
o the system and before a registration is added for the new path.=A0 OK, th=
is window is for SCSI-3 reservations not SCSI-2...<br>
<br>If an IO is sent down the new path in this window then it will get a re=
servation conflict.=A0 If the IO is retried on another path (that is regist=
ered) then it will work.=A0 <br><br>So I think the reservation conflict sho=
uld be retried on each path and then failed if none work.=A0 The key issue =
being we don&#39;t want to get into an infinite loop here where we retry fo=
rever especially when another IO comes does (like a read if the lock is a w=
rite lock or for many devices a test unit ready) that will look like the pa=
th is fine so mark the path good again.<br>
<br>The alternative to retrying would be to make sure that before an IO is =
allowed down a new path that the path is registered.=A0 This would mean tha=
t instead of registering/reserving the paths by an application outside of d=
evice mapper multipath that it would need to be done inside device mapper s=
o it knows what/when to register.<br>
<br>Eddie Williams<br><div class=3D"gmail_quote">On Fri, Dec 17, 2010 at 11=
:59 AM, Mike Snitzer <span dir=3D"ltr">&lt;<a href=3D"mailto:snitzer@redhat=
.com">snitzer@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmai=
l_quote" style=3D"margin: 0pt 0pt 0pt 0.8ex; border-left: 1px solid rgb(204=
, 204, 204); padding-left: 1ex;">
On Tue, Oct 13 2009 at 12:02am -0400,<br>
<a href=3D"mailto:michaelc@cs.wisc.edu">michaelc@cs.wisc.edu</a> &lt;<a hre=
f=3D"mailto:michaelc@cs.wisc.edu">michaelc@cs.wisc.edu</a>&gt; wrote:<br>
<br>
&gt; From: Mike Christie &lt;<a href=3D"mailto:michaelc@cs.wisc.edu">michae=
lc@cs.wisc.edu</a>&gt;<br>
&gt;<br>
&gt; This patch was made over this patch<br>
&gt; <a href=3D"http://marc.info/?l=3Dlinux-scsi&amp;m=3D125417106125449&am=
p;w=3D2" target=3D"_blank">http://marc.info/?l=3Dlinux-scsi&amp;m=3D1254171=
06125449&amp;w=3D2</a><br>
&gt;<br>
&gt; The basic problem is that we do not want dm-multipath to retry<br>
&gt; this error, but the scsi layer returns -EIO or -EILSEQ, so<br>
&gt; dm-multipath cannot distinguish between a reservation conflict<br>
&gt; and other errors.<br>
&gt;<br>
&gt; This problem was originally discussed here<br>
&gt; <a href=3D"http://www.linux-archive.org/device-mapper-development/1802=
90-dm-mpath-scsi-persistent-reservation.html" target=3D"_blank">http://www.=
linux-archive.org/device-mapper-development/180290-dm-mpath-scsi-persistent=
-reservation.html</a><br>

&gt;<br>
&gt; I have considered adding new blk error values (I have sent pactches<br=
>
&gt; for this before and can send updated ones if we want to go this route)=
,<br>
&gt; and even just using more -EXYZ values for scsi errors, but in the end =
I am<br>
&gt; just not sure it ended up being worth it, so this patch just<br>
&gt; handles the one error.<br>
&gt;<br>
&gt; The problem with adding new blk errors is that it seems only dm-multip=
ath<br>
&gt; knows what it wants (have not seen anything from the FS or RAID people=
),<br>
&gt; and I also do not know what every device is sending so I cannot comple=
tely<br>
&gt; clean up cases like where a device returns a error (check condition<br=
>
&gt; and sense) indicating a controller port is temporarily unavialable.<br=
>
&gt; For example, I do not know if I am getting a ILLEGAL request for some<=
br>
&gt; non retryable device error vs the controller is getting its FW updated=
<br>
&gt; (for a non retryable device error case we do not want to fail the path=
<br>
&gt; and just want to fail the IO, but for FW update we just want to fail<b=
r>
&gt; the path), so I have to treat those device errors like a transport err=
or<br>
&gt; and just fail the path.<br>
&gt;<br>
&gt; So, I did another take just using lots of different -EXYZ values. See<=
br>
&gt; this patch<br>
&gt;<br>
&gt; for an example. The problem is still that the transport error<br>
&gt; and generic error cases are the same so all I bought was the handling<=
br>
&gt; of the reservation conflict.<br>
&gt;<br>
&gt; And, that is how I ended up here where I am only handling the one<br>
&gt; error I know for sure will cause problems with the infrastructure we h=
ave.<br>
&gt; I am =A0not in love with this patch, so please give me any other<br>
&gt; suggestions.<br>
&gt;<br>
&gt; Signed-off-by: Mike Christie &lt;<a href=3D"mailto:michaelc@cs.wisc.ed=
u">michaelc@cs.wisc.edu</a>&gt;<br>
&gt; ---<br>
&gt; =A0drivers/md/dm-mpath.c =A0 | =A0 =A02 +-<br>
&gt; =A0drivers/scsi/scsi_lib.c | =A0 =A04 ++++<br>
&gt; =A02 files changed, 5 insertions(+), 1 deletions(-)<br>
&gt;<br>
&gt; diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c<br>
&gt; index 32d0b87..93e6ce5 100644<br>
&gt; --- a/drivers/md/dm-mpath.c<br>
&gt; +++ b/drivers/md/dm-mpath.c<br>
&gt; @@ -1214,7 +1214,7 @@ static int do_end_io(struct multipath *m, struct=
 request *clone,<br>
&gt; =A0 =A0 =A0 if (!error &amp;&amp; !clone-&gt;errors)<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0; =A0 =A0 =A0 /* I/O complete */<b=
r>
&gt;<br>
&gt; - =A0 =A0 if (error =3D=3D -EOPNOTSUPP)<br>
&gt; + =A0 =A0 if (error =3D=3D -EOPNOTSUPP || error =3D=3D -EACCES)<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 return error;<br>
&gt;<br>
&gt; =A0 =A0 =A0 if (mpio-&gt;pgpath)<br>
&gt; diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c<br>
&gt; index 1086552..5635035 100644<br>
&gt; --- a/drivers/scsi/scsi_lib.c<br>
&gt; +++ b/drivers/scsi/scsi_lib.c<br>
&gt; @@ -797,6 +797,10 @@ void scsi_io_completion(struct scsi_cmnd *cmd, un=
signed int good_bytes)<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* happens.<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 action =3D ACTION_RETRY;<br>
&gt; + =A0 =A0 else if (status_byte(cmd-&gt;result) =3D=3D RESERVATION_CONF=
LICT) {<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 error =3D -EACCES;<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 description =3D &quot;Could not access devic=
e&quot;;<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 action =3D ACTION_FAIL;<br>
&gt; =A0 =A0 =A0 } else if (sense_valid &amp;&amp; !sense_deferred) {<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (sshdr.sense_key) {<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 case UNIT_ATTENTION:<br>
&gt; --<br>
&gt; 1.6.2.2<br>
<br>
Hi Mike,<br>
<br>
Just a reminder that Hannes has proposed a slightly different approach<br>
(returning -EREMOTEIO instead of -EACCES). =A0Here is the version of<br>
Hannes&#39; patch that I reviewed/rebased/tweaked last week:<br>
<a href=3D"https://patchwork.kernel.org/patch/384612/" target=3D"_blank">ht=
tps://patchwork.kernel.org/patch/384612/</a><br>
<br>
(NOTE: the scsi_decide_disposition() change relative to<br>
RESERVATION_CONFLICT).<br>
<br>
And here is the corresponding DM mpath change:<br>
<a href=3D"https://patchwork.kernel.org/patch/384602/" target=3D"_blank">ht=
tps://patchwork.kernel.org/patch/384602/</a><br>
<br>
If you agree with this approach your ack would be appreciated.<br>
<br>
Thanks,<br>
Mike<br>
<font color=3D"#888888">--<br>
To unsubscribe from this list: send the line &quot;unsubscribe linux-scsi&q=
uot; in<br>
the body of a message to <a href=3D"mailto:majordomo@vger.kernel.org">major=
domo@vger.kernel.org</a><br>
More majordomo info at =A0<a href=3D"http://vger.kernel.org/majordomo-info.=
html" target=3D"_blank">http://vger.kernel.org/majordomo-info.html</a><br>
</font></blockquote></div><br>

--20cf304340da30a907049d1fa947--


--===============4654634149433631585==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4654634149433631585==--
