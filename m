From: Jonathan Nieder <jrnieder@gmail.com>
Subject: [PATCH/RFC v2] [SCSI] atp870u: Fix bad use of udelay
Date: Tue, 24 Apr 2012 02:49:16 -0500
Message-ID: <20120424074916.GA25261@burratino>
References: <200901092028.n09KSAeI024551@imap1.linux-foundation.org>
 <20090109205835.GB5069@deprecation.cyrius.com>
 <20090109130308.bfde281e.akpm@linux-foundation.org>
 <1231536107.3235.50.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38786 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458Ab2DXHt2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Apr 2012 03:49:28 -0400
Received: by iadi9 with SMTP id i9so630745iad.19
        for <linux-scsi@vger.kernel.org>; Tue, 24 Apr 2012 00:49:27 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1231536107.3235.50.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Martin Michlmayr <tbm@cyrius.com>, linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org

From: Martin Michlmayr <tbm@cyrius.com>

The ACARD driver calls udelay() with a value > 2000, which leads to
to the following compilation error on ARM:
  ERROR: "__bad_udelay" [drivers/scsi/atp870u.ko] undefined!
  make[1]: *** [__modpost] Error 1

This is because udelay is defined on ARM, roughly speaking, as

	#define udelay(n) ((n) > 2000 ? __bad_udelay() : \
		__const_udelay((n) * ((2199023U*HZ)>>11)))

The argument to __const_udelay is the number of jiffies to wait
divided by 4, but this does not work unless the multiplication does
not overflow, and that is what the build error is designed to prevent.
The intended behavior can be achieved by using mdelay to call udelay
multiple times in a loop.

[jn: adding context]
Signed-off-by: Martin Michlmayr <tbm@cyrius.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Cc: <stable@vger.kernel.org>
---
Hi James,

Three years ago, you wrote[1]:
>>> * akpm@linux-foundation.org <akpm@linux-foundation.org> [2009-01-09 12:28]:

>>>> The ACARD driver calls udelay() with a value > 2000, which leads to
>>>> to the following compilation error on ARM:
>>>>   ERROR: "__bad_udelay" [drivers/scsi/atp870u.ko] undefined!
>>>>   make[1]: *** [__modpost] Error 1
>>>> Fix this by using a combination of mdelay and udelay.
[...]
> It's wrong to silence a warning or build break while keeping the effect
> it was complaining about it's hiding a bug.  Now if the warning is
> wrong, we can take it out of the ARM build ... but I've got to say it
> looks right: the udelay in this driver will lock a UP system solid for
> 2ms.

Sorry for the very slow response.  I think the patch was inadequately
explained and that it is actually a good patch.

Here's the patch again with a description that helped me convince
myself it is ok.  Could you look it over and let me know what you
think?

Thanks,
Jonathan

[1] http://thread.gmane.org/gmane.linux.scsi/47523/focus=47533

 drivers/scsi/atp870u.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 68ce08552f69..a540162ac59c 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1173,7 +1173,16 @@ wait_io1:
 	outw(val, tmport);
 	outb(2, 0x80);
 TCM_SYNC:
-	udelay(0x800);
+	/*
+	 * The funny division into multiple delays is to accomodate
+	 * arches like ARM where udelay() multiplies its argument by
+	 * a large number to initialize a loop counter.  To avoid
+	 * overflow, the maximum supported udelay is 2000 microseconds.
+	 *
+	 * XXX it would be more polite to find a way to use msleep()
+	 */
+	mdelay(2);
+	udelay(48);
 	if ((inb(tmport) & 0x80) == 0x00) {	/* bsy ? */
 		outw(0, tmport--);
 		outb(0, tmport);
-- 
1.7.10

