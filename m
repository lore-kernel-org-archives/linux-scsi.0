From: Tony Battersby <tonyb@cybernetics.com>
Subject: Delayed FC rport removal causes errors on other device
Date: Wed, 17 Dec 2014 17:41:20 -0500
Message-ID: <54920690.3080706@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cybernetics.com ([173.71.130.66]:36698 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbaLQWlW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Dec 2014 17:41:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org

Initiator-mode problem summary:

FC initiator HBA cabled directly (no FC switch) to FC target device #1. 
Unplug cable from FC target device #1 and quickly plug it into FC target
device #2, keeping the other end of the cable plugged into the same
initiator HBA port.  The new device shows up immediately; begin sending
commands to it.  The old device stays visible for 30 - 60 seconds after
the cable was moved, and then it disappears with the message
"rport-7:0-0: blocked FC remote port time out: removing rport".  When
the old device disappears, commands outstanding to the new device are
aborted or lock up.


Initiator-mode problem details:

vanilla kernel version 3.18.1

I have three types of FC HBAs:
QLogic QLE2672 16Gb FC HBA using qla2xxx
QLogic QLE2562  8Gb FC HBA using qla2xxx
LSI    7204EP   4Gb FC HBA using mptfc

I have seen the problem with both qla2xxx and mptfc.  With qla2xxx,
commands active during the old rport removal are aborted with host
status 0x0E, but then it recovers and additional commands work fine. 
With mptfc, active commands lock up.

---

The problem I have described above happens using just the initiator-mode
drivers in the mainline kernel, but my real interest is a related
problem that happens with the QLogic target-mode drivers from
"git://git.qlogic.com/scst-qla2xxx.git".  I will describe that problem
with more details below.

---

Target-mode problem summary:

Two separate PCs, each with a QLogic QLE2672 16Gb FC HBA (firmware 7.04.01).
One PC uses the FC HBA in initiator mode; the other PC uses the FC HBA
in target mode.
The target-mode PC presents a disk drive to the initiator-mode PC over FC.
The FC HBAs are directly connected with a FC cable; no FC switch involved.

With the cable plugged in, the initiator PC sees the target-mode FC disk
at /dev/sg2.  When I unplug the cable from one port on the initiator and
quickly plug it into the other port on the initiator, a new disk shows
up for the new path at /dev/sg3.  The old disk at /dev/sg2 stays around
for about 30 seconds and then disappears.  That is all fine and
expected.  The problem is that when the old disk at /dev/sg2 disappears,
the new disk at /dev/sg3 stops responding to commands (but doesn't
disappear).

Note: in the initiator-mode test described at the beginning of this
message, the cable is moved from one target device to another target
device while keeping the same initiator port.  In contrast, in this
target-mode test, the cable is moved from one initiator port to another
initiator port while keeping the same target port.  That is what
distinguishes the two tests.  Whichever port remains the same (whether
initiator or target) is the port that causes the problem when the old
rport is removed.


Target-mode problem details:

vanilla kernel version 3.18.1

Before unplugging the cable, the target-mode PC creates a session with
portid 00:00:e8, loop_id 0, and the wwn of the first initiator port. 
When the cable is unplugged, the session is scheduled for deletion. 
When the cable is plugged into the other initiator port, the target-mode
PC creates another session with the same portid and loop_id as the first
session (which is now scheduled for deletion) but with a different wwn
corresponding to the second initiator port.

The new disk at /dev/sg3 stops responding to commands when the
target-mode PC calls isp_ops->fabric_logout() from
qla2x00_terminate_rport_io() in qla_attr.c.  If I disable that call to
fabric_logout() then the new disk at /dev/sg3 continues to work as
expected.  It looks like qla2x00_terminate_rport_io() is being called to
cleanup the old removed fcport, but ends up messing up the new
still-present fcport instead (I am guessing because the old and new
fcports share the same portid and loopid).  After fabric_logout() messes
up the new fcport, the target-mode HBA returns CTIO_PORT_LOGGED_OUT for
any new incoming commands from the initiator.

The problem can be avoided by waiting 30 seconds after unplugging the
cable before plugging it back in.  But that is not a good solution for
me since these HBAs are to be used in a product sold by my company, and
we want it to "just work" for our customers.

I am very familiar with SCSI but only a little bit with FC, so I am not
exactly sure of the correct fix.  So bear with me while I ask a few
questions: Is it correct for the old and new fcports to share the same
portid and loop_id?  When creating the new fcport, should qla2xxx have
detected that the lost-but-not-yet-dead fcport was using the same portid
and loop_id, and chosen to use different values for the new fcport
instead?  Or should it have invalidated the portid and/or loop_id of the
lost-but-not-yet-dead fcport somewhere (LOOP UP/LOOP DOWN/LIP
reset/etc.)?  Or is it OK for them to share the same portid/loop_id
values, but instead qla2x00_terminate_rport_io() needs more checks
before calling fabric_logout()?

I would be happy to test any patches that anyone can provide.  Or if
someone can provide answers to my questions above or other guidance,
then I can try to come up with a fix myself.


Thanks,
Tony Battersby
Cybernetics

