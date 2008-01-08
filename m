From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC] Implementation of SCSI dynamic power management
Date: Tue, 8 Jan 2008 10:12:52 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0801081006580.2643-100000@iolanthe.rowland.org>
References: <200801081512.55746.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:48485 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751343AbYAHPMx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 10:12:53 -0500
In-Reply-To: <200801081512.55746.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Linux-pm mailing list <linux-pm@lists.linux-foundation.org>

On Tue, 8 Jan 2008, Oliver Neukum wrote:

> Am Montag, 7. Januar 2008 20:42:23 schrieb Alan Stern:
> > =A0/**
> > + *=A0=A0=A0=A0=A0autoresume - perform dynamic (runtime) host resum=
e
> > + *=A0=A0=A0=A0=A0@shp: host to resume
> > + *
> > + *=A0=A0=A0=A0=A0Resume (return to an operational power level) the=
 specified host.
> > + *=A0=A0=A0=A0=A0Return 0 if the resume was successful, otherwise =
a negative
> > + *=A0=A0=A0=A0=A0error code.
> > + *
> > + *=A0=A0=A0=A0=A0Locks: struct Scsi_Host::pm_mutex held throughout=
 the call.
> > + *
> > + *=A0=A0=A0=A0=A0Calling context: process
> > + *
> > + *=A0=A0=A0=A0=A0Notes: If the host is not currently suspended, th=
is method does
> > + *=A0=A0=A0=A0=A0need to do anything.
> > + *
> > + *=A0=A0=A0=A0=A0Optionally defined in: LLD
> > + **/
> > + =A0 =A0int autoresume(struct Scsi_Host *shp)
> > +
>=20
> This seems to be a bit misleading. It seems to me that you must cance=
l
> any outstanding request to autosuspend from other layers.

How about something more like this:

*	Resume (return to an operational power level) the specified host,
*	and prevent autosuspends from other software layers until the
*	template autosuspend method has been called again.
*	Return 0 if the resume was successful, otherwise a negative
*	error code.

Alan Stern

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
