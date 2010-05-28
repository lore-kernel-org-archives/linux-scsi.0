From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: scsi error handler thread seems to run continuously
Date: Fri, 28 May 2010 17:55:32 -0400
Message-ID: <AANLkTim-dZFhUm8IOLwQhNLovBmUxb5AnGYmbYci1YYK@mail.gmail.com>
References: <x49wrunvioi.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55780 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab0E1V4T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 May 2010 17:56:19 -0400
Received: by wyb36 with SMTP id 36so101453wyb.19
        for <linux-scsi@vger.kernel.org>; Fri, 28 May 2010 14:56:17 -0700 (PDT)
In-Reply-To: <x49wrunvioi.fsf@segfault.boston.devel.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-scsi@vger.kernel.org, David Zeuthen <david@fubar.dk>

On Fri, May 28, 2010 at 5:07 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Hi,
>
> If I turn up the scsi logging level to 0xff, I see the following in m=
y
> logs:
>
> May 28 17:04:12 solid kernel: scsi_block_when_processing_errors: rtn:=
 1
> May 28 17:04:12 solid kernel: Waking error handler thread
> May 28 17:04:12 solid kernel: Error handler scsi_eh_1 waking up
> May 28 17:04:12 solid kernel: scsi_eh_1: flush finish cmd: ffff880115=
674580
> May 28 17:04:12 solid kernel: scsi_restart_operations: waking up host=
 to restart
> May 28 17:04:12 solid kernel: Error handler scsi_eh_1 sleeping
> May 28 17:04:12 solid kernel: Waking error handler thread
> May 28 17:04:12 solid kernel: Error handler scsi_eh_1 waking up
> May 28 17:04:12 solid kernel: scsi_eh_1: flush finish cmd: ffff880115=
674580
> May 28 17:04:12 solid kernel: scsi_restart_operations: waking up host=
 to restart
> May 28 17:04:12 solid kernel: Error handler scsi_eh_1 sleeping
> May 28 17:04:12 solid kernel: Waking error handler thread
> May 28 17:04:12 solid kernel: Error handler scsi_eh_1 waking up
> May 28 17:04:12 solid kernel: scsi_eh_1: flush finish cmd: ffff880115=
674580
> May 28 17:04:12 solid kernel: scsi_restart_operations: waking up host=
 to restart
> May 28 17:04:12 solid kernel: Error handler scsi_eh_1 sleeping
> May 28 17:04:12 solid kernel: Waking error handler thread
> May 28 17:04:12 solid kernel: Error handler scsi_eh_1 waking up
> May 28 17:04:12 solid kernel: scsi_eh_1: flush finish cmd: ffff880115=
674580
> May 28 17:04:12 solid kernel: scsi_restart_operations: waking up host=
 to restart
> May 28 17:04:12 solid kernel: Error handler scsi_eh_1 sleeping
> May 28 17:04:12 solid kernel: Waking error handler thread
> May 28 17:04:12 solid kernel: Error handler scsi_eh_1 waking up
> May 28 17:04:12 solid kernel: scsi_eh_1: flush finish cmd: ffff880115=
674580
> May 28 17:04:12 solid kernel: scsi_restart_operations: waking up host=
 to restart
> May 28 17:04:12 solid kernel: Error handler scsi_eh_1 sleeping
> May 28 17:04:12 solid kernel: Waking error handler thread
> May 28 17:04:12 solid kernel: Error handler scsi_eh_1 waking up
> May 28 17:04:12 solid kernel: scsi_eh_1: flush finish cmd: ffff880115=
674580
> May 28 17:04:12 solid kernel: scsi_restart_operations: waking up host=
 to restart
> May 28 17:04:12 solid kernel: Error handler scsi_eh_1 sleeping
> May 28 17:04:12 solid kernel: scsi_block_when_processing_errors: rtn:=
 1
>
> Is this expected? =A0Any ideas on what might be causing it? =A0It's w=
orth
> noting that Mike Snitzer tried this on a scsi_debug device and saw th=
e
> same thing.

Chatting with James on #storage we arrived at the fact that in my case
the error handler was being triggered by: hald-addon-storage: polling
/dev/sr0 (every 16 sec)

Killing hald-addon-storage stops the 16s periodic scsi error handler me=
ssages.

Turning debugging up (0xffffffff) shows:

Error handler scsi_eh_1 sleeping
sr 1:0:0:0: Done: 0xffff88007a8eb280 TIMEOUT
sr 1:0:0:0: Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_OK
sr 1:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
sr 1:0:0:0: scsi host busy 1 failed 0
Waking error handler thread
Error handler scsi_eh_1 waking up
scsi_eh_1: flush finish cmd: ffff88007a8eb280
sr 1:0:0:0: Notifying upper driver of completion (result 8000002)
0 sectors total, 0 bytes done.
scsi_restart_operations: waking up host to restart
sr 1:0:0:0: Send: 0xffff88007a8eb280
sr 1:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
buffer =3D 0x(null), bufflen =3D 0, queuecommand 0xffffffff812a8d15
leaving scsi_dispatch_cmnd()
Error handler scsi_eh_1 sleeping
sr 1:0:0:0: Done: 0xffff88007a8eb280 TIMEOUT
sr 1:0:0:0: Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_OK
sr 1:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
sr 1:0:0:0: scsi host busy 1 failed 0
Waking error handler thread
Error handler scsi_eh_1 waking up
scsi_eh_1: flush finish cmd: ffff88007a8eb280
sr 1:0:0:0: Notifying upper driver of completion (result 8000002)
0 sectors total, 0 bytes done.
scsi_restart_operations: waking up host to restart
sr 1:0:0:0: Send: 0xffff88007a8eb280
sr 1:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
buffer =3D 0x(null), bufflen =3D 0, queuecommand 0xffffffff812a8d15
leaving scsi_dispatch_cmnd()
Error handler scsi_eh_1 sleeping
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
