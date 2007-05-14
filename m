From: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: why does x86 "make defconfig" build a single, lonely module?
Date: Mon, 14 May 2007 15:05:16 +0530
Message-ID: <a781481a0705140235h6a96563cw63ed2c7a85a4f736@mail.gmail.com>
References: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain>
	 <20070513160608.GA29024@redhat.com>
	 <1179072655.3723.42.camel@mulgrave.il.steeleye.com>
	 <1179073116.3723.45.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.181]:14570 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965793AbXENJfS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 May 2007 05:35:18 -0400
Received: by ik-out-1112.google.com with SMTP id b35so1038005ika
        for <linux-scsi@vger.kernel.org>; Mon, 14 May 2007 02:35:17 -0700 (PDT)
In-Reply-To: <1179073116.3723.45.camel@mulgrave.il.steeleye.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Dave Jones <davej@redhat.com>, "Robert P. J. Day" <rpjday@mindspring.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Hi,

On 5/13/07, James Bottomley <James.Bottomley@steeleye.com> wrote:
> On Sun, 2007-05-13 at 11:10 -0500, James Bottomley wrote:
> > > -   depends on SCSI
> > > +   depends on SCSI_SCAN_ASYNC

This is incorrect, alright, but not because of any of the reasons James
mentions below.

The only reason why some module (or Kconfig option) should _depend_
on some other Kconfig option is if (*and only if*) it re-uses _code_
exported by said dependency.

In this particular case, SCSI_SCAN_ASYNC=y/n only controls the
default value of some variable somewhere in SCSI, so no other code
can meaningfully "depend" on it.

> > No.  SCSI_SCAN_ASYNC is a bool ... if you depend on it, you'll force the
> > wait scan to be built in, which isn't the idea at all.

Umm, this isn't true, actually.

> Plus SCSI_SCAN_ASYNC only sets the *default* for async scanning.  You
> can alter this at boot time, so you could need the wait scan module even
> with it set to N.

I think the _correct_ way to handle this situation (and which would make
everyone happy here; Robert can get his module-free builds with defconfig,
James gets his SCSI_WAIT_SCAN module even if nobody asked for it
explicitly) would be as follows:

---

Clean up Kconfig entry for CONFIG_SCSI_WAIT_SCAN.

Signed-off-by: Satyam Sharma <satyam.sharma@gmail.com>

---

 drivers/scsi/Kconfig |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

---

diff -ruNp a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig	2007-05-10 23:19:32.000000000 +0530
+++ b/drivers/scsi/Kconfig	2007-05-14 15:12:46.000000000 +0530
@@ -243,9 +243,8 @@ config SCSI_SCAN_ASYNC

 config SCSI_WAIT_SCAN
 	tristate
-	default m
-	depends on SCSI
-	depends on MODULES
+	default m if SCSI=m
+	default n

 menu "SCSI Transports"
 	depends on SCSI
