From: Mark Harvey <mark.harvey@veritas.com>
Subject: Kernel deadlock ??
Date: Wed, 16 Feb 2005 22:03:04 -0800
Message-ID: <679DD756E54E6A4FB53BBF741A8D5BA79330DD@sydxchmb1.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Received: from bay-bridge.veritas.com ([143.127.3.10]:43616 "EHLO
	MTVMIME03.enterprise.veritas.com") by vger.kernel.org with ESMTP
	id S261874AbVBQGDM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 01:03:12 -0500
Received: from mtvxch15.enterprise.veritas.com (unverified) by MTVMIME03.enterprise.veritas.com
 (Content Technologies SMTPRS 4.3.12) with ESMTP id <T6f299af5a60a8911555ac@MTVMIME03.enterprise.veritas.com> for <linux-scsi@vger.kernel.org>;
 Wed, 16 Feb 2005 22:03:11 -0800
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi One and all,

Apologies if this is the wrong place/list. My first attempt into kernel
level programming.

First a little overview of what I'm attempting:
I have used 'scsi-debug' as a basis for a pseudo SCSI Tape/Library.

i.e.
- It registers a couple of tape devices and a library with the operating
system.
- It also registers a char device.
- A user space daemon reads/writes data via the char device interface
for SCSI write/reads via the /dev/st, /dev/sg....

While it is in a very rough state, I do have basic functionality there.
I can 'tar cvf /dev/st0 /etc/motd' & 'tar tvf /dev/st0' OK.

My problem is when I attempt to pump more data thru, I get a kernel
deadlock/freeze.
The system freeze is not consistent. Sometimes I can back up all of
/etc. Other times it freezes after a couple of files.

Q. Any suggestions on the best way to go about determining what/where
would be causing the lockup ?


More details:
I've implemented a 'variable block SCSI write/read' commands.
resp_read_ssc() & resp_write_ssc() using the scsi-debug's
resp_read()/resp_write() as a basis.
I'm using the kfifo introduced in 2.6.10 as by fifo.
i.e.
 Data written to the char device -> kfifo -> resp_read_ssc()
 Data read from the char device <- kfifo -< resp_write_ssc()

As a test, I've read/written many megabytes of data from user space
to/from fifo via the char device interface with no lockup or indication
of memory leaks (that I can detect).

I do not really understand what is occurring in
'fill_from_dev_buffer()/fetch_to_dev_buffer()' routines.

I also do not understand what 'Rusty Russel refers to as being in user
context (Unreliable Guide to Hacking the Linux kernel)' Chapter 5:
Recipes for Deadlock.

Any assistance and/or guidance welcome.

Regards
Mark Harvey


