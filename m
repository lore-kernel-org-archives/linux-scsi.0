From: Huajun Li <huajun.li.lee@gmail.com>
Subject: Re: status of oops in sd_revalidate_disk?
Date: Wed, 21 Dec 2011 22:12:31 +0800
Message-ID: <CA+v9cxZFUC45WD0=+8mvH2Tq_xvX3PgaW4ttzPep0jqvqab_6w@mail.gmail.com>
References: <4EE8E419.8010000@pre-sense.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:56107 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab1LUOMc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Dec 2011 09:12:32 -0500
Received: by werm1 with SMTP id m1so2694190wer.19
        for <linux-scsi@vger.kernel.org>; Wed, 21 Dec 2011 06:12:31 -0800 (PST)
In-Reply-To: <4EE8E419.8010000@pre-sense.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Axel Theilmann <theilmann@pre-sense.de>
Cc: linux-scsi@vger.kernel.org, jbottomley@parallels.com, stefanr@s5r6.in-berlin.de, huajun.li.lee@gmail.com

=D4=DA 2011=C4=EA12=D4=C215=C8=D5 =C9=CF=CE=E71:59=A3=ACAxel Theilmann =
<theilmann@pre-sense.de> =A3=BA
>
>
> hi,
>
> two weeks ago Huajun Li posted a patch for a kernel oops, subject [PA=
TCH]
> SCSI/sd: Fix NULL dereference in sd_revalidate_disk".
>
> The patch was discussed but considered "clearly wrong". The bug shows=
 up for
> us in kernel 3.1.4 quite often when unplugging usb sticks and it seem=
s a few
> other people have the same problem:
>
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/859199
> https://bugzilla.redhat.com/show_bug.cgi?id=3D754518
> https://bugzilla.novell.com/show_bug.cgi?id=3D722350
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D649735
>
> Can anyone of you maybe give me any status update on that bug?

It's quiet on this thread. :)

As I mentioned at http://marc.info/?l=3Dlinux-scsi&m=3D132266428023443&=
w=3D2
, sd_open() may return -ENOMEDIUM, then rescan_partitions() and
sd_revalidate_disk() will be triggered in turn, the latter will find
sdkp is NULL. The patch can fix the issue _If_ there is no other
dependency.

Any comments?

Thanks,
--Huajun
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
