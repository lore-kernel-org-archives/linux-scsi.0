From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [Bug 13311] New: mptsas: ioc0: removing ssp device, kernel oops
Date: Thu, 28 May 2009 13:54:05 +0200
Message-ID: <ac3eb2510905280454p1cdcbf0cxbb8e2907209ae974@mail.gmail.com>
References: <bug-13311-11613@http.bugzilla.kernel.org/> <20090528010038.b4d3b2b9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:63251 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbZE1LyT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2009 07:54:19 -0400
Received: by bwz22 with SMTP id 22so5376110bwz.37
        for <linux-scsi@vger.kernel.org>; Thu, 28 May 2009 04:54:20 -0700 (PDT)
In-Reply-To: <20090528010038.b4d3b2b9.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mike.tummy@gmail.com, linux-scsi@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org, Greg KH <greg@kroah.com>

On Thu, May 28, 2009 at 10:00, Andrew Morton <akpm@linux-foundation.org=
> wrote:

>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Product: SCSI Drivers
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Version: 2.5
>> =C2=A0 =C2=A0 Kernel Version: 2.6.27.21
>
> Is it reproducible? =C2=A0If so, is there any change that it can be r=
etested
> under a 2.6.29-based kernel?

This driver version:
  MPT_LINUX_VERSION_COMMON       "4.00.43.00suse"
seems not in the upstream kernel:
  MPT_LINUX_VERSION_COMMON       "3.04.07"

The failing code is only in the new driver. This bug should move to
the Novell bugzilla, so the people who added the driver to the SUSE
kernel can check with LSI directly.

> OK, I assume that the scsi driver did something bad to sysfs and
> that sysfs then fell on its face.
>
> Really, given the frequency and imaginativeness with which drivers
> abuse sysfs, the driver-core should be more robust.
>
> Kay, would you have time to plunk through this and see if we can
> strengthen the sysfs code a bit so it doesn't crash?

Might be a missing lock/wrong refcounting issue in the caller, where
two threads try to remove the same thing. With Eric's upcoming changes
to the cleanup logic in sysfs, this should be handled better.

Thanks,
Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
