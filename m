From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: SYNCHRONIZE CACHE command from sd on close
Date: Fri, 19 Feb 2010 01:20:25 +0100
Message-ID: <4B7DD949.3010907@interlog.com>
References: <4B79460A.7040207@interlog.com> <20100215132502.GA15360@infradead.org> <4B79515A.6020507@interlog.com> <20100215224847.GA2490@infradead.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:56885 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923Ab0BSAUd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2010 19:20:33 -0500
In-Reply-To: <20100215224847.GA2490@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, =?UTF-8?B?RGFuIEhv?= =?UTF-8?B?csOhaw==?= <dhorak@redhat.com>

Christoph Hellwig wrote:
> On Mon, Feb 15, 2010 at 02:51:22PM +0100, Douglas Gilbert wrote:
>> What about O_NONBLOCK (which stops a hang on open)?
>> The open code common to my utilities in Linux is
>> below.
> 
> No, O_NONBLOCK should have nothing to do with it and your code
> snipplet looks fine.  We'll need to figure out what's really going
> on here.

Forget SYNCHRONIZE CACHE, the pass-through interface via
sd looks completely stupid when opened RW.

   'modprobe scsi_debug opts=1'
shows all SCSI commands sent to a device (dev/sdb in this
case).

   # sg_start --stop --readonly /dev/sdb
does the expected:
     scsi_debug: cmd 1b 00 00 00 00 00


but remove that '--readonly' and /dev/sdb is opened RW
with this command:
   # sg_start --stop /dev/sdb
then scsi_debug reports this load (of crap):
     scsi_debug: cmd 1b 00 00 00 00 00
     scsi_debug: cmd 12 00 00 00 fe 00
     scsi_debug: cmd 12 01 00 00 fe 00
     scsi_debug: cmd 12 01 83 00 fe 00
     scsi_debug: cmd 28 00 00 00 00 00 00 01 00 00
     scsi_debug: cmd 28 00 00 00 00 00 00 00 08 00
     scsi_debug: cmd 28 00 00 00 00 00 00 00 20 00
     scsi_debug: cmd 28 00 00 00 00 00 00 00 08 00
     scsi_debug: cmd 28 00 00 00 00 00 00 00 08 00

So send a START_STOP_UNIT(stop) through the SG_IO
ioctl on a sd device opened RW and as a bonus get
three INQUIRYs (one standard, two VPD pages) and 5 READ
commands!

If the device is SCSI (as the scsi_debug driver is
simulating) then those READs fail because the drive
is stopped. However if that is an ATA disk behind a
SAT layer, then the disk will be spun up. That defeats
the purpose of the pass-though, especially when it
is being used to spin down the disk.

My guess, reviewing the bug reports flowing into me is
that this nonsense started around lk 2.6.29 .

Please fix.

Doug Gilbert
