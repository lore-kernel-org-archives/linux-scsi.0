From: Bryan Donlan <bdonlan@gmail.com>
Subject: Re: contention on long-held spinlock
Date: Fri, 19 Aug 2011 15:25:30 -0400
Message-ID: <CAF_S4t_5qfx1H+nm+fvYd24k4ezF__JDFLvg6gv_so8SeVqKvA@mail.gmail.com>
References: <4E4E2B2A.40100@odi.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60744 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755684Ab1HST0L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Aug 2011 15:26:11 -0400
In-Reply-To: <4E4E2B2A.40100@odi.ch>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
Cc: linux-kernel@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org

2011/8/19 Ortwin Gl=FCck <odi@odi.ch>:
> Hi,
>
> I have observed a bad behaviour that is likely caused by spinlocks in=
 the
> qla2xxx driver. This is a QLogic Fibre Channel storage driver.

Please CC the relevant maintainers when reporting driver bugs (I'm
adding them in this reply); it will help make sure the right people
notice. Maintainer addresses can be found in the MAINTAINERS file at
the root of the linux source tree.

What version of the kernel are you using? It would also help to
provide dmesg output from when the problem is occurring, if anything
out of the ordinary can be found there (if you've already rebooted,
check /var/log/kern.log - or wherever your distribution puts the
kernel log)

> Somehow the attached SAN had a problem and became unresponsive. Many
> processes queued up waiting to write to the device. The processes wer=
e doing
> nothing but wait, but system load increased to insane values (40 and =
above
> on a 4 core machine). The system was very sluggish and unresponsive, =
making
> it very hard and slow to see what actually was the problem.
>
> I didn't run an indepth analysis, but this is my guess: I see that ql=
a2xxx
> uses spinlocks to guard the HW against concurrent access. So if the H=
W
> becomes unresponsive all waiters would busy spin and burn resources, =
right?
> Those spinlocks are superfast as long as the HW responds well, but be=
come a
> CPU burner once the HW becomes slow.
>
> I wonder if spinlocks could be made aware of such a situation and rel=
ax.
> Something like if spinning for more than 1000 times, perform a simple
> backoff and sleep. A spinlock should never spin busy for several seco=
nds,
> right?

That's what mutexes are for. Note, however, that interrupt handlers
cannot use mutexes as they cannot sleep, nor can they wait for lock
holders which may themselves sleep.

Also note that holding spinlocks for a long time is more likely to
result in lockups than a slowdown - a CPU attempting to grab a
spinlock disables migration and preemption, so on your four CPU
system, four processes waiting on spinlocks is enough to completely
lock up the system (unless you're using the real-time branch's kernel,
which converts most spinlocks to mutexes).
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
