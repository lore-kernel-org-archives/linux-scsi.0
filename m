From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC][PATCH] Add a flight data recorder for scsi commands
Date: Tue, 27 Aug 2013 20:34:43 -0400
Message-ID: <20130827203443.52cfee8c@gandalf.local.home>
References: <20130827220325.GB7293@logfs.org>
	<20130827195422.0c23e47d@gandalf.local.home>
	<20130827224147.GD7293@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17547 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab3H1Aep convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Aug 2013 20:34:45 -0400
In-Reply-To: <20130827224147.GD7293@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: linux-scsi@vger.kernel.org

On Tue, 27 Aug 2013 18:41:47 -0400
J=C3=B6rn Engel <joern@logfs.org> wrote:

> On Tue, 27 August 2013 19:54:22 -0400, Steven Rostedt wrote:
> > On Tue, 27 Aug 2013 18:03:25 -0400
> > J=C3=B6rn Engel <joern@logfs.org> wrote:
> >=20
> > > Here is a fun patch in an early state.  Essentially I want to tra=
ce
> > > scsi commands, which has already been done long ago.  The problem=
 I
> > > have is that I care about all the scsi commands for one particula=
r
> > > device - without knowing in advance which device it will be.  Onc=
e I
> > > know the device in question, I want to dump the last X commands.
> >=20
> > Is the device passed to the trace point? If so, you can add a filte=
r on
> > that device. You can even create a separate buffer to just trace th=
at
> > device.
>=20
> "without knowing in advance which device it will be"
>=20
> I have to trace all devices, because I don't know the interesting one
> ahead of time.  And after the fact, I only care about one device.  So
> having per-device trace buffers seems to be The Right Approach(tm).
>=20
> And having multiple trace buffers is where I cannot easily make my
> problem fit your infrastructure. =20

Are you sure about that? Note, I'm not sure you want this as something
in production systems to always have on boot, for that, we can modify
things a little to help you there. But other than that you can do:

for each device d
  mkdir /sys/kernel/debug/tracing/instances/scsi-$d
  cd /sys/kernel/debug/tracing/instances/scsi-$d
  echo $filter > events/scsi/*/filter
  echo 1 > events/scsi/*/enable
done

The above is a script like pseudo code, just to convey the idea, not
something to put in verbatim.

Basically, on boot, you can make a separate buffer for each device, and
have a different filter for those events to save to each specific
buffer.


Now, this may still not be what you want, but at a minimum, I would not
add another hook like you did with the fdr_scsi_cmd(cmd). You know you
can hook to the tracepoint directly.


	register_trace_scsi_dispatch_cmd_start(fdr_scsi_cmd, NULL);

static void fdr_scsi_cmd(void *data, struct scsi_cmnd *cmd)
{
	[...]
}

Once you call that register function, the tracepoint will call the
function you registered when the tracepoint is hit.

You can also create your own ring buffer with ring_buffer_alloc(), and
get a lockless ring buffer as well. All of ftrace is built with lego
blocks, so the infrastructure is there even if the general utility
isn't exactly what you are looking for.

-- Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
