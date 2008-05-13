From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/4] dpt_i2o: 64 bit support (take 5)
Date: Tue, 13 May 2008 11:51:34 -0500
Message-ID: <1210697494.3077.33.camel@localhost.localdomain>
References: <20080501230211.GA19796@xs4all.net>
	 <20080506201055.12bf16c4.akpm@linux-foundation.org>
	 <20080512224220.5a87a119.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54235 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755141AbYEMQvi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 May 2008 12:51:38 -0400
In-Reply-To: <20080512224220.5a87a119.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miquel van Smoorenburg <mikevs@xs4all.net>, linux-scsi@vger.kernel.org, Mark Salyzyn <mark_salyzyn@adaptec.com>, miquels@cistron.nl, Rolf Eike Beer <eike-kernel@sf-tec.de>, "Rafael J. Wysocki" <rjw@sisk.pl>

On Mon, 2008-05-12 at 22:42 -0700, Andrew Morton wrote:
> On Tue, 6 May 2008 20:10:55 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > I'll let someone else ponder ia64:
> > 
> > drivers/scsi/dpt_i2o.c:83: error: `PROC_IA64' undeclared here (not in a function)
> > drivers/scsi/dpt_i2o.c:83: error: initializer element is not constant
> > drivers/scsi/dpt_i2o.c:83: error: (near initialization for `DPTI_sig.dsProcessor')
> 
> fyi, this is still happening.

OK, this fixes it on my ia64.

I think this fix is the best approach, since -1 and 0xff mean unknown
processor type to the management tool.  The correct fix is obviously to
add the definition of PROC_IA64 to dpt/dptsig.h, but I have no idea what
the value should be.

James

---

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 8508816..bfa9f09 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -80,7 +80,7 @@ static dpt_sig_S DPTI_sig = {
 #ifdef __i386__
 	PROC_INTEL, PROC_386 | PROC_486 | PROC_PENTIUM | PROC_SEXIUM,
 #elif defined(__ia64__)
-	PROC_INTEL, PROC_IA64,
+	PROC_INTEL, -1,
 #elif defined(__sparc__)
 	PROC_ULTRASPARC, PROC_ULTRASPARC,
 #elif defined(__alpha__)
@@ -1973,7 +1973,7 @@ static void adpt_ia64_info(sysInfo_S* si)
 	// This is all the info we need for now
 	// We will add more info as our new
 	// managmenent utility requires it
-	si->processorType = PROC_IA64;
+	si->processorType = 0xff;
 }
 #endif
 


