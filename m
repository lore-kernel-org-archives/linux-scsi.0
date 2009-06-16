From: walt <w41ter@gmail.com>
Subject: Re: Question about scsi device names
Date: Tue, 16 Jun 2009 16:26:58 -0700
Message-ID: <h199nr$g7a$1@ger.gmane.org>
References: <h0s7tv$d8f$1@ger.gmane.org> <a43edf1b0906161235h124f3ca0y6f62419c38fcaa84@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:44931 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755660AbZFPX1D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Jun 2009 19:27:03 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1MGi3T-0003Kr-8N
	for linux-scsi@vger.kernel.org; Tue, 16 Jun 2009 23:27:03 +0000
Received: from adsl-69-234-184-132.dsl.irvnca.pacbell.net ([69.234.184.132])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2009 23:27:03 +0000
Received: from w41ter by adsl-69-234-184-132.dsl.irvnca.pacbell.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2009 23:27:03 +0000
In-Reply-To: <a43edf1b0906161235h124f3ca0y6f62419c38fcaa84@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Billy Crook wrote:
> ... the letter naming of block
> devices in /dev/ is arbitrary and should be presumed unreliable.  It
> is dependant on the order in which the devices were detected.  In your
> case, it is likely that modules are being loaded in another order than
> before.  This could happen for a variety of reasons including module
> renames, removals, or additions.
>
> To reliably reference block devices, use LABEL=, or UUID= in fstab, or
> /dev/disk/by-*/* anywhere else...

Thanks, that's helpful info.  The reason this came up is that the sata
disk on the onboard controller is the boot disk, and it's annoying to
have the boot fail because the ESATA disk is powered on or off, as the
case may be.

The kernel chooses the root partition based on its own value of rdev,
I believe, and that's what I'm trying to set properly.  I've been trying
various different combos of the label and /dev/disk/foo/bar but in the
end rdev just winds up being /dev/sda or /dev/sdb, regardless of what I
type.

Do you know of any way to get around this problem?

Thanks!


> On Thu, Jun 11, 2009 at 19:36, walt<w41ter@gmail.com>  wrote:

>> I have a machine with two sata disks, one connected to the
>> onboard sata controller, the other to an add-on ESATA board
>> plugged into the PCIX slot.
>>
>> When I boot a kernel from the 2.6.28 series, the onboard
>> controller's disk gets dubbed /dev/sdb, and the ESATA disk
>> is /dev/sda.
>>
>> When I boot the same machine with a more recent kernel like
>> Linus's 2.6.30 series, the device names are reversed...

