From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: Delayed FC rport removal causes errors on other device
Date: Wed, 17 Dec 2014 23:17:40 +0000
Message-ID: <D63B9804CB63AD4FAAD96603769566464740481D@avmb2.qlogic.org>
References: <54920690.3080706@cybernetics.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_D63B9804CB63AD4FAAD96603769566464740481Davmb2qlogicorg_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:57305 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751751AbaLQXRn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Dec 2014 18:17:43 -0500
Received: from pps.filterd (m0000643.ppops.net [127.0.0.1])
	by mx0b-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id sBHNDTC0025050
	for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2014 15:17:42 -0800
Received: from avcashub1.qlogic.com (avcashub1.qlogic.com [198.70.193.115])
	by mx0b-0016ce01.pphosted.com with ESMTP id 1r3vjky3n9-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2014 15:17:42 -0800
In-Reply-To: <54920690.3080706@cybernetics.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>

--_000_D63B9804CB63AD4FAAD96603769566464740481Davmb2qlogicorg_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FB69F033A9DC1A4CA55CFD004A5712C6@qlogic.com>
Content-Transfer-Encoding: quoted-printable

Tony,=20

We will look into this further and get back to you.

Do you have driver logs with extended error logging for this failure. If
not, can you please capture one and send it across.

Thanks,
Giridhar

On 12/17/14 2:41 PM, "Tony Battersby" <tonyb@cybernetics.com> wrote:

>Initiator-mode problem summary:
>
>FC initiator HBA cabled directly (no FC switch) to FC target device #1.
>Unplug cable from FC target device #1 and quickly plug it into FC target
>device #2, keeping the other end of the cable plugged into the same
>initiator HBA port.  The new device shows up immediately; begin sending
>commands to it.  The old device stays visible for 30 - 60 seconds after
>the cable was moved, and then it disappears with the message
>"rport-7:0-0: blocked FC remote port time out: removing rport".  When
>the old device disappears, commands outstanding to the new device are
>aborted or lock up.
>
>
>Initiator-mode problem details:
>
>vanilla kernel version 3.18.1
>
>I have three types of FC HBAs:
>QLogic QLE2672 16Gb FC HBA using qla2xxx
>QLogic QLE2562  8Gb FC HBA using qla2xxx
>LSI    7204EP   4Gb FC HBA using mptfc
>
>I have seen the problem with both qla2xxx and mptfc.  With qla2xxx,
>commands active during the old rport removal are aborted with host
>status 0x0E, but then it recovers and additional commands work fine.
>With mptfc, active commands lock up.
>
>---
>
>The problem I have described above happens using just the initiator-mode
>drivers in the mainline kernel, but my real interest is a related
>problem that happens with the QLogic target-mode drivers from
>"git://git.qlogic.com/scst-qla2xxx.git".  I will describe that problem
>with more details below.
>
>---
>
>Target-mode problem summary:
>
>Two separate PCs, each with a QLogic QLE2672 16Gb FC HBA (firmware
>7.04.01).
>One PC uses the FC HBA in initiator mode; the other PC uses the FC HBA
>in target mode.
>The target-mode PC presents a disk drive to the initiator-mode PC over FC.
>The FC HBAs are directly connected with a FC cable; no FC switch involved.
>
>With the cable plugged in, the initiator PC sees the target-mode FC disk
>at /dev/sg2.  When I unplug the cable from one port on the initiator and
>quickly plug it into the other port on the initiator, a new disk shows
>up for the new path at /dev/sg3.  The old disk at /dev/sg2 stays around
>for about 30 seconds and then disappears.  That is all fine and
>expected.  The problem is that when the old disk at /dev/sg2 disappears,
>the new disk at /dev/sg3 stops responding to commands (but doesn't
>disappear).
>
>Note: in the initiator-mode test described at the beginning of this
>message, the cable is moved from one target device to another target
>device while keeping the same initiator port.  In contrast, in this
>target-mode test, the cable is moved from one initiator port to another
>initiator port while keeping the same target port.  That is what
>distinguishes the two tests.  Whichever port remains the same (whether
>initiator or target) is the port that causes the problem when the old
>rport is removed.
>
>
>Target-mode problem details:
>
>vanilla kernel version 3.18.1
>
>Before unplugging the cable, the target-mode PC creates a session with
>portid 00:00:e8, loop_id 0, and the wwn of the first initiator port.
>When the cable is unplugged, the session is scheduled for deletion.
>When the cable is plugged into the other initiator port, the target-mode
>PC creates another session with the same portid and loop_id as the first
>session (which is now scheduled for deletion) but with a different wwn
>corresponding to the second initiator port.
>
>The new disk at /dev/sg3 stops responding to commands when the
>target-mode PC calls isp_ops->fabric_logout() from
>qla2x00_terminate_rport_io() in qla_attr.c.  If I disable that call to
>fabric_logout() then the new disk at /dev/sg3 continues to work as
>expected.  It looks like qla2x00_terminate_rport_io() is being called to
>cleanup the old removed fcport, but ends up messing up the new
>still-present fcport instead (I am guessing because the old and new
>fcports share the same portid and loopid).  After fabric_logout() messes
>up the new fcport, the target-mode HBA returns CTIO_PORT_LOGGED_OUT for
>any new incoming commands from the initiator.
>
>The problem can be avoided by waiting 30 seconds after unplugging the
>cable before plugging it back in.  But that is not a good solution for
>me since these HBAs are to be used in a product sold by my company, and
>we want it to "just work" for our customers.
>
>I am very familiar with SCSI but only a little bit with FC, so I am not
>exactly sure of the correct fix.  So bear with me while I ask a few
>questions: Is it correct for the old and new fcports to share the same
>portid and loop_id?  When creating the new fcport, should qla2xxx have
>detected that the lost-but-not-yet-dead fcport was using the same portid
>and loop_id, and chosen to use different values for the new fcport
>instead?  Or should it have invalidated the portid and/or loop_id of the
>lost-but-not-yet-dead fcport somewhere (LOOP UP/LOOP DOWN/LIP
>reset/etc.)?  Or is it OK for them to share the same portid/loop_id
>values, but instead qla2x00_terminate_rport_io() needs more checks
>before calling fabric_logout()?
>
>I would be happy to test any patches that anyone can provide.  Or if
>someone can provide answers to my questions above or other guidance,
>then I can try to come up with a fix myself.
>
>
>Thanks,
>Tony Battersby
>Cybernetics
>


