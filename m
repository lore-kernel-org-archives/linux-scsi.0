From: Alfredo Dal Ava Junior <alfredo.junior@eldorado.org.br>
Subject: RES: RES: RES: AS2105-based enclosure size issues with >2TB HDDs
Date: Mon, 25 Aug 2014 20:44:22 +0000
Message-ID: <4fb2e797c7f3476f9a00324b61691931@serv030.corp.eldorado.org.br>
References: <175058921e084d26ba362fa6ecd7351c@serv030.corp.eldorado.org.br>
 <Pine.LNX.4.44L0.1408251613270.1385-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.eldorado.org.br ([200.148.226.10]:1149 "EHLO
	smtp1.eldorado.org.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583AbaHYUoc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Aug 2014 16:44:32 -0400
In-Reply-To: <Pine.LNX.4.44L0.1408251613270.1385-100000@iolanthe.rowland.org>
Content-Language: pt-BR
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Oliver Neukum <oneukum@suse.de>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


On Mon, 25 Aug 2014 Alan Stern wrote:
> Part of the problem is that usb-storage has no way to know that anything
> strange is going on.  It's normal for READ CAPACITY(16) to fail (this depend on
> the SCSI level), and it's normal for the READ
> CAPACITY(10) to report a value less than 2 TB.
> Really there is only one way to know whether the actual capacity is larger
> than the reported capacity, and that is by trying to read blocks beyond the
> reported capacity -- a dangerous test that many drives do not like.  (And in
> most cases a futile test.  If a device doesn't support READ CAPACITY(16), how
> likely is it to support READ(16)?)
> Yes, in theory you can believe the value in the partition table in preference to
> the reported capacity.  But what if that value is wrong?
> And how do you tell partition-manager programs what the capacity should be
> when they modify or set up the initial partition table?

We may add this device to UNUSUAL_DEV list, to keep using READ_CAPACITY(10)  and 
pass  some flag to bypass EFI GPT partition check. I'm almost sure that kernel will be able
to mount the partition if we can make it available on /proc/partition. This would make this 
device behaves like it does on Windows 7.

I see this as best effort workaround for a cheap buggy hardware, like many others on
UNUSUAL_DEV list

> Attaching the drive over a SATA connection when you want to partition it
> isn't a very satisfactory solution.  After all, if you have a SATA connection
> available then why would you be using a USB enclosure in the first place?

You may want do a backup or plug it in a laptop, for example.

[]'s
Alfredo
