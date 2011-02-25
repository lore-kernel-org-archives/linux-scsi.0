From: Eddie Williams <Eddie.Williams@us.sios.com>
Subject: Re: [PATCH 1/1] RFC: scsi/dm-mpath: return -EACCES on reservation conflict
Date: Fri, 25 Feb 2011 13:43:59 -0500
Message-ID: <AANLkTinnca87qWnZ+ydvmgrP1-JX=0-3A8F-==WforGF@mail.gmail.com>
References: <1255406553-7054-1-git-send-email-michaelc@cs.wisc.edu>
	<20101217165957.GB1934@redhat.com>
	<AANLkTin+LqQBbdf6z0foVStsBpr1bwLeK4jrOKmhx2M4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34389 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932476Ab1BYSoB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Feb 2011 13:44:01 -0500
Received: by gxk8 with SMTP id 8so818839gxk.19
        for <linux-scsi@vger.kernel.org>; Fri, 25 Feb 2011 10:44:01 -0800 (PST)
In-Reply-To: <AANLkTin+LqQBbdf6z0foVStsBpr1bwLeK4jrOKmhx2M4@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Hannes Reinecke <hare@suse.de>

oops, resend as plain text

On Fri, Feb 25, 2011 at 1:40 PM, Eddie Williams
<Eddie.Williams@us.sios.com> wrote:
>
> I did not see a resolution on this and don't see any changes in linux=
-2.6.38-rc4...
>
> I would like to disagree that it is not useful or appropriate to retr=
y an IO that gets a RESERVATION CONFLICT on different paths to the stor=
age.=A0 The issue is a possible window when a path is hot added to the =
system and before a registration is added for the new path.=A0 OK, this=
 window is for SCSI-3 reservations not SCSI-2...
>
> If an IO is sent down the new path in this window then it will get a =
reservation conflict.=A0 If the IO is retried on another path (that is =
registered) then it will work.
>
> So I think the reservation conflict should be retried on each path an=
d then failed if none work.=A0 The key issue being we don't want to get=
 into an infinite loop here where we retry forever especially when anot=
her IO comes does (like a read if the lock is a write lock or for many =
devices a test unit ready) that will look like the path is fine so mark=
 the path good again.
>
> The alternative to retrying would be to make sure that before an IO i=
s allowed down a new path that the path is registered.=A0 This would me=
an that instead of registering/reserving the paths by an application ou=
tside of device mapper multipath that it would need to be done inside d=
evice mapper so it knows what/when to register.
>
> Eddie Williams
> On Fri, Dec 17, 2010 at 11:59 AM, Mike Snitzer <snitzer@redhat.com> w=
rote:
>>
>> On Tue, Oct 13 2009 at 12:02am -0400,
>> michaelc@cs.wisc.edu <michaelc@cs.wisc.edu> wrote:
>>
>> > From: Mike Christie <michaelc@cs.wisc.edu>
>> >
>> > This patch was made over this patch
>> > http://marc.info/?l=3Dlinux-scsi&m=3D125417106125449&w=3D2
>> >
>> > The basic problem is that we do not want dm-multipath to retry
>> > this error, but the scsi layer returns -EIO or -EILSEQ, so
>> > dm-multipath cannot distinguish between a reservation conflict
>> > and other errors.
>> >
>> > This problem was originally discussed here
>> > http://www.linux-archive.org/device-mapper-development/180290-dm-m=
path-scsi-persistent-reservation.html
>> >
>> > I have considered adding new blk error values (I have sent pactche=
s
>> > for this before and can send updated ones if we want to go this ro=
ute),
>> > and even just using more -EXYZ values for scsi errors, but in the =
end I am
>> > just not sure it ended up being worth it, so this patch just
>> > handles the one error.
>> >
>> > The problem with adding new blk errors is that it seems only dm-mu=
ltipath
>> > knows what it wants (have not seen anything from the FS or RAID pe=
ople),
>> > and I also do not know what every device is sending so I cannot co=
mpletely
>> > clean up cases like where a device returns a error (check conditio=
n
>> > and sense) indicating a controller port is temporarily unavialable=
=2E
>> > For example, I do not know if I am getting a ILLEGAL request for s=
ome
>> > non retryable device error vs the controller is getting its FW upd=
ated
>> > (for a non retryable device error case we do not want to fail the =
path
>> > and just want to fail the IO, but for FW update we just want to fa=
il
>> > the path), so I have to treat those device errors like a transport=
 error
>> > and just fail the path.
>> >
>> > So, I did another take just using lots of different -EXYZ values. =
See
>> > this patch
>> >
>> > for an example. The problem is still that the transport error
>> > and generic error cases are the same so all I bought was the handl=
ing
>> > of the reservation conflict.
>> >
>> > And, that is how I ended up here where I am only handling the one
>> > error I know for sure will cause problems with the infrastructure =
we have.
>> > I am =A0not in love with this patch, so please give me any other
>> > suggestions.
>> >
>> > Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
>> > ---
>> > =A0drivers/md/dm-mpath.c =A0 | =A0 =A02 +-
>> > =A0drivers/scsi/scsi_lib.c | =A0 =A04 ++++
>> > =A02 files changed, 5 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
>> > index 32d0b87..93e6ce5 100644
>> > --- a/drivers/md/dm-mpath.c
>> > +++ b/drivers/md/dm-mpath.c
>> > @@ -1214,7 +1214,7 @@ static int do_end_io(struct multipath *m, st=
ruct request *clone,
>> > =A0 =A0 =A0 if (!error && !clone->errors)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0; =A0 =A0 =A0 /* I/O complete =
*/
>> >
>> > - =A0 =A0 if (error =3D=3D -EOPNOTSUPP)
>> > + =A0 =A0 if (error =3D=3D -EOPNOTSUPP || error =3D=3D -EACCES)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 return error;
>> >
>> > =A0 =A0 =A0 if (mpio->pgpath)
>> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> > index 1086552..5635035 100644
>> > --- a/drivers/scsi/scsi_lib.c
>> > +++ b/drivers/scsi/scsi_lib.c
>> > @@ -797,6 +797,10 @@ void scsi_io_completion(struct scsi_cmnd *cmd=
, unsigned int good_bytes)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* happens.
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 action =3D ACTION_RETRY;
>> > + =A0 =A0 else if (status_byte(cmd->result) =3D=3D RESERVATION_CON=
=46LICT) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 error =3D -EACCES;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 description =3D "Could not access device=
";
>> > + =A0 =A0 =A0 =A0 =A0 =A0 action =3D ACTION_FAIL;
>> > =A0 =A0 =A0 } else if (sense_valid && !sense_deferred) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (sshdr.sense_key) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 case UNIT_ATTENTION:
>> > --
>> > 1.6.2.2
>>
>> Hi Mike,
>>
>> Just a reminder that Hannes has proposed a slightly different approa=
ch
>> (returning -EREMOTEIO instead of -EACCES). =A0Here is the version of
>> Hannes' patch that I reviewed/rebased/tweaked last week:
>> https://patchwork.kernel.org/patch/384612/
>>
>> (NOTE: the scsi_decide_disposition() change relative to
>> RESERVATION_CONFLICT).
>>
>> And here is the corresponding DM mpath change:
>> https://patchwork.kernel.org/patch/384602/
>>
>> If you agree with this approach your ack would be appreciated.
>>
>> Thanks,
>> Mike
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
