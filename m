From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PATCH] another tranche of SCSI updates for 2.6.26
Date: Mon, 28 Apr 2008 03:45:40 +0200
Message-ID: <20080428014540.GB10660@elte.hu>
References: <1209320076.3801.26.camel@localhost.localdomain> <20080428013400.GA6245@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:36350 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761852AbYD1Bpv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Apr 2008 21:45:51 -0400
Content-Disposition: inline
In-Reply-To: <20080428013400.GA6245@elte.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>


* Ingo Molnar <mingo@elte.hu> wrote:

> see:
> 
>  http://redhat.com/~mingo/misc/config-Mon_Apr_28_03_01_00_CEST_2008.bad
>  http://redhat.com/~mingo/misc/log-Mon_Apr_28_03_01_00_CEST_2008.bad
> 
> the commits i pulled are below. The tree before that survived 100+ 
> randconfig bootups - this failed after 7 iterations.

did some more digging, regression is not too serious - excluding the ISA 
drivers below did the trick and it now boots up fine. Time to sleep now 
:-/

	Ingo

----------------->
Subject: qa: no scsi aha
From: Ingo Molnar <mingo@elte.hu>
Date: Mon Apr 28 03:34:16 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/scsi/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/drivers/scsi/Kconfig
===================================================================
--- linux.orig/drivers/scsi/Kconfig
+++ linux/drivers/scsi/Kconfig
@@ -406,6 +406,7 @@ config SCSI_ACARD
 config SCSI_AHA152X
 	tristate "Adaptec AHA152X/2825 support"
 	depends on ISA && SCSI && !64BIT
+	depends on 0
 	select SCSI_SPI_ATTRS
 	select CHECK_SIGNATURE
 	---help---
@@ -423,6 +424,7 @@ config SCSI_AHA152X
 config SCSI_AHA1542
 	tristate "Adaptec AHA1542 support"
 	depends on ISA && SCSI && ISA_DMA_API
+	depends on 0
 	---help---
 	  This is support for a SCSI host adapter.  It is explained in section
 	  3.4 of the SCSI-HOWTO, available from
@@ -437,6 +439,7 @@ config SCSI_AHA1542
 config SCSI_AHA1740
 	tristate "Adaptec AHA1740 support"
 	depends on EISA && SCSI
+	depends on 0
 	---help---
 	  This is support for a SCSI host adapter.  It is explained in section
 	  3.5 of the SCSI-HOWTO, available from