--_000_D63B9804CB63AD4FAAD96603769566464740481Davmb2qlogicorg_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
3QEPVAIAAACARwBpAHIAaQBkAGgAYQByACAATQBhAGwAYQB2AGEAbABpAAAAUwBNAFQAUAAAAGcA
aQByAGkAZABoAGEAcgAuAG0AYQBsAGEAdgBhAGwAaQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAf
AAJdAQAAADoAAABnAGkAcgBpAGQAaABhAHIALgBtAGEAbABhAHYAYQBsAGkAQABxAGwAbwBnAGkA
YwAuAGMAbwBtAAAAAAAfAOVfAQAAAEIAAABzAGkAcAA6AGcAaQByAGkAZABoAGEAcgAuAG0AYQBs
AGEAdgBhAGwAaQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAAAB8AGgwBAAAAJAAAAEcAaQByAGkA
ZABoAGEAcgAgAE0AYQBsAGEAdgBhAGwAaQAAAB8AHwwBAAAAOgAAAGcAaQByAGkAZABoAGEAcgAu
AG0AYQBsAGEAdgBhAGwAaQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAAAB8AHgwBAAAACgAAAFMA
TQBUAFAAAAAAAAIBGQwBAAAAgAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgEcAaQByAGkAZABo
AGEAcgAgAE0AYQBsAGEAdgBhAGwAaQAAAFMATQBUAFAAAABnAGkAcgBpAGQAaABhAHIALgBtAGEA
bABhAHYAYQBsAGkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwABXQEAAAA6AAAAZwBpAHIAaQBk
AGgAYQByAC4AbQBhAGwAYQB2AGEAbABpAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAAAHwD4PwEA
AAAkAAAARwBpAHIAaQBkAGgAYQByACAATQBhAGwAYQB2AGEAbABpAAAAHwAjQAEAAAA6AAAAZwBp
AHIAaQBkAGgAYQByAC4AbQBhAGwAYQB2AGEAbABpAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAAA
HwAiQAEAAAAKAAAAUwBNAFQAUAAAAAAAAgH5PwEAAACAAAAAAAAAAIErH6S+oxAZnW4A3QEPVAIA
AACARwBpAHIAaQBkAGgAYQByACAATQBhAGwAYQB2AGEAbABpAAAAUwBNAFQAUAAAAGcAaQByAGkA
ZABoAGEAcgAuAG0AYQBsAGEAdgBhAGwAaQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAAldAQAA
ADoAAABnAGkAcgBpAGQAaABhAHIALgBtAGEAbABhAHYAYQBsAGkAQABxAGwAbwBnAGkAYwAuAGMA
bwBtAAAAAAAfADFAAQAAAAIAAAAAAAAACwBAOgEAAAAfADBAAQAAAAIAAAAAAAAAHwAaAAEAAAAS
AAAASQBQAE0ALgBOAG8AdABlAAAAAAADAPE/CQQAAAsAQDoBAAAAAwD9P+QEAAACAQswAQAAABAA
AAAfkM5ka5IqQLP6NZ/3+RRDAwAXAAEAAABAADkAAML7pk8a0AFAAAgwvAtMp08a0AELAACACCAG
AAAAAADAAAAAAAAARgAAAAAUhQAAAQAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAAB4AAABhAGMA
YwBlAHAAdABsAGEAbgBnAHUAYQBnAGUAAAAAAAEAAAAMAAAAZQBuAC0AVQBTAAAACwAAgAggBgAA
AAAAwAAAAAAAAEYAAAAABoUAAAAAAAAfADcAAQAAAHYAAABSAGUAOgAgAEQAZQBsAGEAeQBlAGQA
IABGAEMAIAByAHAAbwByAHQAIAByAGUAbQBvAHYAYQBsACAAYwBhAHUAcwBlAHMAIABlAHIAcgBv
AHIAcwAgAG8AbgAgAG8AdABoAGUAcgAgAGQAZQB2AGkAYwBlAAAAAAAfAD0AAQAAAAoAAABSAGUA
OgAgAAAAAAADADYAAAAAAB8AQhABAAAARgAAADwANQA0ADkAMgAwADYAOQAwAC4AMwAwADgAMAA3
ADAANgBAAGMAeQBiAGUAcgBuAGUAdABpAGMAcwAuAGMAbwBtAD4AAAAAAAIBcQABAAAAGwAAAAEB
0BpKlWEPgMkMp3FHi77hEvl5hGOclGq3gAAfAHAAAQAAAG4AAABEAGUAbABhAHkAZQBkACAARgBD
ACAAcgBwAG8AcgB0ACAAcgBlAG0AbwB2AGEAbAAgAGMAYQB1AHMAZQBzACAAZQByAHIAbwByAHMA
IABvAG4AIABvAHQAaABlAHIAIABkAGUAdgBpAGMAZQAAAAAAHwA1EAEAAAB4AAAAPABEADYAMwBC
ADkAOAAwADQAQwBCADYAMwBBAEQANABGAEEAQQBEADkANgA2ADAAMwA3ADYAOQA1ADYANgA0ADYA
NAA3ADQAMAA0ADgAMQBEAEAAYQB2AG0AYgAyAC4AcQBsAG8AZwBpAGMALgBvAHIAZwA+AAAAHwA5
EAEAAABGAAAAPAA1ADQAOQAyADAANgA5ADAALgAzADAAOAAwADcAMAA2AEAAYwB5AGIAZQByAG4A
ZQB0AGkAYwBzAC4AYwBvAG0APgAAAAAAAwDeP59OAABAAAcw+0hHp08a0AEDACYAAAAAAAIBRwAB
AAAALgAAAGM9VVM7YT0gO3A9UUxvZ2ljO2w9QVZNQjItMTQxMjE3MjMxNzQwWi0xMDk3NQAAAB8A
FRABAAAAWAAAAEYAQgA2ADkARgAwADMAMwBBADkARABDADEAQQA0AEMAQQA1ADUAQwBGAEQAMAAw
ADQAQQA1ADcAMQAyAEMANgBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAACARQwAQAAAAwAAAAiAwAA
C4yfiVQAAAAfAPo/AQAAACQAAABHAGkAcgBpAGQAaABhAHIAIABNAGEAbABhAHYAYQBsAGkAAAAf
AACAhgMCAAAAAADAAAAAAAAARgEAAAAWAAAAdQBzAGUAcgAtAGEAZwBlAG4AdAAAAAAAAQAAAEYA
AABNAGkAYwByAG8AcwBvAGYAdAAtAE0AYQBjAE8AdQB0AGwAbwBvAGsALwAxADQALgA0AC4ANAAu
ADEANAAwADgAMAA3AAAAAAAfAACAH6TrM6h6LkK+e3nhqY5UswEAAAA4AAAAQwBvAG4AdgBlAHIA
cwBhAHQAaQBvAG4ASQBuAGQAZQB4AFQAcgBhAGMAawBpAG4AZwBFAHgAAAABAAAAFgEAAEkASQA9
ADAAMQAwADEARAAwADEAQQA0AEYAQQA3ADYAOAA5AEUANwA4ADcANgAyADAAOABFADQAMgA0AEQA
OAAyADEANwBGADEAQwAxADgANwA1ADkANAAxADIANAA7AFMAQgBNAEkARAA9ADEAOwBTADEAPQA8
ADUANAA5ADIAMAA2ADkAMAAuADMAMAA4ADAANwAwADYAQABjAHkAYgBlAHIAbgBlAHQAaQBjAHMA
LgBjAG8AbQA+ADsAVgBlAHIAcwBpAG8AbgA9AFYAZQByAHMAaQBvAG4AIAAxADQALgAyACAAKABC
AHUAaQBsAGQAIAAzADgANwAuADAAKQAsACAAUwB0AGEAZwBlAD0ASAAyAAAAAAADAA00/T8AAB8A
AICGAwIAAAAAAMAAAAAAAABGAQAAACAAAAB4AC0AbQBzAC0AaABhAHMALQBhAHQAdABhAGMAaAAA
AAEAAAACAAAAAAAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAACIAAAB4AC0AbwByAGkAZwBpAG4A
YQB0AGkAbgBnAC0AaQBwAAAAAAABAAAAGAAAAFsAMQAwAC4AMQAuADQALgAxADAAXQAAAB8AAICG
AwIAAAAAAMAAAAAAAABGAQAAABYAAABkAGkAcwBjAGwAYQBpAG0AZQByAAAAAAABAAAADgAAAGIA
eQBwAGEAcwBzAAAAAADX9A==

--_000_D63B9804CB63AD4FAAD96603769566464740481Davmb2qlogicorg_--
