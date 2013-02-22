From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Patch][RFC] st: provide tape statistics via sysfs
Date: Fri, 22 Feb 2013 10:50:59 +0000
Message-ID: <1361530259.2372.28.camel@dabdike.int.hansenpartnership.com>
References: <DDB9C85B850785449757F9914A034FCB34340D6F@G4W3219.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41392 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753845Ab3BVKvC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Feb 2013 05:51:02 -0500
In-Reply-To: <DDB9C85B850785449757F9914A034FCB34340D6F@G4W3219.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2013-02-22 at 02:11 +0000, Seymour, Shane M wrote:
> First forgive me for using outlook for this, if there are any issues =
with what I sent let me know and I'll send it again from gmail. This is=
 also my first attempt at a kernel patch so please be gentle.
>=20
> This patch was written to enable tape statistics via sysfs for the dt
> driver based on kernel 3.8.0-rc6. It creates two new files in sysfs
> and is based on work done previously in 2005 by Kai M=E4kisara. Any
> feedback would be greatly appreciated.

I'm afraid we can't do it the way you're proposing.  files in sysfs mus=
t
conform to the one value per file rule (so we avoid the ABI nastiness
that plagues /proc).  You can create a stat directory with a bunch of
files, but not a single file that gives all values.

> Assuming sysfs is mounted at /sys the first file
> is /sys/bus/scsi/drivers/st/drives which gives a single number
> indicating what the largest tape drive instance assigned by st_probe
> in the st module is. If it's 4 it possible that st0, st1, st2, and st=
3
> exist on the system. Since tape drives can later be disconnected they
> don't have to exist, the count is a hint so it's possible to gather
> statistics in a loop with an upper bound. This makes it easier in
> iostat to gather statistcs.

I don't really get why you need this.  What's wrong with getting the
exact information from /sys/class/scsi_tape?

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
