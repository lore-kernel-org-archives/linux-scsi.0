From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [RFC][PATCH] Add a flight data recorder for scsi commands
Date: Wed, 28 Aug 2013 10:19:38 -0400
Message-ID: <20130828141937.GB15917@logfs.org>
References: <20130827220325.GB7293@logfs.org>
 <20130827195422.0c23e47d@gandalf.local.home>
 <20130827224147.GD7293@logfs.org>
 <20130827203443.52cfee8c@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:60126 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab3H1Px1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Aug 2013 11:53:27 -0400
Content-Disposition: inline
In-Reply-To: <20130827203443.52cfee8c@gandalf.local.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-scsi@vger.kernel.org

On Tue, 27 August 2013 20:34:43 -0400, Steven Rostedt wrote:
> On Tue, 27 Aug 2013 18:41:47 -0400
> J=C3=B6rn Engel <joern@logfs.org> wrote:
> >=20
> > "without knowing in advance which device it will be"
> >=20
> > I have to trace all devices, because I don't know the interesting o=
ne
> > ahead of time.  And after the fact, I only care about one device.  =
So
> > having per-device trace buffers seems to be The Right Approach(tm).
> >=20
> > And having multiple trace buffers is where I cannot easily make my
> > problem fit your infrastructure. =20
>=20
> Are you sure about that?

When it comes to my mental shortcomings, I am quite sure about their
existence. ;)

> Note, I'm not sure you want this as something
> in production systems to always have on boot, for that, we can modify
> things a little to help you there. But other than that you can do:
>=20
> for each device d
>   mkdir /sys/kernel/debug/tracing/instances/scsi-$d
>   cd /sys/kernel/debug/tracing/instances/scsi-$d
>   echo $filter > events/scsi/*/filter
>   echo 1 > events/scsi/*/enable
> done
>=20
> The above is a script like pseudo code, just to convey the idea, not
> something to put in verbatim.

That does look fairly neat and doable.  I am not sure about the
performance overhead, though.  Would this translate into one big
switch or, for large systems, hundreds of "if (some_filter)" lines.
The latter would likely be noticeable overhead.

> Now, this may still not be what you want, but at a minimum, I would n=
ot
> add another hook like you did with the fdr_scsi_cmd(cmd). You know yo=
u
> can hook to the tracepoint directly.
>=20
>=20
> 	register_trace_scsi_dispatch_cmd_start(fdr_scsi_cmd, NULL);
>=20
> static void fdr_scsi_cmd(void *data, struct scsi_cmnd *cmd)
> {
> 	[...]
> }
>=20
> Once you call that register function, the tracepoint will call the
> function you registered when the tracepoint is hit.

Hmm.  I will ponder that idea for a bit.  If we can come up with
something merge-worthy, that would be great.  If not, I will simply
carry my existing patch and not make anyone else pay the cost for it.

J=C3=B6rn

--
The wise man seeks everything in himself; the ignorant man tries to get
everything from somebody else.
-- unknown
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
