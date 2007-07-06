From: "adam radford" <aradford@gmail.com>
Subject: Re: [PATCH] 3w-xxxx: Add tw_sysfs_init() so udev will create /dev/twe* devices.
Date: Fri, 6 Jul 2007 16:58:29 -0700
Message-ID: <b1bc6a000707061658q15cdf1c6jfe399f6a31112d06@mail.gmail.com>
References: <589382.9788.qm@web37906.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.228]:36417 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbXGFX6a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jul 2007 19:58:30 -0400
Received: by nz-out-0506.google.com with SMTP id s18so353661nze
        for <linux-scsi@vger.kernel.org>; Fri, 06 Jul 2007 16:58:29 -0700 (PDT)
In-Reply-To: <589382.9788.qm@web37906.mail.mud.yahoo.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joshua Daniel Franklin <joshuadfranklin@yahoo.com>
Cc: linux-scsi@vger.kernel.org, linuxraid@amcc.com

On 7/6/07, Joshua Daniel Franklin <joshuadfranklin@yahoo.com> wrote:
> Add tw_sysfs_init() to register 3w-xxxx driver with sysfs. This
> also causes udev to create /dev/twe* devices with the correct
> SELinux security context.
>
> Signed-off-by: Joshua Daniel Franklin <joshuadfranklin@yahoo.com>

Thanks for the patch.

I have one problem with this patch:

You are calling "class_device_create()" from 0 to "TW_MAX_UNITS" which is 16...
shouldn't you be calling this only once per each controller instance
that is discovered
via twa_probe() ?

Also, no other scsi LLDD drivers are calling "class_device_create()",
so I wonder if
this is acceptable to scsi maintainers?

Right now we have our userspace tools creating the /dev/tweX devices.

-Adam
