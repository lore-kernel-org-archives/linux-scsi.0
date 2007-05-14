From: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: why does x86 "make defconfig" build a single, lonely module?
Date: Mon, 14 May 2007 17:30:57 +0530
Message-ID: <a781481a0705140500q32a891d6g69b40c2d45ec40c6@mail.gmail.com>
References: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain>
	 <20070513160608.GA29024@redhat.com>
	 <1179072655.3723.42.camel@mulgrave.il.steeleye.com>
	 <1179073116.3723.45.camel@mulgrave.il.steeleye.com>
	 <a781481a0705140235h6a96563cw63ed2c7a85a4f736@mail.gmail.com>
	 <a781481a0705140245s6823df32l5bbf81abf92b0347@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.179]:47703 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966086AbXENMBA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 May 2007 08:01:00 -0400
Received: by ik-out-1112.google.com with SMTP id b35so1060386ika
        for <linux-scsi@vger.kernel.org>; Mon, 14 May 2007 05:00:58 -0700 (PDT)
In-Reply-To: <a781481a0705140245s6823df32l5bbf81abf92b0347@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Dave Jones <davej@redhat.com>, "Robert P. J. Day" <rpjday@mindspring.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Hello,

> > [...]
> >  config SCSI_WAIT_SCAN
> >         tristate
> > -       default m
> > -       depends on SCSI
> > -       depends on MODULES
> > +       default m if SCSI=m
> > +       default n
>
> Note that this also means SCSI_WAIT_SCAN=n (will not get compiled
> and built even as a module) if SCSI=y. But this is perfectly fine, because
> I see:
>
> #ifndef MODULE
> late_initcall(scsi_complete_async_scans);
> #endif
>
> in drivers/scsi/scsi_scan.c anyway, so the async scans will be waited
> upon and get complete even when SCSI=y and scsi_scan_type=async,
> i.e. you don't really need the scsi_wait_scan module in that case anyway.

It seems there is a:

late_initcall(wait_scan_init);

in drivers/scsi/scsi_wait_scan.c too. So we can get rid of the redundant:

#ifndef MODULE
late_initcal(scsi_complete_async_scans);
#endif

in drivers/scsi/scsi_scan.c by enforcing SCSI_WAIT_SCAN=y when
SCSI=y (and =m when SCSI=m).

I guess this is probably the behaviour that James wanted originally?

Anyway, attached patch (subsumes previous one) cleans up all this.
Now, scsi_wait_scan is the only guy who controls waiting upon async
scans to complete:

If SCSI=n, SCSI_WAIT_SCAN=n, obviously.

If SCSI=y, SCSI_WAIT_SCAN=y, so it gets built-in and is run at
late_initcall.

If SCSI=m, SCSI_WAIT_SCAN=m too and would hopefully be run
by the initrd/initramfs scripts to wait for async SCSI bus scans to
finish before allowing the boot to proceed.

[ Attached patch does _not_ expose SCSI_WAIT_SCAN to the
user at kernel configuration time, so if somebody wants it to be
built as a module even when SCSI=y (why would anybody
want that, doesn't make much sense to me to modprobe
scsi_wait_scan _after_ boot-up), it would not be possible to
do so. But if someone really wants that, let me know, we can
add a depends, tristate "..." and help in this Kconfig option to
accomplish that too. ]

Thanks,
Satyam

Signed-off-by: Satyam Sharma <satyam.sharma@gmail.com>

---

 drivers/scsi/Kconfig     |    5 +++--
 drivers/scsi/scsi_scan.c |    5 +----
 2 files changed, 4 insertions(+), 6 deletions(-)

---

diff -ruNp a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig	2007-05-10 23:19:32.000000000 +0530
+++ b/drivers/scsi/Kconfig	2007-05-14 17:37:27.000000000 +0530
@@ -243,9 +243,10 @@ config SCSI_SCAN_ASYNC

 config SCSI_WAIT_SCAN
 	tristate
-	default m
 	depends on SCSI
-	depends on MODULES
+	default y if SCSI=y
+	default m if SCSI=m
+	default n

 menu "SCSI Transports"
 	depends on SCSI
diff -ruNp a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	2007-05-14 16:06:43.000000000 +0530
+++ b/drivers/scsi/scsi_scan.c	2007-05-14 16:10:34.000000000 +0530
@@ -184,14 +184,11 @@ int scsi_complete_async_scans(void)
 /* Only exported for the benefit of scsi_wait_scan */
 EXPORT_SYMBOL_GPL(scsi_complete_async_scans);

-#ifndef MODULE
 /*
  * For async scanning we need to wait for all the scans to complete before
  * trying to mount the root fs.  Otherwise non-modular drivers may not be ready
- * yet.
+ * yet.  This is done by scsi_wait_scan.
  */
-late_initcall(scsi_complete_async_scans);
-#endif

 /**
  * scsi_unlock_floptical - unlock device via a special MODE SENSE command
