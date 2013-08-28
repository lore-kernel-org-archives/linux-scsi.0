From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [RFC][PATCH] Add a flight data recorder for scsi commands
Date: Wed, 28 Aug 2013 10:28:31 -0400
Message-ID: <20130828142831.GC15917@logfs.org>
References: <20130827220325.GB7293@logfs.org>
 <20130827221714.GC7293@logfs.org>
 <1377666559.32763.249.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:60129 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab3H1QCV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Aug 2013 12:02:21 -0400
Content-Disposition: inline
In-Reply-To: <1377666559.32763.249.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-scsi@vger.kernel.org

On Tue, 27 August 2013 22:09:19 -0700, Nicholas A. Bellinger wrote:
> On Tue, 2013-08-27 at 18:17 -0400, J=C3=B6rn Engel wrote:
> > Here is a fun patch in an early state.  Essentially I want to trace
> > scsi commands, which has already been done long ago.  The problem I
> > have is that I care about all the scsi commands for one particular
> > device - without knowing in advance which device it will be.  Once =
I
> > know the device in question, I want to dump the last X commands.
> >=20
> > The existing tracing is covering all commands to all devices.  So
> > either I have to oversize my trace buffer and dump way too much, or=
 I
> > will miss the stuff I am interested in most of the time.  Hence my
> > per-device trace buffer (called fdr to avoid namespace collisions).
> >=20
>=20
> Sounds like a useful idea..
>=20
> However, it adds another kmalloc + spin_lock -> spin_unlock in the fa=
st
> path for each struct scsi_cmnd I/O dispatch, which is exactly what th=
e
> scsi-mq prototype code is trying to avoid at all costs.

Agreed.  It shouldn't be too hard to replace the spin_lock with
cmpxchg, maybe even rcu.  And for the common case, one could reuse the
old buffer, getting rid of kmalloc overhead as well.

=46or the time being I will likely skip the work and see whether the
existing patch actually catches something useful.  First prove the
quick hack to be useful, then optimize the hell out of it.

J=C3=B6rn

--
No art, however minor, demands less than total dedication if you want
to excel in it.
-- Leon Battista Alberti
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
