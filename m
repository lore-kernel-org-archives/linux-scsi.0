From: Billy Crook <billycrook@gmail.com>
Subject: Re: Question about scsi device names
Date: Tue, 16 Jun 2009 14:35:14 -0500
Message-ID: <a43edf1b0906161235h124f3ca0y6f62419c38fcaa84@mail.gmail.com>
References: <h0s7tv$d8f$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:11363 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761563AbZFPTfc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2009 15:35:32 -0400
Received: by yw-out-2324.google.com with SMTP id 5so3091817ywb.1
        for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2009 12:35:34 -0700 (PDT)
In-Reply-To: <h0s7tv$d8f$1@ger.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: walt <w41ter@gmail.com>
Cc: linux-scsi@vger.kernel.org

It's been long enough someone probably already answered you off list,
but just in case you're still wondering, the letter naming of block
devices in /dev/ is arbitrary and should be presumed unreliable.  It
is dependant on the order in which the devices were detected.  In your
case, it is likely that modules are being loaded in another order than
before.  This could happen for a variety of reasons including module
renames, removals, or additions.

To reliably reference block devices, use LABEL=3D, or UUID=3D in fstab,=
 or
/dev/disk/by-*/* anywhere else.

This is particularly useful in SANs or switched storage like FC,
iSCSI, or SAS, where the order individual disks are detected can
realistically change from second to second.

On Thu, Jun 11, 2009 at 19:36, walt<w41ter@gmail.com> wrote:
> Hi list,
>
> Here is some background for my question:
>
> I have a machine with two sata disks, one connected to the
> onboard sata controller, the other to an add-on ESATA board
> plugged into the PCIX slot.
>
> My puzzle:
>
> When I boot a kernel from the 2.6.28 series, the onboard
> controller's disk gets dubbed /dev/sdb, and the ESATA disk
> is /dev/sda.
>
> When I boot the same machine with a more recent kernel like
> Linus's 2.6.30 series, the device names are reversed.
>
> Is this change in behavior expected based on recent kernel
> patches?
>
> Thanks.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
