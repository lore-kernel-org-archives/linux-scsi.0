From: Douglas Gilbert <dougg@torque.net>
Subject: Re: SG_IO open flags are which
Date: Thu, 18 Dec 2003 13:41:07 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FE121D3.6050300@torque.net>
References: <1071506381.3389.22.camel@patibmrh9>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:49419 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S264927AbTLRDrG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Dec 2003 22:47:06 -0500
In-Reply-To: <1071506381.3389.22.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

Pat LaVarre wrote:
> Doug G:
> 
> What open flags should apps use to talk SG_IO?
> 
> O_RDWR?  O_RDONLY?  O_NONBLOCK?  Other?  Combination?
> 
> Wrong info in Google includes:
> 
> 
>>List: linux-scsi
>>Date: 2003-12-03 0:17:56
>>Re: sg utils sg_io -i 0x24 -y "12 00:00:00 24 00"
>>...
>>
>>>>- O_RDWR
>>>>+ O_RDONLY|O_NONBLOCK
>>>
>>>... not from reading a document anywhere ...
>>
>>...
>>Possibly we recommend open O_NONBLOCK for SG_IO ...
>>Evidence in favour ... includes ...
>>From: linux-2.6.0-test11/Documentation/cdrom/cdrom-standard.tex
>>...
>>1997/12/28 ... propose ... $O_NONBLOCK$ to indicate
>>that the device is opened just for issuing $ioctl$
>>commands.
> 
> 
> Wrong guess, if we try 2.6.0-test11 with the three commands:
> 
> -i x24 -y "12 00:00:00 24 00" // standard Inquiry
> -y "1B 00:00:00 00 00" // Stop Unit
> -y "1B 00:00:00 01 00" // Start Unit
> 
> Either open O_NONBLOCK or open O_RDWR allows pass thru of standard
> Inquiry.  And open O_RDWR allows pass thru of Stop Unit.  But open
> O_NONBLOCK rejects pass thru of Stop Unit:
> 
> $ sudo plscsi /dev/sg0 -x "1B 00:00:00 00 00"
> ...
> $ grep -i 'Operation not permitted' /usr/include/asm/errno.h
> #define EPERM            1      /* Operation not permitted */
> $
> 
> Perhaps lk has no open that allows all of SG_IO without closing trays,
> spinning up discs, etc.?  If we do face that limit, then often we can
> settle for O_NONBLOCK to list device names (e.g. sg_scan) and O_RDWR
> otherwise (e.g. sg_dd).
> 
> Wish I knew where in the lk source we're choosing to have the privilege
> of the open vary the transparency of the pass thru.

Pat,
The implementation of open() is found in the driver that "owns"
the device name (e.g. /dev/hdc or /dev/st0m). The same is true
for ioctl() [and read()/write() for char devices].

Therefore the exact action of the O_NONBLOCK flag given to
an open() differs. Broadly speaking the interpretation is the
same: "let me in". For drivers that often encounter removable
media, a simple open() will fail if no media is present
(e.g. st yields EIO while sr/ide-cd yield ENOMEDIUM). In the
case of sg it won't wait for the O_EXCL lock to clear (rather
it yields EBUSY) and sidesteps error processing waits which is
arguably risky. For pass through purposes you should set O_NONBLOCK
as it can't hurt (e.g. sd ignores it and yields ENOMEDIUM if there
is no media (which looks wrong)).

Unix/Linux will only allow a non-root user to open() a file O_RDWR
that they have "rw" permissions for (so individual drivers have no
control over that). The "w" permissions is needed to call write()
but not to call ioctl(). Historically the sg driver output metadata
(including the SCSI command) with a write() and got the results with
a read(). That meant "rw" permissions and O_RDWR were needed. Then
the SG_IO ioctl came along in lk 2.4. The sg driver will only allow
the following SCSI commands through if the file was opened O_RDONLY:
   TEST_UNIT_READY
   REQUEST_SENSE
   INQUIRY
   READ_CAPACITY
   READ_BUFFER
   READ_6
   READ_10
   READ_12
   MODE_SENSE
   MODE_SENSE_10
   LOG_SENSE

Perhaps READ_16, SERVICE_IN and MAINTENANCE_IN should be added
to that list. The idea is to inhibit changing the state of
a device when it is opened O_RDONLY. START_STOP is definitely
_not_ on the list. The SG_IO ioctl() found in block/scsi_ioctl.c
does not have this restriction so you can issue any SCSI
commands when /dev/sda, for example, is opened O_RDONLY.

So first try and open() with the (O_NONBLOCK | O_RDWR) flags.
If that yields ENOMEDIUM look for the corresponding sg
device name. If the initial open() yields EROFS or EACESS then
try to open it (O_NONBLOCK | O_RDONLY). ...

Confused enough yet :-)

Doug Gilbert


