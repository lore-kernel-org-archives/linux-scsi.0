From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] Forcing capacity sizes for block devices
Date: Mon, 21 Dec 2009 22:59:34 +0100
Message-ID: <200912212259.34808.bzolnier@gmail.com>
References: <2f83750a0912200405v77f39a7eifef024cc4cb10a20@mail.gmail.com> <200912201843.40169.bzolnier@gmail.com> <da824cf30912211204jc70fc10ta6f6de1208d2b364@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:54313 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710AbZLUWBu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2009 17:01:50 -0500
Received: by ey-out-2122.google.com with SMTP id 25so108437eya.19
        for <linux-scsi@vger.kernel.org>; Mon, 21 Dec 2009 14:01:49 -0800 (PST)
In-Reply-To: <da824cf30912211204jc70fc10ta6f6de1208d2b364@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: Clemens Fruhwirth <clemens@endorphin.org>, linux-scsi@vger.kernel.org

On Monday 21 December 2009 09:04:03 pm Grant Grundler wrote:
> On Sun, Dec 20, 2009 at 9:43 AM, Bartlomiej Zolnierkiewicz
> <bzolnier@gmail.com> wrote:
> > On Sunday 20 December 2009 01:05:35 pm Clemens Fruhwirth wrote:
> >> Make the size attribute of block devices writable via sysfs. This
> >> allows userspace to force
> >> device boundaries in cases where the device driver is unable to detect
> >> the correct size, as
> >> with spec-incompliant SD card readers. Also see
> >> http://marc.info/?t=125555550200010&r=1&w=2
> >
> > Just a wild idea but maybe the current block infrastructure for handling
> > ATA HPA (see commit db429e9 and e957b60 one) can be used to automatically
> > detect and workaround the issue?
> 
> Are you referring to this change?
> +       libata.ignore_hpa=      [LIBATA] Ignore HPA limit
> +                       libata.ignore_hpa=0       keep BIOS limits (default)
> +                       libata.ignore_hpa=1       ignore limits, using full disk

Nah.

> My git-foo isn't very good...what command will display the two changes
> you refer to above?

git log -p --color db429e9^1..e957b60

We should be able to detect working SD reader/card combination in sd
driver's ->set_capacity method implementation (i.e. by issuing read
request for the last partitioned sector outside of the reported device
capacity) during the initial partition table scan and at the same time
adjust the device capacity used by the kernel if necessary.

New/empty cards would still need to be 'force partitioned' first using
fdisk (or sfdisk if fdisk doesn't allow such operation) but after it's
done the partition rescan on fdisk's exit will recognize new device's
capacity automatically..

> about b0rked HW, the user (or udev maybe?) can workaround this issue.
> Given how simple the patch, I don't see any reason to reject it.

Simple to write or simple to maintain? ;)

To be honest the patch looks like a gross and dangerous hack..

Firstly block layer needs to be properly informed about capacity changes
(set_capacity() + request for partition rescan which the patch doesn't do)
and secondly fixing the problem at the sysfs block/partition layer seems
to be a layering violation (i.e. it also allows partition size changes).

--
Bartlomiej Zolnierkiewicz
