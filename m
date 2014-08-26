From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: RES: RES: AS2105-based enclosure size issues with >2TB HDDs
Date: Tue, 26 Aug 2014 09:58:32 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1748130C@AcuExch.aculab.com>
References: <175058921e084d26ba362fa6ecd7351c@serv030.corp.eldorado.org.br>
 <Pine.LNX.4.44L0.1408251613270.1385-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0.aculab.com ([213.249.233.131]:60477 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757186AbaHZKAO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Aug 2014 06:00:14 -0400
Received: from mx0.aculab.com ([127.0.0.1])
 by localhost (mx0.aculab.com [127.0.0.1]) (amavisd-new, port 10024) with SMTP
 id 14483-09 for <linux-scsi@vger.kernel.org>;
 Tue, 26 Aug 2014 11:00:04 +0100 (BST)
In-Reply-To: <Pine.LNX.4.44L0.1408251613270.1385-100000@iolanthe.rowland.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Alan Stern' <stern@rowland.harvard.edu>, Alfredo Dal Ava Junior <alfredo.junior@eldorado.org.br>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Oliver Neukum <oneukum@suse.de>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

From: Alan Stern
> On Mon, 25 Aug 2014, Alfredo Dal Ava Junior wrote:
> 
> > Well, it is causing problems anyway... from user perspective, it's a
> > Linux compatibility issue, as it works "fine" on Windows. I'm not an
> > expert, but I'm wondering that if usb-storage could set capacity as
> > "UNDETERMINED"/ Zero (or keep using the readcapacity_10 as it as with
> > some flag signalizing it as inaccurate), EFI partition check would be
> > able to ignore size and look for secondary GPT where it really is.
> 
> Part of the problem is that usb-storage has no way to know that
> anything strange is going on.  It's normal for READ CAPACITY(16) to
> fail (this depend on the SCSI level), and it's normal for the READ
> CAPACITY(10) to report a value less than 2 TB.

Could the code try READ CAPACITY(16) first?

> Really there is only one way to know whether the actual capacity is
> larger than the reported capacity, and that is by trying to read blocks
> beyond the reported capacity -- a dangerous test that many drives do
> not like.  (And in most cases a futile test.  If a device doesn't
> support READ CAPACITY(16), how likely is it to support READ(16)?)
> 
> Yes, in theory you can believe the value in the partition table in
> preference to the reported capacity.  But what if that value is wrong?
> And how do you tell partition-manager programs what the capacity should
> be when they modify or set up the initial partition table?

I've a feeling that, historically at least, windows believes the partition table.
I remember some CF cards that locked up when I tried to read the 'device info'
sector, and others (apparently identical) that had the 32bit sector size misaligned.
These were 'major manufacturer' cards as well.

	David



