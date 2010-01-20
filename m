From: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Subject: [PATCH 0/2] scsi: ftrace based scsi tracing feature
Date: Wed, 20 Jan 2010 15:42:55 +0900
Message-ID: <4B56A5EF.40703@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40256 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab0ATGn0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2010 01:43:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>, lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>, Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>

Hi,

We'd like to propose this patchset (ftrace based scsi tracing)
as the first attempt for SCSI tracing, starting with the minimum
trace points.

Tracing gives us an idea how far SCSI processing goes, for
example, even in a case that a SCSI IRQ handling is blocked by
other drivers that disable interrupts for a long time.  Also,
trace could be used for debugging purpose in development similar
to how USB developers use usbmon for collecting submitted and
completed URBs for debugging.  In a mission critical area, there
is sometimes a case that we have to analyze a problem at customers
without taking a memory dump as much as possible.  There is also
a case to solve a problem which reproducibility is very low (but
we can not just leave the problem) so collecting additional data
afterwards is difficult.

In this version, it prints host#, channel, id, lun, and CDB (and
a value of 'result' if it's called in scsi_done().)  All fields
of CDB are printed in hex, and some of them are printed in ascii
as well.  That makes the outputs be more user-friendly.  For
example, retrieving 'lba' and 'transfer length (txlen)' data from
CDB of "SCSI3 block command READ/WRITE," and printing them in the
friendly format, users can easily correlate the info from SCSI
layer with block layer.  (All the conversions to ascii that requires
relatively large costs are done in TP_printk(), making the overheads
at storing trace be minimum.)

CDB has various lengths for its size and that made us end up
creating __print_hex().

This patchset applies to 2.6.33-rc4.

 ([PATCH 0/2] scsi: ftrace based scsi tracing feature)
  [PATCH 1/2] scsi: add __print_hex() to ftrace
  [PATCH 2/2] scsi: add scsi trace core function and put trace points

Thanks,
Kei




