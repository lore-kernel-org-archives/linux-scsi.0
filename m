From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: Question about scsi device names
Date: Wed, 17 Jun 2009 10:19:58 -0400
Message-ID: <20090617141958.GB22727@mars.virtualiron.com>
References: <h0s7tv$d8f$1@ger.gmane.org> <a43edf1b0906161235h124f3ca0y6f62419c38fcaa84@mail.gmail.com> <h199nr$g7a$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host-216-57-134-2.customer.veroxity.net ([216.57.134.2]:56475
	"EHLO mars.virtualiron.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753544AbZFQOej (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Jun 2009 10:34:39 -0400
Content-Disposition: inline
In-Reply-To: <h199nr$g7a$1@ger.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: walt <w41ter@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Jun 16, 2009 at 04:26:58PM -0700, walt wrote:
> Billy Crook wrote:
>> ... the letter naming of block
>> devices in /dev/ is arbitrary and should be presumed unreliable.  It
>> is dependant on the order in which the devices were detected.  In your
>> case, it is likely that modules are being loaded in another order than
>> before.  This could happen for a variety of reasons including module
>> renames, removals, or additions.
>>
>> To reliably reference block devices, use LABEL=, or UUID= in fstab, or
>> /dev/disk/by-*/* anywhere else...
>
> Thanks, that's helpful info.  The reason this came up is that the sata
> disk on the onboard controller is the boot disk, and it's annoying to
> have the boot fail because the ESATA disk is powered on or off, as the
> case may be.
>
> The kernel chooses the root partition based on its own value of rdev,

Which on most distros is the initrd image (/dev/ram0)?

You _need_ to have an initrd image. Then rdev points to (1,0 -
/dev/ram0) and executes the /init process which takes care of scaning
the disks for the labels and pivots in a root filesystem depending on the label
(or the LVM if that is there).
