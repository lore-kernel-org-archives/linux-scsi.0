From: Eddie Williams <eddie.williams@steeleye.com>
Subject: qla2xxx - blocked FC remote port time out: removing target and saving
	binding
Date: Tue, 18 May 2010 10:24:02 -0400
Message-ID: <AANLkTinG6IYyKvYtNMBUpJcYslBmm2_h8iEwp-JYwIdR@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f171.google.com ([209.85.221.171]:60869 "EHLO
	mail-qy0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab0EROYF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2010 10:24:05 -0400
Received: by qyk1 with SMTP id 1so8733815qyk.5
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2010 07:24:04 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

I upgraded an older EM64T server with 2 Qlogic controllers (QLA2340
=46W:v3.03.27 DVR:v8.03.01-k10) to SLES 11 and when a SCSI Bus Reset
(Loop Reset) is issued I get this time out where the driver ends up
removing all devices (causing IO failures for mounted file systems and
the like) and then rescaning to add the devices back.=A0 I verified tha=
t
with the latest stable kernel (2.6.33.4) I see similar behavior
(though the new kernel recovery much quicker).=A0 If I go back to an
older boot disk with Red Hat EL 4 that kernel/driver will issue a
reset without any issues, aka no port time out or loss of connection
to the storage.

I have tried similar tests on different servers connected to the same
=46C switch/storage as well as servers connected to different storage
without seeing this behavior.

output to /var/log/messages:

May 14 11:18:14 goofy kernel: qla2xxx 0000:06:01.0: scsi(2:2:15): LOOP
RESET ISSUED.
May 14 11:18:34 goofy kernel:=A0 rport-2:0-4: blocked FC remote port
time out: removing target and saving binding
May 14 11:18:34 goofy kernel: sd 2:0:2:1: [sdv] Synchronizing SCSI cach=
e
May 14 11:18:34 goofy multipathd: sdv: remove path (uevent)
May 14 11:19:04 goofy kernel:=A0 rport-2:0-2: blocked FC remote port
time out: removing target and saving binding
May 14 11:19:04 goofy kernel:=A0 rport-2:0-3: blocked FC remote port
time out: removing target and saving binding
May 14 11:19:14 goofy kernel:=A0 rport-2:0-6: blocked FC remote port
time out: removing rport
May 14 11:20:22 goofy LifeKeeper[8115]: RECOVERY class=3Ddisk
event=3Dinqfail name=3D3600508b300902930a83a23d1a2850036 STARTING AT: F=
ri
May 14 11:20:22 EDT 2010
May 14 11:20:23 goofy LifeKeeper[8115]: RECOVERY class=3Ddisk
event=3Dinqfail name=3D3600508b300902930a83a23d1a2850036 ENDING AT: Fri
May 14 11:20:23 EDT 2010
May 14 11:23:14 goofy kernel: qla2xxx 0000:06:01.0:
qla2xxx_eh_bus_reset: reset succeded


What is causing this time out and how can I avoid it?

Eddie Williams
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
