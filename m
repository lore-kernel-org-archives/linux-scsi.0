From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH 0/2] sg: fix races during device removal (v2)
Date: Mon, 05 Jan 2009 14:07:19 -0500
Message-ID: <49625A67.3000304@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:1608 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbZAETHr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2009 14:07:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@HansenPartnership.com
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

This is version 2 of my patch, this time using a kref instead of int.
There are also a lot of other changes since the first version since I
found even more bugs both through testing and source code analysis.
I have split the patch up into two parts: the first patch fixes
races between open, close, device removal, and command completion.
The second patch fixes some races I spotted in ioctl(SG_IO).

Below are a list of test cases fixed by the patch.

----------

test #1

open /dev/sgX
send a command that takes a long time (e.g. any tape drive seek
command)
before command completes, echo 1 >
/sys/class/scsi_generic/sgX/device/delete

without patch:
oops

with patch:
test program gets ENODEV immediately
keventd sleeps until the cmd is complete
this is suboptimal since it starves other users of keventd while
waiting for the command to complete, but it is better than an oops

----------

test #2

open /dev/sgX
send a command that takes a long time (e.g. any tape drive seek
command) without waiting for it to complete
close fd
before command completes, echo 1 >
/sys/class/scsi_generic/sgX/device/delete

without patch:
oops when the command does complete (sg_rq_end_io() bad pointer deref)

with patch:
keventd sleeps until the cmd is complete
this is suboptimal since it starves other users of keventd while
waiting for the command to complete, but it is better than an oops

----------

test #3

open /dev/sgX
send a command that takes a long time (e.g. any tape drive seek
command) without waiting for it to complete
close fd
rmmod sg

without patch:
rmmod succeeds without waiting for the command to complete
oops when the command does complete (sg_rq_end_io() callback no
longer exists)

with patch:
sg module usage count does not drop to 0 until the command completes,
so cannot rmmod

----------

test #4

open /dev/sgX
loop: send commands, check results
unplug SAS cable
mptsas automatically removes the device and fails active commands
the test program detects the failed commands and closes its fds at
the same time
this results in the following sequence:
sg_remove() enter
sg_release() enter
sg_release() exit
sg_remove() exit

without patch:
oops

with patch:
ok

----------

test #5

open /dev/sgX
loop: send commands, check results
unplug SAS cable
mptsas automatically removes the device and fails active commands
the test program detects the failed commands, but sleeps for a second
before closing its fds
this results in the following sequence:
sg_remove() enter
sg_remove() exit
sg_release() enter
sg_release() exit

without patch:
oops

with patch:
ok


