From: Robert Woodworth <robertjwoodworth@gmail.com>
Subject: SCSI Enclosure Support (multipath)
Date: Tue, 6 Dec 2011 17:52:23 -0700
Message-ID: <CAB9NSeWgz_m+F7-3JE5Jn12Yi_PjG002UCoKdq9sj7WQLnJ29w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38172 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab1LGAwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Dec 2011 19:52:24 -0500
Received: by wgbdr13 with SMTP id dr13so41780wgb.1
        for <linux-scsi@vger.kernel.org>; Tue, 06 Dec 2011 16:52:23 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello all.

I'm a firmware engineer working on an expander inside an external
enclosure that supports SES.=A0 I have been using the sg interface
(/dev/sgXX) sg_ses and sg_write_buffer to communicate to my device
fine for some time now.

Searching through the list archives, I found a thread from 2008
discussing the ses.c kernel patch and associated /sys/ interface and
lack of /dev/ interface in that code.

=A0For my enclosure, the /sys/ interface is inadequate.=A0 It does not
appear to provide access to a SSP READ_BUFFER, WRITE_BUFFER or monitor
generic SES elements.=A0 (the enclosure provides SES monitoring of temp=
,
fans and PSU voltages)


What I would like to see is a /dev/sesXX mapping such that the I, and
my soon to come ses monitoring apps don't have to search through the
/dev/sgXX system to find the SES devices.

Second, my enclosure is 'dual redundant'.=A0 I have two expanders
providing two paths to each drive and two SES devices in one
enclosure.=A0 In the sg interface, this becomes two handles (/dev/sg5
and /dev/sg6=A0 or whatever...)=A0 To handle the true multipath this
should have a single virtual handle accessing both SES devices and
failover abilities.

However, my end customers will never need such a Linux kernel system.
The enclosure is only supported by the mfg on a LSI MegaRAID.=A0 The LS=
I
firmware already works perfectly with this system.=A0 It reports one SE=
S
device and each drive one time and has no problems if one expander is
removed, re-added then the second expander removed.=A0 The LSI hides th=
e
SES from the OS anyway, just like it hides the individual drives.



Does anyone have similar needs or working on something like this?

If I don't find anything our there, I intend on writing my own kernel
module to support this.
Would it be useful enough to share and possibly submit a patch?



RJW.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
