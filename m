From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: cdrecord: Cannot allocate memory. Cannot get SCSI I/O buffer.
Date: Thu, 12 Jan 2006 16:30:09 +0100
Message-ID: <m31wzdv4zi.fsf@merlin.emma.line.org>
References: <200601121322.17458.T.Maguin@web.de>
	<m3lkxltynn.fsf@merlin.emma.line.org>
	<200601121352.16717.T.Maguin@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.21]:8353 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1751205AbWALPaZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2006 10:30:25 -0500
In-Reply-To: <200601121352.16717.T.Maguin@web.de> (Thomas Maguin's message of
	"Thu, 12 Jan 2006 13:52:06 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: T.Maguin@web.de
Cc: linux-scsi@vger.kernel.org

Thomas Maguin <T.Maguin@web.de> writes:

> On Thursday 12 January 2006 13:32, you wrote:
>> Consider using "sudo".
>
> and when I want to use k3b? Should I sudo k3b? This could possibly re=
sult in a=20
> big security problem.

No, you could write a wrapper script that looks like

#! /bin/sh
exec /usr/bin/sudo /path/to/cdrecord "$@"

and point k3b to use that.

If it's a single-user desktop machine, /removing/ the setuid bit from
cdrecord might actually work, but runs counter to J=F6rg's
recommendations. No memory locking, no real-time priority will work, so
it stands a much higher chance of buffer underruns which are detrimenta=
l
to writing quality even in the light of burnproof, justlink and similar=
=2E
So in this case, the user needs to make absolutely sure the box is
absolutely idle. Better shut off the network so no messages come in and
run through the spam filter, don't browse, and at nighttime, shut down
cron, too.

I recall someone offering cdrecord patches to overcome part of this
problem, to the extent of it dropping its permissions too early,
apparently they haven't made 2.01.01a04 yet, if they are correct at all=
=2E

--=20
Matthias Andree
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
