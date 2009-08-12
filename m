From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Subject: Re: [Fwd: Bug#539406: linux-image-2.6.30-1-alpha-smp: fails to load
	fw for 1st scsi adapter]
Date: Wed, 12 Aug 2009 14:42:48 +0530
Message-ID: <aa5953d60908120212o63d0c914oeb1eeb0f01938af7@mail.gmail.com>
References: <1250042330.23880.44.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:37634 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260AbZHLJMr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2009 05:12:47 -0400
Received: by pzk34 with SMTP id 34so4044835pzk.4
        for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2009 02:12:48 -0700 (PDT)
In-Reply-To: <1250042330.23880.44.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 539406@bugs.debian.org, ben@decadent.org.uk
Cc: linux-scsi@vger.kernel.org, David.Woodhouse@intel.com

Hello Ben,

On Wed, Aug 12, 2009 at 7:28 AM, Ben Hutchings<ben@decadent.org.uk> wro=
te:
> There is a bug in the firmware loading code in qla1280, as reported
> below: it calls request_firmware() while holding a spinlock. =A0I thi=
nk
> that it needs to drop ha->host->host_lock around the call to
> request_firmware() but I'm not sure that's correct.
>

Yes, you are right, we need to unlock while requesting firmware. But
qla1280_mailbox_command() again needs the lock.

I am sorry, currently I do not have access to this hardware, can you
please test it.

Thanks for your help,
--
JSR

> Ben.
>
> -------- Forwarded Message --------
> From: R. Scott Bailey <scott.bailey@eds.com>
> Reply-to: "R. Scott Bailey" <scott.bailey@eds.com>, 539406@bugs.debia=
n.org
> To: Debian Bug Tracking System <submit@bugs.debian.org>
> Subject: Bug#539406: linux-image-2.6.30-1-alpha-smp: fails to load fw=
 for 1st scsi adapter
> Date: Fri, 31 Jul 2009 11:36:38 -0400
>
> Package: linux-image-2.6.30-1-alpha-smp
> Version: 2.6.30-2
> Severity: important
>
> Well, the firmware loading logic has been flaky on my system for a fe=
w
> releases now. I previously reported bug 527265 against 2.6.29, where =
the
> qla1040 firmware would not load at all, and that was resolved in a la=
ter
> 2.6.29 image.
>
> In this release (2.6.30-2) I get new/different bad behavior. My syste=
m
> has three QLA1040 cards in it. In the attached console output from th=
e boot,
> notice that at time 23.256824, the first adapter (scsi0) is located,
> generates a stack trace trying to load firmware, and fails to initial=
ize
> the card. (There goes my tape drive!) A little later, at 83.499957, t=
he
> second adapter is found and this time the firmware loads fine. Ditto =
for
> the third adapter after that.
>
> -- Package-specific info:
>
> -- System Information:
> Debian Release: 5.0.2
> Architecture: alpha
>
> Kernel: Linux 2.6.29-2-alpha-smp (SMP w/1 CPU core)
> Locale: LANG=3DC, LC_CTYPE=3DC (charmap=3DANSI_X3.4-1968)
> Shell: /bin/sh linked to /bin/bash
>
> Versions of packages linux-image-2.6.30-1-alpha-smp depends on:
> ii =A0debconf [debconf-2.0] =A0 =A0 =A0 =A0 1.5.24 =A0 =A0 Debian con=
figuration management sy
> ii =A0initramfs-tools [linux-initra 0.92o =A0 =A0 =A0tools for genera=
ting an initramfs
> ii =A0module-init-tools =A0 =A0 =A0 =A0 =A0 =A0 3.4-1 =A0 =A0 =A0tool=
s for managing Linux kernel mo
>
> linux-image-2.6.30-1-alpha-smp recommends no packages.
>
> Versions of packages linux-image-2.6.30-1-alpha-smp suggests:
> ii =A0aboot =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A01.0~pre20040408-3 Linu=
x bootloader for the SRM conso
> ii =A0fdutils =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A05.5-20060227-3 =A0 =A0Li=
nux floppy utilities
> pn =A0linux-doc-2.6.30 =A0 =A0 =A0 <none> =A0 =A0 =A0 =A0 =A0 =A0(no =
description available)
>
> -- debconf information:
> =A0linux-image-2.6.30-1-alpha-smp/postinst/depmod-error-initrd-2.6.30=
-1-alpha-smp: false
> =A0linux-image-2.6.30-1-alpha-smp/postinst/create-kimage-link-2.6.30-=
1-alpha-smp: true
> =A0linux-image-2.6.30-1-alpha-smp/preinst/lilo-initrd-2.6.30-1-alpha-=
smp: true
> =A0linux-image-2.6.30-1-alpha-smp/preinst/abort-install-2.6.30-1-alph=
a-smp:
> =A0linux-image-2.6.30-1-alpha-smp/postinst/depmod-error-2.6.30-1-alph=
a-smp: false
> =A0linux-image-2.6.30-1-alpha-smp/prerm/removing-running-kernel-2.6.3=
0-1-alpha-smp: true
> =A0linux-image-2.6.30-1-alpha-smp/prerm/would-invalidate-boot-loader-=
2.6.30-1-alpha-smp: true
> =A0linux-image-2.6.30-1-alpha-smp/postinst/bootloader-test-error-2.6.=
30-1-alpha-smp:
> =A0linux-image-2.6.30-1-alpha-smp/preinst/initrd-2.6.30-1-alpha-smp:
> =A0linux-image-2.6.30-1-alpha-smp/postinst/kimage-is-a-directory:
> =A0shared/kernel-image/really-run-bootloader: true
> =A0linux-image-2.6.30-1-alpha-smp/preinst/lilo-has-ramdisk:
> =A0linux-image-2.6.30-1-alpha-smp/preinst/elilo-initrd-2.6.30-1-alpha=
-smp: true
> =A0linux-image-2.6.30-1-alpha-smp/preinst/overwriting-modules-2.6.30-=
1-alpha-smp: true
> =A0linux-image-2.6.30-1-alpha-smp/postinst/bootloader-error-2.6.30-1-=
alpha-smp:
> =A0linux-image-2.6.30-1-alpha-smp/preinst/abort-overwrite-2.6.30-1-al=
pha-smp:
> =A0linux-image-2.6.30-1-alpha-smp/preinst/bootloader-initrd-2.6.30-1-=
alpha-smp: true
> =A0linux-image-2.6.30-1-alpha-smp/postinst/old-initrd-link-2.6.30-1-a=
lpha-smp: true
> =A0linux-image-2.6.30-1-alpha-smp/postinst/old-dir-initrd-link-2.6.30=
-1-alpha-smp: true
> =A0linux-image-2.6.30-1-alpha-smp/postinst/old-system-map-link-2.6.30=
-1-alpha-smp: true
> =A0linux-image-2.6.30-1-alpha-smp/preinst/failed-to-move-modules-2.6.=
30-1-alpha-smp:
>
> --
> Ben Hutchings
> Unix is many things to many people,
> but it's never been everything to anybody.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
