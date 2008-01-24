From: Jan Sembera <jsembera@suse.cz>
Subject: Re: aic94xx: failing on high load
Date: Thu, 24 Jan 2008 15:42:23 +0100
Message-ID: <20080124144223.GB14728@alaris.suse.cz>
References: <20080114144916.GD23867@alaris.suse.cz> <20080114194513.GC7118@tree.beaverton.ibm.com> <1200341026.3159.62.camel@localhost.localdomain> <20080114210305.GD25714@suse.cz> <1200348261.3159.73.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:34416 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752144AbYAXOmZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jan 2008 09:42:25 -0500
Content-Disposition: inline
In-Reply-To: <1200348261.3159.73.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Vojtech Pavlik <vojtech@suse.cz>, "Darrick J. Wong" <djwong@us.ibm.com>, hare@suse.de, Peter Bogdanovic <pbog@us.ibm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

On Mon, Jan 14, 2008 at 04:04:21PM -0600, James Bottomley wrote:
> On Mon, 2008-01-14 at 22:03 +0100, Vojtech Pavlik wrote:
> > On Mon, Jan 14, 2008 at 02:03:45PM -0600, James Bottomley wrote:
> > > On Mon, 2008-01-14 at 11:45 -0800, Darrick J. Wong wrote:
> > > > On Mon, Jan 14, 2008 at 03:49:16PM +0100, Jan Sembera wrote:
> > > > > Hi,
> > > > >
> > > > > 	we have array of 16 SAS disks connected to Adaptec controlle=
rs
> > > > > ...
> > > > > this elsewhere and I was recommended to send it to linux-scsi=
=2E
> > > >
> > > > Hmm... I think Peter Bogdanovic was hitting this error recently=
 (cc'd).
> > > > There are a lot of PRIMITIVE_RECVD messages in the log, which m=
ake me
> > > > wonder if the expander is being flaky or something?  The comman=
ds that
> > > > start timing out under heavy load followed by the repeated broa=
dcasts
> > > > might be indicative of that, since the sequencer firmware and t=
he kernel
> > > > driver are up to date.  Unfortunately, I don't have any LSI exp=
anders...
> > >
> > > I do, and actually, I've seen behaviour like this, except on a SA=
TAPI
> > > DVD not a disk.  What seems to happen is that the expander hangs =
up on
> > > the device and I can't recover it except by power cycling the exp=
ander
> > > (other devices on the expander continue to work normally).
> >
> > It'd be rather hard to power cycle the 16-drive backplane with dual
> > LSISASx28 expanders in this server without bringing the rest of the
> > system down.
> >
> > If the backplane was as flaky as you suggest, I doubt anyone could =
use
> > these machines in production, even under other OSs ...
>
> I'm merely telling you what I see in my LSI expanders.  However, one =
of
> the characteristics is that I can't get any response even to a hard
> reset on the port (that's echo 1 > /sys/class/sas_phy/<phy>/hard_rese=
t)
> if it is the same problem.

	This one doesn't help either. However, we borrowed another
controller, only this time from LSI and therefore using another driver =
and
this controller has worked without issues and complains for two days (o=
ur
previous error occured after about 1 or 2 hours of heavy workload). So =
it
really seems this is some kind of adaptec vs. expander incompatibility =
(in
firmware?) or driver bug.

> > > The problem is (if it is the same problem) there isn't any define=
d error
> > > recovery from this ... the standards don't contain an expander re=
set,
> > > and the expander isn't responding to the phy reset (either hard o=
r
> > > soft). So I'm not sure what can be done at this point.
> > In our last test run, we've received some more errors, but this tim=
e the
> > system recovered and actually finished the test load:
> It could just be a simple failure in the error handler then.  libsas
> implements its own, so I bet there are a few corner cases ...

	I'm not sure about that unfortunately, I tried to do some digging
into the aic94xx driver, but it's way out of my league. We'll have thos=
e
Adaptec controllers available for some period of time (weeks maybe?) fo=
r
ebugging, but when we go production with this machine, we'll have to re=
place
them with LSI controllers and we won't be able to contribute to finding=
 the
solution of this problems any longer.

	We've tried new adaptec firmware shipped with SLES and we got
ourselves new error string that appears just above error messages that =
you
have seen before and that were attached to the original message:

kernel: aic94xx: escb_tasklet_complete: REQ_TASK_ABORT, reason=3D0x6
kernel: aic94xx: escb_tasklet_complete: Can't find task (tc=3D71) to ab=
ort!

Do you think they have any significance?


Best regards
--
Jan Sembera
Linux Administrator
---------------------------------------------------------------------
SUSE LINUX, s. r. o.                        e-mail: jsembera@suse.cz
Lihovarsk=E1 1060/12                          tel: +420 284 028 981
190 00 Praha 9                              fax: +420 284 028 951
Czech Republic                              http://www.suse.cz/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
