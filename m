From: Grant Grundler <grundler@google.com>
Subject: Re: [PATCH] Forcing capacity sizes for block devices
Date: Mon, 21 Dec 2009 12:04:03 -0800
Message-ID: <da824cf30912211204jc70fc10ta6f6de1208d2b364@mail.gmail.com>
References: <2f83750a0912200405v77f39a7eifef024cc4cb10a20@mail.gmail.com>
	 <200912201843.40169.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:49446 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbZLUUEG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2009 15:04:06 -0500
Received: from wpaz1.hot.corp.google.com (wpaz1.hot.corp.google.com [172.24.198.65])
	by smtp-out.google.com with ESMTP id nBLK45oD019023
	for <linux-scsi@vger.kernel.org>; Mon, 21 Dec 2009 12:04:05 -0800
Received: from fg-out-1718.google.com (fgg16.prod.google.com [10.86.7.16])
	by wpaz1.hot.corp.google.com with ESMTP id nBLK44St018513
	for <linux-scsi@vger.kernel.org>; Mon, 21 Dec 2009 12:04:04 -0800
Received: by fg-out-1718.google.com with SMTP id 16so6353330fgg.14
        for <linux-scsi@vger.kernel.org>; Mon, 21 Dec 2009 12:04:03 -0800 (PST)
In-Reply-To: <200912201843.40169.bzolnier@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Clemens Fruhwirth <clemens@endorphin.org>, linux-scsi@vger.kernel.org

On Sun, Dec 20, 2009 at 9:43 AM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> On Sunday 20 December 2009 01:05:35 pm Clemens Fruhwirth wrote:
>> Make the size attribute of block devices writable via sysfs. This
>> allows userspace to force
>> device boundaries in cases where the device driver is unable to detect
>> the correct size, as
>> with spec-incompliant SD card readers. Also see
>> http://marc.info/?t=125555550200010&r=1&w=2
>
> Just a wild idea but maybe the current block infrastructure for handling
> ATA HPA (see commit db429e9 and e957b60 one) can be used to automatically
> detect and workaround the issue?

Are you referring to this change?
+       libata.ignore_hpa=      [LIBATA] Ignore HPA limit
+                       libata.ignore_hpa=0       keep BIOS limits (default)
+                       libata.ignore_hpa=1       ignore limits, using full disk

My git-foo isn't very good...what command will display the two changes
you refer to above?

Looking at latest drivers/ata/libata-core.c where ignore_hpa is used,
that could be leveraged. Clemens will have to comment on if there is a
"detect" method that would work for his problem.

Secondly, the "ignore_hpa" approach is orthogonal to allowing user space
to override the partition size.  This patch does not prevent the kernel from
attempting to fix up the partition/block size. If the kernel can't or
doesn't know
about b0rked HW, the user (or udev maybe?) can workaround this issue.
Given how simple the patch, I don't see any reason to reject it.

thanks,
grant
