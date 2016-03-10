From: Tom Yan <tom.ty89@gmail.com>
Subject: Fwd: [PATCH 1/1] sd: do not let LBPME bit stop the VPDs speak
Date: Thu, 10 Mar 2016 16:15:34 +0800
Message-ID: <CAGnHSE=X2Yd3p75D85jcgSUScKxKYZsueLdqMMiaJ_uBqb+XMw@mail.gmail.com>
References: <56df97e0.d08d420a.58e8f.3162@mx.google.com>
	<yq1mvq7qdcy.fsf@sermon.lab.mkp.net>
	<CAGnHSEnHG5i3EvwmcGZU5BXobUCQa7P+j+KKNrUyoS86s7d8Gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:34870 "EHLO
	mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbcCJIPf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Mar 2016 03:15:35 -0500
Received: by mail-yw0-f196.google.com with SMTP id s188so3942617ywe.2
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2016 00:15:35 -0800 (PST)
In-Reply-To: <CAGnHSEnHG5i3EvwmcGZU5BXobUCQa7P+j+KKNrUyoS86s7d8Gg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The outputs were made with an SSD that supports TRIM plugged in:

[tom@localhost ~]$ sudo smartctl --identify=wb /dev/sdc | grep -i trim
  69     14          1   Deterministic data after trim supported
  69      5          1   Trimmed LBA range(s) returning zeroed data supported
 169      0          1   Trim bit in DATA SET MANAGEMENT command supported

[tom@localhost ~]$ sudo smartctl --identify=wb /dev/sdc | grep -i 'ds m'
 105      -     0x0008   Max blocks of LBA Range Entries per DS MANAGEMENT cmd

Both `blkdiscard` with a patched kernel and `sg_unmap` appeared to
have gone well (checked with `hexdump`).

I just couldn't think of a case that the LBPME bit would actually
indicates that the VPDs should not be used. It's merely bad
implementation of Read Capacity (16), which doesn't practically stops
the device from supporting unmap (even if a similar device is has
broken unmap support, it doesn't mean that the vendor set the LBPME
bit to 0 because they want to tell you it's broken, it's just they
have broken unmap support IN ADDITION to a bad Read Capacity (16)
implementation).

Also, doesn't the kernel ASSUME that the device support Write Same
(16) with Unmap bit set when the LBPME bit is 1 even if it has no
Block Limits and Logical Block Provisioning VPDs? Isn't that even more
lenient than what I am proposing?

On 10 March 2016 at 10:24, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Tom" == tom ty89 <tom.ty89@gmail.com> writes:
>
> Tom,
>
> Tom> Some devices have details of their support on unmapping on the
> Tom> Block Limits and/or Logical Block Provisioning VPDs while they do
> Tom> not set the LBPME bit to 1. Though this is required by the SCSI
> Tom> standards, the VPDs are giving even more concrete details about the
> Tom> support, so they should be used even when the bit is set to 0.
>
> I am not going to enable an already brittle feature if a device can't
> report the right thing.
>
> Does the bridge report LBPME=1 if you plug in an SSD?
>
> --
> Martin K. Petersen      Oracle Linux Engineering
